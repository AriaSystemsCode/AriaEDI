using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Shopify_Product_Reader
{
    public class StyCrsRef
    {   public string variant_id { get; set; }
        public string product_id { get; set; }

        public string inventory_item_id { get; set; }
        public string sku { get; set; }
        public string upc { get; set; }
        public string created_at { get; set; }
        public string updated_at { get; set; }

    }

    public class Main
    {
        public void Do(string fileName, string serverName, string userName, string password, string dbName,string masterDBName, string storeName)
        {
            var listOfProducts = ReadXML(fileName);
            if (listOfProducts.Count > 0)
            {
                WriteToDB(listOfProducts, serverName, userName, password, dbName, storeName);
                WriteToMasterDB(listOfProducts, serverName, userName, password, masterDBName, storeName);
            }
            try
            {
                if (System.IO.File.Exists(fileName))
                {
                    System.IO.File.Delete(fileName);
                }
            }catch(Exception ex) { }
        }
        public List<StyCrsRef> ReadXML(string fileName)
        {
            List<StyCrsRef> ret = new List<StyCrsRef>();
            XmlDocument xml = new XmlDocument();
            xml.Load(fileName);
            
            XmlNodeList nodes = xml.DocumentElement.SelectNodes("variants");
            //if (!(nodes != null && nodes.Count > 0))
            //{ nodes = xml.DocumentElement.SelectNodes("variant"); }
            if (nodes.Count > 0)
            {
                foreach (XmlNode node in nodes)
                {
                    try
                    {
                        XmlNodeList product_id = node.SelectNodes("product-id");
                        XmlNodeList sku = node.SelectNodes("sku");
                        XmlNodeList upc = node.SelectNodes("barcode");
                        XmlNodeList id = node.SelectNodes("id");
                        XmlNodeList inventory_item_id = node.SelectNodes("inventory-item-id");
                        
                        XmlNodeList created_at = node.SelectNodes("created-at");
                        XmlNodeList updated_at = node.SelectNodes("updated-at");

                        ret.Add(new StyCrsRef()
                        {
                            product_id = product_id[0].InnerText,
                            inventory_item_id = inventory_item_id[0].InnerText,
                            sku = sku[0].InnerText,
                            upc = upc[0].InnerText,
                            variant_id = id[0].InnerText,
                            created_at = created_at[0].InnerText,
                            updated_at = updated_at[0].InnerText
                        });
                    }
                    catch (Exception ex)
                    { // handle missing data}
                    }

                }

            }

            return ret;
        }

        public void WriteToDB(List<StyCrsRef> listOfProducts, string serverName, string userName, string password, string dbName, string storeName)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand com = new SqlCommand();
            SqlDataAdapter dt = new SqlDataAdapter();
            con.ConnectionString = @"data source='" + serverName.Trim() + "';initial catalog='" + dbName.Trim() +
             "'; integrated security=False;User ID='" + userName.Trim() + "';Password='" + password.Trim() + "'";

            foreach(var product in listOfProducts)
            {
                com.Connection = con;
                if (string.IsNullOrEmpty(product.updated_at))
                {
                    com.CommandText = "Insert into stycrsref ( store, product_id, variant_id,inventory_item_id, external_upc, external_sku,created, updated, dadd_date) values ("
                      + "'" + storeName + "',"
                      + "'" + product.product_id + "',"
                      + "'" + product.variant_id + "',"
                      + "'" + product.inventory_item_id + "',"
                      + "'" + product.upc + "',"
                      + "'" + product.sku + "',"
                      + "'" + product.created_at.Substring(0, product.created_at.Length - 6) + "',"
                      + "'" + product.updated_at.Substring(0, product.updated_at.Length - 6) + "',"
                      + "'" + DateTime.Now.ToString() + "'"
                      + ")";
                }
                else
                {

                    com.CommandText = "Delete from stycrsref where  product_id='" + product.product_id + "' and variant_id='"+ product.variant_id + "' ; " +
                        "Insert into stycrsref ( store, product_id, variant_id,inventory_item_id, external_upc, external_sku,created, updated, dadd_date) values ("
                      + "'" + storeName + "',"
                      + "'" + product.product_id + "',"
                      + "'" + product.variant_id + "',"
                      + "'" + product.inventory_item_id + "',"
                      + "'" + product.upc + "',"
                      + "'" + product.sku + "',"
                      + "'" + product.created_at.Substring(0, product.created_at.Length - 6) + "',"
                      + "'" + product.updated_at.Substring(0, product.updated_at.Length - 6) + "',"
                      + "'" + DateTime.Now.ToString() + "'"
                      + ")";

                }

                try
                {
                    con.Open();
                    com.ExecuteReader();

                }
                catch (Exception ex)
                {   
                    Console.WriteLine(ex.Message);
                    // WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
                }
                finally
                {
                    con.Close();

                }

            }

        }
 
        public void WriteToMasterDB(List<StyCrsRef> listOfProducts, string serverName, string userName, string password, string masterDBName, string storeName)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand com = new SqlCommand();
            SqlDataAdapter dt = new SqlDataAdapter();
            con.ConnectionString = @"data source='" + serverName.Trim() + "';initial catalog='" + masterDBName.Trim() +
             "'; integrated security=False;User ID='" + userName.Trim() + "';Password='" + password.Trim() + "'";

            string created_date = listOfProducts.Max(r => r.created_at);
            created_date = created_date  == null ? "" : created_date;

            string modified_date = listOfProducts.Max(r => r.updated_at);
            modified_date = modified_date == null ? "" : modified_date;

            com.Connection = con;
            List<string> commands = new List<string>();
            commands.Add("Update networkProfiles  set PreTransferCommand='created_at_min=" + created_date + "' where networkid='"+ storeName + "' AND PreTransferCommand LIKE '%created_at_min%'");
            commands.Add("Update networkProfiles  set PreTransferCommand='updated_at_min=" + modified_date + "' where networkid='" + storeName + "' AND PreTransferCommand LIKE '%updated_at_min%'"); 
            foreach(string command in commands)
            {
                com.CommandText = command;
                try
                {   con.Open();
                    com.ExecuteReader();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    // WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
                }
                finally
                {   con.Close(); }
             }

        }

    }
}

