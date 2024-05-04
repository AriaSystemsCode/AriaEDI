using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace CSVTranslator
{
    public class SendVND : SendTranslator
    {

        public SendVND()
        {

        }

        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany, string cpartcode, string transaction_No, string ErrorLogFile)
        {
            needDataSetOnly = true;
            if (ImportToSql(lcTransactionFile, "VND", ClientId, ActiveCompany))
            {
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "SendVND.xml", "VND");
            }
        }
        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany)
        {
            if (ImportToSql(lcTransactionFile, "VND", ClientId, ActiveCompany))
            {
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "SendVND.xml", "VND");
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
            core.needDataSetOnly = needDataSetOnly;

            core.Import(TransType, ConnectionBuilder.DataSource, ConnectionBuilder.InitialCatalog, ConnectionBuilder.UserID, ConnectionBuilder.Password, XMLfile);
            if (core.needDataSetOnly)
            { dataSetSource = core.dataSetSource; }

            if (core.Error)
            {
                ErrorMsg = core.ErrorMsg;
                return false;
            }
            return true;
        }
    }
}
