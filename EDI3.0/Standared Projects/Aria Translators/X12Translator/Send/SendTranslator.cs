using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Xml;
using System.IO;
using System.Data.SqlClient;
using System.Data.SQLite;
using System.Data.OleDb;
using System.Collections.Specialized;

namespace X12Translator
{
    public class SendTranslator : SENDTRANSACTIONS
    {
        #region Properties & Fields
        public string ErrorLogTable { get; set; }
        public OleDbConnection ErrorLogConection { get; set; }
        public int error_sequence { get; set; }
        public bool RejectionFlag { get; set; }
        public int TRANS_SET { get; set; }
        public int totalSegmentsNo { get; set; }
        public string Trans_Format { get; set; }
        public string[,] rawFileTransactions;
        public int transactions = -1;
        public DataSet DataDataset = new DataSet();
        XmlDocument mapxml = new XmlDocument();
        List<xmlMapClass> xmlMapList = new List<xmlMapClass>();
        StreamWriter streamWriter;
        FileStream fileStream;
        string _dateFormat, mostParentTable, mostChildTable, mostParentLoop;
        public delegates.BeforeReadingRelations BeforeReadingRelations;
        public delegates.AfterReadingRelations AfterReadingRelations;
        EDIPD _tempEdiPd;
        EDIPH _tempEdiPh;
        EDIACPRT ediAccPrt_row;
        EDINET partnerNetwork;
        string fieldSperator;
        string lineSperator;
        Boolean isContinuesNetwork;
        public string CPartCode { get; set; }
        string Tranaction_No { get; set; }
        public bool HasError { get; set; }
        public string OutgoingFile { get; set; }
        List<xmlLoopsClass> xmlLoopsList = new List<xmlLoopsClass>();
        protected List<xmlTablesClass> xmlTableList = new List<xmlTablesClass>();
        protected List<xmlTablesIDClass> xmlTablesIDList = new List<xmlTablesIDClass>();
        Dictionary<string, List<TRANSACTION_SEGMENTS_T>> Loops_SegmentsDic = new Dictionary<string, List<TRANSACTION_SEGMENTS_T>>();
        Dictionary<string, List<xmlMapClass>> Loops_VariablesDic = new Dictionary<string, List<xmlMapClass>>();
        Dictionary<string, List<TRANSACTION_MAP_T>> Segments_FieldsDic = new Dictionary<string, List<TRANSACTION_MAP_T>>();
        OrderedDictionary SqliteStatments = new OrderedDictionary();
        public string mostParentcolumns = "";
        public string mostParentFields = "";
        public string mostParentValues = "";
        public string mostParentSeg { get; set; }
        public string mostChildSeg { get; set; }
        public DataSet DataDatasetCopy = new DataSet();
        DataSet alltablesloop = new DataSet();
        //AEG BGN
        List<SYCSEGHD> _sycseghd;
        List<SYCSEGDT> _sycsegdt;
        List<SYCVICS> _sycvics;
        List<SYCVICS> _sycvics_VICS;
        List<SYCSEGVA> _sycsegva;
        //AEG END
        #endregion

        #region Methods
        public SendTranslator() { }

