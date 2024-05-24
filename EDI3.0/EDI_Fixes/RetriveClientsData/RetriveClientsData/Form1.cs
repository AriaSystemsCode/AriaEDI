using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.Sql;
using System.Data.SqlClient;
using System.IO; 

namespace RetriveClientsData
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        #region Methods

        private void Form1_Load(object sender, EventArgs e)
        {
            FillServerComboBox();
        }

        private void FillServerComboBox()
        {
            SqlDataSourceEnumerator SqlEnumerator;
            SqlEnumerator = SqlDataSourceEnumerator.Instance;
            //DataTable dTable = SqlEnumerator.GetDataSources();
            DataTable dTable = Microsoft.SqlServer.Management.Smo.SmoApplication.EnumAvailableSqlServers();
            for (int i = 0; i < dTable.Rows.Count; i++)
            {
                cmb_ServerName.Items.Add(dTable.Rows[i]["Name"].ToString());
            }
        }

        private void btn_ModifyData_Click(object sender, EventArgs e)
        {
            ChangeClientFileData();
        }

        private void ChangeClientFileData()
        {
            DataTable dt = new DataTable();
            string str_OldPath = @"X:\aria27";
            string str_NewPath = @"X:\aria3edi";
            #region Modify Data of Batch Files
            SqlConnection sqlConnection;
            if (cmb_Authentication.SelectedIndex == 0)
            {
                sqlConnection = new SqlConnection(@"Data Source=" + cmb_ServerName.Text.ToString() + @";Initial Catalog=SYSTEM.Master;Trusted_Connection=yes");
            }
            else
            {
                sqlConnection = new SqlConnection(@"Data Source=" + cmb_ServerName.Text.ToString() + @";Initial Catalog=SYSTEM.Master;User ID=" + txt_UserName.Text.ToString() + @";Password=" + txt_Password.Text.ToString() + @";Trusted_Connection=yes");
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM CLIENTS order by CCLIENTID");
            cmd.Connection = sqlConnection;
            try
            {
                sqlConnection.Open();
                SqlDataAdapter sqldtadp = new SqlDataAdapter();
                sqldtadp.SelectCommand = cmd;
                sqldtadp.Fill(dt);
                for (int i = 1; i <= dt.Rows.Count; i++)
                {
                    
                    #region UPDATE THE LBLPROGRESS LABEL
                    lblProgress.Text = "Fix Clinet: " + dt.Rows[i - 1]["CCLIENTNAME"].ToString().TrimEnd();
                    this.Refresh();
                    #endregion

                    #region EDITFILE
                    string ClientSharedFolder = dt.Rows[i - 1]["CDATAPATH"].ToString().TrimEnd();

                    // Back Up Batch Files, Before Change Their Data 
                    copyFile(ClientSharedFolder, @"\ARIA27\EDI\Snd_RecCoreFTP.BAT");
                    copyFile(ClientSharedFolder, @"\ARIA27\EDI\Rcv_RecCoreFTP.BAT");
                    // Back Up Batch Files, Before Change Their Data 

                    EditFile(ClientSharedFolder,@"\ARIA27\EDI\Snd_RecCoreFTP.BAT", str_OldPath, str_NewPath);
                    EditFile(ClientSharedFolder,@"\ARIA27\EDI\Rcv_RecCoreFTP.BAT", str_OldPath, str_NewPath); 
	                #endregion
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                #region close the connection
                if (sqlConnection.State==ConnectionState.Open)
                  sqlConnection.Close();
                #endregion
            }
            #endregion
            MessageBox.Show(" Finisehd From Modifying Clients Files");
        }

        private void EditFile(string ClientSharedFolder, string FileName, string str_OldPath, string str_NewPath)
        {
            #region EDIT Batch FILE

            try
            {
                //read from file
                FileStream fs;
                fs = new FileStream(ClientSharedFolder + FileName, FileMode.Open);
                StreamReader r = new StreamReader(fs, Encoding.UTF8);
                string line;
                string newLine, NewFileData = "";
                while ((line = r.ReadLine()) != null)
                {
                    //edit file
                    string[] splitedwords = line.Split(' ');
                    for (int j = 0; j < splitedwords.Length; j++)
                    {
                        if (splitedwords[j].Contains(str_OldPath))
                        {
                            if (!splitedwords[j].Contains(str_OldPath + @"\DBFS"))
                                splitedwords[j] = splitedwords[j].Replace(str_OldPath, str_NewPath);
                        }
                    }
                    newLine = "";
                    for (int j = 0; j < splitedwords.Length; j++)
                        newLine += splitedwords[j] + " ";

                    NewFileData += newLine + "\r\n";
                }
                r.Close();
                fs.Close();
                // store new data
                FileStream fileStream = new FileStream(ClientSharedFolder + FileName, FileMode.Create);
                {
                    StreamWriter streamWriter = new StreamWriter(fileStream);
                    streamWriter.Write(NewFileData);
                    streamWriter.Close();
                    fileStream.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            #endregion
        }            
 
        private void cmb_Authentication_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckAuthendication();
        }

        private void CheckAuthendication()
        {
            txt_UserName.Text = "";
            txt_Password.Text = "";
            if (cmb_Authentication.SelectedIndex == 0)
            {
                txt_UserName.Enabled = false;
                txt_Password.Enabled = false;
            }
            else
            {
                txt_UserName.Enabled = true;
                txt_Password.Enabled = true;
            }
        }
        private void copyFile(string ClientSharedFolder, string FileName)
        {
            System.IO.File.Copy(ClientSharedFolder + FileName, ClientSharedFolder+"BK_"+FileName);

        }
        #endregion
    }
}
