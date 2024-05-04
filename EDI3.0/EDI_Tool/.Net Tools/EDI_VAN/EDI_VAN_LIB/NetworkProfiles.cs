using System;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Data;
using System.IO;
using System.Diagnostics;
using System.Windows;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net;
using System.Xml;
using System.Xml.Linq;
using Newtonsoft.Json;

namespace EDI_VAN_LIB
{
    public class NetworkProfiles
    {

        #region Properties
        static PropertyInfo[] propertyInfos;

        public string ServerName;
        public string ServerUserName;
        public string ServerPassword;
        
        public string ErrorMessageString = "";

        private String NewFileName;
        private String ToFileName;

        private string _networkDirection;
        public string NetworkDirection
        {
            get { return _networkDirection; }
            set { _networkDirection = value; }
        }

        private Boolean _DownloadFlag;
        public Boolean DownloadFlag
        {
            get { return _DownloadFlag; }
            set
            {
                if (!String.IsNullOrEmpty(NetworkDirection) && NetworkDirection == "SEND")
                { _DownloadFlag = false; }
                else
                { _DownloadFlag = value; }
            }
        }

        private string _addDatetime;
        public string AddDatetime
        {
            get { return (_addDatetime != null) ? _addDatetime : ""; }
            set
            { _addDatetime = value;  
            }
        }

        private Boolean _UploadFlag;
        public Boolean UploadFlag
        {
            get { return _UploadFlag; }
            set
            {
                if (!String.IsNullOrEmpty(NetworkDirection) && NetworkDirection == "RECEIVE")
                { _UploadFlag = false; }
                else
                { _UploadFlag = value; }
            }
        }
        private Boolean _PreConditionFlag;

        public Boolean PreConditionFlag
        {
            get { return _PreConditionFlag; }
            set { _PreConditionFlag = value; }
        }
        private Boolean _PostConditionFlag;

        public Boolean PostConditionFlag
        {
            get { return _PostConditionFlag; }
            set { _PostConditionFlag = value; }
        }
        private string _ClientID;
        public string ClientID
        {
            get { return _ClientID; }
            set { _ClientID = value; }
        }


        private string _NetWorkID;
        public string NetWorkID
        {
            get { return _NetWorkID; }
            set { _NetWorkID = value; }
        }
        private string _SiteName;
        public string SiteName
        {
            get { return _SiteName; }
            set { _SiteName = value; }
        }

        private string _URL;
        public string URL
        {
            get { return _URL; }
            set { _URL = value; }
        }

        private string _UserName;
        public string UserName
        {
            get { return _UserName; }
            set { _UserName = value; }
        }

        private string _Password;
        public string Password
        {
            get { return _Password; }
            set { _Password = value; }
        }

        private string _InComingFileName;
        public string InComingFileName
        {
            get { return _InComingFileName; }
            set { _InComingFileName = value; }
        }

        private string _inComingEmail;
        public string InComingEmail
        {
            get { return _inComingEmail; }
            set { _inComingEmail = value; }
        }

        private string _outGoingingEmail;
        public string OutGoingingEmail
        {
            get { return _outGoingingEmail; }
            set { _outGoingingEmail = value; }
        }

        private string _OutGoingFileName;
        public string OutGoingFileName
        {
            get { return _OutGoingFileName; }
            set { _OutGoingFileName = value; }
        }

        private Boolean _stillHasData;
        public Boolean StillHasData
        {
            get { return _stillHasData; }
            set { _stillHasData = value; }
        }
        private string _NetworkInboxFolder;
        public string NetworkInboxFolder
        {
            get { return _NetworkInboxFolder; }
            set { _NetworkInboxFolder = value; }
        }

        private string _NetworkOutboxFolder;
        public string NetworkOutboxFolder
        {
            get { return _NetworkOutboxFolder; }
            set { _NetworkOutboxFolder = value; }
        }

        private string _CompanyID;
        public string CompanyID
        {
            get { return _CompanyID; }
            set { _CompanyID = value; }
        }

        private string _EDIClientPath;
        public string EDIClientPath
        {
            get { return _EDIClientPath; }
            set { _EDIClientPath = value; }
        }

        private string _EDIOutboxPath;
        public string EDIOutboxPath
        {
            get { return _EDIOutboxPath; }
            set { _EDIOutboxPath = value; }
        }

        private string _EDIClientDBFSPath;

        public string EDIClientDBFSPath
        {
            get { return _EDIClientDBFSPath; }
            set { _EDIClientDBFSPath = value; }
        }

        private string _EDIFTPHistoryPath;
        public string EDIFTPHistoryPath
        {
            get { return _EDIFTPHistoryPath; }
            set { _EDIFTPHistoryPath = value; }
        }

