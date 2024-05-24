using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Data;

namespace TransactionsCore
{
    public class TransactionsCore
    {
        public bool needDataSetOnly = false;
        public Boolean Error { get; set; }
        public DataSet dataSetSource = new DataSet();
        public string ErrorMsg { get; set; }
        string TransactionFile = "Transactions.xml";
        string DLLLocation { get { return Path.GetDirectoryName(this.GetType().Assembly.Location); } }
        public void TempDataBaseCreator(string TransactionType, string Temp_DB_Name, string ServerName, string UserID, string Password)
        {
            string connectionString = GetSqlCon(ServerName, "master", UserID, Password);
            string CreationStatment = "";
            DataBaseConnector DBC = new DataBaseConnector();
            CreationStatment = "CREATE DATABASE [" + Temp_DB_Name + "]";
            DBC.doCommand(CreationStatment, connectionString);
            connectionString = GetSqlCon(ServerName, Temp_DB_Name, UserID, Password);
            Transaction trans = getTransaction(TransactionType);
            if (trans == null)
            {
                ErrorMsg = "Transaction " + TransactionType + " not supported!";
                Error = true;
                return;
            }
            string creationScript = trans.CreationScript;
            DBC.ExecuteScriptText(connectionString, creationScript);
            Error = DBC.Error;
            ErrorMsg = DBC.ErrorMsg;
            return;
        }

        private Transaction getTransaction(string TransactionType)
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(DLLLocation + "\\" + TransactionFile);
            XmlNode Transaction_Node = xmlDoc.SelectSingleNode("//Transaction[@name='" + TransactionType + "']");
            if (Transaction_Node != null)
            {
                Transaction transaction = new Transaction();
                transaction.TransactionType = TransactionType;
                transaction.MainTable = Transaction_Node["MainTable"].InnerText;
                transaction.CreationScript = Transaction_Node["CreationScript"].InnerText;
                string tables = Transaction_Node["Tables"].InnerText;
                transaction.Tables_List = new List<string>();
                transaction.Tables_List.AddRange(tables.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries));
                return transaction;
            }
            return null;
        }
        private string GetSqlCon(string SqlServer, string DataBase, string UserName, string Password)
        {
            string conString = "";
            conString = "Data Source=" + SqlServer + ";Initial Catalog=" + DataBase + ";";
            if (UserName != "")
                conString += "User Id=" + UserName + ";Password=" + Password + ";";
            else
                conString += "Trusted_Connection=True";

            return conString;
        }
        public void Import(string TransactionType, string ServerName, string DatabaseName, string UserID, string Password, string InXMLFullName)
        {
            Map.XmlToSqlClass XTS = new Map.XmlToSqlClass();
            Transaction trans = getTransaction(TransactionType);
            if (trans == null)
            {
                ErrorMsg = "Transaction " + TransactionType + " not supported!";
                Error = true;
                return;
            }
            XTS.MainSrcTable = trans.MainTable;
            XTS.MainDestTable = trans.MainTable;

            XTS.needDataSetOnly = this.needDataSetOnly;
            XTS.XmlToSql("", "", InXMLFullName, ServerName, DatabaseName, UserID, Password, "", "");
            if (needDataSetOnly)
            { dataSetSource = XTS.dataSetSource; }

            Error = XTS.Error;
            ErrorMsg = XTS.ErrorMsg;
        }

        public void Extract(string TransactionType, string ServerName, string DatabaseName, string UserID, string Password, string KeyExpression, string OutXMLFullName)
        {
            Transaction trans = getTransaction(TransactionType);
            if (trans == null)
            {
                ErrorMsg = "Transaction " + TransactionType + " not supported!";
                Error = true;
                return;
            }
            string TablesName = "";
            trans.Tables_List.ForEach(table => TablesName += table + ",");
            TablesName = TablesName.EndsWith(",") ? TablesName.Remove(TablesName.Length - 1) : TablesName;
            Map.SqlToXmlClass STX = new Map.SqlToXmlClass();
            STX.SqlToXml(ServerName, DatabaseName, UserID, Password, TablesName, "", OutXMLFullName, KeyExpression);
            Error = STX.Error;
            ErrorMsg = STX.ErrorMsg;
        }

        public DataSet GetSchema(string TransactionType)
        {
            string schemaPath = DLLLocation + "\\" + TransactionType + "Schema.xml";
            if (File.Exists(schemaPath))
            {
                DataSet ds = new DataSet();
                ds.ReadXmlSchema(schemaPath);
                return ds;
            }
            return null;
        }
        //private void setMainTablesName(Map.XmlToSqlClass XTS, string TransactionType)
        //{
        //    if (TransactionType == "810")
        //    {
        //        XTS.MainSrcTable = "INVOICE_HEADER_T";
        //        XTS.MainDestTable = "INVOICE_HEADER_T";
        //    }
        //    else if (TransactionType == "856")
        //    {
        //        XTS.MainSrcTable = "SHIPMENT_HEADER_T";
        //        XTS.MainDestTable = "SHIPMENT_HEADER_T";
        //    }
        //    else if (TransactionType == "846")
        //    {
        //        XTS.MainSrcTable = "INVENTORY_HEADER_T";
        //        XTS.MainDestTable = "INVENTORY_HEADER_T";
        //    }
        //}
        //public string TransactionTables(string TransactionType)
        //{
        //    string TranTable = "";
        //    if (TransactionType == "810")
        //    {
        //        TranTable = "INVOICE_CHARGES_T,INVOICE_DETAILS_T,INVOICE_HEADER_T,INVOICE_LOCATIONS_T";
        //    }
        //    else if (TransactionType == "856")
        //    {
        //        TranTable = "SHIPMENT_HEADER_T,SHIPMENT_DETAILS_T,SHIPMENT_ITEMS_T,SHIPMENT_CONTAINERS_T,SHIPMENT_ITEM_CONTAINERS_T,SHIPMENT_ROUTING_T";
        //    }
        //    else if (TransactionType == "846")
        //    {
        //        TranTable = "INVENTORY_HEADER_T,INVENTORY_DETAILS_T";
        //    }
        //    else if (TransactionType == "850")
        //    {
        //        TranTable = "PO_HEADER_T,PO_ITEMS_T,PO_CHARGES_T,PO_ITEM_DISTENTION_T,PO_MESSAGES_T,PO_SUBLINE_ITEM_T,PO_TERMS_T,PO_ADDRESS_T";
        //    }
        //    return TranTable;
        //}
    }

    class Transaction
    {
        public string TransactionType { get; set; }

        public string MainTable { get; set; }

        public List<string> Tables_List { get; set; }

        public string CreationScript { get; set; }
    }
}
