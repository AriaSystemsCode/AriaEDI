using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using System.Data;
namespace X12Translator
{
    public class SqlLite
    {
        public  SQLiteConnection SQLCON;
        public  SQLiteCommand SQLCOM;
        public  bool HasError;
        public  bool _continue;
        public  string  ErrorMsg;
        
        public  SqlLite()
        {
            SQLCON = new SQLiteConnection("Data Source=:memory:");
            SQLCOM = new SQLiteCommand(SQLCON);
            SQLCON.Open();
        }

        public void SqliteExecuteCmd(string Query)
        { 
            try
            {
                SQLCOM.CommandText = Query;
                SQLCOM.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                HasError = true;
                ErrorMsg = "Error While Executing Command to MappingTempDB Sqlite Database!, " + ex.InnerException.ToString();
                _continue = false;
                return;
            }
            finally
            {
                //SQLCON.Close();
            }
        
        }
        public  string SqliteSelectCmd(string Query)
        {
            try
            {
                string result = null;
                SQLCOM.CommandText = Query;
                var sdr = SQLCOM.ExecuteScalar();
                if (sdr != null)
                {
                    //if (!string.IsNullOrEmpty(sdr.ToString()))
                        result = sdr.ToString();
                }
                return result;
            }
            catch (Exception ex)
            {
                HasError = true;
                ErrorMsg = "Error While Selecting From MappingTempDB Sqlite Database!, " + ex.InnerException.ToString() + "  Value :" + SQLCOM;
                _continue = false;
                return null;
            }
            finally
            {
                //SQLCON.Close();
            }
        }
        public void CloseSqliteConnection()
        {
            if (SQLCON.State == ConnectionState.Open)
                SQLCON.Close();
        }

    }
}
