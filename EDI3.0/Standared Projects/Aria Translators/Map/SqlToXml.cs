using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Xml;

namespace Map
{
    public class SqlToXmlClass
    {
        public bool needDataSetOnly = false;
        public DataSet dsSource = new DataSet();
        SqlConnection con = new SqlConnection();

        /// <summary>
        /// Convert Passed SQL tables to XML file
        /// </summary>
        /// <param name="SqlServer">sql server for tables</param>
        /// <param name="DataBase">Database name which contains the tables</param>
        /// <param name="UserName">User name to connect to sql</param>
        /// <param name="Password">Password for SQL user name</param>
        /// <param name="Tables">Tables to convert to XML</param>
        /// <param name="RenameXml">Map file if we need to rename tables names in XML</param>
        /// <param name="OutPutXml">file name for the output xml</param>
        /// <param name="SqlWhereCondition">Where condition applies when selecting data from tables</param>
        public void SqlToXml(string SqlServer, string DataBase, string UserName, string Password, string Tables, string RenameXml, string OutPutXml, string SqlWhereCondition)
        {
            try
            {    // temp code to be removed and set the property from adapters
                if (Tables.ToUpper().Contains("CUSTOMER") || Tables.ToUpper().Contains("APVENDOR") || Tables.ToUpper().Contains("STYLEMAJOR"))
                { needDataSetOnly = true; }
                Error = false;
                con = GetSqlCon(SqlServer, DataBase, UserName, Password);
                SqlWhereCondition = SqlWhereCondition.Trim() != "" ? "Where " + SqlWhereCondition : "";
                dsSource = FillTablesData(dsSource, Tables, con, SqlWhereCondition);
                Rename(dsSource, RenameXml);
                DataSetToXml(dsSource, OutPutXml);
            }
            catch (Exception ex)
            {
                Error = true;
                ErrorMsg = ex.Message;
            }
            finally
            {
                SqlConnection.ClearAllPools();
            }
        }

        /// <summary>
        /// function to rename dataset according to passed XML
        /// </summary>
        /// <param name="dataSet">DataSet to rename</param>
        /// <param name="RenameXml">map to used in renaming</param>
        private void Rename(DataSet dataSet, string RenameXml)
        {
            if (RenameXml != "" && File.Exists(RenameXml))
            {
                XmlDocument xmlrename = new XmlDocument();
                xmlrename.Load(RenameXml);
                foreach (XmlNode table in xmlrename.SelectNodes("//*/Table"))
                {
                    if (dataSet.Tables[table["Name"].InnerText] != null)
                    {
                        dataSet.Tables[table["Name"].InnerText].TableName = table["NewName"].InnerText;
                        foreach (XmlNode fields in table.SelectNodes("//*/Field"))
                        {
                            dataSet.Tables[table["NewName"].InnerText].Columns[fields["Name"].InnerText].Caption = fields["NewName"].InnerText;
                            dataSet.Tables[table["NewName"].InnerText].Columns[fields["Name"].InnerText].ColumnName = fields["NewName"].InnerText;
                        }
                    }
                }
            }
        }
       
        /// <summary>
        /// Get PKey for SQL table from Sql Dictionaries
        /// </summary>
        /// <returns></returns>
        private string GetPKey(SqlConnection sqlConnection, string tableName)
        {
            string creturn = "";
            try
            {
                SqlCommand cmd = sqlConnection.CreateCommand();
                
                cmd.CommandText = "SELECT  top(1) col.name  " +
                    "FROM         sys.tables AS tab INNER JOIN " +
                    "                     sys.indexes AS pk ON tab.object_id = pk.object_id AND pk.is_primary_key = 1 INNER JOIN " +
                    "                    sys.index_columns AS ic ON ic.object_id = pk.object_id AND ic.index_id = pk.index_id INNER JOIN " +
                    "                   sys.columns AS col ON pk.object_id = col.object_id AND col.column_id = ic.column_id " +
                    "WHERE(tab.name = '" + tableName + "') ";
                
                creturn = cmd.ExecuteScalar().ToString();
                 
                return creturn;
            }
            catch (Exception ex) { return creturn; }

            
        }

