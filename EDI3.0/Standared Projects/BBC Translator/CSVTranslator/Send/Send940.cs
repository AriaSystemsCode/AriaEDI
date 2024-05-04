using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace CSVTranslator
{
    public class Send940 : SendTranslator
    {

        public Send940()
        {

        }

        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany)
        { 
            if (ImportToSql(lcTransactionFile, "940", ClientId, ActiveCompany))
            {
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "Send940.xml","940");
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
    }
}
