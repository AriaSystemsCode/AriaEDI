using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using Microsoft.Office.Interop;

namespace TP_List
{
    public partial class Form1 : Form
    {
        Microsoft.Office.Interop.Excel.Application app = new Microsoft.Office.Interop.Excel.Application();
        Microsoft.Office.Interop.Excel.Workbook workBook;
        Microsoft.Office.Interop.Excel.Worksheet workSheet;
        Microsoft.Office.Interop.Excel.Worksheet workSheetX12;
        Microsoft.Office.Interop.Excel.Worksheet workSheetEDIFACT;
        Microsoft.Office.Interop.Excel.Worksheet workSheetXML;
        int nRowX12     = 1;
        int nRowEDIFACT = 1;
        int nRowXML     = 1;
        int nRowCurrent = 0;

        Boolean ICloseIt = false;

        public Form1()
        {
            InitializeComponent();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            string servername = txtServerName.Text.ToString().TrimEnd();
            string userrname = TxtUserName.Text.ToString().TrimEnd();
            string password = TxtPassword.Text.ToString().TrimEnd();


            SqlCommand cmd = new SqlCommand("select [cpartcode],[cParentCode],[cpartname],cversion from sycediph where  not( cpartname like 'Aria%') order by cParentCode,cpartcode,cversion");
            SqlConnection con = new SqlConnection("Data Source=" + servername + ";Initial Catalog=EDIMappings;User ID=" + userrname + ";password =" + password);
            SqlDataAdapter adp = new SqlDataAdapter();

            System.Data.DataTable dtTP = new System.Data.DataTable();
            System.Data.DataTable dtTransactions = new System.Data.DataTable();

            try
            {
                cmd.Connection = con;
                con.Open();
                adp.SelectCommand = cmd;
                adp.Fill(dtTP);
                int nRow = 1;
                adjust(false);
                TPProgressBar.Minimum = 2;
                TPProgressBar.Maximum = dtTP.Rows.Count+2;
                this.Refresh();
                foreach (DataRow row in dtTP.Rows)
                {  
                    nRow = nRow + 1;
                    lblprogress.Text = "EDI Trading Partner: "+row["cpartname"].ToString().Trim(); ;
                    TPProgressBar.Value = nRow;
                    adjustworksheet(row["cversion"].ToString().Trim());

                    cmd.CommandText = "SELECT distinct ceditrntyp,cmapset FROM [EDIMappings].[dbo].[sycedipd]  where cpartcode = '" + row["cpartcode"].ToString() + "'  and cversion ='" + row["cversion"].ToString() + "' order by ceditrntyp";
                    adp.SelectCommand = cmd;
                    dtTransactions.Rows.Clear();
                    adp.Fill(dtTransactions);
                    Boolean firstRow = true;
                    if (dtTransactions.Rows.Count == 0)
                    { adjustworksheetRow(row["cversion"].ToString().Trim());
                    }

                    foreach (DataRow transrow in dtTransactions.Rows)
                    {
                        if (firstRow == true)
                        {
                            workSheet.Cells[nRowCurrent , 1].value = transrow["cmapset"].ToString().Trim();
                            workSheet.Cells[nRowCurrent, 2].value = row["cpartname"].ToString().Trim();
                            workSheet.Cells[nRowCurrent, 3].value = row["cpartcode"].ToString().Trim();
                            workSheet.Cells[nRowCurrent, 4].value = row["cversion"].ToString().Trim();
                            workSheet.Cells[nRowCurrent, 5].value = "Ready";
                            firstRow = false;
                        }

                        try
                        {
                            int clmn = findColumn(transrow["ceditrntyp"].ToString().Trim());
                            workSheet.Cells[nRowCurrent, clmn].value = "√";
                        }
                        catch (Exception ex)
                        { };

                    }

                }

                adjust(true);
                MessageBox.Show("EDI Trading partners Excel Sheet, Done");
                app.Visible = true;
                con.Close();
                //workBook.Close();
                //app.Quit();
                ICloseIt = true; 
                this.Close(); 


            }
            catch (Exception ex)
            {
                adjust(true);
                MessageBox.Show(ex.Message.ToString());
                try
                {
                    workBook.Close();
                    app.Quit();
                    con.Close();
                }
                catch (Exception ex1)
                { };



            };



        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string Path = Application.StartupPath + "\\TradingPartnerTemplate.xls";
            string Path1 = Application.StartupPath + "\\TradingPartnerList.xls";

            adjust(true);

            if (System.IO.File.Exists(Path1) == true)
            { System.IO.File.Delete(Path1); };
            if (System.IO.File.Exists(Path) == true)
            {
                System.IO.File.Copy(Path, Path1);
                workBook = app.Workbooks.Open(Path1, 0, false, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows,
                                                                   "\t", false, false, 0, true, 1, 0);

                workSheetX12     = (Microsoft.Office.Interop.Excel.Worksheet)workBook.Worksheets[1];
                workSheetEDIFACT = (Microsoft.Office.Interop.Excel.Worksheet)workBook.Worksheets[2];
                workSheetXML     = (Microsoft.Office.Interop.Excel.Worksheet)workBook.Worksheets[3];

                btnCreateExcelFile.Enabled = true;
            }
            else
            {
                btnCreateExcelFile.Enabled = false;
            };


        }