        /// <summary>
        /// Fill dataset with SQL tables
        /// </summary>
        /// <param name="dataSet">Dataset to be filled</param>
        /// <param name="Tables">Tables names to get from SQL</param>
        /// <param name="sqlConnection">SQL connection</param>
        /// <param name="SqlWhereCondition">Where condition for data reteriving from SQL</param>
        /// <returns></returns>
        /// 
        private DataSet FillTablesDataNew(System.Data.DataSet dataSet, string Tables, SqlConnection sqlConnection, string SqlWhereCondition)
        {
            if (sqlConnection.State == ConnectionState.Closed)
            { sqlConnection.Open(); }

            SqlCommand cmd = sqlConnection.CreateCommand();
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd);
            DataTable resultDataTable = new DataTable();
            foreach (string table in Tables.Split(','))
            {
                if (table.Trim() != "")
                {   // try
                    //cal get pK 
                    
                    var PKName = GetPKey(sqlConnection, table.Trim());
                    cmd.CommandText = "Select count(*) from {0}  " + SqlWhereCondition;
                    cmd.CommandText = string.Format(cmd.CommandText, table);
                    int RowsCount = (int)cmd.ExecuteScalar();
                    int IterationRowsCount = 1;
                    string SQLOrder = "";
                    string SQLTop = "";
                    int CurrentCounter = RowsCount;
                    if (string.IsNullOrEmpty(PKName)==false && RowsCount >= 50000)
                    {
                        CurrentCounter = 50000;
                        IterationRowsCount = 50000;
                        //SQLOrder = " ORDER BY "+ PKName + "  OFFSET 0 ROWS FETCH NEXT 50000 ROWS ONLY ";
                        SQLOrder = " ORDER BY " + PKName ;
                        SQLTop = " top(50000) ";
                    }

                    resultDataTable = new DataTable();
                    resultDataTable.TableName = table;
                    while(CurrentCounter <= RowsCount)
                    {
                        cmd.CommandText = "Select "+ SQLTop + " * from {0}  " + SqlWhereCondition + SQLOrder;
                        cmd.CommandText = string.Format(cmd.CommandText, table);
                        sqlDataAdapter.Fill(resultDataTable);
                        CurrentCounter = CurrentCounter + IterationRowsCount;
                        //SQLOrder = " ORDER BY " + PKName + " DESC OFFSET "+ CurrentCounter.ToString()+ " ROWS FETCH NEXT 50000 ROWS ONLY ";
                        SQLOrder = " where " + PKName + "> " + "'"+ resultDataTable.Rows[resultDataTable .Rows.Count-1][PKName].ToString().TrimEnd() + "' ORDER BY " + PKName ;
                    }
                    resultDataTable = AdjustTableColumnsWidths(resultDataTable, sqlConnection);
                    dataSet.Tables.Add(resultDataTable);
                }
            }
            if (sqlConnection.State == ConnectionState.Open)
            { sqlConnection.Close(); }

            return dataSet;
        }

