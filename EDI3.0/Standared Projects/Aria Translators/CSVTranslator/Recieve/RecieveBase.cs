using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace CSVTranslator.Recieve
{
    public abstract class RecieveBase
    {
        #region Properities
        // Adding New Properities [20/06/2017] [MSH][Start]
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

        public string AriaOutXMlFile 
        { get; set; }

        // Adding New Properities [20/06/2017] [MSH][End]
        #endregion

        #region Private/Protected Varaibles
        // Adding New Private/Protected Varaibles [20/06/2017] [MSH][Start]
        protected Dictionary<string, List<object>> _variablesDictionary = new Dictionary<string, List<object>>();
        protected bool _continue;
        protected string _rawFileContents;
        //MSH
        protected string _TempRowFilePath;

        protected EDILIBHD _ediLibHD;
        protected List<EDILIBDT> _eDILIBDT_List;
        protected List<string> _ediLibDtPOS = new List<string>();
        protected FreeWayFileFormat _formatType;
        protected List<TRANSACTION_SEGMENTS_T> _segmentsList;
        protected List<TRANSACTION_MAP_T> _segmentsMappingList;
        // Adding New Private/Protected Varaibles [20/06/2017] [MSH][End]
        #endregion

        #region Methods
        // Adding New Methods [20/06/2017] [MSH][Start]

        public RecieveBase()
        {
            _continue = true;
            BatchMode = false;
            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
            HasError = false;
            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        }

        #region Abstract Methods
        //public abstract void DO(bool notused, string lcFileCode, string lcFilter);
        public abstract void DO(bool notused, string lcFileCode, string lcFilter, string trans_no);
        protected abstract void Documentation();
        protected abstract void ProcessPO(string poContent, string tempdb);
        protected abstract void Import(string tempdb);
        #endregion

        /// <summary>
        /// Helper method to check if the variables dictionary contains the passed key in the passed index
        /// </summary>
        /// <typeparam name="T">type of variable</typeparam>
        /// <param name="Key">Key of variable</param>
        /// <param name="index">index in the array of values</param>
        /// <returns>if the variable found or not</returns>
        protected bool VariableChechker<T>(string Key, int index)
        {
            if (_variablesDictionary.ContainsKey(Key) && _variablesDictionary[Key].Count > index && _variablesDictionary[Key][index] is T)
                return true;
            return false;
        }

       
        private void _Documentation() { }

        /// <summary>
        /// init methods to create and test all connections used in the project
        /// </summary>
        /// <param name="ClientID">Current clientID in Aria</param>
        /// <param name="ActiveCompany">Active Company selected in Aria</param>
        public void init(string ClientID, string ActiveCompany)
        {
            try
            {
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

        /// <summary>
        /// Fill Variables dictionary according to passes line and mapping
        /// </summary>
        /// <param name="line">line from current processed PO to extract variables from</param>
        /// <param name="_mappings">Mapping data for current Transaction</param>
        protected void mReadRecord(string line, IOrderedEnumerable<TRANSACTION_MAP_T> _mappings, bool isSegmentBase)
        {
            foreach (TRANSACTION_MAP_T mapItem in _mappings)
            {
                object _value = null;
                if (_formatType == FreeWayFileFormat.FIXED)
                {
                    if (line.Length < mapItem.START_POSITION + mapItem.FIELD_LENGTH)
                        continue;
                    _value = line.Substring(mapItem.START_POSITION.Value - 1, mapItem.FIELD_LENGTH.Value);

                }
                //MSH That's My Case CSV File. 
                //else if(_formatType == FreeWayFileFormat.CSV){}
                else
                {
                    // MSH
                    //_value = line.Split(',')[mapItem.FIELD_ORDER.Value];
                    _value = (mapItem.FIELD_ORDER.Value <= line.Split(',').Count()) ? line.Split(',')[isSegmentBase ? mapItem.FIELD_ORDER.Value : mapItem.FIELD_ORDER.Value - 1] : "";
                    //_value = (mapItem.FIELD_ORDER.Value <= line.Split(',').Count()) ? line.Split(',')[isSegmentBase ? mapItem.FIELD_ORDER.Value-1: mapItem.FIELD_ORDER.Value] : "";

                    // FODA [BEGIN]
                    if (_value.ToString().Contains("+"))
                    {
                        double f;
                        if (double.TryParse(_value.ToString(), out f))
                        {
                            _value = f;
                            _value = _value.ToString();
                        }
                    }

                    if (_formatType == FreeWayFileFormat.CSV)
                    {
                        string[] sp_char_arr = { "\t", "\r", "\n", "\f", "\v" };

                        foreach (string sp_char in sp_char_arr)
                        {
                            _value = _value.ToString().Replace(sp_char, "");
                        }

                        _value = _value.ToString().StartsWith("\"") ? _value.ToString().Remove(0, 1) : _value;
                        _value = _value.ToString().EndsWith("\"") ? _value.ToString().Remove(_value.ToString().Length - 1) : _value;

                    }
                    // FODA [END]
                    if (_formatType == FreeWayFileFormat.COMMA)
                    {
                        _value = _value.ToString().StartsWith("\"") ? _value.ToString().Remove(0, 1) : _value;
                        _value = _value.ToString().EndsWith("\"") ? _value.ToString().Remove(_value.ToString().Length - 1) : _value;
                    }
                }
                if (_value.ToString().HasValue())
                {
                    if (mapItem.DATA_TYPE.Trim() == "D")
                    {
                        //_value = DateTime.ParseExact(_value.ToString().Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture);
                        // MSH
                        // Dates In CSV Could Start With ' To Be Presented.
                        _value = (_value.ToString().StartsWith("'")) ? _value.ToString().Remove(0, 1) : _value;
                        DateTime tempdt;
                        string[] formats = { "dd/MM/yyyy", "dd/M/yyyy", "d/M/yyyy", "d/MM/yyyy", "MM/dd/yyyy", "MM/d/yyyy", "M/d/yyyy", "M/dd/yyyy" };
                        if (DateTime.TryParseExact(_value.ToString().Trim(), formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out tempdt))
                            _value = tempdt;
                        //else 
                        //  _value = null;
                    }
                    else if (mapItem.DATA_TYPE.Trim() == "N")
                    {
                        // FODA [BEGIN]
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
                        // FODA [END]
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
                        {
                            _variablesDictionary.Add(mapItem.FIELD_NAME, new List<object>());
                            _variablesDictionary[mapItem.FIELD_NAME].Add(_value);
                        }
                        else
                            _variablesDictionary[mapItem.FIELD_NAME][0] = _variablesDictionary[mapItem.FIELD_NAME][0].ToString() + "\r\n" + _value.ToString();
                    }
                }
                // MSH
                else if (mapItem.DATA_TYPE.Trim() == "G" || mapItem.DATA_TYPE.Trim() == "N")
                {
                    _value = 0;
                }

                if (mapItem.DATA_TYPE.Trim() != "O")
                {
                    if (!_variablesDictionary.ContainsKey(mapItem.FIELD_NAME))
                        _variablesDictionary.Add(mapItem.FIELD_NAME, new List<object>());
                    _variablesDictionary[mapItem.FIELD_NAME].Add(_value);
                }
            }
        }
        
        #region TempDatabase 
        protected string CreateTempDatabase()
        {

            string tempDB = Path.GetRandomFileName().Replace(".", "");
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            TransactionsCore.TransactionsCore core = new TransactionsCore.TransactionsCore();

            core.TempDataBaseCreator(TransactionType, tempDB, sb.DataSource, sb.UserID, sb.Password);
            if (core.Error)
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
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
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
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
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Couldn't find work path " + AriaOutXMlFile + " to save Ariaxml to it!";
                _continue = false;
                return;
            }

            AriaOutXMlFile += "AriaXMl" + Path.GetRandomFileName().Replace(".", "") + ".xml";
            //MSH
            SqlConnectionStringBuilder connectionBuilder = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            TransactionsCore.TransactionsCore transactionCore = new TransactionsCore.TransactionsCore();
            string where = "";
            //_extractionKey.ForEach(key => where += "'" + key + "',");
            //where = where.EndsWith(",") ? where.Remove(where.Length - 1) : where;
            //where = " AllTrim(PartnerID) (" + where + ")";
            //transactionCore.Extract(TransactionType, connectionBuilder.DataSource, connectionBuilder.InitialCatalog, connectionBuilder.UserID, connectionBuilder.Password, where, AriaOutXMlFile);
            transactionCore.Extract(TransactionType, connectionBuilder.DataSource, tempdb, connectionBuilder.UserID, connectionBuilder.Password, where, AriaOutXMlFile);
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
            //msh
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
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Couldn't get Edi Path from Sysfiles Path : " + AriaConnection.Aria27SysFilesPath + " !";
                _continue = false;
                return;
            }
            _ediFilePath += "EDI\\" + _ediLibHD.cfilepath.Trim() + _ediLibHD.cedifilnam.Trim();
            if (!File.Exists(_ediFilePath))
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Couldn't find Raw Edi file :" + _ediFilePath + " !";
                _continue = false;
                return;
            }
            // MSh
            _TempRowFilePath = _ediFilePath;
            _rawFileContents = File.ReadAllText(_ediFilePath);
            if (_rawFileContents.Length == 0)
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Raw Edi file " + _ediFilePath + " is empty !";
                _continue = false;
                return;
            }
        }


        /// <summary>
        /// Read the raw file pos and save them in array
        /// </summary>
        protected void ReadEDIRawPOS()
        {
            //MSH
            string[] tempFileRecords = _rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            foreach (EDILIBDT edilibDTRow in _eDILIBDT_List)
            {
                string[] trantext = edilibDTRow.mtrantext.Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries);
                int start = 0, length = 0;
                if (!int.TryParse(trantext[1], out start))
                {
                    ErrorMsg = "Couldn't convert EDIlibDt content to valid integer for the start postion ";
                    _continue = false;
                    return;
                }
                if (!int.TryParse(trantext[3], out length))
                {
                    ErrorMsg = "Couldn't convert EDIlibDt content to valid integer for the Length postion ";
                    _continue = false;
                    return;
                }
                // MSH
                //string[] tempFileRecords = _rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                string Concat_line = "";
                for (int i = start; i <= length; i++)
                    Concat_line += tempFileRecords[i] + "\r\n";
                _ediLibDtPOS.Add(Concat_line);
                //_ediLibDtPOS.Add(_rawFileContents.Substring(start, length));
            }
            BatchMode = _ediLibDtPOS.Count > 1;
        }

        #endregion
        // Adding New Methods [20/06/2017] [MSH][End]
        #endregion

    }
}