        private string _EDIArchiveProgramPath;

        public string EDIArchiveProgramPath
        {
            get { return _EDIArchiveProgramPath; }
            set { _EDIArchiveProgramPath = value; }
        }

        private string _PostTransferCommand;
        public string PostTransferCommand
        {
            get { return _PostTransferCommand; }
            set { _PostTransferCommand = value; }
        }

        private string _PreTransferCommand;
        public string PreTransferCommand
        {
            get { return _PreTransferCommand; }
            set { _PreTransferCommand = value; }
        }

        private string _NetworkOutGoingFileName;

        public string NetworkOutGoingFileName
        {
            get { return _NetworkOutGoingFileName; }
            set { _NetworkOutGoingFileName = value; }
        }

        private string _NetGroup;
        public string NetGroup
        {
            get { return _NetGroup; }
            set { _NetGroup = value; }
        }
        #endregion

        private string _downloadedFileName;
        public string DownloadedFileName
        {
            get { return _downloadedFileName; }
            set { _downloadedFileName = value; }
        }

        #region Methods
        public NetworkProfiles()
        { }

        public DataSet ConenctToClientMasterDB(string[] args)
        {


            string networkName = "";
            if (args.Count() > 2)
            { networkName = args[2].ToString().ToUpper(); }

            XmlDocument xml = new XmlDocument();
            xml.Load(args[0].ToString() + "/Client_Setting.xml");
            XmlNode node = xml.SelectSingleNode("VFPData").SelectSingleNode("clientset").SelectSingleNode("clientid");
            XmlNode nodeClientConnection = xml.SelectSingleNode("VFPData").SelectSingleNode("clientset").SelectSingleNode("clientconnectionstring");

            string ClientID = node.InnerText;
            string ClientMasterDbName = ClientID.Trim() + ".Master";
            // string ServerName = @"ARIATesting\ARIASQLSERVER";
            //string userName ="sa";
            //string password = "aria_123";
            //ServerName = @"Ariasql\ARIASQLSERVER";
            //ServerUserName = "sa";
            //ServerPassword = "aria_123";

            ServerName = nodeClientConnection.InnerText.Split(';')[1].Split('=')[1];
            ServerUserName = nodeClientConnection.InnerText.Split(';')[3].Split('=')[1];
            ServerPassword = nodeClientConnection.InnerText.Split(';')[4].Split('=')[1];
            DB Connecttodb = new DB(ServerName, ServerUserName, ServerPassword, ClientMasterDbName);

            string sqlStr = "Select  * from NetworkProfiles";
            if (networkName != "")
            { sqlStr = sqlStr + " where NetWorkID = '" + networkName + "'"; }

            DataSet ClientNetworks = Connecttodb.SelectQuery(sqlStr);
            //Assembly.LoadFrom
            return ClientNetworks;
        }

        public void Do(string path, string pNetworkDirection, string pNetwork, string silentMode, string callReset)
        {
            string[] args = new string[4];
            //args[0] = @"\\10.0.1.18\lac99sh\ARIA4XP\SYSFILES";
            //args[1] = "RECEIVE";
            //args[2] = "SHPPO";
            //args[3] = "Y";

            args[0] = @path;
            args[1] = pNetworkDirection;
            args[2] = pNetwork;
            args[3] = silentMode;

            DataSet temp = ConenctToClientMasterDB(args);
            DataTable NetTable = temp.Tables[0];
            ImportData(NetTable, NetTable.Rows[0]);
            string networkDirection = pNetworkDirection;
            string CoreFtpPath = "";
            System.Collections.Specialized.NameValueCollection appSettings = new System.Collections.Specialized.NameValueCollection();
            if (!string.IsNullOrEmpty(callReset) && callReset == "Y")
            {
                ResetBatch(CoreFtpPath, appSettings, networkDirection);
            }
            ProcessBatch(CoreFtpPath, appSettings, networkDirection);
        }
        public string GetInsert()
        {
            string Insert = "INSERT INTO  " + this.GetType().Name + " ( ";
            string Values = " VALUES ( ";
            if (propertyInfos == null)
            { propertyInfos = typeof(NetworkProfiles).GetProperties(); }

            foreach (var property in propertyInfos)
            {
                Insert += "[" + property.Name + "],";
                // Values += GetPropValue(property, property.Name);

                var value = property.GetValue(this, null);
                if (value != null)
                {
                    Values += "'" + value.ToString() + "',";
                }
                else
                {
                    Values += "'',";
                }

            }
            Insert = Insert.TrimEnd(',');
            Insert += ")";
            Values = Values.TrimEnd(',');
            Values += ")";
            return Insert + Values;

        }