        public string[,] Translate(string AriaXmlPath, string MapSet, string MapVersion,
                               string FileFormat, string outgoingFile, string ClientId,
                               string ActiveCompany, string CPartCode, string LcTransactionType, string ErrorLogFile)
        {
            try
            {

                if (string.IsNullOrEmpty(AriaXmlPath) || string.IsNullOrEmpty(MapSet) || string.IsNullOrEmpty(MapVersion)
                    || string.IsNullOrEmpty(outgoingFile) || string.IsNullOrEmpty(ClientId)
                    || string.IsNullOrEmpty(ActiveCompany) || string.IsNullOrEmpty(LcTransactionType)
                    || string.IsNullOrEmpty(CPartCode) || string.IsNullOrEmpty(ErrorLogFile) || string.IsNullOrEmpty(FileFormat))
                {
                    HasError = true;
                    ErrorMsg = "one or more Arguments is Null or Empty";
                    _continue = false;
                    return null;
                }
                this.TransactionType = LcTransactionType;
                this.FileFormat = FileFormat;
                this.MapVersion = MapVersion;
                this.MapSet = MapSet;
                this.CPartCode = CPartCode;
                this.OutgoingFile = outgoingFile;
                if (File.Exists(this.OutgoingFile))
                {
                    this.fileStream = new FileStream(OutgoingFile, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
                    this.streamWriter = new StreamWriter(this.fileStream);
                }
                else
                {
                    HasError = true;
                    ErrorMsg = "Outgoing file is not exist.";
                    _continue = false;
                    return null;

                }

                if (!File.Exists(ErrorLogFile))
                {
                    HasError = true;
                    ErrorMsg = "Error Log file does not exist.";
                    _continue = false;
                    return null;
                }
                this.ErrorLogTable = ErrorLogFile;
                try
                {
                    string strLogConnectionString = @"Provider=vfpoledb;Data Source=" + this.ErrorLogTable + ";Collating Sequence=machine;Mode=ReadWrite;";
                    this.ErrorLogConection = new OleDbConnection(strLogConnectionString);
                }
                catch (Exception ex)
                {
                    HasError = true;
                    ErrorMsg = ex.InnerException.ToString();
                    _continue = false;
                    return null;
                }
                //Get Partner Information
                getPartnerInfo();

                if (this._tempEdiPd == null || this._tempEdiPh == null)
                {
                    HasError = true;
                    _continue = false;
                    return null;
                }

                this.TRANS_SET = _tempEdiPd.ntranseq != null && (int)this._tempEdiPd.ntranseq == 0 ? 1 : (int)this._tempEdiPd.ntranseq;

                ReadMapXml();
                if (!_continue) return null;

                ReadConfigXml();
                if (!_continue) return null;

                init(ClientId, ActiveCompany);
                if (!_continue) return null;

                ReadAriaXml(AriaXmlPath);
                if (!_continue) return null;

                ReadLoops();
                if (!_continue) return null;

                //AEG BGN
                GetDictionary();
                if (!_continue) return null;
                //AEG END
                
                DataDatasetCopy = DataDataset.Clone();
                Readrelation();

                WriteFile();
                if (!_continue) return null;

                streamWriter.Close();
                this.fileStream.Close();
                if (!_continue) return null;
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                if (streamWriter != null)
                    streamWriter.Close();

                if(this.fileStream !=null)
                    this.fileStream.Close();
                _continue = false;
                return null;
            }
            //Check if all transactions has no rejections.
            if(RejectionFlag)
            {
                return null;
            }
            else
            {
                EDIPD.Update(AriaConnection.DbfsConnection, "ntranseq = " + (this.TRANS_SET + 1).ToString(),
                    "WHERE cpartcode = '" + this.CPartCode + "' and cversion ='" + this.MapVersion + "' and ceditrntyp ='" + this.TransactionType + "'");
                
                return rawFileTransactions;
            }
        }
        public void TrimFieldLineSeparator(ref string field_sep, ref string line_seperator)
        {
            field_sep = field_sep.Replace("'", "").Replace("\"", "").Trim();

            if (field_sep.Contains("CHR"))
            {
                field_sep = field_sep.Substring(field_sep.IndexOf('(') + 1, field_sep.IndexOf(')') - field_sep.IndexOf('(') - 1);
                field_sep = char.ConvertFromUtf32(int.Parse(field_sep)).ToString();
            }



            line_seperator = line_seperator.Replace("\"", "").Replace("'", "").Trim();
            if (line_seperator.Contains("CHR"))
            {
                line_seperator = line_seperator.Substring(line_seperator.IndexOf('(') + 1, line_seperator.IndexOf(')') - line_seperator.IndexOf('(') - 1);
                line_seperator = char.ConvertFromUtf32(int.Parse(line_seperator)).ToString();
            }



        }
        public void getPartnerInfo()
        {
            this._tempEdiPh = EDIPH.Select(AriaConnection.DbfsConnection, "WHERE cpartcode = '" + this.CPartCode + "' and cversion = '" + this.MapVersion + "'").FirstOrDefault();
            this._tempEdiPd = EDIPD.Select(AriaConnection.DbfsConnection, "WHERE cpartcode = '" + this.CPartCode + "' and cversion ='" +this.MapVersion + "' and ceditrntyp ='" + this.TransactionType + "'").FirstOrDefault();
            this.ediAccPrt_row = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cpartcode = '" + this.CPartCode + "'").First();
            this.fieldSperator = _tempEdiPh.cfieldsep;
            this.lineSperator = _tempEdiPh.clinesep;
            TrimFieldLineSeparator(ref this.fieldSperator, ref this.lineSperator);

            this.partnerNetwork = EDINET.Select(AriaConnection.DbfsConnection, "WHERE Cnetwork = '" + this._tempEdiPh.cnetwork.Trim() + "'").FirstOrDefault();

            if (partnerNetwork.lsndcntseg == null || partnerNetwork.lsndcntseg == false)
            {
                this.isContinuesNetwork = false;
            }
            else if (!partnerNetwork.lsndcntseg == null && partnerNetwork.lsndcntseg == true)
            {
                this.isContinuesNetwork = true;
            }

        }
        public virtual void WriteFile()
        {
            rawFileTransactions = new string[DataDataset.Tables[mostParentTable].Rows.Count, 3];

            FilterDataUsingRelation(mostParentLoop, DataDataset.Tables[mostParentTable].Rows[0]);
            if (!_continue)
                return;
        }

        //FilterDataUsingRelation is a recursion method to go on the tables depth technique.
        // for example header-carton-item
        //and header-summery
        //get each record from header and get the cartons record for the record of header by relation
        //and get each record of carton and get the items records for the record of carton by relation
        // and loop on items until the records of item table finish after filter item table by carton
        // and go back as a recursive and finish all data

        //FilterDataUsingRelation has two paramters loop_id is the current loop will work on it
        // and parentrow is if item loop the parentrow is carton record , if carton loop then the parentrow is header record
        private void FilterDataUsingRelation(string loop_id, DataRow parentrow)
        {
            //get the loop details nodes from loops.xml by loop_id
            var loopdetails = xmlLoopsList.Where(loop => loop.ID == loop_id).FirstOrDefault();

            DataRow[] childrows = null;
            //check if the table of loop_id is the mostparenttable and loop_id is not equal the mostparentloop
            //this case for summery loop for example
            if (loopdetails.ParentTable == mostParentTable && loop_id != mostParentLoop)
            {
                childrows = new DataRow[1];
                childrows[0] = parentrow;
            }
            else
                childrows = parentrow.GetChildRows(parentrow.Table.ToString() + "-" + loopdetails.ParentTable);

            //if loop_id equal mostparentloop get all records on loopdetails.parentTable
            if (loop_id == mostParentLoop)
                childrows = DataDataset.Tables[loopdetails.ParentTable].Select();

            foreach (DataRow record in childrows)
            {
                if (loop_id == mostParentLoop)
                {
                    ++transactions;
                    if (transactions > 0 )
                    {
                        //Initialize New ST
                        this.TRANS_SET++;
                        this.totalSegmentsNo = 0;
                    }

                    rawFileTransactions[transactions, 0] = TRANS_SET.ToString().PadLeft(9, '0');
                }
                //alltablesloop is a filtered data set by record to send it to writeloop method
                DataSet alltablesloop = new DataSet();

                alltablesloop = DataDatasetCopy.Clone();

                alltablesloop.Tables[loopdetails.ParentTable].ImportRow(record);

                //this if statment to check if record has parent loop add it to alltablesloop
                //for example if record is for carton table then i will get the record of header table and add it to alltablesloop
                if (!(string.IsNullOrEmpty(loopdetails.ParentLoop)))
                {
                    var parentrelations = xmlTableList.Where(relation => relation.ChildTable == loopdetails.ParentTable);
                    foreach (var relation in parentrelations)
                    {
                        alltablesloop.Tables[relation.ParentTable].ImportRow(record.GetParentRow(relation.ParentTable + "-" + loopdetails.ParentTable));
                    }
                }

                //if record is carton record add the child rows to alltablesloop the childrows in this example is the records
                // of item table
                foreach (DataRelation relation in DataDataset.Tables[loopdetails.ParentTable].ChildRelations)
                {
                    foreach (DataRow childrelationrow in record.GetChildRows(relation))
                        alltablesloop.Tables[relation.ChildTable.ToString()].ImportRow(childrelationrow);
                }

                //call writeloop method with the filtered data set and current loop id
                WriteLoop(alltablesloop, loop_id);
                if (!_continue)
                    return;


                //get the child loops for the current loop
                string[] childloops = string.IsNullOrEmpty(loopdetails.ChildLoop) ? null : loopdetails.ChildLoop.Split(',');

                if (childloops != null)
                {
                    //loop on each child loop as and call the same method
                    foreach (string childloop in childloops)
                    {
                        FilterDataUsingRelation(childloop, record);
                        if (!_continue)
                            return;
                    }
                }
            }
        }

        //this method for get relation from XML get column from column node under parenttable node as primary key
        //and get the column from column node under childtable node as foreign key
        //and set relation on datadataset set each primary key is foreign key in between each table
        //according to XML
        private void Readrelation()
        {
            foreach (var relation in xmlTableList)
            {
                DataColumn[] dcparent = new DataColumn[relation.ParentColumnsList[0].ColumnList.Count];
                DataColumn[] dcchild = new DataColumn[relation.ParentColumnsList[0].ColumnList.Count];
                for (int columnindex = 0; columnindex < relation.ParentColumnsList[0].ColumnList.Count; columnindex++)
                {
                    dcparent[columnindex] = DataDataset.Tables[relation.ParentTable].Columns[relation.ParentColumnsList[0].ColumnList[columnindex].Columndata];
                    dcchild[columnindex] = DataDataset.Tables[relation.ChildTable].Columns[relation.ChildColumnsList[0].ColumnList[columnindex].Columndata];
                }
                DataRelation dr = new DataRelation(relation.ParentTable + "-" + relation.ChildTable, dcparent, dcchild);

                DataDataset.Relations.Add(dr);
            }
        }
        private void ReadMapXml()
        {
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string xmlMappath = dllLocation + "\\" + TransactionType + "\\Send.xml"; //Baiomy
            if (!File.Exists(xmlMappath))
            {
                HasError = true;
                ErrorMsg = "Send" + this.TransactionType + "  " + xmlMappath + " couldn't be found!";
                _continue = false;
                return;
            }
            mapxml.Load(xmlMappath);
            DateFormat = mapxml.SelectSingleNode("//DateFormat").InnerText.ToUpper();
            _dateFormat = mapxml.SelectSingleNode("//DateFormat").InnerText.Trim();
            FileSegments = mapxml.SelectSingleNode("//FileSegments").InnerText;
            mostParentTable = mapxml.SelectSingleNode("//MostParentTable").InnerText;
            mostChildTable = mapxml.SelectSingleNode("//MostChildTable").InnerText;
            TransactionType = mapxml.SelectSingleNode("//TransactionType").InnerText;
            try
            {
                mostParentLoop = mapxml.SelectSingleNode("//MostParentLoop").InnerText;
            }
            catch (Exception) { }
            foreach (XmlNode xmlmapNode in mapxml.SelectNodes("//Map"))
            {
                xmlMapClass map = new xmlMapClass();
                map.Variable = xmlmapNode["Variable"].InnerText;
                map.Table = xmlmapNode["Table"].InnerText;
                map.Column = xmlmapNode["Column"].InnerText;
                map.Loop = xmlmapNode["Loop"].InnerText;
                map.Temp = xmlmapNode["Variable"].Attributes["Temp"] != null;
                try
                {
                    map.relatedtypevalue = xmlmapNode["relatedtypevalue"].InnerText;
                    map.relatedtype = xmlmapNode["relatedtype"].InnerText;
                }
                catch (Exception)
                {
                }

                foreach (XmlNode node in xmlmapNode.SelectNodes("Condition"))
                {
                    if (node.InnerText.HasValue())
                    {
                        xmlMapClass.condition cond = new xmlMapClass.condition();
                        cond.type = node.Attributes["Type"].InnerText;
                        cond.experssion = node.InnerText;
                        cond.lhsSource = node.Attributes["lhsSource"].InnerText;
                        cond.rhsSource = node.Attributes["rhsSource"].InnerText;
                        map.Condition.Add(cond);
                    }
                }
                foreach (XmlNode node in xmlmapNode.SelectNodes("Fixed"))
                {
                    if (node.InnerText.HasValue())
                    {
                        xmlMapClass.Fixed fixd = new xmlMapClass.Fixed();
                        fixd.experssion = node.InnerText;
                        if (node.Attributes["Type"] != null)
                            fixd.type = node.Attributes["Type"].InnerText;
                        if (node.Attributes["lhsSource"] != null)
                            fixd.lhsSource = node.Attributes["lhsSource"].InnerText;
                        if (node.Attributes["rhsSource"] != null)
                            fixd.rhsSource = node.Attributes["rhsSource"].InnerText;
                        map.fixd.Add(fixd);
                    }
                }
                this.xmlMapList.Add(map);
            }

            //FODA [BEGIN]
            foreach (XmlNode node in mapxml.SelectNodes("//Relations/Source/Add/Relation"))
            {
                xmlTablesClass XMLTables = new xmlTablesClass();
                XMLTables.ParentTable = node["ParentTable"].InnerText;
                XMLTables.ChildTable = node["ChildTable"].InnerText;

                foreach (XmlNode ParentColumnsnode in node.SelectNodes("ParentColumns"))
                {
                    xmlTablesClass.ParentColumns parentcolumns = new xmlTablesClass.ParentColumns();

                    foreach (XmlNode Columnsnode in ParentColumnsnode.SelectNodes("Column"))
                    {
                        xmlTablesClass.ParentColumns.Column columns = new xmlTablesClass.ParentColumns.Column();
                        columns.Columndata = Columnsnode.InnerText;
                        parentcolumns.ColumnList.Add(columns);
                    }
                    XMLTables.ParentColumnsList.Add(parentcolumns);
                }
                foreach (XmlNode ChildColumnsnode in node.SelectNodes("ChildColumns"))
                {
                    xmlTablesClass.ChildColumns childcolumns = new xmlTablesClass.ChildColumns();

                    foreach (XmlNode Columnsnode in ChildColumnsnode.SelectNodes("Column"))
                    {
                        xmlTablesClass.ChildColumns.Column columns = new xmlTablesClass.ChildColumns.Column();
                        columns.Columndata = Columnsnode.InnerText;
                        childcolumns.ColumnList.Add(columns);
                    }
                    XMLTables.ChildColumnsList.Add(childcolumns);
                }
                xmlTableList.Add(XMLTables);
            }
            foreach (XmlNode node in mapxml.SelectNodes("//Tables940"))
            {
                foreach (XmlNode table940 in node.SelectNodes("//Table940"))
                {
                    xmlTablesIDClass TableID = new xmlTablesIDClass();
                    TableID.Tablename = table940["TableName"].InnerText;
                    TableID.identifier = table940["Identifier"].InnerText;
                    xmlTablesIDList.Add(TableID);
                }
            }
        }
        private void ReadAriaXml(string xmlPath)
        {
            if (!File.Exists(xmlPath))
            {
                ErrorMsg = "AriaXMl " + xmlPath + " couldn't be found!";
                _continue = false;
                return;
            }

            TransactionsCore.TransactionsCore core = new TransactionsCore.TransactionsCore();
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            string tempDB = Path.GetRandomFileName().Replace(".", "");

            //core.TempDataBaseCreator(TransactionType+FileFormat, tempDB, sb.DataSource, sb.UserID, sb.Password);
            //core.Import(TransactionType + FileFormat, sb.DataSource, tempDB, sb.UserID, sb.Password, xmlPath);

            core.TempDataBaseCreator(this.Trans_Format, tempDB, sb.DataSource, sb.UserID, sb.Password);
            core.Import(this.Trans_Format, sb.DataSource, tempDB, sb.UserID, sb.Password, xmlPath);

            sb.InitialCatalog = tempDB;
            SqlConnection tempDBcon = new SqlConnection(sb.ConnectionString);

            tempDBcon.Open();
            DataTable tablesNamesDataTable = tempDBcon.GetSchema("Tables", new string[] { tempDB, null, null, null });
            tempDBcon.Close();
            List<string> tableNamesList = new List<string>();
            foreach (DataRow tableNameRow in tablesNamesDataTable.Rows)
                tableNamesList.Add(Convert.ToString(tableNameRow["Table_Name"]));
            string sqlstatment = "";
            tableNamesList.ForEach(tableName => sqlstatment += Environment.NewLine + "Select * from [" + tableName + "]");

            SqlDataAdapter da = new SqlDataAdapter(tempDBcon.CreateCommand());
            da.SelectCommand.CommandText = sqlstatment;
            da.Fill(DataDataset);
            for (int x = 0; x < tableNamesList.Count; x++)
                DataDataset.Tables[x].TableName = tableNamesList[x];

            SqlConnection.ClearAllPools();
            SqlCommand cmd = AriaConnection.ClientMasterConnection.CreateCommand();
            cmd.Connection.Open();
            cmd.CommandText = "ALTER DATABASE [" + tempDB + "]SET OFFLINE WITH ROLLBACK IMMEDIATE";
            cmd.ExecuteNonQuery();
            cmd.CommandText = "drop database [" + tempDB + "]";
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();

            // shipmentDataset.ReadXml(xmlPath);
        }
        public void ReadLoops()
        {
            XmlDocument mapxml = new XmlDocument();
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string LoopXmlPath = dllLocation + "\\" + TransactionType + "\\loops.xml";
            if (!File.Exists(LoopXmlPath))
            {
                HasError = true;
                ErrorMsg = "Loop XML File : " + LoopXmlPath + " couldn't be found!";
                _continue = false;
                return;
            }
            mapxml.Load(LoopXmlPath);
            mostParentSeg = mapxml.SelectSingleNode("//MostParent").InnerText;
            mostChildSeg = mapxml.SelectSingleNode("//MostChild").InnerText;

            //FODA [BEGIN]
            mostParentLoop = mapxml.SelectSingleNode("//MostParentLoop").InnerText;
            //FODA [END]

            foreach (XmlNode xmlLoopNode in mapxml.SelectNodes("//Loop"))
            {
                xmlLoopsClass Loop = new xmlLoopsClass();
                Loop.ParentLoop = xmlLoopNode["ParentLoop"].InnerText;
                Loop.ID = xmlLoopNode["ID"].InnerText;
                Loop.Repeatble = xmlLoopNode["Repeatble"].InnerText.ToUpper() == "TRUE" ? true : false;
                Loop.Description = xmlLoopNode["Description"].InnerText;
                Loop.SegId = xmlLoopNode["SegId"].InnerText;
                Loop.ParentTable = xmlLoopNode["ParentTable"].InnerText;
                Loop.ParentTableColumn = xmlLoopNode["ParentTableColumn"].InnerText;
                Loop.ChildTable = xmlLoopNode["ChildTable"].InnerText;
                Loop.ChildTableColumn = xmlLoopNode["ChildTableColumn"].InnerText;
                Loop.RelatedValue = xmlLoopNode["RelatedValue"].InnerText;
                Loop.ChildLoop = xmlLoopNode["ChildLoop"].InnerText;
                mostParentLoop = mapxml.SelectSingleNode("//MostParentLoop").InnerText;
                bool relatedvalueparse = int.TryParse(xmlLoopNode["RelatedColumn"].InnerText, out Loop.RelatedColumn);

                if (!relatedvalueparse && xmlLoopNode["RelatedColumn"].InnerText.HasValue())
                {
                    HasError = true;
                    ErrorMsg = "can't parse Related Value node in loops.xml !";
                    _continue = false;
                    return;
                }
                this.xmlLoopsList.Add(Loop);

            }


        }
        public void ReadConfigXml()
        {
            XmlDocument xmlDocument = new XmlDocument();
            XmlNode nodeToFind;
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string configpath = dllLocation + "\\" + "config.xml";
            xmlDocument.Load(configpath);
            nodeToFind = xmlDocument.SelectSingleNode("//DatabaseSetup");
            if (nodeToFind != null && nodeToFind["EDIMAPPINGSDBNAME"] != null)
            {
                AriaConnection.MappingDbName = nodeToFind["EDIMAPPINGSDBNAME"].InnerText;
            }
            else
            {
                HasError = true;
                ErrorMsg = "config XML file node DatabaseSetup or EDIMAPPINGSDBNAME not found , then cannot get the database name";
                _continue = false;
            }

        }
        //ISA
        public void WriteInterchangeHeader(string OutputFilePath, string cpartCode, string MapVersion, string TransactionType, string MINV_ISA)
        {
            StreamWriter TempstreamWriter;
            if (File.Exists(OutputFilePath))
            {
                if (string.IsNullOrEmpty(this.fieldSperator) || string.IsNullOrEmpty(this.lineSperator))
                {
                    this.CPartCode = cpartCode;
                    this.MapVersion = MapVersion;
                    this.TransactionType = TransactionType;
                    this.getPartnerInfo();
                }
                TempstreamWriter = new StreamWriter(OutputFilePath, append: true);
                string[] XField = new string[16];
                XField[0] = "00";
                XField[1] = new string(' ', 10);
                XField[2] = string.IsNullOrEmpty(this._tempEdiPh.ledipaswrd.ToString().Trim()) ? "01" : "00";//
                XField[3] = this._tempEdiPh.cedipaswrd.ToString(); //
                XField[4] = this.ediAccPrt_row.ccmpisaql.ToString();
                XField[5] = this.ediAccPrt_row.ccmpisaid.ToString();
                XField[6] = this._tempEdiPd.cpartqual.ToString();
                XField[7] = this._tempEdiPd.cpartid.ToString();
                //XField[7] = string.IsNullOrEmpty(this._tempEdiPd.cpartgsid.ToString()) ? this._tempEdiPd.cpartid.ToString().Trim() : this._tempEdiPd.cpartgsid.ToString().Trim();
                XField[8] = DateTime.Today.ToString("yyMMdd").Trim();
                XField[9] = DateTime.Now.ToString("HHmm").Trim();
                XField[10] = string.IsNullOrEmpty(this._tempEdiPh.cisacnstid.ToString()) ? "U" : this._tempEdiPh.cisacnstid.ToString().Trim();
                XField[11] = string.IsNullOrEmpty(this._tempEdiPd.cintchgver.ToString()) ? this._tempEdiPh.cintchgver.ToString().Trim() : this._tempEdiPd.cintchgver.ToString().Trim();
                XField[12] = MINV_ISA.ToString().PadLeft(9, '0').Trim();
                XField[13] = "0";
                XField[14] = this._tempEdiPd.ctranactv.ToString().Trim();
                XField[15] = string.IsNullOrEmpty(this._tempEdiPh.csubelesep.ToString()) ? ">" : this._tempEdiPh.csubelesep.ToString().Trim();
                this.WriteSegment(TempstreamWriter, "ISA", "01", XField);
                TempstreamWriter.Close();

            }
            else
            {
                HasError = true;
                ErrorMsg = "Outgoing file is not exist.";
                _continue = false;
            }
        }
        //GS
        public void WriteFunctionalHeader(string OutputFilePath, string cpartCode, string MapVersion, string TransactionType, string lcTranId, string MINV_GS)
        {
            StreamWriter TempstreamWriter;
            if (File.Exists(OutputFilePath))
            {
                if (string.IsNullOrEmpty(this.fieldSperator) || string.IsNullOrEmpty(this.lineSperator))
                {
                    this.CPartCode = cpartCode;
                    this.MapVersion = MapVersion;
                    this.TransactionType = TransactionType;
                    this.getPartnerInfo();
                }
                TempstreamWriter = new StreamWriter(OutputFilePath, append: true);
                string[] XField = new string[8];
                XField[0] = lcTranId;
                //XField[1] = string.IsNullOrEmpty(this._tempEdiPh.cisacnstid.ToString()) ? this.ediAccPrt_row.ccmpisaid.ToString().Trim() : this.ediAccPrt_row.ccmpgsid.ToString().Trim();
                XField[1] = string.IsNullOrEmpty(this.ediAccPrt_row.ccmpisaid.ToString().Trim()) ? this.ediAccPrt_row.ccmpgsid.ToString().Trim() : this.ediAccPrt_row.ccmpisaid.ToString().Trim();
                XField[2] = string.IsNullOrEmpty(this._tempEdiPd.cpartgsid.ToString()) ? this._tempEdiPd.cpartid.ToString().Trim() : this._tempEdiPd.cpartgsid.ToString().Trim();
                XField[3] = this._tempEdiPd.cversion.ToString().Substring(0, 5);
                XField[4] = DateTime.Now.ToString("yyMMdd");
                XField[5] = MINV_GS.ToString().Trim();
                XField[6] = "X";
                XField[7] = this._tempEdiPd.cversion.ToString().Trim();
                this.WriteSegment(TempstreamWriter, "GS", "01", XField);
                TempstreamWriter.Close();
            }

            else
            {
                HasError = true;
                ErrorMsg = "Outgoing file is not exist.";
                _continue = false;
                //return null;
            }
        }
        //GE
        public void WriteFunctionalTrailer(string OutputFilePath, string MTRNNO, string MINV_GS)
        {
            StreamWriter TempstreamWriter;
            if (File.Exists(OutputFilePath))
            {
                TempstreamWriter = new StreamWriter(OutputFilePath, append: true);
                string[] XField = new string[2];
                XField[0] = MTRNNO.ToString().Trim();
                XField[1] = MINV_GS.ToString().PadLeft(9, ' ').Trim();
                this.WriteSegment(TempstreamWriter, "GE", "09", XField);
                TempstreamWriter.Close();
            }
            else
            {
                HasError = true;
                ErrorMsg = "Outgoing file is not exist.";
                _continue = false;
                //return null;
            }
        }
        //IEA
        public void WriteInterchangeTrailer(string OutputFilePath, string MGRPNO, string MINV_ISA)
        {
            StreamWriter TempstreamWriter;
            if (File.Exists(OutputFilePath))
            {
                TempstreamWriter = new StreamWriter(OutputFilePath, append: true);
                string[] XField = new string[2];
                XField[0] = MGRPNO.ToString().Trim();
                XField[1] = MINV_ISA.ToString().PadLeft(9, '0');
                this.WriteSegment(TempstreamWriter, "IEA", "09", XField);
                TempstreamWriter.Close();
            }
            else
            {
                HasError = true;
                ErrorMsg = "Outgoing file is not exist.";
                _continue = false;
                //return null;
            }
        }

        public void WriteSegment(StreamWriter streamWriter, string Seg_ID, string loop_id, string[] XField)
        {
            string segment_line = Seg_ID, line_write; //initialize segment line.
            bool write_segment = false; // fields flag.
            int line_sep_index, line_wrap;
            //Derby-Integration
            //string field_sep = _tempEdiPh.cfieldsep;
            //string line_seperator = _tempEdiPh.clinesep;
            //Should get network continues or not.*******************************
            //bool continues = false;
            int wrap_value = 0;
            int current_position = 0;
            //loop over fields array.
            foreach (string field_val in XField)
            {
                if (!string.IsNullOrEmpty(field_val))
                    write_segment = true;
                segment_line += this.fieldSperator + field_val; //append fields to segment line.
            }

            while ((segment_line.Last().ToString() == this.fieldSperator))
                segment_line = segment_line.Remove(segment_line.Length - 1);

            segment_line += this.lineSperator; //add line seperator.

            //if there's at least one field in segment, then segment should be written.
            if (write_segment)
            {
                //if file is continues.
                if (this.isContinuesNetwork)
                {
                    //if there's no wrapping for file.
                    if (wrap_value == 0)
                        streamWriter.Write(segment_line);
                    else //there's is wraping.
                    {    //loop until line is finished.
                        while (segment_line.Length > 0)
                        {
                            if (segment_line.Length + current_position >= wrap_value)
                            {
                                line_write = segment_line.Substring(0, wrap_value - current_position);
                                //write until reaching the wrap value.
                                streamWriter.WriteLine(line_write);
                                segment_line = segment_line.Substring(wrap_value);
                                current_position = 0;
                            }
                            else
                            {
                                streamWriter.Write(segment_line);
                                current_position += segment_line.Length;
                                segment_line = "";//update current position.
                            }

                        }
                    }
                }
                else
                {    //if there's no wrapping.
                    if (wrap_value == 0)
                        streamWriter.WriteLine(segment_line);
                    else
                    {    //loop until line ends.
                        while (segment_line.Length > 0)
                        {
                            line_sep_index = segment_line.IndexOf(this.lineSperator); //
                            line_wrap = Math.Min(line_sep_index, wrap_value); //
                            if (line_wrap == 0)
                            {
                                streamWriter.WriteLine(segment_line);//
                                segment_line = "";
                            }
                            else
                            {
                                line_write = line_sep_index >= wrap_value ? segment_line.Substring(0, line_wrap) : segment_line.Substring(0, (line_wrap += 1));//
                                streamWriter.WriteLine(line_write);//
                                segment_line = segment_line.Substring(line_wrap);
                            }
                        }
                    }

                }

            }
            else
            {
                //*****************Need to check if current segment is Mandatory***************
                //streamWriter.WriteLine("No Segment To Write");
            }
        }
        public string Parse_LFread(string fn_line, SqlLite sqllit)
        {
            fn_line = fn_line.ToLower();

            if (fn_line.Contains('\''))
                fn_line = fn_line.Replace("\'", "");

            fn_line = fn_line.Substring(fn_line.IndexOf('(') + 1);
            fn_line = fn_line.Remove(fn_line.Length - 1);

            string[] ParamArray = fn_line.Split(',');

            return LFread(ParamArray, sqllit);
        }
        public string LFread(string[] ParamArray,SqlLite sqllit)
        {
            //get the field from cValue field.
            int Field_No = Int32.Parse(ParamArray[0]);
            string keyvalue = ParamArray[1];
            string level = ParamArray[2];
            string trn_type = ParamArray[3];
            string Seg_ID = ParamArray[4];
            string[] keyvalue_array = keyvalue.Split('+');
            string whole_val = "";

            whole_val = ExecuteValue(keyvalue, sqllit);
            EDISV edisvRow = EDISV.Select(AriaConnection.DbfsConnection, " where cpartcode = '" + this.CPartCode +
                                        "' and  ceditrntyp = '" + trn_type + "' and level = '" + level +
                                          "' and segid ='" + Seg_ID + "' and ckey_value ='" + whole_val + "'").FirstOrDefault();

            if (edisvRow != null)
            {
                string seg_line = edisvRow.cvalue.ToString().Trim();
                int seg_ID_count = Seg_ID.Length;
                string Field_seperator = seg_line.Substring(seg_ID_count, 1);
                string[] fields = seg_line.Split(Field_seperator[0]);

                return fields[Field_No];
            }
            else
            {
                //ErrorMsg = "Value in LFread couldn't be found!";
                //_continue = false;
                return "";
            }
        }

        public void WriteLoop(DataSet ds, String loopNumber)
        {
            if (ds == null || ds.Tables == null || ds.Tables.Count == 0 || string.IsNullOrEmpty(loopNumber))
            {
                ErrorMsg = "Invalid Patamters given to the WriteLoop Function.";
                _continue = false;
                return;
            }
            String lcVersion_VICS = this.MapVersion.Substring(0, 6) + "VICS";
            this.error_sequence++;
            SqlLite sqllit = new SqlLite();
            Dictionary<string, string> RejectionDic = new Dictionary<string, string>();
            //Dictionary<string, string> RejectionDic = new Dictionary<string, string>();
            List<TRANSACTION_SEGMENTS_T> currentLoopSegments = new List<TRANSACTION_SEGMENTS_T>();
            if (this.Loops_SegmentsDic.ContainsKey(loopNumber))
            {
                currentLoopSegments = this.Loops_SegmentsDic[loopNumber];
            }
            else
            {
                currentLoopSegments.AddRange(_segmentsList.Where(_segment => _segment.LOOP_ID == loopNumber)); //get all loop segments from [TRANSACTION_SEGMENTS_T]
                this.Loops_SegmentsDic.Add(loopNumber, currentLoopSegments); //Save it in Loops Segments dictianary with key=current loop.
            }


            List<xmlMapClass> VariablesList = new List<xmlMapClass>();
            if (Loops_VariablesDic.ContainsKey(loopNumber))
            {
                VariablesList = Loops_VariablesDic[loopNumber];
            }
            else
            {
                VariablesList.AddRange(xmlMapList.Where(r => r.Loop.ToString() == loopNumber));// All Transaction Variables List for specific current loop.
                Loops_VariablesDic.Add(loopNumber, VariablesList);//Save it in Loops Segments dictianary with key=current loop.
            }

            string mainFields = "[TRANS_SET] , [MSEGNO]";
            string mainValues = "'" + TRANS_SET.ToString().PadLeft(9, '0') + "' , '" + totalSegmentsNo.ToString() + "'";
            string mainColumns = "TRANS_SET varchar(255) , MSEGNO varchar(255)";
            string fields = "";
            string values = "";
            string columns = "";
            string value = "";
            foreach (xmlMapClass CurrVar in VariablesList)
            {
                value = getVariableValue(ds, CurrVar.Variable.Trim());
                columns = columns == "" ? columns + CurrVar.Variable + " varchar(255)" : columns + " , " + CurrVar.Variable + " varchar(255)";
                fields = fields == "" ? fields + "[" + CurrVar.Variable + "]" : fields + " , " + "[" + CurrVar.Variable + "]";
                values = values == "" ? values + "'" + value + "'" : values + " , '" + value + "'";
            }
            //SqliteStatments
            List<string> CurrentLoopStatments = new List<string>();
            CurrentLoopStatments.Add(columns);
            CurrentLoopStatments.Add(fields);
            CurrentLoopStatments.Add(values);

            if (SqliteStatments.Contains(loopNumber))
            {

                //Finding which Loops need to be removed from the Sqlite loops Collection.
                int i = -1;
                int index = -1;
                string RemovedLoops = "";
                foreach (string key in SqliteStatments.Keys)
                {
                    i++;
                    if (key == loopNumber)
                        index = i;

                    if (index > -1 && i >= index)
                    {
                        RemovedLoops += key + ",";
                    }
                }
                //Remove the un-needed previous loops.
                string[] _loops = RemovedLoops.Split(new char[] { ',' },
                         StringSplitOptions.RemoveEmptyEntries);
                foreach (string removeLoop in _loops)
                    //SqliteStatments.Remove(removeLoop);
                    SqliteStatments.Remove(removeLoop);


                SqliteStatments.Add(loopNumber, CurrentLoopStatments);
            }
            else
            {
                SqliteStatments.Add(loopNumber, CurrentLoopStatments);
            }



            foreach (string key in SqliteStatments.Keys)
            {
                List<string> temp = SqliteStatments[key] as List<string>;

                mainColumns = mainColumns + (string.IsNullOrEmpty(temp[0]) ? "" : " , " + temp[0]);
                mainFields = mainFields + (string.IsNullOrEmpty(temp[1]) ? "" : " , " + temp[1]);
                mainValues = mainValues + (string.IsNullOrEmpty(temp[2]) ? "" : " , " + temp[2]);

                //mainColumns += " , " + temp[0];
                //mainFields += " , " + temp[1];
                //mainValues += " , " + temp[2];
            }

            // Insert the Variable ans its Value to SQL Lite to apply any Condition on it
            string insertstatment = "INSERT INTO TempRawFileTable (" + mainFields +") VALUES (" + mainValues + ")";
            string CreateStatment = "CREATE TABLE TempRawFileTable (" + mainColumns + ")";
            sqllit.SqliteExecuteCmd(CreateStatment);
            sqllit.SqliteExecuteCmd(insertstatment);

            // Loop again to get the Final Variables Values and write the Segments 
            foreach (TRANSACTION_SEGMENTS_T segment in currentLoopSegments)
            {

                string updateStatment = "UPDATE TempRawFileTable SET MSEGNO ='" + totalSegmentsNo + "'";
                sqllit.SqliteExecuteCmd(updateStatment);
                value = "";

                //AEG BGN
                string segid = segment.SEGMENT_ID.ToString().Trim();
                var sycseghd = _sycseghd.Where(seghd => (seghd.loop_id == loopNumber.PadRight(3, ' ') && (seghd.segid.Trim() == segid))).FirstOrDefault();
                String SegHdUsage = "O";
                SegHdUsage = sycseghd != null ? sycseghd.cusage.ToString().Trim().ToUpper() : SegHdUsage;
                String SegmentUsage = segment.USAGE.ToString().Trim().ToUpper();
                Boolean isSegmentMandatory = (SegmentUsage == "M");
                isSegmentMandatory = (string.IsNullOrEmpty(SegmentUsage) ? SegHdUsage == "M" : SegmentUsage == "M") || isSegmentMandatory;
                //AEG END

                List<TRANSACTION_MAP_T> SegmentFields = new List<TRANSACTION_MAP_T>();
                SegmentFields.AddRange(_segmentsMappingList.Where(r => r.TRANSACTION_SEGMENTS_KEY == segment.TRANSACTION_SEGMENTS_KEY));
                SegmentFields.OrderBy(r => r.FIELD_ORDER);
                int SegmentMaxFieldOrder = (int)SegmentFields.Max(r => r.FIELD_ORDER);
                string[] CurrSegFieldsArray = new string[SegmentMaxFieldOrder];
                for (int i = 1; i <= SegmentMaxFieldOrder; i++)
                {
                    CurrSegFieldsArray[i - 1] = "";
                    //AEG BGN
                    var sycsegdt = _sycsegdt.Where(sysegdt => (sysegdt.loop_id.Trim() == loopNumber) && (sysegdt.segid.Trim() == segid) && (sysegdt.cfld_name.Trim() == segid + i.ToString().PadLeft(2, '0'))).FirstOrDefault();
                    var sycvics = _sycvics.Where(vics => vics.cfld_name == (segid + i.ToString().PadLeft(2, '0')).PadRight(10, ' ')).ToList();
                    var sycvics_VICS = _sycvics_VICS.Where(vics => vics.cfld_name == (segid + i.ToString().PadLeft(2, '0')).PadRight(10, ' ')).ToList();
                    //AEG END

                    var segmentFieldRecords = SegmentFields.Where(r => r.FIELD_ORDER == i);
                    if (segmentFieldRecords != null)
                    {
                        TRANSACTION_MAP_T finalField = null;
                        foreach (TRANSACTION_MAP_T variablerec in segmentFieldRecords)
                        {
                            SYCEDIXP exceptionRecord = XpChecker(MapSet, MapVersion, segid, variablerec.FIELD_ORDER.ToString(), loopNumber, variablerec.TRANSACTION_MAP_KEY);
                            if (exceptionRecord != null)
                            {
                                variablerec.USAGE = exceptionRecord.cusage;
                                variablerec.VALUE = exceptionRecord.f_value;
                                variablerec.FIELD_NAME = exceptionRecord.f_name;
                                variablerec.FIELD_ORDER = (short)exceptionRecord.f_order;
                                variablerec.DATA_TYPE = exceptionRecord.DATA_TYPE;
                            }


                            if (variablerec.VALUE.Trim().StartsWith("LFREAD")) // Read from LFREAD.
                            {
                                value = Parse_LFread(variablerec.VALUE.Trim(), sqllit);
                                if (!_continue)
                                {
                                    return;
                                }
                            }
                            else // APPLY Qurery.
                            {
                                value = ExecuteValue(variablerec.VALUE.Trim(), sqllit);
                                if (!_continue)
                                {
                                    return;
                                }
                            }

                            if (value == null && variablerec.USAGE.Trim().ToUpper() == "C")
                            {
                                variablerec.USAGE = "O";
                            }
                            else if (value != null && variablerec.USAGE.Trim().ToUpper() == "C")
                            {
                                variablerec.USAGE = "M";
                            }

                            finalField = variablerec;
                            if (value != null)
                            {
                                //Derby-Data Casting[Start]
                                if (variablerec.DATA_TYPE.ToString().Trim().ToUpper().StartsWith("D"))
                                {
                                    CurrSegFieldsArray[(int)(variablerec.FIELD_ORDER) - 1] = Convert.ToDateTime(value).ToString("yyyyMMdd").Trim();
                                }
                                else if (variablerec.DATA_TYPE.ToString().Trim().ToUpper().StartsWith("N"))
                                {
                                    decimal dec = decimal.Zero;
                                    decimal.TryParse(Convert.ToString(value), out dec);
                                    CurrSegFieldsArray[(int)(variablerec.FIELD_ORDER) - 1] = dec.ToString().Trim();
                                }
                                else
                                {
                                    CurrSegFieldsArray[(int)(variablerec.FIELD_ORDER) - 1] = Convert.ToString(value).ToUpper().Trim();
                                }
                            }
                            //Derby-Data Casting[End]
                        }
                        /* start validationn
                                /* Case 1 :Field exist on MAP and its M and its eval is empty or zero if numeric [Reject] */
                            if ((((sycsegdt != null) && sycsegdt.cusage.ToString().Trim() == "M" && finalField.USAGE != "O") || finalField.USAGE == "M") &&
                             (string.IsNullOrEmpty(CurrSegFieldsArray[(int)(finalField.FIELD_ORDER) - 1].Trim()) || (finalField.DATA_TYPE.Trim() == "N" && int.Parse(CurrSegFieldsArray[(int)(finalField.FIELD_ORDER) - 1].Trim()) == 0)))
                            {
                                fillerrordata(loopNumber, finalField, sycsegdt, segid, CurrSegFieldsArray, lcVersion_VICS, segment, i);
                                RejectionFlag = true;
                            }
                            // Case 2: check if qualifer exists in sycvics
                            if (((sycvics != null && sycvics.Count != 0) && sycvics.Find(r => r.ccode_no.ToString().Trim() == value.Trim()) == null) &&
                                ((sycvics_VICS != null && sycvics_VICS.Count != 0) && sycvics.Find(r => r.ccode_no.ToString().Trim() == value.Trim()) == null))
                            {
                                ErrorLogReport ErrorLogdata = new ErrorLogReport();
                                ErrorLogdata.cPartCode = this.CPartCode;
                                ErrorLogdata.cEdiTrnTyp = this.TransactionType;
                                ErrorLogdata.Key = "";//Error
                                ErrorLogdata.SegId = segid.ToUpper();
                                ErrorLogdata.f_Order = (int)segment.SEGMENT_ORDER;
                                ErrorLogdata.cField = sycsegdt.cfld_name;
                                ErrorLogdata.cFldDesc = sycseghd.desc1.Trim() + " " + CurrSegFieldsArray[i - 1].ToUpper().Trim();
                                ErrorLogdata.cExpress = finalField.VALUE.ToUpper().Trim();
                                ErrorLogdata.cValue = CurrSegFieldsArray[i - 1].ToUpper().Trim();
                                ErrorLogdata.cError = "3";
                                ErrorLogdata.Comment = "Standard VICS Codes";
                                ErrorLogdata.cCondition = "";
                                ErrorLogdata.cUsage = finalField.USAGE.ToUpper().Trim();
                                ErrorLogdata.Loop_ID = loopNumber;
                                ErrorLogdata.cRecType = "T";
                                ErrorLogdata.nSegSequ = this.error_sequence;
                                WriteErrorLogReport(ErrorLogdata);
                                RejectionFlag = true;
                            }
                        }
                        else // Find it in segdt if mandatory or not  
                        {
                            /* Case 3 :Field exist on segdt and its M and not exist in MAP [Reject] */
                            if (sycsegdt != null && sycsegdt.cusage.ToString().Trim() == "M")
                            {
                                fillerrordata(loopNumber, null, sycsegdt, segid, CurrSegFieldsArray, lcVersion_VICS, segment, i);
                                RejectionFlag = true;
                            }
                        }
                    }
                    // Case 4 :validate if the segment is empty and seg id is mandatory [Reject]
                if (CurrSegFieldsArray.All(i => string.IsNullOrEmpty(i)) && isSegmentMandatory)
                {
                    ErrorLogReport ErrorLogdata = new ErrorLogReport();
                    ErrorLogdata.cPartCode = this.CPartCode;
                    ErrorLogdata.cEdiTrnTyp = this.TransactionType;
                    ErrorLogdata.Key = "";//Error
                    ErrorLogdata.SegId = segid.ToUpper();
                    ErrorLogdata.f_Order = (int)segment.SEGMENT_ORDER;
                    ErrorLogdata.cField = "";
                    ErrorLogdata.cFldDesc = sycseghd.desc1.Trim();
                    ErrorLogdata.cExpress = "";
                    ErrorLogdata.cValue = "";
                    ErrorLogdata.cError = "4";
                    ErrorLogdata.Comment = "";
                    ErrorLogdata.cCondition = "";
                    ErrorLogdata.cUsage = "M";
                    ErrorLogdata.Loop_ID = loopNumber;
                    ErrorLogdata.cRecType = "O";
                    ErrorLogdata.nSegSequ = this.error_sequence;
                    WriteErrorLogReport(ErrorLogdata);
                    RejectionFlag = true;
                }

                //thease indexes must give the correct index even if eow file is coninues
                if (segid.ToUpper() == "ST")
                {
                    rawFileTransactions[transactions, 1] = this.streamWriter.BaseStream.Length.ToString(); //index of ST;
                }
                if (!CurrSegFieldsArray.All(i => string.IsNullOrEmpty(i)) && !this.RejectionFlag)
                {
                    WriteSegment(this.streamWriter, segid, loopNumber, CurrSegFieldsArray);
                    this.streamWriter.Flush();
                    totalSegmentsNo++;
                }

                if (segid.ToUpper() == "SE")
                {
                    rawFileTransactions[transactions, 2] = this.streamWriter.BaseStream.Length.ToString(); //index of SE;
                }

            }
            sqllit.CloseSqliteConnection();
        }
        private SYCEDIXP XpChecker(string Mapset, string Cversion, string Segid, string Fieldno, string loop_id, int TRANSACTION_MAP_KEY)
        {
            return SYCEDIXP.Select(AriaConnection.ClientMasterConnection, " where cmapset='" + Mapset + "' And cversion='" + Cversion + "' And loop_id='" + loop_id + "' And segid='" + Segid + "' AND f_order='" + Fieldno + "' AND TRANSACTION_MAP_KEY='" + TRANSACTION_MAP_KEY + "' AND ceditrntyp='" + this.TransactionType + "'").FirstOrDefault();
        }
        public string getVariableValue(DataSet ds, string VariableName)
        {
            string value = "";
            bool isRowOriented = false;
            xmlMapClass mapObj = xmlMapList.Find(r => r.Variable.ToUpper().Trim() == VariableName.ToUpper().Trim());
            if (mapObj == null)
            {
                ErrorMsg = "Given Variable Name :" + VariableName + " is not found in Mapping XML";
                _continue = false;
                return null;
            }

            DataRow itemRecord = null;
            if (string.IsNullOrEmpty(mapObj.relatedtype) && string.IsNullOrEmpty(mapObj.relatedtypevalue)) //not row oriented
            {
                if (ds.Tables[mapObj.Table].Rows.Count > 0)
                    itemRecord = ds.Tables[mapObj.Table].Rows[0];
            }
            else // row Oriented 
            {
                isRowOriented = true;
                foreach (DataRow item in ds.Tables[mapObj.Table].Rows)
                {
                    if (item[mapObj.relatedtype].ToString().Trim().ToUpper() == mapObj.relatedtypevalue.ToString().Trim().ToUpper())
                    {
                        itemRecord = item;
                        break;
                    }
                }
            }

            if (itemRecord != null)
            {
                value = Convert.ToString(itemRecord[mapObj.Column]);
                return value;
            }
            else if (!isRowOriented)
            {
                ErrorMsg = "Data for given Variable Name :" + VariableName + " is not found in DataSet";
                _continue = false;
                return null;
            }
            else
            {
                return "";
            }

        }

        protected string ExecuteValue(string value, SqlLite sqllit)
        {
            value = value.ToUpper();
            string cmd = "SELECT ";
            if (!value.ToUpper().Contains("WHERE"))
            {
                cmd += value + " FROM [TempRawFileTable]";
            }
            else
            {
                string[] valueArray = value.Split(new string[] { "WHERE" }, StringSplitOptions.RemoveEmptyEntries);
                cmd += valueArray[0] + " FROM [TempRawFileTable] WHERE " + valueArray[1];
            }

            return sqllit.SqliteSelectCmd(cmd);
        }

        private void GetDictionary() 
        {
            String lcVersion_VICS = this.MapVersion.Substring(0, 6) + "VICS";
            _sycseghd = SYCSEGHD.Select(AriaConnection.EdiMappingConnection, " where ceditrntyp='" + this.TransactionType + "' And cversion='" + this.MapVersion + "'");
            _sycsegdt = SYCSEGDT.Select(AriaConnection.EdiMappingConnection, " where ceditrntyp='" + this.TransactionType + "'And cversion='" + this.MapVersion + "'");
            _sycvics = SYCVICS.Select(AriaConnection.EdiMappingConnection, " where ceditrntyp='" + this.TransactionType + "' And cpartcode='" + this.CPartCode + "' And cversion='" + lcVersion_VICS + "'");
            _sycvics_VICS = SYCVICS.Select(AriaConnection.EdiMappingConnection, " where ceditrntyp='" + this.TransactionType + "' And cpartcode='" + "VICS  " + "' And cversion='" + lcVersion_VICS + "'");
            _sycsegva = SYCSEGVA.Select(AriaConnection.EdiMappingConnection, " where ceditrntyp='" + this.TransactionType +  "'");

            if (_sycseghd == null || _sycsegdt == null || _sycsegva == null || (_sycvics == null && _sycvics_VICS == null)) _continue = false;
            
        
        }
        private void fillerrordata(string loopNumber, TRANSACTION_MAP_T finalField, SYCSEGDT sycsegdt, string segid, string[] CurrSegFieldsArray, string lcVersion_VICS, TRANSACTION_SEGMENTS_T segment, int i)
        {
            // need to get variables names and description from SYCSEGVA
            SYCSEGVA sycsegva = null;
            var sycsegva_list = _sycsegva.Where(segva => segva.loop_id.Trim() == loopNumber).ToList();
            
            if (sycsegva_list != null && sycsegva_list.Count != 0 && finalField != null)
            {
                foreach (SYCSEGVA lsycsegva in sycsegva_list)
                {
                    if (finalField.VALUE.ToUpper().Trim().Contains(lsycsegva.cvar_name.ToUpper().Trim()))
                    {
                        sycsegva = lsycsegva;
                        break;
                    }
                }

            }

            String lcComment = sycsegva != null ? sycsegva.comment.Trim() :
            this.TransactionType + " mapping set " + this.MapSet + " version " + this.MapVersion + " for account " + _tempEdiPh.cpartname;

            int lnRltsPos;
            string lcFldDesc = "";
            if (sycsegdt != null)
            {
                lcFldDesc = sycsegdt.desc1.Trim();
                if (!string.IsNullOrEmpty(sycsegdt.crltd_nam))
                {
                    Int32.TryParse(sycsegdt.crltd_nam.Replace(segid, "").Trim(), out lnRltsPos);
                    if (lnRltsPos != 0 && !string.IsNullOrEmpty(CurrSegFieldsArray[lnRltsPos - 1]))
                    {
                        var sycvics_VICSerror = _sycvics_VICS.Where(svics => (svics.cfld_name.Trim() == sycsegdt.crltd_nam.PadRight(10, ' ')) && (svics.ccode_no.Trim() == CurrSegFieldsArray[lnRltsPos - 1].Trim())).FirstOrDefault();
                        if (sycvics_VICSerror != null)
                        {
                            lcFldDesc = sycvics_VICSerror.desc1.Trim();
                        }
                    }
                }
            }
            ErrorLogReport ErrorLogdata = new ErrorLogReport();
            ErrorLogdata.cPartCode = this.CPartCode;
            ErrorLogdata.cEdiTrnTyp = this.TransactionType;
            ErrorLogdata.Key = "";//Error
            ErrorLogdata.SegId = segid.ToUpper();
            ErrorLogdata.f_Order = sycsegdt != null ? (int)segment.SEGMENT_ORDER : 0;
            ErrorLogdata.cField = sycsegdt != null ? sycsegdt.cfld_name : segid;
            ErrorLogdata.cFldDesc = lcFldDesc;
            ErrorLogdata.cExpress = finalField != null ? finalField.VALUE.ToUpper().Trim() : "";
            ErrorLogdata.cValue = CurrSegFieldsArray[i - 1].Trim();
            ErrorLogdata.cError = sycsegdt != null ? sycsegdt.cdata_typ.Trim() == "C" ? "1" : "2" : "1";
            ErrorLogdata.Comment = lcComment;
            ErrorLogdata.cCondition = finalField != null ? finalField.CONDITION.Trim() : "";
            ErrorLogdata.cUsage = sycsegdt != null ? sycsegdt.cusage.ToString().Trim().ToUpper() == "M" ? "M" : finalField != null ? finalField.USAGE.Trim().ToUpper() : "M" : "M";
            ErrorLogdata.Loop_ID = loopNumber;
            ErrorLogdata.cRecType = "T";
            ErrorLogdata.nSegSequ = this.error_sequence;
            WriteErrorLogReport(ErrorLogdata);
        }
        private void WriteErrorLogReport(ErrorLogReport ErrorLogdata)
        {

            //need to move it to another place
            string MyInsert = "insert into " + Path.GetFileNameWithoutExtension(this.ErrorLogTable) + " (cPartCode,cEdiTrnTyp, Key, SegId,f_Order,cField  ,cFldDesc,cExpress,";
            MyInsert += "cValue, cError ,Comment ,cCondition ,cUsage ,Loop_ID ,cRecType ,nSegSequ)";
            MyInsert += "values (?,?, ?, ?, ?, ?,?,?,?,?,?,?,?,?,?,? )";
            try
            {
                this.ErrorLogConection.Open();
                OleDbCommand cmd = new OleDbCommand(MyInsert, this.ErrorLogConection);
                cmd.Parameters.AddWithValue("parmSlot1", ErrorLogdata.cPartCode);
                cmd.Parameters.AddWithValue("parmSlot2", ErrorLogdata.cEdiTrnTyp);
                cmd.Parameters.AddWithValue("parmSlot3", ErrorLogdata.Key);
                cmd.Parameters.AddWithValue("parmSlot4", ErrorLogdata.SegId);
                cmd.Parameters.AddWithValue("parmSlot5", ErrorLogdata.f_Order);
                cmd.Parameters.AddWithValue("parmSlot6", ErrorLogdata.cField);
                cmd.Parameters.AddWithValue("parmSlot7", ErrorLogdata.cFldDesc);
                cmd.Parameters.AddWithValue("parmSlot8", ErrorLogdata.cExpress);
                cmd.Parameters.AddWithValue("parmSlot9", ErrorLogdata.cValue);
                cmd.Parameters.AddWithValue("parmSlot10", ErrorLogdata.cError);
                cmd.Parameters.AddWithValue("parmSlot11", ErrorLogdata.Comment);
                cmd.Parameters.AddWithValue("parmSlot12", ErrorLogdata.cCondition);
                cmd.Parameters.AddWithValue("parmSlot13", ErrorLogdata.cUsage);
                cmd.Parameters.AddWithValue("parmSlot14", ErrorLogdata.Loop_ID);
                cmd.Parameters.AddWithValue("parmSlot15", ErrorLogdata.cRecType);
                cmd.Parameters.AddWithValue("parmSlot16", ErrorLogdata.nSegSequ);
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                HasError = true;
                ErrorMsg = "could not write  in Error Log report.";
                _continue = false;
            }
            finally
            {
                this.ErrorLogConection.Close();
            }
        }
#endregion

        #region Sub-Classes
        class xmlMapClass
        {
            public string Variable, Table, Column, Loop, DataType, relatedtype, relatedtypevalue;
            public bool Temp;
            public List<condition> Condition = new List<condition>();
            public List<Fixed> fixd = new List<Fixed>();
            public struct Fixed
            {
                public string type, lhsSource, rhsSource, experssion;
            }

            public struct condition
            {
                public string type, lhsSource, rhsSource, experssion;
            }
        }
        public class xmlLoopsClass
        {
            public string ParentLoop, ID, Description, SegId, ParentTable, ParentTableColumn, ChildTable, ChildTableColumn, RelatedValue, ChildLoop;
            public int RelatedColumn;
            public bool Temp, Repeatble;
        }
        public class xmlTablesClass
        {
            public string ParentTable, ChildTable;
            public List<ParentColumns> ParentColumnsList = new List<ParentColumns>();
            public List<ChildColumns> ChildColumnsList = new List<ChildColumns>();
            public class ParentColumns
            {
                public List<Column> ColumnList = new List<Column>();
                public class Column
                {
                    public string Columndata;
                }
            }
            public class ChildColumns
            {
                public List<Column> ColumnList = new List<Column>();
                public class Column
                {
                    public string Columndata;
                }
            }
        }
        public class xmlTablesIDClass
        {
            public string Tablename, identifier;
        }

        public class delegates
        {
            public delegate void BeforeReadingRelations();
            public delegate void AfterReadingRelations();
        }
        public class ErrorLogReport
        {

            public string cPartCode, cEdiTrnTyp, Key, SegId, cField, cFldDesc, cExpress,
            cValue, cError, Comment, cCondition, cUsage, Loop_ID, cRecType;

            public int f_Order, nSegSequ;
        }
        #endregion
    }
}