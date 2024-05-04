using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Data.OleDb;

namespace CSVTranslator
{
    public class DB
    {
        internal static void UpdateEdiLibHd(string FileCode, string NewVal)
        {
            DbCommand cmd = AriaConnection.DbfsConnection.CreateCommand();
            cmd.CommandText = "update EDILIBHD set cfilecode = '" + NewVal + "' where cFileCode = '" + FileCode + "'";
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }

        internal static void UpdateArchEdiLibHd(string archFile, string aRchPath, string cFileCode)
        {
            DbCommand cmd = AriaConnection.DbfsConnection.CreateCommand();
            cmd.CommandText = "update EDILIBHD set cEdiFilNam = '" + archFile + "', cFilePath = '" + aRchPath + "' where cFileCode = '" + cFileCode + "'";
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }

        internal static void UpdateSeq(string cSeqType, decimal NewVal)
        {
            DbCommand cmd = AriaConnection.DbfsConnection.CreateCommand();
            cmd.CommandText = "update Sequence set nSeq_No = " + NewVal + " where cSeq_Type = '" + cSeqType + "'";
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }

        internal static void updateEdiLHStatus(int TrnCount, int Nrejtran, string FileCode,string Mstatus)
        {
            DbCommand cmd = AriaConnection.DbfsConnection.CreateCommand();
            cmd.CommandText = "update EDILIBHD set cStatus = 'R', nTranNumb = " + TrnCount + ",Nrejtran=" + Nrejtran + ", Mstatus = strtran( '" + Mstatus + "', " + "'|'" + ", chr(13)+chr(10)) where cFileCode = '" + FileCode + "'";
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }
        internal static void updateEdiLDStatus(string Crejreason, string FileCode)
        {
            DbCommand cmd = AriaConnection.DbfsConnection.CreateCommand();
            //cmd.CommandText = "update EDILIBDT set Crejreason = 'FFFTF', Mstatus = '" + Mstatus + "'  where cFileCode = '" + FileCode + "'";
            cmd.CommandText = "update EDILIBDT set Crejreason = '" + Crejreason + "' where cFileCode = '" + FileCode + "'";
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }
    }
}