        public void ImportData(DataTable table, DataRow row)
        {
            foreach (DataColumn cl in table.Columns)
            {
                PropertyInfo prop = this.GetType().GetProperty(cl.ColumnName, BindingFlags.Public | BindingFlags.Instance);
                if (cl.DataType.ToString() == "System.Boolean")
                {
                    prop.SetValue(this, (row[table.Columns.IndexOf(cl)].ToString()) == "" ? false : (row[table.Columns.IndexOf(cl)]), null);
                }
                else
                {   

                    prop.SetValue(this, (row[table.Columns.IndexOf(cl)]) is null ? "" : (row[table.Columns.IndexOf(cl)]).ToString(), null);
                }
            }
        }

        public bool ProcessBatch(string CoreFtpPath, System.Collections.Specialized.NameValueCollection appSettings, string networkDirection = "")
        {
            NetworkDirection = networkDirection;
            DownloadFlag = !string.IsNullOrEmpty(NetworkOutboxFolder) ? true : false;
            UploadFlag = !string.IsNullOrEmpty(NetworkInboxFolder) ? true : false;
            PreConditionFlag = !string.IsNullOrEmpty(PreTransferCommand) ? true : false;
            PostConditionFlag = !string.IsNullOrEmpty(PostTransferCommand) ? true : false;


            CoreFtpPath = '"' + CoreFtpPath + '"';
            string cmd = @"/c " + CoreFtpPath + " -site " + this.SiteName + "";
            bool UploadSuccessed = false;
            bool ProcessSuccessed = false;
            // rename the network if starts with 'Exp'
            if (!string.IsNullOrEmpty(NetworkOutGoingFileName) & NetworkOutGoingFileName.StartsWith("Exp"))
            {
                string finalName = "";
                string[] NameParts;
                string TempName = NetworkOutGoingFileName.Remove(0, 4);
                TempName = TempName.Remove(TempName.Length - 1, 1);
                char[] splitchar = { '%' };
                NameParts = TempName.Split(splitchar);
                foreach (var Part in NameParts)
                {
                    if (Part.StartsWith("this"))
                    {
                        finalName = finalName + this.GetType().GetProperty(Part.Remove(0, 5)).GetValue(this, null);
                    }
                    else if (Part.StartsWith("'"))
                    {
                        string tempPart = Part.Remove(0, 1);

                        finalName = finalName + tempPart.Remove(tempPart.Length - 1, 1); ;
                    }
                    else
                    {
                        object x = EvalCSCode.Eval(Part);
                        finalName = finalName + x.ToString();
                    }
                }
                this.NewFileName = finalName;
            }
            else
            {
                this.NewFileName = this.NetworkOutGoingFileName;

                if (!string.IsNullOrEmpty(this.AddDatetime) && this.AddDatetime == "Y")
                { 
                    //if (string.IsNullOrEmpty(this.ToFileName))
                    { this.ToFileName = this.OutGoingFileName; }

                    if (!string.IsNullOrEmpty(this.ToFileName) && this.ToFileName.Contains(".") )
                    {   
                        this.ToFileName = this.ToFileName.Replace(".", '_' + DateTime.Now.ToString("yyyyMMddhhmmss") + ".");
                    }
                    else
                    { this.ToFileName = this.ToFileName + '_' + DateTime.Now.ToString("yyyyMMddhhmmss"); }
                      
                }
            }
            StillHasData = true;
            var start = DateTime.Now;
            while (StillHasData == true)
            {
                StillHasData = false;
                // execute precondition
                if (PreConditionFlag)
                {
                    DoCondition(this.PreTransferCommand);
                }

                // execute API networks
                if (URL != "")
                {
                    // call apis
                    if (!string.IsNullOrEmpty(InComingFileName))
                    {
                        ProcessSuccessed = false;
                        ApiConnectGet();
                        if (!string.IsNullOrEmpty(InComingEmail))
                        {
                            //SendEmail(appSettings, "Download");
                        }
                        ProcessSuccessed = true;
                    }

                    if (!string.IsNullOrEmpty(OutGoingFileName))
                    {
                        ProcessSuccessed = false;
                        ApiConnectPost();
                        if (!string.IsNullOrEmpty(OutGoingingEmail))
                        {
                            // SendEmail(appSettings, "Upload");
                        }
                        ProcessSuccessed = true;
                    }
                }
                else
                {// execute non API networks
                    if (DownloadFlag)
                    {
                        ProcessSuccessed = false;
                        Download(cmd);
                        if (!string.IsNullOrEmpty(InComingEmail))
                        {
                            SendEmail(appSettings, "Download");
                        }
                        ProcessSuccessed = true;
                    }

                    if (UploadFlag && ValidateRowFile(this.EDIOutboxPath))
                    {
                        ProcessSuccessed = false;
                        UploadSuccessed = Upload(cmd, appSettings);
                        if (!string.IsNullOrEmpty(OutGoingingEmail))
                        {
                            SendEmail(appSettings, "Upload");
                        }
                        ProcessSuccessed = true;
                    }
                }

                Archive(UploadSuccessed);

                if (PostConditionFlag)
                { DoCondition(this.PostTransferCommand); }
            }
            var end = DateTime.Now - start;
            return ProcessSuccessed;
        }