        private int findColumn(string TransactionCode)
        {
            TransactionCode = TransactionCode.ToString().Trim();
            int trcolumn = 0;
            switch (TransactionCode)
            {
                case "204":
                    trcolumn = 6;
                    break;

                case "211":
                    trcolumn = 7;
                    break;
                case "753":
                    trcolumn = 8;
                    break;

                case "754":
                    trcolumn = 9;
                    break;
                case "810":
                    trcolumn = 10;
                    break;

                case "811":
                    trcolumn = 11;
                    break;
                case "812":
                    trcolumn = 12;
                    break;

                case "816":
                    trcolumn = 13;
                    break;
                case "820":
                    trcolumn = 14;
                    break;

                case "824":
                    trcolumn = 15;
                    break;
                case "830":
                    trcolumn = 16;
                    break;

                case "831":
                    trcolumn = 17;
                    break;
                case "832":
                    trcolumn = 18;
                    break;

                case "846":
                    trcolumn = 19;
                    break;
                case "850":
                    trcolumn = 20;
                    break;

                case "852":
                    trcolumn = 21;
                    break;
                case "855":
                    trcolumn = 22;
                    break;

                case "856":
                    trcolumn = 23;
                    break;
                case "860":
                    trcolumn = 24;
                    break;

                case "864":
                    trcolumn = 25;
                    break;
                case "865":
                    trcolumn = 26;
                    break;

                case "869":
                    trcolumn = 27;
                    break;
                case "870":
                    trcolumn = 28;
                    break;

                case "940":
                    trcolumn = 29;
                    break;
                case "943":
                    trcolumn = 30;
                    break;

                case "944":
                    trcolumn = 31;
                    break;
                case "945":
                    trcolumn = 32;
                    break;

                case "997":
                    trcolumn = 33;
                    break;

                default:
                    trcolumn = 0;
                    break;
            }

            return trcolumn;
        }

        private void adjust(Boolean bState)
        {
            TPProgressBar.Visible = !bState;
            lblprogress.Visible   = !bState;

            txtServerName.Enabled = bState;
            TxtUserName.Enabled   = bState;
            TxtPassword.Enabled   = bState;
            btnCreateExcelFile.Enabled = bState;
        }

        private void adjustworksheet(string version)
        {
            if (version.IndexOf('.') > 0)
            { workSheet = workSheetXML;
            nRowXML = nRowXML + 1;
            nRowCurrent = nRowXML;
            }
            else {
                if (version.IndexOf(':') > 0)
                { workSheet = workSheetEDIFACT ;
                nRowEDIFACT = nRowEDIFACT + 1;
                nRowCurrent = nRowEDIFACT;
                }
            else
                { workSheet = workSheetX12;
                nRowX12 = nRowX12 + 1;
                nRowCurrent = nRowX12;
                };

            
            }


        }
        private void adjustworksheetRow(string version)
        {
            if (version.IndexOf('.') > 0)
            {
                nRowXML = nRowXML - 1;
                nRowCurrent = nRowXML;
            }
            else
            {
                if (version.IndexOf(':') > 0)
                {
                    nRowEDIFACT = nRowEDIFACT - 1;
                    nRowCurrent = nRowEDIFACT;
                }
                else
                {
                    nRowX12 = nRowX12 - 1;
                    nRowCurrent = nRowX12;
                };


            }


        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            try
            {
                if (ICloseIt == false)
                {
                    workBook.Close();
                    app.Quit();
                }
            }
            catch (Exception ex)
            { };

        }
    }
}

