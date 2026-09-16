using System.Data;
using System.Net.Http.Headers;
using System.Text.Json;
using Microsoft.Data.SqlClient;

var shop = Environment.GetEnvironmentVariable("SHOPIFY_SHOP") ?? "amazingwoman.co.uk";
var token = Environment.GetEnvironmentVariable("SHOPIFY_TOKEN")
    ?? throw new InvalidOperationException("Set the SHOPIFY_TOKEN environment variable.");
var locationId = Environment.GetEnvironmentVariable("SHOPIFY_LOCATION_ID") ?? "107229020546";
var storeCode = Environment.GetEnvironmentVariable("SHOPIFY_STORE_CODE") ?? "SHOPIFY";
var apiVersion = Environment.GetEnvironmentVariable("SHOPIFY_API_VERSION") ?? "2025-01";
var sql = Environment.GetEnvironmentVariable("ARIAMASTER_CONNECTION")
    ?? "Server=DESKTOP-3MDV69C;Database=onetouchDevDb3;TrustServerCertificate=True;User ID=sa;Password=Mbgb_3#4$;";

using var http = new HttpClient { BaseAddress = new Uri($"https://{shop}/admin/api/{apiVersion}/") };
http.DefaultRequestHeaders.Add("X-Shopify-Access-Token", token);
http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

var variants = new List<(JsonElement Variant, string ProductId)>();
// Query each status separately because some Shopify shops return no rows for status=any.
foreach (var status in new[] { "active", "draft", "archived" })
{
    string? page = $"products.json?limit=250&status={status}&fields=id,created_at,updated_at,variants";
    while (page is not null)
    {
        using var response = await http.GetAsync(page);
        var body = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();
        using var doc = JsonDocument.Parse(body);
        foreach (var product in doc.RootElement.GetProperty("products").EnumerateArray())
            foreach (var variant in product.GetProperty("variants").EnumerateArray())
                variants.Add((variant.Clone(), product.GetProperty("id").GetInt64().ToString()));
        page = GetNextLink(response.Headers.TryGetValues("Link", out var links) ? string.Join(",", links) : null);
    }
}

var quantities = new Dictionary<string, int>();
var inventoryIds = variants
    .Where(v => v.Variant.TryGetProperty("inventory_item_id", out var id) && id.ValueKind == JsonValueKind.Number)
    .Select(v => v.Variant.GetProperty("inventory_item_id").GetInt64().ToString())
    .Distinct();
foreach (var batch in inventoryIds.Chunk(50))
{
    using var response = await http.GetAsync($"inventory_levels.json?location_ids={locationId}&inventory_item_ids={string.Join(',', batch)}&limit=250");
    response.EnsureSuccessStatusCode();
    using var doc = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
    foreach (var level in doc.RootElement.GetProperty("inventory_levels").EnumerateArray())
    {
        var available = level.GetProperty("available");
        quantities[level.GetProperty("inventory_item_id").GetInt64().ToString()] =
            available.ValueKind == JsonValueKind.Number ? available.GetInt32() : 0;
    }
}

await using var db = new SqlConnection(sql);
await db.OpenAsync();
foreach (var entry in variants)
{
    var v = entry.Variant;
    if (!v.TryGetProperty("inventory_item_id", out var inventoryItem) || inventoryItem.ValueKind != JsonValueKind.Number)
    {
        Console.WriteLine($"Skipping variant {v.GetProperty("id").GetInt64()} because inventory_item_id is null.");
        continue;
    }
    var inventoryItemId = inventoryItem.GetInt64().ToString();
    var sku = v.TryGetProperty("sku", out var skuValue) ? skuValue.GetString() : null;
    var barcode = v.TryGetProperty("barcode", out var barcodeValue) ? barcodeValue.GetString() : null;
    var variantId = v.GetProperty("id").GetInt64().ToString();
    var available = quantities.TryGetValue(inventoryItemId, out var q) ? q : 0;
    await using var cmd = db.CreateCommand();
    cmd.CommandText = @"UPDATE dbo.STYCRSREF SET external_upc=@upc, external_sku=@sku, variant_id=@variant,
        updated=SYSUTCDATETIME(), dedit_date=SYSUTCDATETIME() WHERE inventory_item_id=@item AND store=@store;
        IF @@ROWCOUNT=0 INSERT dbo.STYCRSREF(external_upc,product_id,store,external_sku,updated,created,dadd_date,variant_id,inventory_item_id)
        VALUES(@upc,@product,@store,@sku,SYSUTCDATETIME(),SYSUTCDATETIME(),SYSUTCDATETIME(),@variant,@item);";
    cmd.Parameters.AddWithValue("@upc", (object?)barcode ?? DBNull.Value);
    cmd.Parameters.AddWithValue("@sku", (object?)sku ?? DBNull.Value);
    cmd.Parameters.AddWithValue("@variant", variantId);
    cmd.Parameters.AddWithValue("@product", entry.ProductId);
    cmd.Parameters.AddWithValue("@item", inventoryItemId);
    cmd.Parameters.AddWithValue("@store", storeCode);
    await cmd.ExecuteNonQueryAsync();
    Console.WriteLine($"{inventoryItemId}: available={available}");
}
Console.WriteLine($"Synchronized {variants.Count} variants to dbo.STYCRSREF.");

static string? GetNextLink(string? link)
{
    if (string.IsNullOrWhiteSpace(link)) return null;
    var next = link.Split(',').FirstOrDefault(x => x.Contains("rel=\"next\"", StringComparison.OrdinalIgnoreCase));
    if (next is null) return null;
    var start = next.IndexOf('<') + 1; var end = next.IndexOf('>');
    return start > 0 && end > start ? new Uri(next[start..end]).PathAndQuery.Replace("/admin/api/2025-01/", "") : null;
}