        public bool ResetBatch(string CoreFtpPath, System.Collections.Specialized.NameValueCollection appSettings, string networkDirection = "")
        {
            string ClientMasterDbName = this.ClientID.Trim() + ".Master";
            EDI_VAN_LIB.DB Connecttodb = new EDI_VAN_LIB.DB(this.ServerName, this.ServerUserName, this.ServerPassword, ClientMasterDbName);
            if (PreTransferCommand.Contains("since_id"))
            {
                string sqlStr = "Update networkProfiles  set PreTransferCommand='since_id' where networkid='" + this.NetWorkID + "' AND PreTransferCommand LIKE '%since_id%'";
                Connecttodb.DoQuery(sqlStr);
                PreTransferCommand = "since_id";
            }
            return true;
        }

        private void SendEmail(System.Collections.Specialized.NameValueCollection appSettings, string cKey)
        {

            try
            {
                MailAttachment AttRowFile = new MailAttachment(System.IO.File.ReadAllText(this.EDIOutboxPath).ToUpper(), this.OutGoingFileName);
                string emailBody = appSettings[cKey];
                string emailSubject = appSettings[cKey + "SUBJECT"];
                string email = appSettings["Email"];
                string emailPassword = appSettings["EmailPassword"];
                string emailTo = appSettings["To"];
                string emailCC = appSettings["CC"];
                string emailCC1 = appSettings["CC1"];
                string emailDisplayName = appSettings["DisplayName"];

                Mail.Email(emailBody, emailSubject, email, emailPassword, emailTo, emailCC, emailCC1, emailDisplayName);
            }
            catch (Exception ex)
            {

                //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
            }

        }

        public void DoCondition(string cmd)
        {
            string[] preConitions = cmd.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string condition in preConitions)
            {
                if (!string.IsNullOrEmpty(condition) && condition.ToUpper().Contains(".DLL"))
                {

                    var physical_path = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + @"\";

                    var objectFromExternalDLL = Assembly.LoadFrom(physical_path + condition);
                    var dllName = System.IO.Path.GetFileNameWithoutExtension(condition);
                    // Get the type to use.
                    Type myType = objectFromExternalDLL.GetType(dllName + ".Main");
                    // Get the method to call.
                    MethodInfo myMethod = myType.GetMethod("Do");
                    // Create an instance.
                    object obj = Activator.CreateInstance(myType);
                    // Execute the method.
                    string ClientMasterDbName = this.ClientID.Trim() + ".Master";
                    try
                    {
                        if (!string.IsNullOrEmpty(DownloadedFileName))
                        {
                            object[] parameters = new object[7];
                            parameters[0] = DownloadedFileName;
                            parameters[1] = ServerName;
                            parameters[2] = ServerUserName;
                            parameters[3] = ServerPassword;
                            parameters[4] = NetworkInboxFolder.Contains(',') ? NetworkInboxFolder.Split(',')[2] : NetworkInboxFolder;
                            parameters[5] = ClientMasterDbName;
                            parameters[6] = NetWorkID;

                            myMethod.Invoke(obj, parameters);
                            //Shopify_Product_Reader.Main main = new Shopify_Product_Reader.Main();
                            //main.Do(DownloadedFileName, ServerName, ServerUserName, ServerPassword, NetworkInboxFolder, ClientMasterDbName, NetWorkID);
                        }
                    }
                    catch (Exception ex)
                    { };
                }
                else
                {
                    RunCmd(@"/c " + condition);
                }
            }
        }

