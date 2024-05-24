using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace CSVTranslator
{
    public class Send810 : SendTranslator
    {

        public Send810()
        {

        }

        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany)
        {
            base.BeforeReadingRelations += new SendTranslator.delegates.BeforeReadingRelations(beforeReadingRelations);
            if (ImportToSql(lcTransactionFile, "810", ClientId, ActiveCompany))
            {
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "Send810.xml","810");
            }
        }

        public bool ImportToSql(string XMLfile, string TransType, string ClientID, string ActiveCompany)
        {
            if (!AriaConnection.init(ClientID, ActiveCompany))
            {
                ErrorMsg = AriaConnection.ErrorMsg;
                return false;
            }
            TransactionsCore.TransactionsCore core = new TransactionsCore.TransactionsCore();
            System.Data.SqlClient.SqlConnectionStringBuilder ConnectionBuilder = new System.Data.SqlClient.SqlConnectionStringBuilder(AriaConnection.CompanyConnection.ConnectionString);
            core.Import(TransType, ConnectionBuilder.DataSource, ConnectionBuilder.InitialCatalog, ConnectionBuilder.UserID, ConnectionBuilder.Password, XMLfile);
            if (core.Error)
            {
                ErrorMsg = core.ErrorMsg;
                return false;
            }
            return true;
        }

        void beforeReadingRelations()
        {
            if (DataDataset != null && DataDataset.Tables.Count > 0)
            {
                DataDataset.Tables["INVOICE_CHARGES_T"].Columns.Add("LOCATION_TYPE");
                DataDataset.Tables["INVOICE_CHARGES_T"].Columns.Add("VatPercent");
                DataDataset.Tables["INVOICE_CHARGES_T"].Columns.Add("VatAmount");
                DataDataset.Tables["INVOICE_CHARGES_T"].Columns.Add("C310Percent");
                DataDataset.Tables["INVOICE_CHARGES_T"].Columns.Add("C310Amount");
                DataDataset.Tables["INVOICE_DETAILS_T"].Columns.Add("INVOICE_CHARGES_KEY", typeof(Int64));

                var INVOICE_CHARGES_KEY = 0;
                int.TryParse(Convert.ToString(DataDataset.Tables["INVOICE_CHARGES_T"].Compute("max(INVOICE_CHARGES_KEY)", null)), out INVOICE_CHARGES_KEY);
                INVOICE_CHARGES_KEY++;

                foreach (DataRow HeaderRow in DataDataset.Tables["INVOICE_HEADER_T"].Rows)
                {
                    string HeaderKey = Convert.ToString(HeaderRow["INVOICE_HEADER_KEY"]);

                    #region Charges
                    var ChargesRows = DataDataset.Tables["INVOICE_CHARGES_T"].Select("INVOICE_HEADER_KEY=" + HeaderKey);
                    if (ChargesRows.Length == 0)
                    {
                        DataRow chargesNewRow = DataDataset.Tables["INVOICE_CHARGES_T"].NewRow();
                        chargesNewRow["INVOICE_HEADER_KEY"] = HeaderKey;
                        chargesNewRow["VatPercent"] = decimal.Zero;
                        chargesNewRow["VatAmount"] = decimal.Zero;
                        chargesNewRow["C310Percent"] = decimal.Zero;
                        chargesNewRow["C310Amount"] = decimal.Zero;
                        DataDataset.Tables["INVOICE_CHARGES_T"].Rows.Add(chargesNewRow);
                        chargesNewRow["INVOICE_CHARGES_KEY"] = INVOICE_CHARGES_KEY++;
                        ChargesRows = new DataRow[] { chargesNewRow };

                    }
                    foreach (DataRow chargeRow in ChargesRows)
                    {
                        if (Convert.ToString(chargeRow["SERVICE_TYPE"]) == "C" && Convert.ToString(chargeRow["SERVICE_CODE"]) == "VAT")
                        {
                            ChargesRows[0]["VatPercent"] = chargeRow["PERCENT"];
                            ChargesRows[0]["VatAmount"] = chargeRow["Amount"];
                        }
                        else
                        {
                            ChargesRows[0]["VatPercent"] = decimal.Zero;
                            ChargesRows[0]["VatAmount"] = decimal.Zero;
                        }

                        if (Convert.ToString(chargeRow["SERVICE_TYPE"]) == "A" && Convert.ToString(chargeRow["SERVICE_CODE"]) == "C310")
                        {
                            ChargesRows[0]["C310Percent"] = chargeRow["PERCENT"];
                            ChargesRows[0]["C310Amount"] = chargeRow["Amount"];
                        }
                        else
                        {
                            ChargesRows[0]["C310Percent"] = decimal.Zero;
                            ChargesRows[0]["C310Amount"] = decimal.Zero;
                        }
                    }
                    for (int x = ChargesRows.Length; x > 1; x--)
                    {
                        DataDataset.Tables["INVOICE_CHARGES_T"].Rows.Remove(ChargesRows[x - 1]);
                    }
                    var DetailsRows = DataDataset.Tables["INVOICE_DETAILS_T"].Select("INVOICE_HEADER_KEY=" + HeaderKey);
                    foreach (DataRow row in DetailsRows)
                    {
                        row["INVOICE_CHARGES_KEY"] = ChargesRows[0]["INVOICE_CHARGES_KEY"];
                    }
                    #endregion


                    #region Location
                    string location_Type = null;
                    var LocationsRows = DataDataset.Tables["INVOICE_LOCATIONS_T"].Select("INVOICE_HEADER_KEY=" + HeaderKey, "LOCATION_TYPE DESC");
                    foreach (DataRow row in LocationsRows)
                    {
                        if (Convert.ToString(row["LOCATION"]).HasValue() && location_Type == null)
                            location_Type = Convert.ToString(row["LOCATION_TYPE"]);
                        else
                            DataDataset.Tables["INVOICE_LOCATIONS_T"].Rows.Remove(row);
                    }
                    ChargesRows = DataDataset.Tables["INVOICE_CHARGES_T"].Select("INVOICE_HEADER_KEY=" + HeaderKey);
                    foreach (DataRow row in ChargesRows)
                    {
                        row["LOCATION_TYPE"] = location_Type;
                    }
                    #endregion

                }
            }
        }
    }
}