using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Web.Http;
using System.Xml;

namespace ERP.Controllers
{
    public class DictionaryTableController : ApiController
    {
        public List<object[]> GetTableData(string userid, string password, string clientID, string CompanyID, string tableName, string whereCondition, string fields = "")
        {
            List<object[]> dataList = new List<object[]>();
            string strAppPath = AppDomain.CurrentDomain.BaseDirectory;
            if (this.VerifyCredentials(userid, password))
            {
                try
                {
                    string tableNameone = tableName;
                    if (tableNameone.Contains(",")) { tableNameone = tableNameone.Split(',')[0]; };
                    FileType tableType = GetTableType(userid, password, clientID, tableNameone);
                    SQLServerSettings _SQLServerSettings = this.GetClinet(clientID);
                    if (tableType.Type == TableType.Fox)
                    {
                        if (!_SQLServerSettings.NotAllowed && !String.IsNullOrEmpty(_SQLServerSettings.ARIA27SYS))
                        {
                            OleDbConnection con = new OleDbConnection(@"Provider=VFPOLEDB;Data Source=" + _SQLServerSettings.ARIA27SYS.Trim() + ";Collating Sequence=machine; Mode=ReadWrite;");
                            //System.IO.File.WriteAllText(strAppPath + "//WriteText.txt", _SQLServerSettings.ARIA27SYS.Trim() + "aa");
                            con.Open();
                            System.IO.File.WriteAllText(strAppPath + "//WriteText.txt", _SQLServerSettings.ARIA27SYS.Trim() + "after");
                            OleDbCommand dbcommandfox = con.CreateCommand();
                            dbcommandfox.CommandText = "SELECT ccom_ddir FROM syccomp Where  ccomp_id='" + CompanyID + " '";
                            var dar = dbcommandfox.ExecuteReader();
                            var data = "";
                            while (dar.Read())
                            {
                                data = dar[0].ToString().ToUpper().Replace(@"X:\", _SQLServerSettings.DataPath.Trim());

                            }
                            dbcommandfox.Connection.Close();

                            con = new OleDbConnection(@"Provider=VFPOLEDB;Data Source=" + data + ";Collating Sequence=machine; Mode=ReadWrite;");
                            con.Open();
                            dbcommandfox = con.CreateCommand();
                            if (!String.IsNullOrEmpty(fields))
                            {
                                dbcommandfox.CommandText = "SELECT " + fields + " FROM " + tableName + " Where " + whereCondition + "";
                            }

                            else
                                dbcommandfox.CommandText = "SELECT * FROM " + tableName + " Where " + whereCondition + "";
                            dar = dbcommandfox.ExecuteReader();

                            while (dar.Read())
                            {

                                object[] tempRow = new object[dar.FieldCount];
                                for (int i = 0; i < dar.FieldCount; i++)
                                {
                                    tempRow[i] = dar[i];
                                }
                                dataList.Add(tempRow);

                            }
                            dbcommandfox.Connection.Close();
                        }
                    }
                    if (!_SQLServerSettings.NotAllowed && tableType.Type == TableType.SQL)
                    {
                        if (!String.IsNullOrEmpty(_SQLServerSettings.ARIA27SYS))
                        {
                            OleDbConnection con = new OleDbConnection(@"Provider=VFPOLEDB;Data Source=" + _SQLServerSettings.ARIA27SYS.Trim() + ";Collating Sequence=machine; Mode=ReadWrite;");
                            con.Open();
                            OleDbCommand dbcommandfox = con.CreateCommand();
                            dbcommandfox.CommandText = "SELECT cconserver, ccondbname, cconuserid, cconpaswrd FROM syccomp Where  ccomp_id='" + CompanyID + " '";
                            var dar = dbcommandfox.ExecuteReader();
                            var cconserver = "";
                            var ccondbname = "";
                            var cconuserid = "";
                            var cconpaswrd = "";
                            while (dar.Read())
                            {
                                cconserver = dar[0].ToString().Trim();
                                ccondbname = dar[1].ToString().Trim();
                                cconuserid = dar[2].ToString().Trim();
                                cconpaswrd = dar[3].ToString().Trim();
                            }
                            dbcommandfox.Connection.Close();

                            SqlConnection cn = new SqlConnection();
                            SqlCommand cmd = new SqlCommand();
                            cn.ConnectionString = "Server=" + cconserver + ";Database=" + ccondbname + ";User Id=" + cconuserid + ";Password=" + cconpaswrd + ";";

                            cmd.Connection = cn;
                            cmd.Connection.Open();
                            if (!String.IsNullOrEmpty(fields))
                            {
                                cmd.CommandText = "SELECT " + fields + " FROM " + tableName + " Where " + whereCondition + "";
                            }

                            else
                                cmd.CommandText = "SELECT * FROM " + tableName + " Where " + whereCondition + "";
                            System.IO.File.WriteAllText(strAppPath + "//WriteText.txt", cn.ConnectionString + "aa");
                            SqlDataReader dr = cmd.ExecuteReader();
                            System.IO.File.WriteAllText(strAppPath + "//WriteText.txt", cn.ConnectionString + "cccccccccccccccc");
                            while (dr.Read())
                            {

                                object[] tempRow = new object[dr.FieldCount];
                                for (int i = 0; i < dr.FieldCount; i++)
                                {
                                    tempRow[i] = dr[i];
                                }
                                dataList.Add(tempRow);

                            }
                        }
                    }

                }
                catch (Exception ex)
                {
                    System.IO.File.WriteAllText(strAppPath + "//WriteText.txt", ex.Message.ToString() + "cccccccccccccccc");
                    throw ex;
                }
            }
            return dataList;

        }

        public FileType GetTableType(string userid, string password, string clientID, string tableName)
        {
            FileType data = new FileType();
            if (this.VerifyCredentials(userid, password))
            {
                SQLServerSettings _SQLServerSettings = this.GetClinet(clientID);
                if (!_SQLServerSettings.NotAllowed)
                {
                    SqlConnection conn = new SqlConnection();
                    SqlCommand cmnd = new SqlCommand();
                    conn.ConnectionString = "Server=" + _SQLServerSettings.Server + " ;Database=" + _SQLServerSettings.Database + ";User Id=" + _SQLServerSettings.UserId + ";Password=" + _SQLServerSettings.Password + " ;";
                    cmnd.Connection = conn;
                    cmnd.Connection.Open();
                    cmnd.CommandText = "SELECT cfile_nam,cver FROM sydfiles  Where  cfile_nam='" + tableName + " '";
                    SqlDataReader dar = cmnd.ExecuteReader();
                    while (dar.Read())
                    {
                        data.Name = dar[0].ToString();
                        data.Type = dar[1].ToString() == "A40" ? TableType.SQL : TableType.Fox;
                    }
                }
            }
            return data;

        }

        public List<Files> GetTables(string userid, string password, string clientID)
        {
            List<Files> dataList = new List<Files>();
            if (this.VerifyCredentials(userid, password))
            {
                try
                {
                    SQLServerSettings _SQLServerSettings = this.GetClinet(clientID);
                    if (!_SQLServerSettings.NotAllowed)
                    {
                        SqlConnection cn = new SqlConnection();
                        SqlCommand cmd = new SqlCommand();
                        cn.ConnectionString = "Server=" + _SQLServerSettings.Server + " ;Database=" + _SQLServerSettings.Database + ";User Id=" + _SQLServerSettings.UserId + ";Password=" + _SQLServerSettings.Password + " ;";
                        cmd.Connection = cn;
                        cmd.Connection.Open();
                        cmd.CommandText = "SELECT cfile_nam,cfile_ttl, cver FROM sydfiles";
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            Files tempRow = new Files();
                            tempRow.Name = dr[0].ToString();
                            tempRow.Title = dr[1].ToString();
                            tempRow.Version = dr[2].ToString().Replace("A40", "SQL").Replace("A27", "FOX");
                            dataList.Add(tempRow);
                        }
                    }
                }
                catch (Exception)
                {
                    throw;
                }
            }

            return dataList;
        }

