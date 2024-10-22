using EDI_VAN_LIB;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Xml;

namespace EDI_VAN
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        string CoreFtpPath = System.Configuration.ConfigurationManager.AppSettings["CoreFtpPath"];
        string DoneCorrectlyMessage = System.Configuration.ConfigurationManager.AppSettings["DoneCorrectlyMessage"];
        string DoneWithErrorsMessage = System.Configuration.ConfigurationManager.AppSettings["DoneWithErrorsMessage"];

        public DataTable NetTable = new DataTable();
        public bool successfulFlag = false;

        string networkDirection = "";
        string networkName = "";

        bool IsGroup = true;
        NetworkProfilesViewModel MainNetworkProfilesViewModel = new NetworkProfilesViewModel();         //Holding all Network Profile Data.
        NetworkProfilesViewModel TempNetProViewModel = new NetworkProfilesViewModel();                  //Mixed Case [Grouped records and Single records]
        NetworkProfilesViewModel NetProViewModel = new NetworkProfilesViewModel();                      //Normal Case
        NetworkProfilesViewModel AutoNetProViewModel = new NetworkProfilesViewModel();                  //In Case of Automatic Networks

        #region Methods
        public MainWindow() { }
        /// <summary>
        /// This method can called with:
        /// param: aria system files path
        /// param: network should send, receive both, and values are "RECEIVE"|"SEND"|"RECEIVE&SEND" like "" also for old versions.
        /// </summary>
        /// <param name="args"></param>
        public MainWindow(string[] args)
        {
            #region to be removed
            string argsstring = "";
            for (int i = 0; i < args.Count(); i++)
            { argsstring = argsstring + i.ToString() + ": " + args[i].ToString() + System.Environment.NewLine; }
            //System.IO.File.WriteAllText(@"\\10.0.1.18\lac99sh\ARIA3EDI\Log1.txt", argsstring);
            #endregion to be removed


            if (args.Count() == 0)
            {
                args = new string[4];
                //args[0] = @"\\10.0.1.18\stc10sh\Aria4XP\SYSFILES";
                args[0] = @"X:\aria4xp\sysfiles";
                args[1] = "";
                args[2] = "";
                args[3] = "";
            }



            networkDirection = "";
            if (args.Count() > 1)
            { networkDirection = args[1].ToString().ToUpper(); }
            Boolean silentMode = false;
            if (args.Count() > 3)
            { silentMode = args[3].ToString().ToUpper() == "Y" ? true : false; }

            if (args.Count() > 0 && Directory.Exists(args[0].ToString()))
            {
                DataSet temp = ConenctToClientMasterDB(args);
                try { NetTable = temp.Tables[0]; }
                catch (Exception ex) { MessageBox.Show("Couldn’t connect to network profiles SQL table, please refer to Aria technical support team."); }

                if (silentMode)
                {
                    EDI_VAN_LIB.NetworkProfiles NetModel = new EDI_VAN_LIB.NetworkProfiles();
                    NetModel.ImportData(NetTable, NetTable.Rows[0]);
                    NetModel.ServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
                    NetModel.ServerUserName = System.Configuration.ConfigurationManager.AppSettings["UserName"];
                    NetModel.ServerPassword = System.Configuration.ConfigurationManager.AppSettings["Password"];

                    NetModel.ProcessBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                }
                else if (NetTable != null && NetTable.Rows != null && NetTable.Rows.Count > 1)
                {
                    InitializeComponent();
                    DataContext = NetProViewModel;
                    foreach (DataRow dt in NetTable.Rows)
                    {
                        EDI_VAN_LIB.NetworkProfiles NetModel = new EDI_VAN_LIB.NetworkProfiles();
                        NetModel.ImportData(NetTable, dt);
                        NetModel.ServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
                        NetModel.ServerUserName = System.Configuration.ConfigurationManager.AppSettings["UserName"];
                        NetModel.ServerPassword = System.Configuration.ConfigurationManager.AppSettings["Password"];

                        if (!NetModel.NetWorkID.ToUpper().Contains("AUTO"))
                        {
                            EDI_VAN_LIB.NetworkProfiles MainNetpro = new EDI_VAN_LIB.NetworkProfiles();     //Adding all data on MainViewModel.
                            MainNetpro.ServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
                            MainNetpro.ServerUserName = System.Configuration.ConfigurationManager.AppSettings["UserName"];
                            MainNetpro.ServerPassword = System.Configuration.ConfigurationManager.AppSettings["Password"];

                            MainNetpro.NetworkDirection = networkDirection;
                            MainNetpro.ImportData(NetTable, dt);                    //Adding all data on MainViewModel.
                            MainNetworkProfilesViewModel.Networks.Add(MainNetpro);   //Adding all data on MainViewModel.
                            TempNetProViewModel.Networks.Add(NetModel);            //Adding all data on TempViewModel.
                            var NetworkGroub = NetProViewModel.Networks.Where(x => x.NetGroup == NetModel.NetGroup);
                            if ((NetworkGroub == null) || !(NetworkGroub.Any()))
                                NetProViewModel.Networks.Add(NetModel);

                            if (string.IsNullOrEmpty(NetModel.NetGroup))   //Update IsGroup Flag to determine whether we need to change the View or not. 
                                IsGroup &= false;
                        }
                        else
                        {
                            AutoNetProViewModel.Networks.Add(NetModel);
                        }
                    }
                    successfulFlag = true;
                    if (IsGroup)
                    {
                        ListView NetworkListView = (ListView)NetworkList;
                        GridView NetworkGridView = ((GridView)NetworkListView.View);
                        GridViewColumn GridViewColumnId = NetworkGridView.Columns[2];
                        GridViewColumn GridViewColumnSite = NetworkGridView.Columns[3];
                        GridViewColumn GridViewColumnCompany = NetworkGridView.Columns[4];

                        NetworkGridView.Columns.Remove(GridViewColumnId);
                        NetworkGridView.Columns.Remove(GridViewColumnSite);
                        NetworkGridView.Columns.Remove(GridViewColumnCompany);
                    }
                    else
                    {
                        if (TempNetProViewModel.Networks.Where(x => string.IsNullOrEmpty(x.NetGroup)).Count() > 0)
                        {
                            string TempGroups = "";
                            string Indices = "";
                            for (int i = 0; i < TempNetProViewModel.Networks.Count(); i++)
                            {
                                if (string.IsNullOrEmpty(TempNetProViewModel.Networks[i].NetGroup))
                                {
                                    continue;
                                }

                                if (TempGroups.Contains(TempNetProViewModel.Networks[i].NetGroup))
                                {
                                    Indices += i + "|";
                                    EDI_VAN_LIB.NetworkProfiles editednetwork = TempNetProViewModel.Networks.FirstOrDefault(x => x.NetGroup == TempNetProViewModel.Networks[i].NetGroup);
                                    editednetwork.NetWorkID = "";
                                    editednetwork.SiteName = "";
                                    editednetwork.CompanyID = "";
                                }
                                else
                                {
                                    TempGroups += TempNetProViewModel.Networks[i].NetGroup + "|";
                                }
                            }
                            string[] IndicesArr = Indices.Split('|');
                            for (int i = 0; i < IndicesArr.Length - 1; i++)
                            {
                                TempNetProViewModel.Networks.RemoveAt((int.Parse(IndicesArr[i])) - i);
                            }
                        }
                        DataContext = TempNetProViewModel;
                    }
                }
                else if (temp.Tables.Count >= 0 && NetTable != null && NetTable.Rows.Count == 1)
                {
                    EDI_VAN_LIB.NetworkProfiles NetModel = new EDI_VAN_LIB.NetworkProfiles();
                    NetModel.ServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
                    NetModel.ServerUserName = System.Configuration.ConfigurationManager.AppSettings["UserName"];
                    NetModel.ServerPassword = System.Configuration.ConfigurationManager.AppSettings["Password"];
                    NetModel.ImportData(NetTable, NetTable.Rows[0]);
                    NetModel.ProcessBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                }
                else
                {
                    MessageBox.Show("Client has no network profiles, please refer to Aria technical support team.");
                }
            }
            else
            {
                MessageBox.Show("Some errors occured while connecting to system files, please refer to Aria technical support team.");
                successfulFlag = false;
            }

        }

        public DataSet ConenctToClientMasterDB(string[] args)
        {
            string networkName = "";
            if (args.Count() > 2)
            { networkName = args[2].ToString().ToUpper(); }

            XmlDocument xml = new XmlDocument();
            xml.Load(args[0].ToString() + "/Client_Setting.xml");
            XmlNode node = xml.SelectSingleNode("VFPData").SelectSingleNode("clientset").SelectSingleNode("clientid");
            string ClientID = node.InnerText;
            string ClientMasterDbName = ClientID.Trim() + ".Master";
            string ServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
            string userName = System.Configuration.ConfigurationManager.AppSettings["UserName"];
            string password = System.Configuration.ConfigurationManager.AppSettings["Password"];
            EDI_VAN_LIB.DB Connecttodb = new EDI_VAN_LIB.DB(ServerName, userName, password, ClientMasterDbName);

            string sqlStr = "Select  * from NetworkProfiles";
            if (networkName != "")
            { sqlStr = sqlStr + " where NetWorkID = '" + networkName + "'"; }

            DataSet ClientNetworks = Connecttodb.SelectQuery(sqlStr);
            return ClientNetworks;
        }

        private void RunButton_Click(object sender, RoutedEventArgs e)
        {

            foreach (EDI_VAN_LIB.NetworkProfiles SelectedProfile in NetworkList.SelectedItems)
            {
                SelectedProfile.ErrorMessageString = "";
                if (string.IsNullOrEmpty(SelectedProfile.NetGroup))
                {
                    RunButton.IsEnabled = false;
                    CancelButton.IsEnabled = false;
                    ResetButton.IsEnabled = false;
                    SelectedProfile.ProcessBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                    RunButton.IsEnabled = true;
                    CancelButton.IsEnabled = true;
                    ResetButton.IsEnabled = true;

                    if (!string.IsNullOrEmpty(SelectedProfile.ErrorMessageString))
                    { MessageBox.Show(SelectedProfile.SiteName + " " + this.DoneWithErrorsMessage + System.Environment.NewLine + SelectedProfile.ErrorMessageString); }
                    else
                    { MessageBox.Show(SelectedProfile.SiteName + " " + this.DoneCorrectlyMessage); }
                    SelectedProfile.ErrorMessageString = "";
                }
                else
                {
                    foreach (EDI_VAN_LIB.NetworkProfiles Profile in MainNetworkProfilesViewModel.Networks.Where(x => x.NetGroup == SelectedProfile.NetGroup))
                    {
                        Profile.ErrorMessageString = "";

                        RunButton.IsEnabled = false;
                        CancelButton.IsEnabled = false;
                        ResetButton.IsEnabled = false;
                        Profile.ProcessBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                        RunButton.IsEnabled = true;
                        CancelButton.IsEnabled = true;
                        ResetButton.IsEnabled = true;
                        if (!string.IsNullOrEmpty(SelectedProfile.ErrorMessageString))
                        { MessageBox.Show(Profile.SiteName + " " + this.DoneWithErrorsMessage + System.Environment.NewLine + Profile.ErrorMessageString); }
                        else
                        { MessageBox.Show(Profile.SiteName + " " + this.DoneCorrectlyMessage); }
                        Profile.ErrorMessageString = "";
                    }
                }
            }
            foreach (EDI_VAN_LIB.NetworkProfiles Profile in AutoNetProViewModel.Networks)
            {
                Profile.ErrorMessageString = ""; 
                RunButton.IsEnabled = false;
                CancelButton.IsEnabled = false;
                ResetButton.IsEnabled = false;
                Profile.ProcessBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                RunButton.IsEnabled = true;
                CancelButton.IsEnabled = true;
                ResetButton.IsEnabled = true;

                if (!string.IsNullOrEmpty(Profile.ErrorMessageString))
                { MessageBox.Show(Profile.SiteName + " " + this.DoneWithErrorsMessage + System.Environment.NewLine + Profile.ErrorMessageString); }
                else
                { MessageBox.Show(Profile.SiteName + " " + this.DoneCorrectlyMessage); }
                Profile.ErrorMessageString = "";
            }
            // 
            //MessageBox.Show("Calling is done",this.Title);
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            // NetworkProfiles net = new NetworkProfiles();
            // net.test(@"\\10.0.1.18\lac99sh\ARIA4XP\SYSFILES", "RECEIVE","SHPPO","Y");
            Application.Current.Shutdown();
        }
        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            var confrim = MessageBox.Show("Do you want to reset selected network(s)?", this.Title, MessageBoxButton.YesNo);
            if (confrim == MessageBoxResult.Yes)
            {
                foreach (EDI_VAN_LIB.NetworkProfiles SelectedProfile in NetworkList.SelectedItems)
                {
                    if (!string.IsNullOrEmpty(SelectedProfile.PreTransferCommand) && SelectedProfile.PreTransferCommand.Contains("since_id"))
                    {
                        RunButton.IsEnabled = false;
                        CancelButton.IsEnabled = false;
                        ResetButton.IsEnabled = false;
                        SelectedProfile.ResetBatch(CoreFtpPath, ConfigurationManager.AppSettings, networkDirection);
                        RunButton.IsEnabled = true;
                        CancelButton.IsEnabled = true;
                        ResetButton.IsEnabled = true;

                    }
                }
                MessageBox.Show("Reset is done", this.Title);
            }
        }
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            if (successfulFlag && !RunButton.IsEnabled) e.Cancel = true;
        }
        #endregion
    }
}
