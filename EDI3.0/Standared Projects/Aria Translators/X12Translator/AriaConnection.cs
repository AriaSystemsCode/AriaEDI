using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Data.OleDb;

namespace X12Translator
{
    public static class AriaConnection
    {
        public static OdbcConnection SysFilesConnection { get; set; }

        public static OdbcConnection DbfsConnection { get; set; }

        public static SqlConnection CompanyConnection { get; set; }

        public static SqlConnection ClientMasterConnection { get; set; }
        //Derby Add new Mapping Connection[Start]
        public static SqlConnection EdiMappingConnection { get; set; }
        //Derby Add new Mapping Connection[End]

        public static SqlConnection SystemMasterConnection { get; set; }

        public static string Aria27SysFilesPath { get; set; }
        //FODA [BEGIN]
        public static string MappingDbName { get; set; }
        //FODA [END]

        public static string ErrorMsg { get; set; }

        public static bool init(string ClientID, string ActiveCompany)
        {
            if (!ClientID.HasValue())
            {
                ErrorMsg = "ClientID is Empty!";
                return false;
            }
            if (!ActiveCompany.HasValue())
            {
                ErrorMsg = "Active Company is Empty!";
                return false;
            }

            Aria.Environment.AriaEnviromentVariables AriaConnection = new Aria.Environment.AriaEnviromentVariables();
            AriaConnection.ClientID = ClientID;
            AriaConnection.ConnectionsRefresh();

            string Aria27DataConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria27Data);
            string Aria27SystemFilesConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria27SystemFiles);
            string Aria40DataConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria40Data);
            string Aria40SystemFilesConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria40SystemFiles);
            string Aria50ClientConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria50ClientSystemFiles);
            string Aria50SystemFilesConnection = AriaConnection.GetConnectionString(ActiveCompany, Aria.Environment.AriaDatabaseTypes.Aria50SystemFiles);

            OdbcConnection _sysFilesConnection = new OdbcConnection(Aria27SystemFilesConnection);

            if (_sysFilesConnection != null)
            {
                _sysFilesConnection.Open();
                _sysFilesConnection.Close();
                SysFilesConnection = _sysFilesConnection;
                Aria27SysFilesPath = AriaConnection.Aria27SystemFilesPath;
            }
            else
            {
                ErrorMsg = "Connection to sysfiles: " + ClientID + " failed!";
                return false;
            }

            OdbcConnection _dbfsConnection = new OdbcConnection(Aria27DataConnection);

            if (_dbfsConnection != null)
            {
                _dbfsConnection.Open();
                _dbfsConnection.Close();
                DbfsConnection = _dbfsConnection;
            }
            else
            {
                ErrorMsg = "Connection to DBFS  failed!";
                return false;
            }

            if (!Aria40DataConnection.Trim().EndsWith(";"))
                Aria40DataConnection += ";";
            Aria40DataConnection += "Persist Security Info=True;";
            SqlConnection _companyConnection = new SqlConnection(Aria40DataConnection);
            if (_companyConnection != null)
            {
                _companyConnection.Open();
                _companyConnection.Close();
                CompanyConnection = _companyConnection;
            }
            else
            {
                ErrorMsg = "Connection to Aria4 SQL Failed!";
                return false;
            }


            if (!Aria50ClientConnection.Trim().EndsWith(";"))
                Aria50ClientConnection += ";";
            Aria50ClientConnection += "Persist Security Info=True;";
            SqlConnection _clientMasterConnection = new SqlConnection(Aria50ClientConnection);
            if (_clientMasterConnection != null)
            {
                _clientMasterConnection.Open();
                _clientMasterConnection.Close();
                ClientMasterConnection = _clientMasterConnection;
            }
            else
            {
                ErrorMsg = "Connection to Client.Master SQL Failed!";
                return false;
            }

            //Derby Add new Mapping Connection[Start]
            string mappingconn = Aria50ClientConnection;
            //FODA [BEGIN]
            //mappingconn=mappingconn.Replace(_clientMasterConnection.Database, "EDIMappings");
            mappingconn = mappingconn.Replace(_clientMasterConnection.Database, MappingDbName);
            //FODA [END]

            SqlConnection _EdiMappingConnection = new SqlConnection(mappingconn);
            if (_EdiMappingConnection != null)
            {
                _EdiMappingConnection.Open();
                _EdiMappingConnection.Close();
                EdiMappingConnection = _EdiMappingConnection;
            }
            else
            {
                ErrorMsg = "Connection to EdiMapping DataBase SQL Failed!";
                return false;
            }
            //Derby Add new Mapping Connection[End]


            if (!Aria50SystemFilesConnection.Trim().EndsWith(";"))
                Aria50SystemFilesConnection += ";";
            Aria50SystemFilesConnection += "Persist Security Info=True;";
            SqlConnection _systemMasterConnection = new SqlConnection(Aria50SystemFilesConnection);
            if (_systemMasterConnection != null)
            {
                _systemMasterConnection.Open();
                _systemMasterConnection.Close();
                SystemMasterConnection = _systemMasterConnection;
            }
            else
            {
                ErrorMsg = "Connection to System.Master SQL Failed!";
                return false;
            }
            return true;
        }
    }
}