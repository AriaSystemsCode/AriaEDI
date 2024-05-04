using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data;
using System.Data.Common;
using System.IO;
using System.Globalization;
//using X12Translator.Recieve;
using System.Xml;
using System.Data.SQLite;

namespace X12Translator
{
    public class RECEIVE
    {
        #region Classes
        public class xmlMapClass
        {
            //Derby -Adding the new RelatedType & relatedTypeeValue variables.
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
            //Derby -Adding the new RelatedType & relatedTypeeValue variables.
            //FODA [BEGIN] phase 2
            //public string ParentLoop, ID, Description, SegId, ParentTable, ParentTableColumn, ChildTable, ChildTableColumn;
            public string ParentLoop, ID, Description, SegId, ParentTable, ParentTableColumn, ChildTable, ChildTableColumn, RelatedValue;
            public int RelatedColumn;
            //FODA [END] phase 2
            public bool Temp, Repeatble;
            //FODA [BEGIN] phase 2
            /*public List<NestedChildLoop> NestedChildLoops = new List<NestedChildLoop>();
            public struct NestedChildLoop
            {
                public bool Repeatble;
                public string LoopId, SegId, NestedParentTable, NestedParentTableColumn, NestedChildTable, NestedChildTableColumn;
            }*/
            //FODA [END] phase 2
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
        #endregion

        #region Properties
        public string MACCOUNT
        {
            get;
            set;
        }
        //FODA[Start]
        public string mostParentSeg
        {
            get;
            set;
        }
        public string mostChildSeg
        {
            get;
            set;
        }
        public string cPartCode
        { get; set; }
        public string currloop
        {
            get;
            set;
        }
        public string oldloop
        {
            get;
            set;
        }
        public string CurrentSeg
        { get; set; }
        public Boolean IsLoopRepeatable
        { get; set; }
        public Boolean IsOldLoopRepeatable
        { get; set; }
        public string tempSqldb
        {
            get;
            set;
        }
        public SQLiteConnection Sqliteconnection
        {
            get;
            set;
        }
        //Derby
        public string TransactionType
        { get; set; }
        public bool HasError
        { get; set; }

        public string ErrorMsg
        { get; set; }

        public string MappingCode
        { get; set; }

        public string Version
        { get; set; }

        public bool BatchMode
        { get; set; }

        public string Location
        { get; set; }
        public string Sender_id { get; set; }
        public string lineSep { get; set; }

        public string AriaOutXMlFile
        { get; set; }
        #endregion

        #region Private/Protected Varaibles
        protected Dictionary<string, string> _variablesDictionary = new Dictionary<string, string>();
        protected bool _continue;
        protected string _rawFileContents;
        protected string _TempRowFilePath;

        protected EDILIBHD _ediLibHD;
        protected List<EDILIBDT> _eDILIBDT_List;
        protected List<string> _ediLibDtPOS = new List<string>();
        protected FreeWayFileFormat _formatType;
        protected List<TRANSACTION_SEGMENTS_T> _segmentsList;
        protected List<TRANSACTION_MAP_T> _segmentsMappingList;

        protected XmlDocument mapxml = new XmlDocument();
        protected List<xmlMapClass> xmlMapList = new List<xmlMapClass>();
        protected List<xmlLoopsClass> xmlLoopsList = new List<xmlLoopsClass>();
        //FODA [BEGIN]
        protected List<xmlTablesClass> xmlTableList = new List<xmlTablesClass>();
        protected List<xmlTablesIDClass> xmlTablesIDList = new List<xmlTablesIDClass>();
        //insertsqueryes should have list of all insert statments to execute it one time
        protected List<string> insertsqueryes = new List<string>();
        //tablelastrecord should have the last index for each table on Listofdata
        protected Dictionary<string, int> tablelastrecord = new Dictionary<string, int>();
        //Listofdata it most important list in collect method .
        // should have the tables name and columns name and list of all records more details in collect method
        protected Dictionary<string, Dictionary<string, List<string>>> Listofdata = new Dictionary<string, Dictionary<string, List<string>>>();
        //tablesrelations is list of array the index should be array. that array has four indexes [0] should have child table , 
        //[1] should have child column , [2] should have the parent table , [3] should have the parent column
        protected List<string[]> tablesrelations = new List<string[]>();
        #endregion

        #region Methods

        public RECEIVE()
        {
            _continue = true;
            BatchMode = false;
            HasError = false;
        }

        /// <summary>
        /// init methods to create and test all connections used in the project
        /// </summary>
        /// <param name="ClientID">Current clientID in Aria</param>
        /// <param name="ActiveCompany">Active Company selected in Aria</param>
        public void init(string ClientID, string ActiveCompany)
        {
            try
            {
                //FODA-Getting EDIMAPPINGS Database From Configuration File. [BEGIN]
                ReadConfigXml();
                //FODA-Getting EDIMAPPINGS Database From Configuration File. [END]
                if (!AriaConnection.init(ClientID, ActiveCompany))
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = AriaConnection.ErrorMsg;
                    _continue = false;
                    return;
                }
            }
            catch (Exception ex)
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
        }
        //FODA [END]
        /// <summary>
        ///  For documention related to fix# and functionalty of the program.
        /// </summary>
        protected void Documentation() { }
        /// <summary>
        /// Main method for receiveing 850 files 
        /// </summary>
        /// <param name="lcFileCode">FileCode saved in Edi tables</param>
        /// <param name="lcFilter">Filter for targeted POS in the selected file</param>
        /// <param name="notused">NOT Used paramter -- just for EDI compatibility like old EDI Code</param>
        public void DO(bool notused, string lcFileCode, string lcFilter, string TransactionNo)
        {
            try
            {
                _continue = true;

                //FODA [BEGIN]
                if (!TransactionNo.HasValue())
                {
                    HasError = true;
                    ErrorMsg = "Empty Transaction Number !";
                    _continue = false;
                    return;
                }
                TransactionType = TransactionNo;
                //FODA [END]
                if (!lcFileCode.HasValue())
                {
                    HasError = true;
                    ErrorMsg = "Empty FileCode !";
                    _continue = false;
                    return;
                }
                var ediLibHDList = EDILIBHD.Select(AriaConnection.DbfsConnection, "where cedifiltyp+cfilecode = 'R" + lcFileCode + "'");
                _ediLibHD = ediLibHDList != null && ediLibHDList.Count > 0 ? ediLibHDList[0] : null;
                if (_ediLibHD == null)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find data in EdiLibHD for FileCode " + lcFileCode + " !";
                    _continue = false;
                    return;
                }


                lcFilter = lcFilter.HasValue() ? " And " + lcFilter : "";

                _eDILIBDT_List = EDILIBDT.Select(AriaConnection.DbfsConnection, " where cfilecode = '" + lcFileCode + "'" + lcFilter);

                if (_eDILIBDT_List == null || _eDILIBDT_List.Count == 0)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find data in EdiLibDT for FileCode " + lcFileCode + " with Filter " + lcFilter + " !";
                    _continue = false;
                    return;
                }