        public bool Upload(string cmd, System.Collections.Specialized.NameValueCollection appSettings)
        {
            bool _continue = false;
            int count = 0;
            while (!_continue && count < 4)
            {
                count += 1;
                string tempCmd = cmd;
                cmd = cmd + " -u " + Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + (string.IsNullOrEmpty(this.NewFileName) ? this.OutGoingFileName.ToUpper() : this.NewFileName.ToUpper()) + " -p /" + this.NetworkInboxFolder + "/";

                if (!string.IsNullOrEmpty(this.AddDatetime) && this.AddDatetime == "Y")
                {
                    string outgoingFile = Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + (string.IsNullOrEmpty(this.NewFileName) ? this.OutGoingFileName.ToUpper() : this.NewFileName.ToUpper());
                    string newOutgoingFile = Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + this.ToFileName;
                    try
                    {
                        if (System.IO.File.Exists(outgoingFile))
                        {
                            //copy to new name
                            System.IO.File.Copy(outgoingFile, newOutgoingFile);
                        }
                    }
                    catch (Exception) { }
                    cmd = tempCmd + " -u " + newOutgoingFile + " -p /" + this.NetworkInboxFolder + "/";

                }


                string Log = " -Log " + this.EDIClientPath + @"\Log.log";
                RunCmd(cmd + Log);
                _continue = ValidateUpload(this.EDIClientPath + @"\log.log");
                if (!string.IsNullOrEmpty(this.AddDatetime) && this.AddDatetime == "Y")
                {
                    string newOutgoingFile = Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + this.ToFileName;
                    if (System.IO.File.Exists(newOutgoingFile))
                    {
                        //Delete to new name
                        System.IO.File.Delete(newOutgoingFile);
                    }
                }
                    //-------------Update PH------------
                    if (_continue == false && count == 4)
                {
                    string str = "";
                    if (File.Exists(this.EDIClientPath + @"\log.log"))
                    {
                        str = System.IO.File.ReadAllText(this.EDIClientPath + @"\log.log").ToUpper();
                    }

                    //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + "Couldn't upload outgoing File : " + this.OutGoingFileName + " for network id " + this.NetWorkID + "\n Try Again later. ", 103, 0);
                    MailAttachment AttErr = new MailAttachment(str, "LogFile");
                    try
                    {
                        MailAttachment AttRowFile = new MailAttachment(System.IO.File.ReadAllText(this.EDIOutboxPath).ToUpper(), this.OutGoingFileName);
                        string emailBody = "There was a problem while uploading an outgoing file with the below information : <br /> Client: "
                            + this.ClientID + "<br /> Network ID: "
                            + this.NetWorkID + "<br /> File Name: "
                            + this.OutGoingFileName + "<br /> ";
                        string email = appSettings["Email"];
                        string emailPassword = appSettings["EmailPassword"];
                        string emailTo = appSettings["To"];
                        string emailCC = appSettings["CC"];
                        string emailCC1 = appSettings["CC1"];
                        string emailDisplayName = appSettings["DisplayName"];

                        Mail.Email(emailBody, "EDI_VAN Upload Fail", email, emailPassword, emailTo, emailCC, emailCC1, emailDisplayName, AttErr, AttRowFile);
                    }
                    catch (Exception ex)
                    {

                        //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);
                    }
                }
                if (File.Exists(this.EDIClientPath + @"\log.log"))
                {

                    if (DB.UpdatePH(this.EDIClientDBFSPath, this.OutGoingFileName, this.EDIClientPath + @"\log.log"))
                    {
                        if (File.Exists(this.EDIClientPath + @"\keeplog.log"))
                        { File.Copy(this.EDIClientPath + @"\log.log", this.EDIClientPath + @"\log" + DateTime.Now.ToString("yyyyMMddhhmmss") + ".log"); }

                        File.Delete(this.EDIClientPath + @"\log.log");

                    }

                }
            }
            if (File.Exists(Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + (this.NewFileName)))
                File.Delete(Path.GetDirectoryName(this.EDIOutboxPath) + "\\" + (this.NewFileName));
            return _continue;
        }

        public void ApiConnectGet()
        {
            StillHasData = false;
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
            HttpClient client = new HttpClient();

            client.BaseAddress = new Uri(URL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));

            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(UserName + ":" + Password);
            string val = System.Convert.ToBase64String(plainTextBytes);
            client.DefaultRequestHeaders.Add("Authorization", "Basic " + val);

