using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace CSVTranslator
{
    public class SendCST : SendTranslator
    {

        public SendCST()
        {

        }

        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany, string cpartcode, string transaction_No, string ErrorLogFile)
        {
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class 1 ");
            needDataSetOnly = true;
            if (ImportToSql(lcTransactionFile, "CST", ClientId, ActiveCompany))
            {
                System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class 1 -1");
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "SendCST.xml", "CST");
            }
        }
        public void WriteOutGoingFile(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany)
        {
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class 2 ");
            if (ImportToSql(lcTransactionFile, "CST", ClientId, ActiveCompany))
            {
                Translate(lcTransactionFile, MapSet, MapVersion, FileFormat, OutgoingFile, ClientId, ActiveCompany, "SendCST.xml", "CST");
            }
        }
        public bool ImportToSql(string XMLfile, string TransType, string ClientID, string ActiveCompany)
        {
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -1 ");
            if (!AriaConnection.init(ClientID, ActiveCompany))
            {

                ErrorMsg = AriaConnection.ErrorMsg;
                return false;
            }

            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -2 ");

            TransactionsCore.TransactionsCore core = new TransactionsCore.TransactionsCore();
            System.Data.SqlClient.SqlConnectionStringBuilder ConnectionBuilder = new System.Data.SqlClient.SqlConnectionStringBuilder(AriaConnection.CompanyConnection.ConnectionString);
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -3 ");
            core.needDataSetOnly = needDataSetOnly;
            core.Import(TransType, ConnectionBuilder.DataSource, ConnectionBuilder.InitialCatalog, ConnectionBuilder.UserID, ConnectionBuilder.Password, XMLfile);
            
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -4 ");

            if (core.needDataSetOnly)
            { dataSetSource = core.dataSetSource; }
            System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -5 ");

            if (core.Error)
            {
                ErrorMsg = core.ErrorMsg;
                System.IO.File.AppendAllText(@"d:\shared\aria3edi\edi\outbox\log.txt", "in class import -error "+ core.ErrorMsg.ToString());
                return false;
            }
            return true;
        }
    
    }
}