        /// <summary>
        /// Fill dataset with SQL tables
        /// </summary>
        /// <param name="dataSet">Dataset to be filled</param>
        /// <param name="Tables">Tables names to get from SQL</param>
        /// <param name="sqlConnection">SQL connection</param>
        /// <param name="SqlWhereCondition">Where condition for data reteriving from SQL</param>
        /// <returns></returns>
        private DataSet FillTablesData(System.Data.DataSet dataSet, string Tables, SqlConnection sqlConnection, string SqlWhereCondition)
        {
            SqlCommand cmd = sqlConnection.CreateCommand();
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd);
            DataTable resultDataTable = new DataTable();
            foreach (string table in Tables.Split(','))
            {
                if (table.Trim() != "")
                {
                    cmd.CommandText = "Select * from {0}  " + SqlWhereCondition;
                    cmd.CommandText = string.Format(cmd.CommandText, table);
                    resultDataTable = new DataTable();
                    sqlDataAdapter.Fill(resultDataTable);
                    resultDataTable.TableName = table;
                    resultDataTable = AdjustTableColumnsWidths(resultDataTable, sqlConnection);
                    dataSet.Tables.Add(resultDataTable);
                }
            }
            return dataSet;
        }


        /// <summary>
        /// Gets the exact width of string datatypes from SQL metadata and set it in the table properties
        /// </summary>
        /// <param name="table">Table to be used</param>
        /// <param name="sqlcon">sql Server connection</param>
        /// <returns>Table after adjusting the width</returns>
        private DataTable AdjustTableColumnsWidths(DataTable table, SqlConnection sqlcon)
        {
            SqlCommand cmd = sqlcon.CreateCommand();
            ConnectionState state = sqlcon.State;
            if (state == ConnectionState.Closed)
                sqlcon.Open();
            foreach (DataColumn column in table.Columns)
            {
                if (column.DataType == typeof(string))
                {
                    cmd.CommandText = "select ltrim(rtrim(str(MAX(Datalength({column})))))+'|'+ltrim(rtrim(str(Col_Length('{table}','{column}')))) from {table} order by 1 desc";
                    //cmd.CommandText = "select Col_Length('{0}','{1}')";
                    //cmd.CommandText = string.Format(cmd.CommandText, column.Table.TableName, column.ColumnName);
                    cmd.CommandText = cmd.CommandText.Replace("{table}", column.Table.TableName).Replace("{column}", column.ColumnName);
                    object width = cmd.ExecuteScalar();
                    if (width != null && width is string && width.ToString().Contains('|'))
                    {
                        int columnLength, DataLength;
                        DataLength = Convert.ToInt32(width.ToString().Split('|')[0]);
                        columnLength = Convert.ToInt32(width.ToString().Split('|')[1]);
                        column.MaxLength = DataLength > columnLength ? DataLength : columnLength;
                    }
                    try {
                        if (needDataSetOnly == false)
                        {
                            foreach (DataRow row in table.Rows)
                            {
                                row[column] = row[column].ToString().TrimEnd();

                            }
                        }
                }
                        catch (Exception ex) { }
            }
            }
            if (state == ConnectionState.Closed)
                sqlcon.Close();
            return table;
        }

        /// <summary>
        /// Convert the Dataset to xml
        /// </summary>
        /// <param name="dataset">Dataset to be converted</param>
        /// <param name="OutPutXml">XML file name to be written</param>
        private void DataSetToXml(DataSet dataset, string OutPutXml)
        {
            dataset.WriteXml(OutPutXml, XmlWriteMode.WriteSchema);
        }

        /// <summary>
        /// Returns SQLconnection for the passed sql information
        /// </summary>
        /// <param name="SqlServer"></param>
        /// <param name="DataBase"></param>
        /// <param name="UserName"></param>
        /// <param name="Password"></param>
        /// <returns></returns>
        public SqlConnection GetSqlCon(string SqlServer, string DataBase, string UserName, string Password)
        {
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source=" + SqlServer + ";Initial Catalog=" + DataBase + ";";
            if (UserName != "")
                conn.ConnectionString += "User Id=" + UserName + ";Password=" + Password + ";";
            else
                conn.ConnectionString += "Trusted_Connection=True";

            return conn;
        }

        public Boolean Error { get; set; }

        private string _errorMsg { get; set; }
        public string ErrorMsg
        {
            get
            {
                if (!string.IsNullOrEmpty(_errorMsg))
                { return "Error Happen While Processing, Please Process Again In 2 Min(s), or Conact Our Support."; }
                else { return ""; }
            }
            set
            {
                _errorMsg = value;
                System.IO.File.AppendAllText("Log.txt", System.Environment.NewLine);
                System.IO.File.AppendAllText("Log.txt", DateTime.Now.ToString());
                System.IO.File.AppendAllText("Log.txt", value.ToString());
                System.IO.File.AppendAllText("Log.txt", "-------------------------------------");

            }
        }
    }
}