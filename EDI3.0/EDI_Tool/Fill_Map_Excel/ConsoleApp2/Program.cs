////using System;
////using System.Net.Http;
////using System.Threading.Tasks;

////namespace ConsoleApp2
////{
////    class Program
////    {
////        static void Main(string[] args)
////        {
////            Run().GetAwaiter().GetResult();
////        }

////        static async Task Run()
////        {
////            string apiToken = "pk_48125139_G58GZNXGLK49KFL7D10Q1HO1HIRZVBSF";
////            string listId = "10619516";

////            using (HttpClient client = new HttpClient())
////            {
////                client.DefaultRequestHeaders.Clear();

////                // Correct way to pass Personal Access Token
////                client.DefaultRequestHeaders.Add("Authorization", apiToken);

////                HttpResponseMessage response =
////                    await client.GetAsync($"https://api.clickup.com/api/v2/list/{listId}/task");

////                Console.WriteLine("Status: " + response.StatusCode);

////                string content = await response.Content.ReadAsStringAsync();
////                Console.WriteLine(content);
////            }
////        }
////    }
////}

//using System;
//using System.Net.Http;
//using System.Threading.Tasks;

//class Program
//{
//    static async Task Main()
//    {
//        string apiToken = "pk_48125139_G58GZNXGLK49KFL7D10Q1HO1HIRZVBSF"; // Replace with your ClickUp token
//        //            string apiToken = "pk_48125139_G58GZNXGLK49KFL7D10Q1HO1HIRZVBSF";
//        //            string listId = "10619516";
//        string url1 = "https://api.clickup.com/api/v2/team";
//        // string url = "https://api.clickup.com/api/v2/list/901001184215/task";
//        string url = "https://api.clickup.com/api/v2/list/901513206647/task";




//        using (HttpClient client = new HttpClient())
//        {
//            // ✅ Personal Access Token header (raw, no Bearer)
//            client.DefaultRequestHeaders.Clear();
//            client.DefaultRequestHeaders.Add("Authorization", apiToken);

//            try
//            {
//                HttpResponseMessage response = await client.GetAsync(url);
//                response.EnsureSuccessStatusCode(); // throws if status != 200

//                string content = await response.Content.ReadAsStringAsync();
//                Console.WriteLine(content);

//                // get tasks comments
//                string taskId = "86c87zc8e";

//                string commentsUrl = $"https://api.clickup.com/api/v2/task/{taskId}/comment";
//                HttpResponseMessage commentsResponse = await client.GetAsync(commentsUrl);
//                commentsResponse.EnsureSuccessStatusCode();

//                string commentsJson = await commentsResponse.Content.ReadAsStringAsync();
//                Console.WriteLine("Comments: " + commentsJson);

//            }
//            catch (HttpRequestException ex)
//            {
//                Console.WriteLine("Request error: " + ex.Message);
//            }
//        }
//    }
//}

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using ClosedXML.Excel;

class Program
{
    static void Main()
    {
        string connStr = "Server=AriaTesting\\AriaSQLServer;Database=EDIMappings-TFS;User ID=sa;Password=aria_123;";

        string query = @"
            SELECT 
                cmapset as Map,
                (select top (1)  cParentName from sycediph where sycediph.cpartcode = sycedipd.cpartcode) as TradingPartnerName,
                cpartcode as DivisionCode,
                cversion as Version,
                'Ready' as Status,
                ceditrntyp as DocType
            FROM sycedipd order by cpartcode, cversion
        ";

        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.Fill(dt);
        }

        // All EDI columns (fixed structure)
        var ediColumns = new List<string>
        {
            "204","211","753","754","810","811","812","816","820","824",
            "830","831","832","846","850","852","855","856","860","864",
            "865","869","870","940","943","944","945","997"
        };

        using (var wb = new XLWorkbook())
        {
            var ws = wb.Worksheets.Add("EDI Matrix");

            int row = 1;
            int col = 1;

            // HEADER
            ws.Cell(row, col++).Value = "Map";
            ws.Cell(row, col++).Value = "Trading Partner Name";
            ws.Cell(row, col++).Value = "Division Code";
            ws.Cell(row, col++).Value = "Version";
            ws.Cell(row, col++).Value = "Status";

            foreach (var c in ediColumns)
                ws.Cell(row, col++).Value = c;

            // GROUP DATA
            var groups = dt.AsEnumerable()
                .GroupBy(r => new
                {
                    Map = r["Map"].ToString(),
                    Partner = r["TradingPartnerName"].ToString(),
                    Division = r["DivisionCode"].ToString(),
                    Version = r["Version"].ToString(),
                    Status = r["Status"].ToString()
                });

            row++;

            foreach (var g in groups)
            {
                col = 1;

                ws.Cell(row, col++).Value = g.Key.Map;
                ws.Cell(row, col++).Value = g.Key.Partner;
                ws.Cell(row, col++).Value = g.Key.Division;
                ws.Cell(row, col++).Value = g.Key.Version;
                ws.Cell(row, col++).Value = g.Key.Status;

                foreach (var edi in ediColumns)
                {
                    bool exists = g.Any(x => x["DocType"].ToString() == edi);
                    ws.Cell(row, col++).Value = exists ? "√" : "";
                }

                row++;
            }

            ws.Columns().AdjustToContents();

            string file = @"C:\Temp\EDI_Matrix.xlsx";
            wb.SaveAs(file);

            Console.WriteLine("Excel created: " + file);
        }
    }
}