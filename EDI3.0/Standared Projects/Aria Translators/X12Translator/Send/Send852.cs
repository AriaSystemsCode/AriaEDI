using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace X12Translator
{
   public  class Send852 :SendTranslator
    {
        public Send852()
        {

        }
        public string[,] WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany, string cpartcode, string transaction_No, string ErrorLogFile)
        { 
            string[,] lcResut = null;
            this.Trans_Format = transaction_No.Trim() + FileFormat.Trim();
            if (ImportToSql(lcTransactionFile, this.Trans_Format, ClientId, ActiveCompany))
            {
               lcResut = Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, cpartcode, transaction_No, ErrorLogFile);  
            }
            return lcResut;
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
