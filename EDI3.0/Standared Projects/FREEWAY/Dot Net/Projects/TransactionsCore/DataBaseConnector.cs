using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;

namespace TransactionsCore
{
    class DataBaseConnector
    {
        public Boolean Error { get; set; }
        public string ErrorMsg { get; set; }

        public void doCommand(string ComText, string ConnectionString)
        {

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand comd = new SqlCommand(ComText, con);
            try
            {
                con.Open();
                comd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Error = true;
                ErrorMsg = ex.Message;
            }
            finally
            {
                con.Close();
            }

        }
        public DataSet ReteriveData(string ComText, string ConnectionString)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand comd = new SqlCommand(ComText, con);
            SqlDataAdapter Dad = new SqlDataAdapter(comd);
            DataSet ds = new DataSet();
            try
            {
                Dad.Fill(ds);
            }
            catch (Exception ex)
            {
                Error = true;
                ErrorMsg = ex.Message;
            }
            return ds;
        }

        public bool ExecuteScriptFile(SqlConnection con, string FilepPath)
        {
            if (File.Exists(FilepPath))
            {
                Server server = new Server(new ServerConnection(con));
                int x = server.ConnectionContext.ExecuteNonQuery(File.ReadAllText(FilepPath));
                return x > 0;
            }
            return false;
        }

        public bool ExecuteScriptText(string ConnectionString, string scriptText)
        {
            if (!string.IsNullOrEmpty(scriptText))
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                Server server = new Server(new ServerConnection(con));
                int x = server.ConnectionContext.ExecuteNonQuery(scriptText);
                return x > 0;
            }
            return false;
        }
    }
}
