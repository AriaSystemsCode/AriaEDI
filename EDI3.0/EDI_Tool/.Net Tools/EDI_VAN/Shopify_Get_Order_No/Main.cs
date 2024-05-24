using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Shopify_Order_Reader
{
    public class Main
    {

        public void Do(string fileName, string serverName, string userName, string password, string dbName, string masterDBName, string storeName)
        {  
            WriteToMasterDB(fileName, serverName, userName, password, masterDBName, storeName);
        }
        public void WriteToMasterDB(string fileName, string serverName, string userName, string password, string masterDBName, string storeName)
        {
            string orderid = "0";
            XmlDocument xml = new XmlDocument();
            xml.Load(fileName);
            XmlNodeList nodes = xml.SelectNodes("orders")[0].SelectNodes("order");
            if (nodes.Count > 0)
            {
                orderid = nodes[nodes.Count - 1].SelectNodes("id")[0].InnerText.ToString();

                SqlConnection con = new SqlConnection();
                SqlCommand com = new SqlCommand();
                SqlDataAdapter dt = new SqlDataAdapter();
                con.ConnectionString = @"data source='" + serverName.Trim() + "';initial catalog='" + masterDBName.Trim() +
                 "'; integrated security=False;User ID='" + userName.Trim() + "';Password='" + password.Trim() + "'";

                com.Connection = con;

                com.CommandText = "Update networkProfiles  set PreTransferCommand='since_id=" + orderid + "' where networkid='" + storeName + "' AND PreTransferCommand LIKE '%since_id%'";

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
                { con.Close(); }

            }
        }

    }
}