        public List<Fields> GetTableStructure(string userid, string password, string clientID, string tableName)
        {
            List<Fields> dataList = new List<Fields>();
            if (this.VerifyCredentials(userid, password))
            {
                try
                {
                    SQLServerSettings _SQLServerSettings = this.GetClinet(clientID);
                    if (!_SQLServerSettings.NotAllowed)
                    {
                        // connect to client master db
                        SqlConnection cn = new SqlConnection();
                        SqlCommand cmd = new SqlCommand();
                        cn.ConnectionString = "Server=" + _SQLServerSettings.Server + " ;Database=" + _SQLServerSettings.Database + ";User Id=" + _SQLServerSettings.UserId + ";Password=" + _SQLServerSettings.Password + " ;";

                        cmd.Connection = cn;
                        cmd.Connection.Open();

                        cmd.CommandText = "SELECT cfld_name,cfld_head,cdata_typ, nfld_wdth, nfld_dec FROM sydfield where cfld_name in (select cfld_name from sydflfld where cfile_nam='" + tableName + "')";
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            Fields tempRow = new Fields();
                            tempRow.Name = dr[0].ToString();
                            tempRow.Description = dr[1].ToString();
                            tempRow.DataType = dr[2].ToString();
                            tempRow.Width = Int32.Parse(dr[3].ToString());
                            tempRow.Decimal = Int32.Parse(dr[4].ToString());
                            dataList.Add(tempRow);
                        }
                    }
                }

                catch (Exception)
                {
                    throw;
                }

            }
            return dataList;
        }