            // List data response.
            string requestURI = NetworkOutboxFolder;
            //if (string.IsNullOrEmpty(NetworkInboxFolder) == false)
            //{
            //   requestURI = String.Format(NetworkOutboxFolder + "{0}{1}", "?since_id" , NetworkInboxFolder);
            //}
            if (string.IsNullOrEmpty(PreTransferCommand) == false)
            {
                string firstParameter = "?";
                if (NetworkOutboxFolder.Contains("?"))
                    firstParameter = "&";
                requestURI = String.Format(NetworkOutboxFolder + "{0}{1}", firstParameter, PreTransferCommand);
            }
            HttpResponseMessage response = client.GetAsync(requestURI).Result;  // Blocking call! Program will wait here until a response is received or a timeout occurs.
            if (response.IsSuccessStatusCode)
            {
                //Parse the response body.
                string dataObjects = response.Content.ReadAsStringAsync().Result;  //Make sure to add a reference to System.Net.Http.Formatting.dll

                string path = DateTime.Now.ToString("yyyyMMddHHmmss");
                Directory.CreateDirectory(Path.Combine(this.EDIFTPHistoryPath + "\\IN\\", path));

                System.IO.File.WriteAllText(this.EDIFTPHistoryPath + "\\in\\" + path + "\\" + InComingFileName, dataObjects);

                string partialName = Path.GetFileNameWithoutExtension(InComingFileName);
                DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(EDIClientPath + @"\EDI\INBOX\");


                FileInfo[] filesInDir = hdDirectoryInWhichToSearch.GetFiles("*" + partialName + "*.*");
                string newfilename = partialName;
                if (filesInDir.Length > 0)
                { newfilename += "_" + filesInDir.Length.ToString().PadLeft(3, '0'); }

                newfilename += Path.GetExtension(InComingFileName);


                Boolean writeToFile = true;

                if (NetworkOutboxFolder.ToUpper().Contains("JSON"))
                {
                    XNode node = JsonConvert.DeserializeXNode(dataObjects, "Root");
                    string nodeString = node.ToString();
                    if (NetworkOutboxFolder.ToUpper().Contains("ORDERS"))
                    {
                        nodeString = nodeString.Replace("<orders>", "<order>").Replace("</orders>", "</order>").Replace("<line_items>", "<line_item>").Replace("</line_items>", "</line_item>");
                        dataObjects = nodeString.Replace("_", "-").Replace("<Root>", "<orders>").Replace("</Root>", "</orders>");
                    }

                    if (NetworkOutboxFolder.ToUpper().Contains("VARIANTS"))
                    {
                        dataObjects = nodeString.Replace("_", "-").Replace("<Root>", "<products>").Replace("</Root>", "</products>");
                    }
                }

                if (!string.IsNullOrEmpty(NetworkInboxFolder) && NetworkInboxFolder.Contains(','))
                {
                    XmlDocument xml = new XmlDocument();

                    //xml.Load(EDIClientPath + @"\EDI\INBOX\" + newfilename);
                    xml.LoadXml(dataObjects);
                    XmlNodeList nodes = xml.SelectNodes(NetworkInboxFolder.Split(',')[0]);
                    if (nodes != null && nodes.Count.ToString() == NetworkInboxFolder.Split(',')[1])
                    {//loop again as we sill have data
                        StillHasData = true;
                        // UpdateDownloadedOrderNumber(nodes);
                    }
                    if (nodes != null && nodes.Count > 0)
                    {   //update id
                        UpdateDownloadedOrderNumber(nodes);
                    }

                    if (nodes != null && nodes.Count == 0)
                    {//not write the file
                        writeToFile = false;
                    }

                }
                if (writeToFile)
                {
                    DownloadedFileName = EDIClientPath + @"\EDI\INBOX\" + newfilename;
                    System.IO.File.WriteAllText(EDIClientPath + @"\EDI\INBOX\" + newfilename, dataObjects);
                }

            }
            client.Dispose();
        }

        /// <summary>
        /// get all files on outgoing folder, with same prefix, , which comes from networkprofile table.
        /// loop on the collected files.
        /// get the content for each file, send to api url, which comes from networkprofile table.
        /// </summary>
        public void APILoopOnOutgoingFiles()
        {
            string partialName = Path.GetFileNameWithoutExtension(OutGoingFileName);
            DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(EDIClientPath + @"\EDI\OUTBOX\");
            FileInfo[] filesInDir = hdDirectoryInWhichToSearch.GetFiles(partialName + "*" + Path.GetExtension(OutGoingFileName));
            string newfilename = partialName;
            if (filesInDir.Length > 0)
            {
                foreach (FileInfo fileInfo in filesInDir)
                {
                    APISendContent(System.IO.File.ReadAllText(fileInfo.FullName), fileInfo.Extension);
                    fileInfo.Delete();
                }
            }

        }

        public void APISendContent(string contentstring, string contenttype)
        {
            string param_id = "";
            string NewNetworkOutboxFolder = NetworkOutboxFolder;
            if (NetworkOutboxFolder.Contains("{"))
            {
                int param_id_index = NetworkOutboxFolder.IndexOf("{");
                if (param_id_index > -1)
                {
                    param_id = NetworkOutboxFolder.Substring(param_id_index + 1);
                    param_id_index = param_id.IndexOf("}");
                    param_id = param_id.Substring(0, param_id_index);
                }
            }

            if (string.IsNullOrEmpty(param_id) == false && contentstring.Contains("\"" + param_id + "\""))
            {
                int order_id_index = contentstring.IndexOf("\"" + param_id + "\"");
                if (order_id_index > -1)
                {
                    string order_id = contentstring.Substring(order_id_index + 12);
                    order_id_index = contentstring.IndexOf("\"", 2);
                    order_id = order_id.Substring(0, 15);
                    order_id = order_id.Replace('"', ' ');
                    order_id = order_id.Replace('"', ' ');
                    order_id = order_id.Replace('}', ' ');
                    order_id = order_id.Replace('}', ' ');
                    order_id = order_id.TrimEnd();
                    NewNetworkOutboxFolder = NetworkOutboxFolder.Replace("{" + param_id + "}", order_id);
                }
            }

            var content = new StringContent(contentstring, Encoding.UTF8, "application/" + contenttype.Substring(1));
            string methodname = NetworkInboxFolder;
            HttpResponseMessage response = new HttpResponseMessage();
            if (!String.IsNullOrEmpty(methodname) && methodname.Trim().ToUpper() == "PUT")
            {
                response = client.PutAsync(NewNetworkOutboxFolder, content).Result;
                // Blocking call! Program will wait here until a response is received or a timeout occurs.
            }
            else
            { response = client.PostAsync(NewNetworkOutboxFolder, content).Result; }

            if (response.IsSuccessStatusCode)
            {
                string dataObjects = response.Content.ReadAsStringAsync().Result;  //Make sure to add a reference to System.Net.Http.Formatting.dll
            }
            else
            {
                //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok: " + response.StatusCode + " " + response.ReasonPhrase, 103, 0);
            }

        }

        HttpClient client = new HttpClient();
        /// <summary>
        /// prepare the channel to connect to shopify API.
        /// add content type, which comes from networkprofile table.
        /// add user name and password, which comes from networkprofile table.
        /// </summary>
        public void APIPrepareChannel()
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
            client.BaseAddress = new Uri(URL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(UserName + ":" + Password);
            string val = System.Convert.ToBase64String(plainTextBytes);
            client.DefaultRequestHeaders.Add("Authorization", "Basic " + val);
        }

        public void ApiConnectPost()
        {
            client = new HttpClient();
            APIPrepareChannel();
            APILoopOnOutgoingFiles();
            client.Dispose();
        }

        public void Download(string cmd)
        {
            foreach (string file in this.NetworkOutboxFolder.Split('|'))
            {
                string ncmd = cmd + "  -d /" + (file.Contains(".") ? file + " -p " + this.EDIFTPHistoryPath + "" : file + "/ -p " + this.EDIFTPHistoryPath + "");
                string Log = " -Log " + this.EDIClientPath + @"\DownloadLog.log";
                RunCmd(ncmd + Log);
            }

        }

        public void Archive(bool IsArchiveUpload)
        {
            if (File.Exists(this.EDIArchiveProgramPath))
            {
                try
                {

                    //if (File.Exists(this.EDIClientPath + @"\keeplog.log"))
                    //{
                        //System.IO.File.AppendAllText(this.EDIClientPath + @"\Archivelog" + DateTime.Now.ToString("yyyyMMddhhmmss") + ".log", (IsArchiveUpload ? this.OutGoingFileName : "ERROR"));
                        //File.Copy(this.EDIClientPath + @"\log.log", this.EDIClientPath + @"\log" + DateTime.Now.ToString("yyyyMMddhhmmss") + ".log");
                        
                    //}


                    System.Diagnostics.Process.Start(this.EDIArchiveProgramPath,
                    //(IsArchiveUpload ? this.OutGoingFileName : this.OutGoingFileName + "WrongFileName")
                    (IsArchiveUpload ? this.OutGoingFileName : "ERROR")
                    + " " + this.EDIClientDBFSPath + " " +
                    Path.GetDirectoryName(this.EDIOutboxPath) + " " +
                    this.CompanyID + " " +
                    this.InComingFileName + " " +
                    this.EDIFTPHistoryPath + " " +
                    this.EDIClientPath);
                    // MessageBox.Show(this.EDIArchiveProgramPath + "" + (IsArchiveUpload ? this.OutGoingFileName : "") + " " + this.EDIClientDBFSPath + " " + Path.GetDirectoryName(this.EDIOutboxPath) + " " + this.CompanyID + " " + this.EDIFTPHistoryPath + " " + this.EDIClientPath);
                }
                catch (System.ComponentModel.Win32Exception)
                {
                    //MessageBox.Show("An error occurred while opening Archive program, Please refer to Aria technical support team.");
                    // WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok: " + "An error occurred while opening Archive program, Please refer to Aria technical support team.", 103, 0);
                }
            }

            else if (!string.IsNullOrEmpty(this.EDIArchiveProgramPath))
            {
                //MessageBox.Show("Archive program is missing, Please refer to Aria technical support team.");
                //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok: " + "Archive program is missing, Please refer to Aria technical support team.", 103, 0);
            }
        }
        public void RunCmd(string cmd)
        {
            //Add event log handler to easly trace what commands are being excute.
            ProcessStartInfo cmdsi = new ProcessStartInfo("cmd.exe");
            cmdsi.Arguments = cmd;
            cmdsi.WindowStyle = ProcessWindowStyle.Hidden;
            cmdsi.CreateNoWindow = true;
            Process process = Process.Start(cmdsi);
            process.WaitForExit();

        }
        public bool ValidateUpload(string path)
        {
            if (File.Exists(path))
            {
                string text = System.IO.File.ReadAllText(path).ToUpper();
                string[] sp_char_arr = { "\t", "\f", "\v" };
                foreach (string sp_char in sp_char_arr)
                {
                    text = text.ToString().Replace(sp_char, "");
                }
                text = text.ToString().StartsWith("\"") ? text.ToString().Remove(0, 1) : text;

                string[] lines = text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);

                string TotalUploadedFiles = lines.FirstOrDefault(r => r.Contains("TOTAL UPLOADED FILES"));
                string TotalUploadedData = lines.FirstOrDefault(r => r.Contains("TOTAL UPLOADED DATA"));
                string _Files = TotalUploadedFiles.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries)[1].ToString().Trim().Replace("\r", "");
                string _Data = TotalUploadedData.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries)[1].ToString().Trim().Replace("\r", "");
                string _Warnings = lines.FirstOrDefault(r => r.Contains("WARNING:"));

            
                if (_Files == "1")
                {
                    if (_Data != "0 KB")
                    {
                        return true;
                    }
                    else { return false; }
                }

                this.ErrorMessageString = _Warnings + System.Environment.NewLine;
            }
            return false;
        }
        public bool ValidateRowFile(string path)
        {

            if (File.Exists(path) || Directory.GetFiles(Path.GetDirectoryName(path) + "\\", this.OutGoingFileName).Length > 0)
            {
                if (!File.Exists(path))
                {
                    path = Directory.GetFiles(Path.GetDirectoryName(path) + "\\", this.OutGoingFileName)[0];
                    if (!File.Exists(path))
                    {
                        return false;
                    }
                }
                string text = System.IO.File.ReadAllText(path).ToUpper();
                if (text.Length < 1)
                {
                    //MessageBox.Show("Outgoing file name " + Path.GetFileName(path) + "for network " + this.NetWorkID + " has zero length, Uploading process is terminated.", "Uploading Error");
                    // WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok: " + "Outgoing file name " + Path.GetFileName(path) + "for network " + this.NetWorkID + " has zero length, Uploading process is terminated.", 103, 0);
                    return false;
                }
                else
                {
                    //if (!string.IsNullOrEmpty(this.NetworkOutGoingFileName))
                    if (!string.IsNullOrEmpty(this.NewFileName))
                    { File.Copy(this.EDIOutboxPath, Path.GetDirectoryName(this.EDIOutboxPath) + @"\\" + this.NewFileName); }
                    return true;
                }
            }
            else
            {
                //MessageBox.Show("There is no file " + (path) + " at this moment on your outbox folder.", "Uploading Error");
                this.ErrorMessageString = "There is no file " + (path) + " at this moment on your outbox folder." + System.Environment.NewLine;
                return false;
            }

        }

        public void UpdateDownloadedOrderNumber(XmlNodeList nodes)
        {
            string orderid = "0";
            orderid = nodes[nodes.Count - 1].SelectNodes("id")[0].InnerText.ToString();

            string ClientMasterDbName = this.ClientID.Trim() + ".Master";
            EDI_VAN_LIB.DB Connecttodb = new EDI_VAN_LIB.DB(this.ServerName, this.ServerUserName, this.ServerPassword, ClientMasterDbName);
            if (PreTransferCommand.Contains("since_id"))
            {
                string sqlStr = "Update NetworkProfiles set PreTransferCommand = 'since_id=" + orderid + "' where clientid='" + this.ClientID + "' and networkid='" + this.NetWorkID + "'";
                Connecttodb.DoQuery(sqlStr);
                PreTransferCommand = "since_id=" + orderid;
            }

        }
        #endregion

    }
}