                //Derby
                this.cPartCode = _eDILIBDT_List[0].cpartcode.Trim();
                //Derby

                var _tempEdiPd = EDIPD.Select(AriaConnection.DbfsConnection, "where cPartCode = '" + _eDILIBDT_List[0].cpartcode.Trim() + "' and ceditrntyp = '"+TransactionType+"'");
                if (_tempEdiPd == null || _tempEdiPd.Count == 0)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find data in map for CpartCode " + _eDILIBDT_List[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
                    _continue = false;
                    return;
                }

                this.MappingCode = _tempEdiPd[0].cmapset.Trim();
                this.Version = _tempEdiPd[0].cversion.Trim();
                this.Sender_id = _tempEdiPd[0].cpartid.Trim();
                List<EDIACPRT> _tempEdiAcPrt = EDIACPRT.Select(AriaConnection.DbfsConnection, "where cpartcode = '" + _tempEdiPd[0].cpartcode + "'");
                if (_tempEdiAcPrt == null || _tempEdiAcPrt.Count == 0)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find EDI Account for CpartCode " + _tempEdiPd[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
                    _continue = false;
                    return;
                }
                MACCOUNT = _tempEdiAcPrt[0].cpartner.Trim();
                
                
                ReadEdiFile();
                if (!_continue)
                    return;

                //_segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, " where direction='R' And map_Set='" + MappingCode + "' And transaction_Type='" + TransactionType + "' And version='" + Version + "'");
                _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.EdiMappingConnection, " where direction='R' And map_Set='" + MappingCode + "' And transaction_Type='" + TransactionType + "' And version='" + Version + "'");

                if (_segmentsList == null || _segmentsList.Count == 0)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find Segments for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
                    _continue = false;
                    return;
                }
                string segmentsKeys = "";
                _segmentsList.ForEach(segment => segmentsKeys = segmentsKeys + segment.TRANSACTION_SEGMENTS_KEY + ",");
                segmentsKeys = segmentsKeys.EndsWith(",") ? segmentsKeys.Remove(segmentsKeys.Length - 1) : segmentsKeys;
               // _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
                _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.EdiMappingConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
                if (_segmentsMappingList == null || _segmentsMappingList.Count == 0)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't find Segments Map  for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
                    _continue = false;
                    return;
                }
                ReadEDIRawPOS();
                this.tempSqldb = this.CreateTempDatabase();

                if (this.tempSqldb == null)
                {
                    HasError = true;
                    ErrorMsg = "Couldn't create temp Database !";
                    _continue = false;
                    return;
                }

                //Foda[Start]
                ReadLoops();
                ReadMapXml();
                //Foda[End]
                if (!_continue) return;

                foreach (string Pocontent in _ediLibDtPOS)
                {
                    Process(Pocontent, this.tempSqldb);
                    // FODA [BEGIN]
                    if (!_continue) break;
                    // FODA [END]
                }
                // FODA [BEGIN]
                if (_continue)
                // FODA [END]
                    CreateTemporaryFiles(this.tempSqldb);
                DeleteTempDatabase(this.tempSqldb);
            }
            catch (Exception ex)
            {
                HasError = true;
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                //Clear Temp Dbs 
                ClearTempFiles();
                DeleteTempDatabase(tempSqldb);
                return;
            }
        }
        /// <summary>
        /// Process single PO at a time
        /// </summary>
        /// <param name="poContent">PO Content to recieve</param>
        protected void Process(string poContent, string tempdb)
        {
            //Create SQLite DB and table Also get an object as a dataSet.
            CreateSqliteDB();
            _variablesDictionary.Clear();

            char FieldSeparator = poContent[2];
            this.currloop = "";
            var lines = poContent.Split(new string[] { this.lineSep }, StringSplitOptions.RemoveEmptyEntries);
            int counter = 0;
            foreach (string line in lines)
            {
                counter++;
                if (lines.Length == counter)
                {
                    this.oldloop = this.currloop;
                    this.IsOldLoopRepeatable = this.IsLoopRepeatable;
                    collect();
                    if (!_continue)
                        return;

                    break;
                }
                string [] fields  = line.Split(FieldSeparator);
                this.CurrentSeg = fields[0];
                bool isneedinsert = false;
                //FODA [BEGIN] phase 2
                //var checksegloop = xmlLoopsList.Where(loopnode => loopnode.SegId == this.CurrentSeg).FirstOrDefault();//If Segmet is Key Loop
                var checksegloop = xmlLoopsList.Where(loopnode => loopnode.SegId == this.CurrentSeg && 
                    (loopnode.RelatedValue.HasValue() && loopnode.RelatedColumn != 0 ? fields[loopnode.RelatedColumn] == loopnode.RelatedValue : true)).FirstOrDefault();//If Segmet is Key Loop
                //FODA [END] phase 2
                if (checksegloop != null)
                {
                    isneedinsert =this.CurrentSeg != mostParentSeg ? true : false;
                    this.oldloop = this.currloop;
                    this.currloop = checksegloop.ID;
                    this.IsOldLoopRepeatable = this.IsLoopRepeatable;
                    this.IsLoopRepeatable = checksegloop.Repeatble;

                    //FODA [BEGIN] phase 2
                    if (isneedinsert)
                    {
                        collect();
                        if (!_continue)
                            return;
                        _variablesDictionary.Clear();
                    }
                    //FODA [END] phase 2
                }
                    //FODA [BEGIN] phase 2
                    /*
                else
                {
                    checksegloop = xmlLoopsList.Where(loopnode => loopnode.ID == this.currloop).FirstOrDefault();
                    if (checksegloop==null)
                        continue;

                    var nestedsegloop = checksegloop.NestedChildLoops.Where(nestedloop => nestedloop.SegId == this.CurrentSeg);
                    if (nestedsegloop != null && nestedsegloop.Count() > 0)
                    {
                        isneedinsert = true;
                        this.oldloop = this.currloop;
                        this.currloop = nestedsegloop.FirstOrDefault().LoopId;

                        this.IsOldLoopRepeatable = this.IsLoopRepeatable;
                        this.IsLoopRepeatable = nestedsegloop.FirstOrDefault().Repeatble;
                    }
                }*/
                //FODA [END] phase 2
                var _segmentsKey = _segmentsList.Where(segment => segment.SEGMENT_ID == this.CurrentSeg && segment.LOOP_ID == this.currloop);

                if (_segmentsKey.Count() == 0)
                {
                    continue;
                }
                // FODA [BEGIN] phase 2
                var _mappings = _segmentsMappingList.Where(segmentMap => segmentMap.TRANSACTION_SEGMENTS_KEY == _segmentsKey.First().TRANSACTION_SEGMENTS_KEY).OrderBy(segmentMap => segmentMap.FIELD_ORDER);
                /*List<TRANSACTION_MAP_T> _mappings = null;
                string XPorder = "";

                foreach (TRANSACTION_MAP_T segmentMap in _segmentsMappingList.OrderBy(segment => segment.TRANSACTION_SEGMENTS_KEY).ThenBy(segment => segment.FIELD_ORDER))
                {
                    if (segmentMap.TRANSACTION_SEGMENTS_KEY == _segmentsKey.First().TRANSACTION_SEGMENTS_KEY)
                    {
                        if (XPorder == segmentMap.FIELD_ORDER.ToString())
                        {
                            continue;
                        }

                        var XpResult = XpChecker(this.MappingCode, this.Version, this.CurrentSeg, segmentMap.FIELD_ORDER.ToString(), this.currloop);
                        if (XpResult != null)
                        {
                            XPorder = segmentMap.FIELD_ORDER.ToString();
                            foreach (SYCEDIXP XPfield in XpResult)
                            {
                                TRANSACTION_MAP_T datamap = null;
                                datamap.TRANSACTION_SEGMENTS_KEY = segmentMap.TRANSACTION_SEGMENTS_KEY;
                                datamap.FIELD_ORDER = Convert.ToInt16(XPfield.f_order);
                                datamap.START_POSITION = segmentMap.START_POSITION;
                                datamap.FIELD_LENGTH = segmentMap.FIELD_LENGTH;
                                datamap.FIELD_NAME = XPfield.f_name;
                                datamap.CONDITION = XPfield.f_cond;
                                datamap.VALUE = XPfield.f_value;
                                //datamap.DATA_TYPE = XPfield.f_value; // add data_type on sycedixp review
                                datamap.USAGE = XPfield.cusage;
                                datamap.TRANSACTION_MAP_KEY = segmentMap.TRANSACTION_MAP_KEY;
                                _mappings.Add(datamap);
                            }
                        }
                        else
                        {
                            _mappings.Add(segmentMap);
                        }
                    }
                }*/

                // FODA [END] phase 2
                mReadRecord(line, _mappings, isneedinsert, FieldSeparator);
                if (!_continue)
                    return;
            }

            collectinsertstatments();
            ExecuteInsert();
            ClearTempFiles();
            if (!_continue)
            {
                return;
            }      
        }

        /// <summary>
        /// Fill Variables dictionary according to passes line and mapping
        /// </summary>
        /// <param name="line">line from current processed PO to extract variables from</param>
        /// <param name="_mappings">Mapping data for current Transaction</param>
        protected void mReadRecord(string line, IOrderedEnumerable<TRANSACTION_MAP_T> _mappings, bool IsUpdate, char FieldSperator)
        {
            //Derby SV BUG[Start]
            //Check SV
            //SvChecker(this.cPartCode, this.Version, this.TransactionType, this.currloop, this.CurrentSeg, line);
            //Derby SV BUG[END]
            //FODA [BEGIN] phase 2
            /*if (IsUpdate)
            {
                //Check if Current loop exist on datatable
                DeleteLoopFromtempDataTable();
                //Call The insert function to save the segment data on dataTable
                insertTempRawFileLine(line, FieldSperator);
                //Call collect Function to update the last loop.
                collect();
                if (!_continue)
                    return;
                _variablesDictionary.Clear();
            }
            else
            {*/
            //FODA [END] phase 2
                DeleteLoopFromtempDataTable();
                insertTempRawFileLine(line, FieldSperator);
                //} //FODA [BEGIN] phase 2

                //Derby SV BUG[Start]
                SvChecker(this.cPartCode, this.Version, this.TransactionType, this.currloop, this.CurrentSeg, line);
                //Derby SV BUG[End]

            foreach (TRANSACTION_MAP_T mapItem in _mappings)
            {

                //Check On Sycedixp there is a record with the same Mapset+Cversion+Segid+Fieldname.
                //if true work on this line, so we will replace current mapitem (CONDITION,VALUE).
                //var XpResult = XpChecker(this.MappingCode, this.Version, mapItem.TRANSACTION_MAP_KEY.ToString(), mapItem.FIELD_ORDER.ToString());
                //FODA [BEGIN] phase 2
                //var XpResult = XpChecker(this.MappingCode, this.Version, this.CurrentSeg, mapItem.FIELD_ORDER.ToString());
                var XpResult = XpChecker(this.MappingCode, this.Version, this.CurrentSeg, mapItem.FIELD_ORDER.ToString(),this.currloop,mapItem.TRANSACTION_MAP_KEY);
                
                if (XpResult != null)
                {
                    mapItem.USAGE = XpResult.cusage.Trim();
                    mapItem.DATA_TYPE = XpResult.DATA_TYPE.Trim();
                    mapItem.FIELD_NAME = XpResult.f_name.Trim();
                    mapItem.CONDITION = XpResult.f_cond.Trim();
                    mapItem.VALUE = XpResult.f_value.Trim();
                }
                //FODA [END] phase 2
                object _value = null;
                _value = (mapItem.FIELD_ORDER.Value < line.Split(FieldSperator).Count()) ? line.Split(FieldSperator)[mapItem.FIELD_ORDER.Value] : "";

                //-Check if this record has Value.
                if (!string.IsNullOrEmpty(mapItem.VALUE))
                {
                    if (mapItem.VALUE.ToString().ToUpper().Trim().StartsWith("LFGETOCCURRENCE("))
                    {
                        //Handle Helper Functions
                        string exp = mapItem.VALUE.ToString().ToUpper().Trim();
                        string tempExp = "";
                        string tempValue = "";
                        tempExp = exp.Replace("LFGETOCCURRENCE(", "");
                        tempExp = tempExp.Remove(tempExp.Length - 1);

                        string[] arrParam = tempExp.Split(new string[] { "," }, StringSplitOptions.None);

                        tempValue = ExecuteValue(arrParam[0]);
                        _value = X12Translator.Recieve.HelperClass.LFGetOccurrence(tempValue, arrParam[1], int.Parse(arrParam[2]));

                    }
                    else 
                    {
                        //-Execute Value.
                        _value = ExecuteValue(mapItem.VALUE);
                        if (string.IsNullOrEmpty(_value.ToString()))
                            continue;

                    }

                    //_value = ExecuteValue(mapItem.VALUE);
                    ////-Execute Value.
                    //if (string.IsNullOrEmpty(_value.ToString()))
                    //    continue;
                }

                //-Execute condition If True : Cast The Value to be as the dataType of Var Map datatype. 
                if (_value.ToString().HasValue())
                {

                    if (mapItem.DATA_TYPE.Trim() == "D")
                    {
                        //_value = DateTime.ParseExact(_value.ToString().Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture);
                        // Dates In CSV Could Start With ' To Be Presented.
                        _value = (_value.ToString().StartsWith("'")) ? _value.ToString().Remove(0, 1) : _value;
                        DateTime tempdt;
                        string[] formats = { "dd/MM/yyyy", "dd/M/yyyy", "d/M/yyyy", "d/MM/yyyy", "MM/dd/yyyy", "MM/d/yyyy", "M/d/yyyy", "M/dd/yyyy" };
                        if (DateTime.TryParseExact(_value.ToString().Trim(), formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out tempdt))
                            _value = tempdt;
                    }
                    else if (mapItem.DATA_TYPE.Trim() == "N")
                    {
                        int x; decimal y; float z;
                        if (_value.ToString().Contains("."))
                        {
                            if (float.TryParse(_value.ToString(), out z))
                                _value = z;
                            else
                                _value = 0;
                        }
                        else
                        {
                            if (int.TryParse(_value.ToString(), out x))
                                _value = x;
                            else if (decimal.TryParse(_value.ToString(), out y))
                                _value = y;
                            else
                                _value = 0;
                        }
                    }
                    else if (mapItem.DATA_TYPE.Trim() == "G")
                    {
                        long x;
                        if (long.TryParse(_value.ToString(), out x))
                            _value = x;
                    }
                    else if (mapItem.DATA_TYPE.Trim() == "O")
                    {
                        if (!_variablesDictionary.ContainsKey(mapItem.FIELD_NAME))
                            _variablesDictionary.Add(mapItem.FIELD_NAME, mapItem.VALUE);
                        else
                            _variablesDictionary[mapItem.FIELD_NAME] = _variablesDictionary[mapItem.FIELD_NAME].ToString() + "\r\n" + _value.ToString();
                    }
                }
                else if (mapItem.DATA_TYPE.Trim() == "G" || mapItem.DATA_TYPE.Trim() == "N")
                {
                    _value = 0;
                }

                if (mapItem.DATA_TYPE.Trim() != "O" && !string.IsNullOrEmpty(_value.ToString()))
                {
                    if (!_variablesDictionary.ContainsKey(mapItem.FIELD_NAME))
                        _variablesDictionary.Add(mapItem.FIELD_NAME, _value.ToString());
                    else
                        _variablesDictionary[mapItem.FIELD_NAME] = _value.ToString();
                }
            }
        }
        protected void insertTempRawFileLine(string line, char FieldSperator)
        {
            string stmt = "";
            string[] fieldarr = line.Split(FieldSperator).ToArray();
            string cols = "[Sender_Id],[SEGID],[Loop_id],[Loop_Seg],", values = "'" + this.Sender_id + "','" + fieldarr[0] + "','" + currloop + "','" + currloop + fieldarr[0] + "',";
            
            for (int i = 1; i < fieldarr.Length; i++)
            {

                cols += "[" + (i).ToString() + "]" + ",";
                values += "'" + fieldarr[i] + "'" + ",";

            }
            cols = cols.Remove(cols.LastIndexOf(","));
            values = values.Remove(values.LastIndexOf(","));

            stmt = "INSERT INTO [TempRawFileTable] ( " + cols + " ) " + " VALUES( " + values + ")";

            SqliteExecuteCmd(stmt);

        }
        //foda [BEGIN] phase 2
        //protected SYCEDIXP XpChecker(string Mapset, string Cversion, string Segid, string Fieldno)
        protected SYCEDIXP XpChecker(string Mapset, string Cversion, string Segid, string Fieldno, string loop_id, int TRANSACTION_MAP_KEY)
        
        {
            //Select from SYCEDIXP with the paramter data.
            //return SYCEDIXP.Select(AriaConnection.EdiMappingConnection, " where cmapset='" + MappingCode + "' And segid='" + currloop + "' And cversion='" + Version + "' AND f_order='" + Fieldno + "'").FirstOrDefault();
            return SYCEDIXP.Select(AriaConnection.ClientMasterConnection, " where cmapset='" + MappingCode + "' And cversion='" + Version + "' And loop_id='" + loop_id + "' And segid='" + Segid + "' AND f_order='" + Fieldno + "' AND TRANSACTION_MAP_KEY='" + TRANSACTION_MAP_KEY + "' AND ceditrntyp='" + this.TransactionType + "'").FirstOrDefault();
        }
        //foda [END] phase 2
        protected void SvChecker(string cpartcode, string Cversion, string tranno, string loopdesc, string Segid, string line)
        {
            var sycedisv = SYCEDISV.Select(AriaConnection.EdiMappingConnection, " where cpartcode='" + cpartcode + "' And ceditrntyp='" + tranno + "' And cversion='" + Cversion + "' And segid='" + Segid + "' And level='" + loopdesc + "'").FirstOrDefault();
            
            if (sycedisv != null && !string.IsNullOrEmpty(sycedisv.key_exp))
            {

                string keyVal = ExecuteValue(sycedisv.key_exp);
                if (!string.IsNullOrEmpty(keyVal))
                {

                    EDISV EDISVObj = new EDISV();
                    EDISVObj.cpartcode = cpartcode;
                    EDISVObj.cvalue = line;
                    EDISVObj.ceditrntyp = tranno;
                    EDISVObj.cversion = Cversion;
                    EDISVObj.ckey_val = keyVal;
                    EDISVObj.segid = Segid;
                    EDISVObj.level = loopdesc;
                    EDISVObj.ExecuteVFPnsert(AriaConnection.DbfsConnection);
                }

            }
        }
        protected string ExecuteValue(string value)
        {
            value = value.ToUpper();
            if (!value.ToUpper().Contains("WHERE"))
                return value;
            string cmd = "";
            string[] valueArray = value.Split(new string[] { "WHERE" }, StringSplitOptions.RemoveEmptyEntries);
            cmd = "SELECT Distinct " + valueArray[0] +
                               " FROM [TempRawFileTable] M1 ,[TempRawFileTable] M2," +
                               " [TempRawFileTable] M3 ,[TempRawFileTable] M4," +
                               " [TempRawFileTable] M5, [TempRawFileTable] M6," +
                               " [TempRawFileTable] M7 , [TempRawFileTable] M8," +
                               " [TempRawFileTable] M9 , [TempRawFileTable] M10" +
                               " WHERE " + valueArray[1];

            return SqliteSelectCmd(cmd);
            //if (!string.IsNullOrEmpty(result))
            //    return result;
            //else
            //{
            //    HasError = true;
            //    ErrorMsg = "Error While Evaluating Mapping Value !, " + "Value :" + value;
            //    _continue = false;
            //    return null;

            //}
        }
        public void CreateSqliteDB()
        {
            Sqliteconnection = new SQLiteConnection("Data Source=:memory:");
            Sqliteconnection.Open();
            CreateSqliteTable();
        }
        public void CreateSqliteTable()
        {
            SqliteExecuteCmd("CREATE TABLE IF NOT EXISTS [TempRawFileTable]([Sender_Id] [varchar](255) NULL,[SEGID] [varchar](255) NULL,[Loop_id] [varchar](255) NULL, [Loop_Seg] [varchar](255) NULL,	[1] [varchar](255) NULL,	[2] [varchar](255) NULL,[3] [varchar](255) NULL,	[4] [varchar](255) NULL,	[5] [varchar](255) NULL,	[6] [varchar](255) NULL,	[7] [varchar](255) NULL,	[8] [varchar](255) NULL,	[9] [varchar](255) NULL,	[10] [varchar](255) NULL,	[11] [varchar](255) NULL,	[12] [varchar](255) NULL,	[13] [varchar](255) NULL,	[14] [varchar](255) NULL,	[15] [varchar](255) NULL,	[16] [varchar](255) NULL,	[17] [varchar](255) NULL,	[18] [varchar](255) NULL,	[19] [varchar](255) NULL,	[20] [varchar](255) NULL,	[21] [varchar](255) NULL,	[22] [varchar](255) NULL,	[23] [varchar](255) NULL,	[24] [varchar](255) NULL,	[25] [varchar](255) NULL,	[26] [varchar](255) NULL,	[27] [varchar](255) NULL,	[28] [varchar](255) NULL,	[29] [varchar](255) NULL,	[30] [varchar](255) NULL); ");
        }
        public void DeleteLoopFromtempDataTable()
        {
            string cmd = "DELETE FROM [TempRawFileTable] WHERE [Loop_Seg] = '" + this.currloop + this.CurrentSeg + "'";
            SqliteExecuteCmd(cmd);
        }
        public void SqliteExecuteCmd(string cmd)
        {
            SQLiteCommand command = new SQLiteCommand(Sqliteconnection);
            try
            {
                command.CommandText = cmd;
                command.ExecuteNonQuery();

            }
            catch (Exception ex)
            {
                HasError = true;
                ErrorMsg = "Error While Executing Command to MappingTempDB Sqlite Database!, " + ex.InnerException.ToString();
                _continue = false;
                return;
            }


        }
        public string SqliteSelectCmd(string cmd)
        {
            try
            {
                string result = "";
                SQLiteCommand command = new SQLiteCommand(Sqliteconnection);
                command.CommandText = cmd;
                var sdr = command.ExecuteScalar();
                if (sdr != null)
                {
                    if (!string.IsNullOrEmpty(sdr.ToString()))
                        result = sdr.ToString();
                }
                return result;
            }
            catch (Exception ex)
            {
                HasError = true;
                ErrorMsg = "Error While Selecting From MappingTempDB Sqlite Database!, " + ex.InnerException.ToString() + "  Value :" + cmd;
                _continue = false;
                return null;
            }
        }
        public void ClearTempFiles()
        {
            if (Sqliteconnection.State == ConnectionState.Open)
                Sqliteconnection.Close();
        }
        //FODA [BEGIN]
        //collect method take a _variablesDictionary list have a key and value .the key is a variable name and the value is the value of tha variable name
        //the output of collect method should fill the dictionary called Listofdata
        //Listofdata is a dictionary of dictionaries the key is the tables name and the value is dictionary
        //the second dictionary key is columns names and the value is the value of each record
        public void collect()
        {
            bool inserted = false; // boolean check if there are a new record added on Listofdata or not
            List<string> neededtable = new List<string>(); // this list have the tables which i will use in each calling for collect() method

            for (int dicindex = 0; dicindex < _variablesDictionary.Count(); dicindex++) // this loop is loop for each variable on _variablesDictionary
            {
                string table, column, relatedcolumn, relatedvalue, variabledictionarykey;
                variabledictionarykey = _variablesDictionary.Keys.ElementAt(dicindex);
                //search in xml to get the node of this variable from XML
                var variablenode = xmlMapList.Where(mapnode => mapnode.Variable == variabledictionarykey && mapnode.Loop == this.oldloop).FirstOrDefault();
                if (variablenode == null)
                {
                    HasError = true;
                    ErrorMsg = "Variable : " + variabledictionarykey + " couldn't be found on XML!";
                    _continue = false;
                    return;
                }
                table = variablenode.Table;
                column = variablenode.Column;
                relatedcolumn = variablenode.relatedtype;
                relatedvalue = variablenode.relatedtypevalue;

                if (!(neededtable.Contains(table))) // add the table name in neededtable list if not exist
                {
                    neededtable.Add(table);
                }
                if (!(Listofdata.Keys.Contains(table)))// add table on key of Listofdata if not exist and add the primary key column readed from the Receive940 XML
                {
                    Listofdata.Add(table, new Dictionary<string, List<string>>());

                    var tableIDs = xmlTablesIDList.Where(tablename => tablename.Tablename == table).FirstOrDefault();
                    if (tableIDs == null)
                    {
                        HasError = true;
                        ErrorMsg = "table : " + table + " couldn't be found on Tables XML!";
                        _continue = false;
                        return;
                    }
                    Listofdata[table].Add(tableIDs.identifier, new List<string>());
                    tablelastrecord[table] = 0;
                }
                // add the new record of primary key column its value is GUID and make inserted boolean with true that mean there are a record added
                if (Listofdata[table][Listofdata[table].Keys.First()].ElementAtOrDefault(tablelastrecord[table]) == null)
                {
                    Listofdata[table][Listofdata[table].Keys.First()].Insert(tablelastrecord[table], Guid.NewGuid().ToString());
                    inserted = true;
                }
                // add column name in Listofdata of table if column is not exist
                if (!(Listofdata[table].Keys.Contains(column)))
                {
                    Listofdata[table].Add(column, new List<string>());
                }
                //check if variable have related column and related value or not
                if (!(string.IsNullOrEmpty(relatedcolumn)) && !(string.IsNullOrEmpty(relatedvalue)))
                {
                    // if have related column and related value add related column in Listofdata of table if column is not exist
                    if (!(Listofdata[table].Keys.Contains(relatedcolumn)))
                    {
                        Listofdata[table].Add(relatedcolumn, new List<string>());
                    }
                    //searchonrelatedvalues method if related value of the related column exists return the index of the record else return -1
                    int relatedcolumnindex = searchonrelatedvalues(table, relatedcolumn, relatedvalue);
                    if (relatedcolumnindex != -1 && !inserted)
                    {
                        //if searchonrelatedvalues method return the index that mean i don't need to add new record on Listofdata i should add in the same index record
                        //relatedcolumnindex = Listofdata[table][relatedcolumn].IndexOf(relatedvalue);  testttt
                        addemptydata(table, column, relatedcolumnindex);
                        Listofdata[table][column].Insert(relatedcolumnindex, (_variablesDictionary[variabledictionarykey]));
                    }
                    else
                    {
                        //if searchonrelatedvalues method return -1 that mean i need to add new record on Listofdata with new related column and related value
                        if (Listofdata[table][relatedcolumn].Count > 0 && !inserted)
                        {
                            tablelastrecord[table]++;
                            Listofdata[table][Listofdata[table].Keys.First()].Insert(tablelastrecord[table], Guid.NewGuid().ToString());
                        }
                        addemptydata(table, relatedcolumn, tablelastrecord[table]);
                        Listofdata[table][relatedcolumn].Insert(tablelastrecord[table], relatedvalue);

                        addemptydata(table, column, tablelastrecord[table]);
                        Listofdata[table][column].Insert(tablelastrecord[table], (_variablesDictionary[variabledictionarykey]));

                        setforeignkeys(table, tablelastrecord[table]);
                    }
                }
                else
                {
                    addemptydata(table, column, tablelastrecord[table]);
                    Listofdata[table][column].Insert(tablelastrecord[table], (_variablesDictionary[variabledictionarykey]));
                    setforeignkeys(table, tablelastrecord[table]);
                }
                inserted = false;
            }
            //loop on all tables of tablelastrecord and check if this is a repeatable loop add new record for repeatable table
            foreach (string table in tablelastrecord.Keys.ToList())
            {
                if (neededtable.Contains(table) && this.IsOldLoopRepeatable)
                {
                    tablelastrecord[table] = currrecord(table);
                }
            }
        }
        private int searchonrelatedvalues(string tablename, string relatedcolumn, string relatedvalue)
        {
            int currindex = -1;
            // get the relation of each table that this table has foregin keys with which table and which column
            var filtertablerelation = tablesrelations.Where(childtable => childtable[0] == tablename);
            if (filtertablerelation != null)
            {
                //loop on number of records of listofdata for the tablename and relatedcolumn descending
                for (int valuescount = Listofdata[tablename][relatedcolumn].Count - 1; valuescount >= 0; valuescount--)
                {
                    //check if current index of the table tablename and column relatedcolumn equal the value of relatedvalue
                    if (Listofdata[tablename][relatedcolumn].ElementAtOrDefault(valuescount) == relatedvalue)
                    {
                        //loop on each relation 
                        //for ex : table has two foregin keys each foreign key from specific table then filtertablerelation has two records for each table
                        // each record has foregin key column of tablename and primary key column of the relation table
                        foreach (string[] tablerelationarray in filtertablerelation)
                        {
                            // check if the foregin key of tablename equal to the primary key of last record of the relation table then return get the index in currindex
                            if (Listofdata[tablename][tablerelationarray[1]].ElementAtOrDefault(valuescount) == Listofdata[tablerelationarray[2]][tablerelationarray[3]][Listofdata[tablerelationarray[2]][tablerelationarray[3]].Count - 1])
                            {
                                currindex = valuescount;
                            }
                            else
                            {
                                currindex = -1;
                                break;
                            }
                        }
                        if (currindex != -1)
                        {
                            break;
                        }
                    }
                }
            }
            return currindex;
        }
        // this method collectinsertstatments should collect the insert statments from Listofdata and add it to insertsqueryes list
        public void collectinsertstatments()
        {
            // loop on each table on Listofdata
            foreach (string tablename in Listofdata.Keys)
            {
                // loop on the number of maximum records on each table
                for (int valueindex = 0; valueindex < tablelastrecord[tablename] + 1; valueindex++)
                {
                    string fields = "";
                    string values = "";
                    // loop on each column of the current table
                    foreach (string column in Listofdata[tablename].Keys)
                    {
                        // check if the current index exist on current column if true collect the insert statment
                        if (Listofdata[tablename][column].ElementAtOrDefault(valueindex) != null)
                        {
                            fields = fields == "" ? fields + column : fields + " , " + column;
                            values = values == "" ? values + "'" + Listofdata[tablename][column][valueindex] + "'" : values + " , '" + Listofdata[tablename][column][valueindex] + "'";
                        }
                    }
                    // add the insert statment to insertsqueryes if exist
                    if (fields != "" || values != "")
                    {
                        string insertstatment = "insert into " + tablename + " (" + fields + ") values (" + values + ")";
                        insertsqueryes.Add(insertstatment);
                    }
                }
            }
        }
        // this method should return the maximum number of records for tablename
        //loop on each column and get the maximum number of indexes and return it
        private int currrecord(string tablename)
        {
            int greatestnum = 0;
            foreach (string column in Listofdata[tablename].Keys)
            {
                greatestnum = Listofdata[tablename][column].Count() > greatestnum ? Listofdata[tablename][column].Count() : greatestnum;
            }
            return greatestnum;
        }
        // loop descending on the recods of Listofdata and add empty value of null indexes (handle bugs)
        private void addemptydata(string tablename, string column, int lastrecord)
        {
            List<int> nullindexes = new List<int>();
            for (int columnsindex = lastrecord - 1; columnsindex >= 0; columnsindex--)
            {
                if (Listofdata[tablename][column].ElementAtOrDefault(columnsindex) == null)
                {
                    nullindexes.Add(columnsindex);
                }
                else
                {
                    break;
                }
            }
            for (int emptyindex = (nullindexes.Count) - 1; emptyindex >= 0; emptyindex--)
            {
                Listofdata[tablename][column].Insert(nullindexes[emptyindex], "");
            }
        }
        //this method setforeignkeys should add the foregin key for the last record of tablename
        private void setforeignkeys(string tablename, int lastrecord)
        {
            // get the Relation nodes from XML that the child table is tablename
            var relations = xmlTableList.Where(Relationnode => Relationnode.ChildTable == tablename);
            if (relations != null)
            {
                // loop in each Relation node
                foreach (xmlTablesClass relationnode in relations)
                {
                    string parenttable = relationnode.ParentTable;  // get the parent table from ParentTable node
                    string childtable = relationnode.ChildTable; // get the Child table from ChildTable node
                    List<string> parentcolumns = new List<string>();
                    List<string> childcolumns = new List<string>();
                    //loop for each column in ParentTable node and add it to list parentcolumns
                    foreach (xmlTablesClass.ParentColumns Parentcol in relationnode.ParentColumnsList)
                    {
                        foreach (xmlTablesClass.ParentColumns.Column column in Parentcol.ColumnList)
                        {
                            parentcolumns.Add(column.Columndata);
                        }
                    }
                    //loop for each column in ChildTable node and add it to list childcolumns
                    foreach (xmlTablesClass.ChildColumns Childcol in relationnode.ChildColumnsList)
                    {
                        foreach (xmlTablesClass.ChildColumns.Column column in Childcol.ColumnList)
                        {
                            childcolumns.Add(column.Columndata);
                        }
                    }
                    //loop on number of parentcolumns and must be the number of childcolumns
                    for (int columnsindex = 0; columnsindex < parentcolumns.Count(); columnsindex++)
                    {
                        //check if the foreign key column doesn't exist on Listofdata of table childtable add it
                        if (!(Listofdata[childtable].Keys.Contains(childcolumns[columnsindex])))
                        {
                            Listofdata[childtable].Add(childcolumns[columnsindex], new List<string>());
                        }
                        //check if the index lastrecord of childcolumn of table childtable not exist add it on lastrecord index
                        if (Listofdata[childtable][childcolumns[columnsindex]].ElementAtOrDefault(lastrecord) == null)
                        {
                            //add on lastrecord index the value of the last record of the parent column of the parent table
                            Listofdata[childtable][childcolumns[columnsindex]].Insert(lastrecord, Listofdata[parenttable][parentcolumns[columnsindex]][Listofdata[parenttable][parentcolumns[columnsindex]].Count() - 1]);

                            //add on tablesrelations list the relation of each table and each column if not exist
                            if (tablesrelations.Find(x => x[0] == childtable && x[(columnsindex * 2) + 1] == childcolumns[columnsindex] && x[2] == parenttable) == null)
                            {
                                //more detail ... the childcolumns of childtable is a foreign key for parentcolumns of parenttable
                                string[] tablerelation = new string[4];
                                tablerelation[0] = childtable;
                                tablerelation[1] = childcolumns[columnsindex];
                                tablerelation[2] = parenttable;
                                tablerelation[3] = parentcolumns[columnsindex];
                                tablesrelations.Add(tablerelation);
                            }
                        }
                    }
                }
            }
        }
        // ExecuteInsert method loop on insertsqueryes and execute insert of each index of insertsqueryes
        public void ExecuteInsert()
        {
            string currentinsert = "";
            //string connetionString = @"Data Source=EDISQL\EDISQL;Initial Catalog=TestEDI;User ID=sa;Password=aria_123;";
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            sb.InitialCatalog = this.tempSqldb;
            SqlConnection sqlConnection1 = new SqlConnection(sb.ConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                cmd.Connection = sqlConnection1;
                sqlConnection1.Open();
                cmd.CommandText = "Begin Transaction";
                cmd.ExecuteNonQuery();

                foreach (string insertquery in insertsqueryes)
                {
                    currentinsert = insertquery;
                    cmd.CommandText = insertquery;
                    cmd.ExecuteNonQuery();
                }
                cmd.CommandText = "Commit";
                cmd.ExecuteNonQuery();
                sqlConnection1.Close();
            }
            catch (Exception ex)
            {
                cmd.CommandText = "ROLLBACK";
                cmd.ExecuteNonQuery();
                sqlConnection1.Close();
                HasError = true;
                ErrorMsg = ex.Message+"~~" + ex.InnerException + "...Insert statments failed : " + currentinsert;
                _continue = false;
                return;
            }
            finally
            {
                Listofdata.Clear();
                insertsqueryes.Clear();
            }
        }
        public void ReadLoops()
        {
            XmlDocument mapxml = new XmlDocument();
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string LoopXmlPath = dllLocation + "\\" + TransactionType +"\\loops.xml";
            if (!File.Exists(LoopXmlPath))
            {
                HasError = true;
                ErrorMsg = "Loop XML File : " + LoopXmlPath + " couldn't be found!";
                _continue = false;
                return;
            }
            mapxml.Load(LoopXmlPath);
            //FODA [BEGIN]
            mostParentSeg = mapxml.SelectSingleNode("//MostParent").InnerText;
            mostChildSeg = mapxml.SelectSingleNode("//MostChild").InnerText;
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
                //FODA [BEGIN] phase 2
                Loop.RelatedValue = xmlLoopNode["RelatedValue"].InnerText;
                bool relatedvalueparse = int.TryParse(xmlLoopNode["RelatedColumn"].InnerText, out Loop.RelatedColumn);

                if (!relatedvalueparse && xmlLoopNode["RelatedColumn"].InnerText.HasValue())
                {
                    HasError = true;
                    ErrorMsg = "can't parse Related Value node in loops.xml !";
                    _continue = false;
                    return;
                }

                /*
                foreach (XmlNode xmlNestedLoopNode in xmlLoopNode.SelectNodes("NestedChildLoop"))
                {
                    xmlLoopsClass.NestedChildLoop NestedLoop = new xmlLoopsClass.NestedChildLoop();
                    NestedLoop.LoopId = xmlNestedLoopNode["LoopId"].InnerText;
                    NestedLoop.SegId = xmlNestedLoopNode["SegId"].InnerText;
                    NestedLoop.Repeatble = xmlNestedLoopNode["Repeatble"].InnerText.ToUpper() == "TRUE" ? true : false;
                    NestedLoop.NestedChildTable = xmlNestedLoopNode["NestedParentTable"].InnerText;
                    NestedLoop.NestedChildTableColumn = xmlNestedLoopNode["NestedParentTableColumn"].InnerText;
                    NestedLoop.NestedParentTable = xmlNestedLoopNode["NestedChildTable"].InnerText;
                    NestedLoop.NestedParentTableColumn = xmlNestedLoopNode["NestedChildTableColumn"].InnerText;

                    Loop.NestedChildLoops.Add(NestedLoop);
                }*/
                //FODA [END] phase 2
                xmlLoopsList.Add(Loop);
            }


        }
        private void ReadMapXml()
        {
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string xmlMappath = dllLocation + "\\" + TransactionType + "\\Receive.xml";
            if (!File.Exists(xmlMappath))
            {
                HasError = true;
                ErrorMsg = "Receive " + TransactionType + "  " + xmlMappath + " couldn't be found!";
                _continue = false;
                return;
            }
            mapxml.Load(xmlMappath);

            foreach (XmlNode xmlmapNode in mapxml.SelectNodes("//Map"))
            {
                xmlMapClass map = new xmlMapClass();
                map.Variable = xmlmapNode["Variable"].InnerText;
                map.Table = xmlmapNode["Table"].InnerText;
                map.Column = xmlmapNode["Column"].InnerText;
                map.Loop = xmlmapNode["Loop"].InnerText;
                map.Temp = xmlmapNode["Variable"].Attributes["Temp"] != null;
                //Derby - Read RelatedType & RelatedTypeValue from XML File.[Start]
                try
                {
                    map.relatedtypevalue = xmlmapNode["relatedtypevalue"].InnerText;
                    map.relatedtype = xmlmapNode["relatedtype"].InnerText;
                }
                catch (Exception)
                {
                }
                //Derby - Read RelatedType & RelatedTypeValue from XML File.[End]
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
                xmlMapList.Add(map);
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
            //FODA [BEGIN]
            foreach (XmlNode node in mapxml.SelectNodes("//Tables"+this.TransactionType))
            {
                foreach (XmlNode currTable in node.SelectNodes("//Table"+this.TransactionType))
                {
                    xmlTablesIDClass TableID = new xmlTablesIDClass();
                    TableID.Tablename = currTable["TableName"].InnerText;
                    TableID.identifier = currTable["Identifier"].InnerText;
                    xmlTablesIDList.Add(TableID);
                }
            }
            //FODA [END]
        }

        //FODA [BEGIN]
        private void ReadConfigXml()
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
        //FODA [END]
        /// <summary>
        /// Fill data objects with data in the Variables Dictionary
        /// </summary>
        #endregion

        #region TempDatabase
        protected string CreateTempDatabase()
        {

            string tempDB = Path.GetRandomFileName().Replace(".", "");
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            TransactionsCore.TransactionsCore core = new TransactionsCore.TransactionsCore();

            core.TempDataBaseCreator(TransactionType+"EDI", tempDB, sb.DataSource, sb.UserID, sb.Password);
            if (core.Error)
            {
                HasError = true;
                ErrorMsg = core.ErrorMsg;
                return null;
            }
            return tempDB;
        }
        protected void DeleteTempDatabase(string TempDb)
        {
            try
            {
                // foda [BEGIN]
                SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
                sb.InitialCatalog = TempDb;
                SqlConnection con = new SqlConnection(sb.ConnectionString);
                SqlCommand cmd = new SqlCommand("ALTER DATABASE [" + TempDb + "]SET OFFLINE WITH ROLLBACK IMMEDIATE", con);
                con.Open();
                cmd.ExecuteNonQuery();
                SqlCommand camd = new SqlCommand("drop database [" + TempDb + "]", con);
                camd.ExecuteNonQuery();
                con.Close();
                // foda [END]
            }
            catch (Exception Ex)
            {
                HasError = true;
                ErrorMsg = Ex.Message;
                _continue = false;
                return;
            }
        }
        #endregion

        #region XML File
        /// <summary>
        /// Create output Aria Xml file
        /// </summary>
        protected void CreateTemporaryFiles(string tempdb)
        {

            AriaOutXMlFile = GetEDIBasePath() + "Work\\";
            if (!Directory.Exists(AriaOutXMlFile))
            {
                HasError = true;
                ErrorMsg = "Couldn't find work path " + AriaOutXMlFile + " to save Ariaxml to it!";
                _continue = false;
                return;
            }

            AriaOutXMlFile += "AriaXMl" + Path.GetRandomFileName().Replace(".", "") + ".xml";
            SqlConnectionStringBuilder connectionBuilder = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            TransactionsCore.TransactionsCore transactionCore = new TransactionsCore.TransactionsCore();
            string where = "";
            //_extractionKey.ForEach(key => where += "'" + key + "',");
            //where = where.EndsWith(",") ? where.Remove(where.Length - 1) : where;
            //where = " AllTrim(PartnerID) (" + where + ")";
            //transactionCore.Extract(TransactionType, connectionBuilder.DataSource, connectionBuilder.InitialCatalog, connectionBuilder.UserID, connectionBuilder.Password, where, AriaOutXMlFile);
            transactionCore.Extract(TransactionType+"EDI", connectionBuilder.DataSource, tempdb, connectionBuilder.UserID, connectionBuilder.Password, where, AriaOutXMlFile);
        }
        #endregion

        #region Standard EDI
        /// <summary>
        /// Calculate the path of the EDI folder using the path of the Sysfile
        /// </summary>
        /// <returns>EDI application path</returns>
        protected string GetEDIBasePath()
        {
            string _ediPath = AriaConnection.Aria27SysFilesPath;
            _ediPath = _ediPath.EndsWith("\\") ? _ediPath : _ediPath + "\\";
            int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA4XP\\SYSFILES\\");
            if (_a27WordPostion > 0)
            {
                _ediPath = _ediPath.Remove(_a27WordPostion) + "Aria3Edi\\";
                return _ediPath;
            }
            return null;
        }

        /// <summary>
        /// Read the contents of the Rawfile in variable
        /// </summary>
        protected void ReadEdiFile()
        {
            string _ediFilePath = GetEDIBasePath();
            if (_ediFilePath == null)
            {
                HasError = true;
                ErrorMsg = "Couldn't get Edi Path from Sysfiles Path : " + AriaConnection.Aria27SysFilesPath + " !";
                _continue = false;
                return;
            }
            _ediFilePath += "EDI\\" + _ediLibHD.cfilepath.Trim() + _ediLibHD.cedifilnam.Trim();
            if (!File.Exists(_ediFilePath))
            {
                HasError = true;
                ErrorMsg = "Couldn't find Raw Edi file :" + _ediFilePath + " !";
                _continue = false;
                return;
            }
            _TempRowFilePath = _ediFilePath;
            _rawFileContents = File.ReadAllText(_ediFilePath);
            if (_rawFileContents.Length == 0)
            {
                HasError = true;
                ErrorMsg = "Raw Edi file " + _ediFilePath + " is empty !";
                _continue = false;
                return;
            }
        }


        /// <summary>
        /// Read the raw file pos and save them in array
        /// </summary>
        /// 
        //Biomy[Start]
        protected void ReadEDIRawPOS()
        {
            foreach (EDILIBDT edilibDTRow in _eDILIBDT_List)
            {
                string[] trantext = edilibDTRow.mtrantext.Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries);
                int start = 0, length = 0;
                if (!int.TryParse(trantext[1], out start))
                {
                    HasError = true;
                    ErrorMsg = "Couldn't convert EDIlibDt content to valid integer for the start postion ";
                    _continue = false;
                    return;
                }
                if (!int.TryParse(trantext[3], out length))
                {
                    HasError = true;
                    ErrorMsg = "Couldn't convert EDIlibDt content to valid integer for the Length postion ";
                    _continue = false;
                    return;
                }

                string Concat_line = "";
                Concat_line += _rawFileContents.Substring(start, length); //get each trx by start and end.
                Concat_line = Concat_line.Replace("\r", ""); //some files have different carriage return.

                //Gets line-sep 
                //string lineSep = Char.IsDigit(Concat_line, Concat_line.IndexOf("\n") - 1) ? "" : Concat_line.Substring(Concat_line.IndexOf("\n") - 1, 1);
                this.lineSep = Char.IsDigit(Concat_line, Concat_line.IndexOf("\n") - 1) ? "\n" : Concat_line.Substring(Concat_line.IndexOf("\n") - 1, 1) + "\n";
                //if (lineSep != null && lineSep.Length > 0)
                //    Concat_line = Concat_line.Replace(lineSep, "");

                //Concat_line = Concat_line.Replace("\n", "\r\n");
                _ediLibDtPOS.Add(Concat_line);
            }

            BatchMode = _ediLibDtPOS.Count > 1;
        }
        //Biomy[End]

        #endregion


    }
}