        public List<INDEXES> GetTableIndexes(string userid, string password, string clientID, string tableName)
        {
            List<INDEXES> dataList = new List<INDEXES>();
            if (this.VerifyCredentials(userid, password))
            {
                try
                {
                    SQLServerSettings _SQLServerSettings = this.GetClinet(clientID);
                    if (!_SQLServerSettings.NotAllowed)
                    {
                        // connect to client master db
                        SqlConnection cn = new SqlConnection();
                        SqlCommand cmd = new SqlCommand();
                        cn.ConnectionString = "Server=" + _SQLServerSettings.Server + " ;Database=" + _SQLServerSettings.Database + ";User Id=" + _SQLServerSettings.UserId + ";Password=" + _SQLServerSettings.Password + " ;";

                        cmd.Connection = cn;
                        cmd.Connection.Open();

                        cmd.CommandText = "SELECT cfile_tag,cindx_exp,lunique, mindx_des FROM SYDINDEX where cfile_nam='" + tableName + "'";
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            INDEXES tempRow = new INDEXES();
                            tempRow.IndexCode = dr[0].ToString();
                            tempRow.IndexExpression = dr[1].ToString();
                            tempRow.Unique = bool.Parse(dr[2].ToString());
                            tempRow.IndexName = dr[3].ToString();
                            tempRow.TableName = tableName;
                            dataList.Add(tempRow);
                        }
                    }
                }

                catch (Exception)
                {
                    throw;
                }

            }
            return dataList;
        }

        private SQLServerSettings GetSettings()
        {
            SQLServerSettings _SQLServerSettings = new SQLServerSettings();
            XmlDocument xmldoc = new XmlDocument();
            XmlNodeList xmlnode;

            string strAppPath = AppDomain.CurrentDomain.BaseDirectory;

            xmldoc.Load(strAppPath + "//SystemMaster.xml");
            xmlnode = xmldoc.GetElementsByTagName("SystemMaster");

            _SQLServerSettings.Server = xmlnode[0].ChildNodes.Item(0).InnerText.Trim();
            _SQLServerSettings.Database = xmlnode[0].ChildNodes.Item(1).InnerText.Trim();
            _SQLServerSettings.UserId = xmlnode[0].ChildNodes.Item(2).InnerText.Trim();
            _SQLServerSettings.Password = xmlnode[0].ChildNodes.Item(3).InnerText.Trim();
            _SQLServerSettings.OnlyFor = xmlnode[0].ChildNodes.Item(4).InnerText.Trim();

            xmldoc = null;

            return _SQLServerSettings;

        }

        private SQLServerSettings GetClinet(string clientID)
        {
            SQLServerSettings _ClientSQLServerSettings = new SQLServerSettings();
            SQLServerSettings _SQLServerSettings = this.GetSettings();

            if (!String.IsNullOrEmpty(_SQLServerSettings.OnlyFor) && _SQLServerSettings.OnlyFor.ToUpper() != clientID.ToUpper())
            {
                _ClientSQLServerSettings.NotAllowed = true;
                return _ClientSQLServerSettings;
            }

            //get data from table client
            SqlConnection cn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            cn.ConnectionString = "Server=" + _SQLServerSettings.Server + ";Database=" + _SQLServerSettings.Database + ";User Id=" + _SQLServerSettings.UserId + ";Password=" + _SQLServerSettings.Password + " ;";
            cmd.Connection = cn;
            cmd.Connection.Open();
            cmd.CommandText = "SELECT CCONSERVER,CCONDBNAME,CCONUSERID,CCONPASWRD,ARIA27SYS,cDataPath  FROM Clients  Where  CCLIENTID='" + clientID + "'";
            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                _ClientSQLServerSettings.Server = dr.GetString(0);
                _ClientSQLServerSettings.Database = dr.GetString(1);
                _ClientSQLServerSettings.UserId = dr.GetString(2);
                _ClientSQLServerSettings.Password = dr.GetString(3);
                _ClientSQLServerSettings.ARIA27SYS = dr.GetString(4);
                _ClientSQLServerSettings.DataPath = dr.GetString(5);
            }
            return _ClientSQLServerSettings;
        }

        private bool VerifyCredentials(string userid, string password)
        {
            if (userid == "admin" && password == "aria_123")
                return true;
            else
                return false;
        }
    }
    public class Files
    {
        public string Name { get; set; }
        public string Title { get; set; }

        public string Version { get; set; }
    }

    public class Fields
    {
        public string Name { get; set; }

        public string Description { get; set; }

        public string DataType { get; set; }

        public Int32 Width { get; set; }
        public Int32 Decimal { get; set; }

    }

    public class INDEXES
    {
        public string TableName { get; set; }

        public string IndexName { get; set; }

        public string IndexExpression { get; set; }

        public string IndexCode { get; set; }
        public bool Unique { get; set; }

    }

    public class FileType
    {
        public string Name { get; set; }
        public TableType Type { get; set; }
    }

    public enum TableType
    {
        Fox,
        SQL
    }

    public class SQLServerSettings
    {
        public bool NotAllowed { get; set; }
        public string Server { get; set; }

        public string Database { get; set; }

        public string UserId { get; set; }

        public string Password { get; set; }

        public string OnlyFor { get; set; }

        public string ARIA27SYS { get; set; }

        public string DataPath { get; set; }
    }
}
