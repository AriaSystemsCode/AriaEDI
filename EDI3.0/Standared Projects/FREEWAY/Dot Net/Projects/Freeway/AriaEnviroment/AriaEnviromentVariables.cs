namespace Aria.Environment
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Odbc;
    using System.Data.SqlClient;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Xml;

    public class AriaEnviromentVariables
    {
        private string _aria04SQLAuthenticatedDataConnectionString = "";
        private string _aria04WindowsAuthenticatedDataConnectionString = "";
        private string _aria27DataConnectionString;
        private string _aria27SystemFilesConnectionString;
        private string _aria27SystemFilesPath = "";
        private string _aria40SystemFilesConnectionString;
        private string _aria40SystemFilesPath = "";
        private string _aria50ClientSystemFilesConnectionString;
        private string _aria50ClientSystemFilesConnectionStringOdbc;
        private string _aria50SystemFilesConnectionString;
        private string _aria50SystemFilesConnectionStringOdbc;
        private string _ariaSenderMail;
        private string _ariaSenderName;
        private string _ariaSMTPHost;
        private string _ariaSMTPPassword;
        private int _ariaSMTPPort;
        private string _ariaSMTPUserName;
        private Dictionary<string, string> _cached04DataConnectionString = new Dictionary<string, string>();
        private Dictionary<string, string> _cached27DataConnectionString = new Dictionary<string, string>();
        private string _clientDatabaseConnectionString = "";
        private string _clientID = "";
        private string _customAria50ClientSystemFilesConnectionString = "";
        private string _customAria50SystemFilesConnectionString = "";
        private bool _customConnection = false;
        private DatabaseServerLoginTypes _dbServerLoginType;
        private string _dbServerPassword = "";
        private string _dbServerUserName = "";
        private string _senderAddress = "";
        private string _senderName = "";
        private string _serverName = "";
        private int _smtpPort = 0;
        private string _smtpServer = "";
        private string _smtpUserName = "";
        private string _smtpUserPassword = "";
        private bool _ssl = true;

        public AriaEnviromentVariables()
        {
            this.Init();
            this._ariaSMTPPort = this._smtpPort;
            this._ariaSMTPHost = this._smtpServer;
            this._ariaSMTPUserName = this._smtpUserName;
            this._ariaSMTPPassword = this._smtpUserPassword;
            this._ariaSenderMail = this._senderAddress;
            this._ariaSenderName = this._senderName;
            if (this._dbServerLoginType == DatabaseServerLoginTypes.SqlServerAuthentication)
            {
                this._aria50SystemFilesConnectionString = "Data Source=" + this._serverName + ";Initial Catalog=System.Master;User ID=" + this._dbServerUserName + ";Password=" + this._dbServerPassword + ";";
                this._aria50SystemFilesConnectionStringOdbc = "Driver={SQL Server};server=" + this._serverName + ";DATABASE=System.Master;UID=" + this._dbServerUserName + ";PWD=" + this._dbServerPassword;
                this._aria50ClientSystemFilesConnectionString = "Data Source=" + this._serverName + ";Initial Catalog=Aria.Master;User ID=" + this._dbServerUserName + ";Password=" + this._dbServerPassword + ";";
                this._aria50ClientSystemFilesConnectionStringOdbc = "Driver={SQL Server};server=" + this._serverName + ";DATABASE=Aria.Master;UID=" + this._dbServerUserName + ";PWD=" + this._dbServerPassword;
            }
            else
            {
                this._aria50SystemFilesConnectionString = "Data Source=" + this._serverName + ";Initial Catalog=System.Master;Integrated Security=True";
                this._aria50SystemFilesConnectionStringOdbc = "Driver={SQL Server};server=" + this._serverName + ";DATABASE=System.Master";
                this._aria50ClientSystemFilesConnectionString = "Data Source=" + this._serverName + ";Initial Catalog=Aria.Master;Integrated Security=True";
                this._aria50ClientSystemFilesConnectionStringOdbc = "Driver={SQL Server};server=" + this._serverName + ";DATABASE=Aria.Master";
            }
            if (this.CustomConnection)
            {
                this._aria50SystemFilesConnectionString = this._customAria50SystemFilesConnectionString;
                this._aria50ClientSystemFilesConnectionString = this._customAria50ClientSystemFilesConnectionString;
            }
            this._aria27SystemFilesConnectionString = "Driver={Microsoft Visual FoxPro Driver};sourcedb=" + this._aria27SystemFilesPath + ";sourcetype=DBF;exclusive=No;Backgroundfetch=NO;collate=Machine;null=No;deleted=Yes";
            this._aria27DataConnectionString = "Driver={Microsoft Visual FoxPro Driver};sourcedb=<DataBaseLocation>;sourcetype=DBF;exclusive=No;Backgroundfetch=NO;collate=Machine;null=No;deleted=Yes";
            this._aria40SystemFilesConnectionString = "Driver={Microsoft Visual FoxPro Driver};sourcedb=" + this._aria40SystemFilesPath + ";sourcetype=DBF;exclusive=No;Backgroundfetch=NO;collate=Machine;null=No;deleted=Yes";
            this._aria04SQLAuthenticatedDataConnectionString = "Data Source=<Server>;Initial Catalog=<DBName>;User ID=<UserID>;Password=<Password>;Trusted_Connection=no";
            this._aria04WindowsAuthenticatedDataConnectionString = "Data Source=<Server>;Initial Catalog=<DBName>;Integrated Security=True";
        }

        private void AriaClientDBConnection(string ConnectionType)
        {
            string ClientID = "";
            if (string.IsNullOrEmpty(this.ClientID))
            {
                ClientID = this.GetClientID();
            }
            else
            {
                ClientID = this.ClientID.ToString().TrimEnd(new char[0]);
            }
            string ClientConn = "";
            SqlConnection Conn = new SqlConnection(this.Aria50SystemFilesConnectionString);
            Conn.Open();
            SqlCommand Cmd = new SqlCommand("select * from CLIENTS where CCLIENTID='" + ClientID + "'", Conn);
            DataTable Dt = new DataTable();
            Dt.Load(Cmd.ExecuteReader());
            if (ConnectionType == "SQL")
            {
                if (((this._dbServerLoginType == DatabaseServerLoginTypes.WindowAuthentication) && string.IsNullOrEmpty(Dt.Rows[0]["CCONPASWRD"].ToString())) && string.IsNullOrEmpty(Dt.Rows[0]["CCONUSERID"].ToString()))
                {
                    ClientConn = "Data Source=" + Dt.Rows[0]["CCONSERVER"].ToString() + ";Initial Catalog=" + Dt.Rows[0]["CCONDBNAME"].ToString() + ";Integrated Security=True;";
                }
                else
                {
                    ClientConn = "Data Source=" + Dt.Rows[0]["CCONSERVER"].ToString() + ";Initial Catalog=" + Dt.Rows[0]["CCONDBNAME"].ToString() + ";User ID=" + Dt.Rows[0]["CCONUSERID"].ToString() + ";Password=" + Dt.Rows[0]["CCONPASWRD"].ToString() + ";";
                }
            }
            if (ConnectionType == "ODBC")
            {
                if (((this._dbServerLoginType == DatabaseServerLoginTypes.WindowAuthentication) && string.IsNullOrEmpty(Dt.Rows[0]["CCONPASWRD"].ToString())) && string.IsNullOrEmpty(Dt.Rows[0]["CCONUSERID"].ToString()))
                {
                    ClientConn = "Driver={SQL Server};server=" + Dt.Rows[0]["CCONSERVER"].ToString() + ";DATABASE=" + Dt.Rows[0]["CCONDBNAME"].ToString();
                }
                else
                {
                    ClientConn = "Driver={SQL Server};server=" + Dt.Rows[0]["CCONSERVER"].ToString() + ";DATABASE=" + Dt.Rows[0]["CCONDBNAME"].ToString() + ";UID=" + Dt.Rows[0]["CCONUSERID"].ToString() + ";PWD=" + Dt.Rows[0]["CCONPASWRD"].ToString();
                }
            }
            this._clientDatabaseConnectionString = ClientConn;
            Conn.Close();
        }

        public void ConnectionsRefresh()
        {
            if (!string.IsNullOrEmpty(this.ClientID))
            {
                this.AriaClientDBConnection("SQL");
                this._aria50ClientSystemFilesConnectionString = this._clientDatabaseConnectionString;
                this.AriaClientDBConnection("ODBC");
                this._aria50ClientSystemFilesConnectionStringOdbc = this._clientDatabaseConnectionString;
                SqlConnection Conn = new SqlConnection(this.Aria50SystemFilesConnectionString);
                Conn.Open();
                SqlCommand Cmd = new SqlCommand("select * from CLIENTS where CCLIENTID='" + this.ClientID + "'", Conn);
                DataTable Dt = new DataTable();
                Dt.Load(Cmd.ExecuteReader());
                this._aria27SystemFilesPath = Dt.Rows[0]["ARIA27SYS"].ToString().TrimEnd(new char[0]);
                this._aria40SystemFilesPath = Dt.Rows[0]["ARIA40SYS"].ToString().TrimEnd(new char[0]);
                Conn.Close();
                this._aria27SystemFilesConnectionString = "Driver={Microsoft Visual FoxPro Driver};sourcedb=" + this._aria27SystemFilesPath + ";sourcetype=DBF;exclusive=No;Backgroundfetch=NO;collate=Machine;null=No;deleted=Yes";
                this._aria40SystemFilesConnectionString = "Driver={Microsoft Visual FoxPro Driver};sourcedb=" + this._aria40SystemFilesPath + ";sourcetype=DBF;exclusive=No;Backgroundfetch=NO;collate=Machine;null=No;deleted=Yes";
                Conn.Close();
            }
        }

        public string GetAria04CompanyDataConnectionString(string companyID)
        {
            if (this._cached04DataConnectionString.ContainsKey(companyID))
            {
                return this._cached04DataConnectionString[companyID];
            }
            OdbcCommand command = new OdbcCommand {
                CommandText = "SELECT CconServer,CconDbname,Cconuserid,Cconpaswrd FROM Syccomp WHERE Ccomp_id = '" + companyID + "'",
                Connection = new OdbcConnection()
            };
            command.Connection.ConnectionString = this._aria27SystemFilesConnectionString;
            command.Connection.Open();
            OdbcDataAdapter dataAdapter = new OdbcDataAdapter(command);
            DataTable row = new DataTable();
            dataAdapter.Fill(row);
            string res = "";
            if (row.Rows[0]["Cconuserid"].ToString().Trim().CompareTo("") == 0)
            {
                res = this._aria04WindowsAuthenticatedDataConnectionString.Replace("<Server>", row.Rows[0]["CconServer"].ToString()).Replace("<DBName>", row.Rows[0]["CconDbname"].ToString());
                this._cached04DataConnectionString.Add(companyID, res);
                return res;
            }
            res = this._aria04SQLAuthenticatedDataConnectionString.Replace("<Server>", row.Rows[0]["CconServer"].ToString()).Replace("<DBName>", row.Rows[0]["CconDbname"].ToString()).Replace("<UserID>", row.Rows[0]["Cconuserid"].ToString()).Replace("<Password>", row.Rows[0]["Cconpaswrd"].ToString());
            this._cached04DataConnectionString.Add(companyID, res);
            return res;
        }

        public string GetAria27CompanyDataConnectionString(string companyID)
        {
            if (this._cached27DataConnectionString.ContainsKey(companyID))
            {
                return this._cached27DataConnectionString[companyID];
            }
            OdbcCommand command = new OdbcCommand {
                CommandText = "SELECT Ccom_ddir FROM Syccomp WHERE Ccomp_id = '" + companyID + "'",
                Connection = new OdbcConnection()
            };
            command.Connection.ConnectionString = this._aria27SystemFilesConnectionString;
            command.Connection.Open();
            OdbcDataAdapter dataAdapter = new OdbcDataAdapter(command);
            DataTable row = new DataTable();
            dataAdapter.Fill(row);
            string RealPath = "";
            RealPath = row.Rows[0]["Ccom_ddir"].ToString();
            //if ((RealPath.Length > 2) && (RealPath[1] == ':'))
            //{
            //    int errorout = 0;
            //    RealPath = GetUNCPath2(RealPath, out errorout);
            //    if (errorout != 0)
            //    {
            //        SqlConnection Conn = new SqlConnection(this.Aria50SystemFilesConnectionString);
            //        Conn.Open();
            //        SqlCommand Cmd = new SqlCommand("SELECT * from CLIENTS WHERE CCLIENTID='" + this.ClientID + "'", Conn);
            //        DataTable Dt = new DataTable();
            //        Dt.Load(Cmd.ExecuteReader());
            //        RealPath = Path.Combine(Dt.Rows[0]["CDATAPATH"].ToString().TrimEnd(new char[0]).Trim().ToUpper(), row.Rows[0]["Ccom_ddir"].ToString().Substring(3));
            //        Conn.Close();
            //    }
            //}
            string res = this._aria27DataConnectionString.Replace("<DataBaseLocation>", RealPath);
            this._cached27DataConnectionString.Add(companyID, res);
            if (!string.IsNullOrEmpty(this.ClientID))
            {
                command.Connection.Close();
                command.CommandText = "SELECT Cfld_name, mdata_def FROM Setups WHERE cFld_Name in('M_SMTPSRVR','M_SMTPPORT','M_SMTPUSER','M_SMTPPSS ', 'M_SNDRNME ' ,'M_SSL     ','M_SMTPUSR2')";
                command.Connection = new OdbcConnection();
                command.Connection.ConnectionString = res;
                row.Rows.Clear();
                dataAdapter.Fill(row);
                if (row.Rows.Count == 0)
                {
                    throw new Exception("Couldn't Find Aria4 Email settings for company " + companyID);
                }
                this._smtpServer = row.Select("cFld_Name = 'M_SMTPSRVR'")[0]["mdata_def"].ToString();
                if (this._smtpServer.Trim() == "")
                {
                    throw new Exception("Couldn't Find Aria4 Email settings (SMTP Server) for company " + companyID);
                }
                this._ariaSMTPHost = this._smtpServer;
                if (row.Select("cFld_Name = 'M_SMTPPORT'")[0]["mdata_def"].ToString().Trim() == "")
                {
                    throw new Exception("Couldn't Find Aria4 Email settings (SMTP Port) for company " + companyID);
                }
                this._smtpPort = int.Parse(row.Select("cFld_Name = 'M_SMTPPORT'")[0]["mdata_def"].ToString());
                this._ariaSMTPPort = this._smtpPort;
                this._smtpUserName = row.Select("cFld_Name = 'M_SMTPUSER'")[0]["mdata_def"].ToString();
                if (this._smtpUserName.Trim() == "")
                {
                    throw new Exception("Couldn't Find Aria4 Email settings (SMTP UserName) for company " + companyID);
                }
                this._ariaSMTPUserName = this._smtpUserName;
                this._smtpUserPassword = row.Select("cFld_Name = 'M_SMTPPSS '")[0]["mdata_def"].ToString();
                if (this._smtpUserPassword.Trim() == "")
                {
                    throw new Exception("Couldn't Find Aria4 Email settings (SMTP Password) for company " + companyID);
                }
                this._ariaSMTPPassword = this._smtpUserPassword;
                this._senderName = row.Select("cFld_Name = 'M_SNDRNME '")[0]["mdata_def"].ToString();
                this._ariaSenderName = this._senderName;
                this._senderAddress = row.Select("cFld_Name = 'M_SMTPUSR2'")[0]["mdata_def"].ToString();
                this._ariaSenderMail = this._senderAddress;
                this._ssl = false;
                if ((row.Select("cFld_Name = 'M_SSL     '")[0]["mdata_def"].ToString().ToUpper().TrimEnd(new char[0]) == ".T.") || (row.Select("cFld_Name = 'M_SSL     '")[0]["mdata_def"].ToString().ToUpper().TrimEnd(new char[0]) == "TRUE"))
                {
                    this._ssl = true;
                }
                else if ((row.Select("cFld_Name = 'M_SSL     '")[0]["mdata_def"].ToString().ToUpper().TrimEnd(new char[0]) == ".F.") || (row.Select("cFld_Name = 'M_SSL     '")[0]["mdata_def"].ToString().ToUpper().TrimEnd(new char[0]) == "FALSE"))
                {
                    this._ssl = false;
                }
            }
            return res;
        }

        public string GetClientID()
        {
            string XMLPath = GetUNCPath(@"X:\") + @"\Client_Setting.XML";
            DataSet DS = new DataSet();
            DS.ReadXml(XMLPath);
            if (DS.Tables[0].Rows.Count > 0)
            {
                return DS.Tables[0].Rows[0]["ClientID"].ToString();
            }
            return "";
        }

        public string GetConnectionString(string companyName, AriaDatabaseTypes databaseType)
        {
            switch (databaseType)
            {
                case AriaDatabaseTypes.Aria27Data:
                    return this.GetAria27CompanyDataConnectionString(companyName);

                case AriaDatabaseTypes.Aria40Data:
                    return this.GetAria04CompanyDataConnectionString(companyName);

                case AriaDatabaseTypes.Aria27SystemFiles:
                    return this.Aria27SystemFilesConnectionString;

                case AriaDatabaseTypes.Aria40SystemFiles:
                    return this.Aria40SystemFilesConnectionString;

                case AriaDatabaseTypes.Aria50SystemFiles:
                    return this.Aria50SystemFilesConnectionString;

                case AriaDatabaseTypes.Aria50ClientSystemFiles:
                    return this.Aria50ClientSystemFilesConnectionString;
            }
            return "";
        }

        public static string GetUNCPath(string originalPath)
        {
            StringBuilder sb = new StringBuilder(0x200);
            int size = sb.Capacity;
            if ((originalPath.Length > 2) && (originalPath[1] == ':'))
            {
                char c = originalPath[0];
                if ((((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z'))) && (WNetGetConnection(originalPath.Substring(0, 2), sb, ref size) == 0))
                {
                    string path = Path.GetFullPath(originalPath).Substring(Path.GetPathRoot(originalPath).Length);
                    return Path.Combine(sb.ToString().TrimEnd(new char[0]), path);
                }
            }
            return originalPath;
        }

        public static string GetUNCPath2(string originalPath, out int errorout)
        {
            StringBuilder sb = new StringBuilder(0x200);
            int size = sb.Capacity;
            errorout = 0;
            if ((originalPath.Length > 2) && (originalPath[1] == ':'))
            {
                char c = originalPath[0];
                if (((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z')))
                {
                    int error = WNetGetConnection(originalPath.Substring(0, 2), sb, ref size);
                    errorout = error;
                    if (error == 0)
                    {
                        string path = Path.GetFullPath(originalPath).Substring(Path.GetPathRoot(originalPath).Length);
                        return Path.Combine(sb.ToString().TrimEnd(new char[0]), path);
                    }
                }
            }
            return originalPath;
        }

        private void Init()
        {
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.Load(Environment.GetEnvironmentVariable("ARIA_SERVER_CONFIGURATION_PATH", EnvironmentVariableTarget.Machine));
            XmlElement documentElement = xmlDocument.DocumentElement;
            for (int index = 0; index < documentElement.ChildNodes.Count; index++)
            {
                XmlNode xmlNode;
                int childIndex;
                if (documentElement.ChildNodes[index].Name == "EmailSettings")
                {
                    xmlNode = null;
                    childIndex = 0;
                    while (childIndex < documentElement.ChildNodes[index].ChildNodes.Count)
                    {
                        xmlNode = documentElement.ChildNodes[index].ChildNodes[childIndex];
                        if (xmlNode.Name == "SmtpServer")
                        {
                            this._smtpServer = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "SmtpPort")
                        {
                            this._smtpPort = int.Parse(xmlNode.InnerText);
                        }
                        else if (xmlNode.Name == "SmtpUserName")
                        {
                            this._smtpUserName = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "SmtpUserPassword")
                        {
                            this._smtpUserPassword = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "SenderAddress")
                        {
                            this._senderAddress = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "SenderName")
                        {
                            this._senderName = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "SSL")
                        {
                            this._ssl = Convert.ToBoolean(xmlNode.InnerText);
                        }
                        childIndex++;
                    }
                }
                else if (documentElement.ChildNodes[index].Name == "DatabaseSetup")
                {
                    xmlNode = null;
                    for (childIndex = 0; childIndex < documentElement.ChildNodes[index].ChildNodes.Count; childIndex++)
                    {
                        xmlNode = documentElement.ChildNodes[index].ChildNodes[childIndex];
                        if (xmlNode.Name == "Aria27SystemFilesPath")
                        {
                            this._aria27SystemFilesPath = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "Aria40SystemFilesPath")
                        {
                            this._aria40SystemFilesPath = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "ServerName")
                        {
                            this._serverName = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "ServerLoginType")
                        {
                            this._dbServerLoginType = (DatabaseServerLoginTypes) Enum.Parse(typeof(DatabaseServerLoginTypes), xmlNode.InnerText);
                        }
                        else if (xmlNode.Name == "UserName")
                        {
                            this._dbServerUserName = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "Password")
                        {
                            this._dbServerPassword = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "CustomConnection")
                        {
                            if (string.IsNullOrEmpty(xmlNode.InnerText))
                            {
                                this._customConnection = false;
                            }
                            if ((xmlNode.InnerText.ToLower() == "true") || (xmlNode.InnerText.ToLower() == "false"))
                            {
                                this._customConnection = Convert.ToBoolean(xmlNode.InnerText);
                            }
                            else
                            {
                                this._customConnection = false;
                            }
                        }
                        else if (xmlNode.Name == "Aria50SystemFilesConnectionString")
                        {
                            this._customAria50SystemFilesConnectionString = xmlNode.InnerText;
                        }
                        else if (xmlNode.Name == "Aria50ClientSystemFilesConnectionString")
                        {
                            this._customAria50ClientSystemFilesConnectionString = xmlNode.InnerText;
                        }
                    }
                }
            }
        }

        [DllImport("mpr.dll", CharSet=CharSet.Unicode, SetLastError=true)]
        public static extern int WNetGetConnection([MarshalAs(UnmanagedType.LPTStr)] string localName, [MarshalAs(UnmanagedType.LPTStr)] StringBuilder remoteName, ref int length);

        public string Aria04SQLAuthenticatedDataConnectionString
        {
            get
            {
                return this._aria04SQLAuthenticatedDataConnectionString;
            }
            set
            {
                this._aria04SQLAuthenticatedDataConnectionString = value;
            }
        }

        public string Aria04WindowsAuthenticatedDataConnectionString
        {
            get
            {
                return this.Aria04WindowsAuthenticatedDataConnectionString;
            }
            set
            {
                this.Aria04WindowsAuthenticatedDataConnectionString = value;
            }
        }

        public string Aria27DataConnectionString
        {
            get
            {
                return this._aria27DataConnectionString;
            }
            set
            {
                this._aria27DataConnectionString = value;
            }
        }

        public string Aria27SystemFilesConnectionString
        {
            get
            {
                return this._aria27SystemFilesConnectionString;
            }
            set
            {
                this._aria27SystemFilesConnectionString = value;
            }
        }

        public string Aria27SystemFilesPath
        {
            get
            {
                return this._aria27SystemFilesPath;
            }
            set
            {
                this._aria27SystemFilesPath = value;
            }
        }

        public string Aria40SystemFilesConnectionString
        {
            get
            {
                return this._aria40SystemFilesConnectionString;
            }
            set
            {
                this._aria40SystemFilesConnectionString = value;
            }
        }

        public string Aria40SystemFilesPath
        {
            get
            {
                return this._aria40SystemFilesPath;
            }
            set
            {
                this._aria40SystemFilesPath = value;
            }
        }

        public string Aria50ClientSystemFilesConnectionString
        {
            get
            {
                return this._aria50ClientSystemFilesConnectionString;
            }
            set
            {
                this._aria50ClientSystemFilesConnectionString = value;
            }
        }

        public string Aria50ClientSystemFilesConnectionStringOdbc
        {
            get
            {
                return this._aria50ClientSystemFilesConnectionStringOdbc;
            }
            set
            {
                this._aria50ClientSystemFilesConnectionStringOdbc = value;
            }
        }

        public string Aria50SystemFilesConnectionString
        {
            get
            {
                return this._aria50SystemFilesConnectionString;
            }
            set
            {
                this._aria50SystemFilesConnectionString = value;
            }
        }

        public string Aria50SystemFilesConnectionStringOdbc
        {
            get
            {
                return this._aria50SystemFilesConnectionStringOdbc;
            }
            set
            {
                this._aria50SystemFilesConnectionStringOdbc = value;
            }
        }

        public string AriaSenderMail
        {
            get
            {
                return this._ariaSenderMail;
            }
            set
            {
                this._ariaSenderMail = value;
            }
        }

        public string AriaSenderName
        {
            get
            {
                return this._ariaSenderName;
            }
            set
            {
                this._ariaSenderName = value;
            }
        }

        public string AriaSMTPHost
        {
            get
            {
                return this._ariaSMTPHost;
            }
            set
            {
                this._ariaSMTPHost = value;
            }
        }

        public string AriaSMTPPassword
        {
            get
            {
                return this._ariaSMTPPassword;
            }
            set
            {
                this._ariaSMTPPassword = value;
            }
        }

        public int AriaSMTPPort
        {
            get
            {
                return this._ariaSMTPPort;
            }
            set
            {
                this._ariaSMTPPort = value;
            }
        }

        public string AriaSMTPUserName
        {
            get
            {
                return this._ariaSMTPUserName;
            }
            set
            {
                this._ariaSMTPUserName = value;
            }
        }

        public string ClientDatabaseConnectionString
        {
            get
            {
                if (this._clientDatabaseConnectionString.Length <= 0)
                {
                    this.AriaClientDBConnection("SQL");
                }
                return this._clientDatabaseConnectionString;
            }
        }

        public string ClientDatabaseConnectionStringODBC
        {
            get
            {
                if (this._clientDatabaseConnectionString.Length <= 0)
                {
                    this.AriaClientDBConnection("ODBC");
                }
                return this._clientDatabaseConnectionString;
            }
        }

        public string ClientID
        {
            get
            {
                return this._clientID;
            }
            set
            {
                this._clientID = value;
            }
        }

        public string CustomAria50ClientSystemFilesConnectionString
        {
            get
            {
                return this._customAria50ClientSystemFilesConnectionString;
            }
            set
            {
                this._customAria50ClientSystemFilesConnectionString = value;
            }
        }

        public string CustomAria50SystemFilesConnectionString
        {
            get
            {
                return this._customAria50SystemFilesConnectionString;
            }
            set
            {
                this._customAria50SystemFilesConnectionString = value;
            }
        }

        public bool CustomConnection
        {
            get
            {
                return this._customConnection;
            }
            set
            {
                this._customConnection = value;
            }
        }

        public bool Ssl
        {
            get
            {
                return this._ssl;
            }
            set
            {
                this._ssl = value;
            }
        }
    }
}

