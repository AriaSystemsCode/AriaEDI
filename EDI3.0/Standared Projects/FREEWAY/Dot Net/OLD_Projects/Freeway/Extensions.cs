using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Data.OleDb;

namespace Freeway
{
    public static class MyExtensions
    {
        public static bool HasValue(this string str)
        {
            return !(string.IsNullOrEmpty(str) || string.IsNullOrEmpty(str.Trim()));
        }

        public static DataTable ExecuteDataTable(this DbCommand command)
        {
            //using ()
            //{
            DataTable dt = new DataTable("Results");
            DbDataAdapter dad = new SqlDataAdapter();
            if (command.GetType() == typeof(OdbcCommand))
                dad = new OdbcDataAdapter((OdbcCommand)command);
            else if (command.GetType() == typeof(OleDbCommand))
                dad = new OleDbDataAdapter((OleDbCommand)command);
            else if (command.GetType() == typeof(SqlCommand))
                dad = new SqlDataAdapter((SqlCommand)command);

            dad.Fill(dt);
            command.Connection.Close();
            //  command.Connection.Dispose();
            return dt;
            // }       
        }

        public static string GetDetailedMessage(this Exception ex)
        {
            string message = ex.Message + " ";
            System.Diagnostics.StackTrace trace = new System.Diagnostics.StackTrace(ex, true);
            if (trace.FrameCount > 0)
            {
                message += "Method:" + trace.GetFrame(0).GetMethod().Name + " ";
                message += "Line No:" + trace.GetFrame(0).GetFileLineNumber() + " ";
                message += "File Name:" + trace.GetFrame(0).GetFileName();
            }
            return message;
        }
    }
}