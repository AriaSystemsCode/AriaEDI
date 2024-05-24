using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace EDI_VAN_LIB
{
    public class DB
    {
        SqlConnection con = new SqlConnection();
        SqlCommand com = new SqlCommand();
        SqlDataAdapter dt = new SqlDataAdapter();

        public DB(String ServerName, string Username, String Password, string dbName)
        {
            con.ConnectionString = @"data source='" + ServerName.Trim() + "';initial catalog='" + dbName.Trim() +
                "'; integrated security=False;User ID='" + Username.Trim() + "';Password='" + Password.Trim() + "'";
        }
        
        public DataSet SelectQuery(string query)
        {
            com.Connection = con;
            com.CommandText = query;

            try
            {
                con.Open();
                com.ExecuteReader();

            }
            catch (Exception ex)
            {
                //Console.WriteLine(ex.Message);
               // WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
            }
            finally
            {
                con.Close();

            }
            DataSet result = new DataSet();
            dt.SelectCommand = com;
            result.Clear();
            dt.Fill(result);
            return result;
        }
        public void DoQuery(string query)
        {
            com.Connection = con;
            com.CommandText = query;
            try
            {
                con.Open();
                com.ExecuteNonQuery();

            }
            catch (Exception ex)
            { //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
            }
            finally
            {
                con.Close();
            }
        }

        public static bool UpdatePH(string path, string FileName, string LogPath)
        {

            bool flag = false;
            path = path + "\\";
            OleDbConnection conn = new OleDbConnection(@"Provider=vfpoledb;Data Source=" + path + @";Collating Sequence=machine;");
            OleDbCommand command = new OleDbCommand("UPDATE EDILIBHD.dbf Set vanlog=vanlog+FILETOSTR('" + LogPath + "') where Cedifilnam = '" + FileName + @"'", conn);
            try
            {
                conn.Open();
                command.ExecuteReader();
                flag = true;
            }
            catch (Exception ex)
            {
                flag = false;
                //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
            }
            finally
            {
                conn.Close();
            }
            return flag;
        }
    }
}
