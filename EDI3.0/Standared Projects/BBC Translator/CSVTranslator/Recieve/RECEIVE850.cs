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

namespace CSVTranslator
{
    public class RECEIVE850
    {
        #region Properties

        public string ErrorMsg
        {
            get;
            set;
        }

        public string TransactionType
        {
            get
            {
                return "850";
            }
        }

        public string MappingCode
        {
            get
            {
                return "FRW";
            }
        }

        public string Version
        {
            get
            {
                return "2.806.0042";
            }
        }

        public bool BatchMode
        {
            get;
            set;
        }

        public string Location
        {
            get;
            set;
        }

        public string AriaOutXMlFile
        {
            get;
            set;
        }


        #endregion

        #region Private Variables

        Dictionary<string, List<object>> _variablesDictionary = new Dictionary<string, List<object>>();

        EDILIBHD _ediLibHD;
        List<EDILIBDT> _eDILIBDT_List;

        string _rawFileContents;

        bool _continue;

        FreeWayFileFormat _formatType;

        List<TRANSACTION_SEGMENTS_T> _segmentsList;

        List<TRANSACTION_MAP_T> _segmentsMappingList;

        List<string> _ediLibDtPOS = new List<string>();

        List<string> _freeWaySegments = new List<string>();

        List<PO_HEADER_T> _poHeaderList = new List<PO_HEADER_T>();
        List<PO_ADDRESS_T> _poAddressList = new List<PO_ADDRESS_T>();
        List<PO_ITEMS_T> _poItemsList = new List<PO_ITEMS_T>();
        List<string> _extractionKey = new List<string>();

        #endregion

        #region Methods

        public RECEIVE850()
        {
            _continue = true;
            BatchMode = false;
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
                if (!AriaConnection.init(ClientID, ActiveCompany))
                {
                    ErrorMsg = AriaConnection.ErrorMsg;
                    _continue = false;
                    return;
                }
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
        }

        /// <summary>
        ///  For documention related to fix# and functionalty of the program.
        /// </summary>
        private void Documentation() { }

        /// <summary>
        /// Main method for receiveing 850 files 
        /// </summary>
        /// <param name="lcFileCode">FileCode saved in Edi tables</param>
        /// <param name="lcFilter">Filter for targeted POS in the selected file</param>
        /// <param name="notused">NOT Used paramter -- just for EDI compatibility like old EDI Code</param>
        public void DO(bool notused, string lcFileCode, string lcFilter)
        {
            try
            {
                _continue = true;
                if (!lcFileCode.HasValue())
                {
                    ErrorMsg = "Empty FileCode !";
                    _continue = false;
                    return;
                }
                var ediLibHDList = EDILIBHD.Select(AriaConnection.DbfsConnection, "where cedifiltyp+cfilecode = 'R" + lcFileCode + "'");
                _ediLibHD = ediLibHDList != null && ediLibHDList.Count > 0 ? ediLibHDList[0] : null;
                if (_ediLibHD == null)
                {
                    ErrorMsg = "Couldn't find data in EdiLibHD for FileCode " + lcFileCode + " !";
                    _continue = false;
                    return;
                }

                ReadEdiFile();
                if (!_continue)
                    return;


                lcFilter = lcFilter.HasValue() ? " And " + lcFilter : "";
                _eDILIBDT_List = EDILIBDT.Select(AriaConnection.DbfsConnection, " where cfilecode = '" + lcFileCode + "'" + lcFilter);

                if (_eDILIBDT_List == null || _eDILIBDT_List.Count == 0)
                {
                    ErrorMsg = "Couldn't find data in EdiLibDT for FileCode " + lcFileCode + " with Filter " + lcFilter + " !";
                    _continue = false;
                    return;
                }

                if (_rawFileContents.StartsWith("COMMA"))
                    _formatType = FreeWayFileFormat.COMMA;
                else if (_rawFileContents.StartsWith("FIXED"))
                    _formatType = FreeWayFileFormat.FIXED;
                else if (_rawFileContents.StartsWith("CSV"))
                    _formatType = FreeWayFileFormat.CSV;
                else
                {
                    ErrorMsg = "Couldn't determine Freeway file type " + _rawFileContents.Substring(0, 5) + " !";
                    _continue = false;
                    return;
                }

                _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, " where direction='R' And map_Set='" + MappingCode + "' And transaction_Type='" + TransactionType + "' And version='" + Version + "'");

                if (_segmentsList == null || _segmentsList.Count == 0)
                {
                    ErrorMsg = "Couldn't find Segments for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
                    _continue = false;
                    return;
                }
                string segmentsKeys = "";
                _segmentsList.ForEach(segment => segmentsKeys = segmentsKeys + segment.TRANSACTION_SEGMENTS_KEY + ",");
                segmentsKeys = segmentsKeys.EndsWith(",") ? segmentsKeys.Remove(segmentsKeys.Length - 1) : segmentsKeys;
                _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
                if (_segmentsMappingList == null || _segmentsMappingList.Count == 0)
                {
                    ErrorMsg = "Couldn't find Segments Map  for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
                    _continue = false;
                    return;
                }
                FillWareHouse();
                ReadEDIRawPOS();
                if (!_continue) return;
                // FillFreeSegments();
                foreach (string Pocontent in _ediLibDtPOS)
                {
                    ProcessPO(Pocontent);
                    if (!_continue) return;
                }
                if (!_continue) return;
                CreateTemporaryFiles();
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
        }

        /// <summary>
        /// Process single PO at a time
        /// </summary>
        /// <param name="poContent">PO Content to recieve</param>
        private void ProcessPO(string poContent)
        {
            _variablesDictionary.Clear();
            foreach (string line in poContent.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries))
            {
                string _segment = line.Substring(0, 5).Trim();
                var _segmentsKey = _segmentsList.Where(segment => segment.SEGMENT_ID == _segment);
                if (_segmentsKey.Count() == 0)
                {
                    ErrorMsg = "Couldn't find Segment :" + _segment + " in Segments datatable!";
                    _continue = false;
                    return;
                }
                var _mappings = _segmentsMappingList.Where(segmentMap => segmentMap.TRANSACTION_SEGMENTS_KEY == _segmentsKey.First().TRANSACTION_SEGMENTS_KEY).OrderBy(segmentMap => segmentMap.FIELD_ORDER);
                mReadRecord(line, _mappings);
            }
            Import();
            UpdateTables();
        }

        /// <summary>
        /// Fill Variables dictionary according to passes line and mapping
        /// </summary>
        /// <param name="line">line from current processed PO to extract variables from</param>
        /// <param name="_mappings">Mapping data for current Transaction</param>
        private void mReadRecord(string line, IOrderedEnumerable<TRANSACTION_MAP_T> _mappings)
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
                else
                {
                    _value = line.Split(',')[mapItem.FIELD_ORDER.Value];
                    if (_formatType == FreeWayFileFormat.COMMA)
                    {
                        _value = _value.ToString().StartsWith("\"") ? _value.ToString().Remove(0, 1) : _value;
                        _value = _value.ToString().EndsWith("\"") ? _value.ToString().Remove(_value.ToString().Length - 1) : _value;
                    }
                }
                if (_value.ToString().HasValue())
                {
                    if (mapItem.DATA_TYPE.Trim() == "D")
                        _value = DateTime.ParseExact(_value.ToString().Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    else if (mapItem.DATA_TYPE.Trim() == "N")
                    {
                        int x; decimal y;
                        if (int.TryParse(_value.ToString(), out x))
                            _value = x;
                        else if (decimal.TryParse(_value.ToString(), out y))
                            _value = y;
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
                if (mapItem.DATA_TYPE.Trim() != "O")
                {
                    if (!_variablesDictionary.ContainsKey(mapItem.FIELD_NAME))
                        _variablesDictionary.Add(mapItem.FIELD_NAME, new List<object>());
                    _variablesDictionary[mapItem.FIELD_NAME].Add(_value);
                }
            }
        }

        /// <summary>
        /// Write data for processed PO in PO SQL
        /// </summary>
        private void UpdateTables()
        {
            bool insertSucessed = true;

            string sqlcmdstring = "";
            _poHeaderList.ForEach(poheader => sqlcmdstring += "'" + poheader.PARTNER_ID + poheader.RETAILER_PO + "',");
            sqlcmdstring = sqlcmdstring.EndsWith(",") ? sqlcmdstring.Remove(sqlcmdstring.Length - 1) : sqlcmdstring;
            PO_ITEMS_T.Delete(AriaConnection.CompanyConnection, " where rtrim(PARTNER_ID)+rtrim(RETAILER_PO) in(" + sqlcmdstring + ")");
            PO_ADDRESS_T.Delete(AriaConnection.CompanyConnection, " where rtrim(PARTNER_ID)+rtrim(RETAILER_PO) in(" + sqlcmdstring + ")");
            PO_HEADER_T.Delete(AriaConnection.CompanyConnection, " where rtrim(PARTNER_ID)+rtrim(RETAILER_PO) in(" + sqlcmdstring + ")");

            _poAddressList.ForEach(poAddress => insertSucessed = poAddress.ExecuteSqlInsert(AriaConnection.CompanyConnection) > 0);
            _poHeaderList.ForEach(poHeader => insertSucessed = poHeader.ExecuteSqlInsert(AriaConnection.CompanyConnection) > 0);
            _poItemsList.ForEach(poItems => insertSucessed = poItems.ExecuteSqlInsert(AriaConnection.CompanyConnection) > 0);
            if (!insertSucessed)
            {
                ErrorMsg = "Error Inserting into POEntity tables !";
                _continue = false;
                return;
            }
            _poHeaderList.ForEach(poheader => _extractionKey.Add(poheader.PARTNER_ID + poheader.RETAILER_PO));
        }

        /// <summary>
        /// Fill data objects with data in the Variables Dictionary
        /// </summary>
        private void Import()
        {
            _poAddressList.Clear();
            _poHeaderList.Clear();
            _poItemsList.Clear();
            int start = 0;
            bool continueloop = false;
            do
            {
                continueloop = false;
                PO_HEADER_T poHeader = new PO_HEADER_T();
                if (VariableChechker<DateTime>("MSTART", start))
                {
                    poHeader.ENTERED = DateTime.Parse(_variablesDictionary["MSTART"][start].ToString());
                    if (_variablesDictionary["MSTART"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MCUSTPO", start))
                {
                    poHeader.RETAILER_PO = _variablesDictionary["MCUSTPO"][start].ToString();
                    if (_variablesDictionary["MCUSTPO"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<DateTime>("MCOMPLETE", start))
                {
                    poHeader.CANCEL_AFTER = DateTime.Parse(_variablesDictionary["MCOMPLETE"][start].ToString());
                    if (_variablesDictionary["MCOMPLETE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<DateTime>("MCANCEL", start))
                {
                    poHeader.CANCEL_AFTER = DateTime.Parse(_variablesDictionary["MCANCEL"][start].ToString());
                    if (_variablesDictionary["MCANCEL"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MACCOUNTID", start))
                {
                    poHeader.PARTNER_ID = _variablesDictionary["MACCOUNTID"][start].ToString();
                    if (_variablesDictionary["MACCOUNTID"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MDEPT", start))
                {
                    poHeader.DEPARTMENT = _variablesDictionary["MDEPT"][start].ToString();
                    if (_variablesDictionary["MDEPT"].Count > start + 1) continueloop = true;
                }

                poHeader.TRANSACTION_TYPE = "N";
                start++;
                _poHeaderList.Add(poHeader);
            }
            while (continueloop);

            start = 0;
            do
            {
                continueloop = false;
                PO_ADDRESS_T poAddress = new PO_ADDRESS_T();
                if (_poHeaderList.Count > 0)
                {
                    poAddress.PARTNER_ID = _poHeaderList[0].PARTNER_ID;
                    poAddress.RETAILER_PO = _poHeaderList[0].RETAILER_PO;
                }

                if (VariableChechker<string>("MSTORE", start))
                {
                    // HES 11/9/2011 , fill address type with "ST" [BEGIN]
                    poAddress.ADDRESS_TYPE = "ST";
                    // HES 11/9/2011 , fill address type with "ST" [END  ]
                    poAddress.LOCATION_CODE = _variablesDictionary["MSTORE"][start].ToString();
                    poAddress.LOCATION_CODE = poAddress.PARTNER_ID == "5010487000009" ? poAddress.LOCATION_CODE.Trim().Remove(0, poAddress.LOCATION_CODE.Trim().Length - 2) : poAddress.LOCATION_CODE;
                    if (_variablesDictionary["MSTORE"].Count > start + 1) continueloop = true;
                }

                // HES 11/9/2011 , fill location code with mbstore, only if location code is empty [BEGIN]
                //if (VariableChechker<string>("MBSTORE", start)
                if (VariableChechker<string>("MBSTORE", start) && !poAddress.LOCATION_CODE.ToString().Trim().HasValue())
                // HES 11/9/2011 , fill location code with mbstore, only if location code is empty [END  ]
                {
                    poAddress.LOCATION_CODE = _variablesDictionary["MBSTORE"][start].ToString();
                    poAddress.LOCATION_CODE = poAddress.PARTNER_ID == "5010487000009" ? poAddress.LOCATION_CODE.Trim().Remove(0, poAddress.LOCATION_CODE.Trim().Length - 2) : poAddress.LOCATION_CODE;
                    if (_variablesDictionary["MBSTORE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTNAME", start))
                {
                    poAddress.NAME = _variablesDictionary["MSTNAME"][start].ToString();
                    if (_variablesDictionary["MSTNAME"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTADD1", start))
                {
                    poAddress.ADDRESS_LINE_1 = _variablesDictionary["MSTADD1"][start].ToString();
                    if (_variablesDictionary["MSTADD1"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTADD2", start))
                {
                    poAddress.ADDRESS_LINE_2 = _variablesDictionary["MSTADD2"][start].ToString();
                    if (_variablesDictionary["MSTADD2"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTCITY", start))
                {
                    poAddress.CITY = _variablesDictionary["MSTCITY"][start].ToString();
                    if (_variablesDictionary["MSTCITY"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTSTATE", start))
                {
                    poAddress.STATE = _variablesDictionary["MSTSTATE"][start].ToString();
                    if (_variablesDictionary["MSTSTATE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTZIP", start))
                {
                    poAddress.ZIP_CODE = _variablesDictionary["MSTZIP"][start].ToString();
                    if (_variablesDictionary["MSTZIP"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTOREGLN", start))
                {
                    poAddress.GLN_NUMBER = _variablesDictionary["MSTOREGLN"][start].ToString();
                    if (_variablesDictionary["MSTOREGLN"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MBSTOREGLN", start))
                {
                    poAddress.GLN_NUMBER = _variablesDictionary["MBSTOREGLN"][start].ToString();
                    if (_variablesDictionary["MBSTOREGLN"].Count > start + 1) continueloop = true;
                }

                start++;
                _poAddressList.Add(poAddress);
            }
            while (continueloop);
            start = 0;

            do
            {
                continueloop = false;
                PO_ITEMS_T poItems = new PO_ITEMS_T();

                if (VariableChechker<int>("MQTY", start))
                {
                    poItems.QUANTITY_ORDERED = int.Parse(_variablesDictionary["MQTY"][start].ToString());
                    if (_variablesDictionary["MQTY"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MUPC", start))
                {
                    poItems.UPC_NUMBER = _variablesDictionary["MUPC"][start].ToString();
                    if (_variablesDictionary["MUPC"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<long>("MSTYLE", start))
                {
                    poItems.ITEM_LINE_NO = long.Parse(_variablesDictionary["MSTYLE"][start].ToString());
                    if (_variablesDictionary["MSTYLE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<decimal>("MPRICE", start))
                {
                    poItems.UNIT_PRICE = decimal.Parse(_variablesDictionary["MPRICE"][start].ToString());
                    if (_variablesDictionary["MPRICE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSTYL", start))
                {
                    poItems.VENDOR_STYLE = _variablesDictionary["MSTYL"][start].ToString();
                    if (_variablesDictionary["MSTYL"].Count > start + 1) continueloop = true;
                }
                if (_poHeaderList.Count > 0)
                {
                    poItems.PARTNER_ID = _poHeaderList[0].PARTNER_ID;
                    poItems.RETAILER_PO = _poHeaderList[0].RETAILER_PO;
                }
                start++;
                _poItemsList.Add(poItems);

            }
            while (continueloop);

        }

        /// <summary>
        /// Create output Aria Xml file
        /// </summary>
        private void CreateTemporaryFiles()
        {
            AriaOutXMlFile = GetEDIBasePath() + "Work\\";
            if (!Directory.Exists(AriaOutXMlFile))
            {

                ErrorMsg = "Couldn't find work path " + AriaOutXMlFile + " to save Ariaxml to it!";
                _continue = false;
                return;
            }

            AriaOutXMlFile += "AriaXMl" + Path.GetRandomFileName().Replace(".", "") + ".xml";

            SqlConnectionStringBuilder connectionBuilder = new SqlConnectionStringBuilder(AriaConnection.CompanyConnection.ConnectionString);

            TransactionsCore.TransactionsCore transactionCore = new TransactionsCore.TransactionsCore();
            string where = "";
            _extractionKey.ForEach(key => where += "'" + key + "',");
            where = where.EndsWith(",") ? where.Remove(where.Length - 1) : where;
            where = " rtrim(PARTNER_ID)+rtrim(RETAILER_PO) in (" + where + ")";
            transactionCore.Extract(TransactionType, connectionBuilder.DataSource, connectionBuilder.InitialCatalog, connectionBuilder.UserID, connectionBuilder.Password, where, AriaOutXMlFile);
        }

        /// <summary>
        /// Helper method to check if the variables dictionary contains the passed key in the passed index
        /// </summary>
        /// <typeparam name="T">type of variable</typeparam>
        /// <param name="Key">Key of variable</param>
        /// <param name="index">index in the array of values</param>
        /// <returns>if the variable found or not</returns>
        private bool VariableChechker<T>(string Key, int index)
        {
            if (_variablesDictionary.ContainsKey(Key) && _variablesDictionary[Key].Count > index && _variablesDictionary[Key][index] is T)
                return true;
            return false;
        }

        /// <summary>
        /// Read the contents of the Rawfile in variable
        /// </summary>
        private void ReadEdiFile()
        {
            string _ediFilePath = GetEDIBasePath();
            if (_ediFilePath == null)
            {
                ErrorMsg = "Couldn't get Edi Path from Sysfiles Path : " + AriaConnection.Aria27SysFilesPath + " !";
                _continue = false;
                return;
            }
            _ediFilePath += "EDI\\" + _ediLibHD.cfilepath.Trim() + _ediLibHD.cedifilnam.Trim();
            if (!File.Exists(_ediFilePath))
            {
                ErrorMsg = "Couldn't find Raw Edi file :" + _ediFilePath + " !";
                _continue = false;
                return;
            }
            _rawFileContents = File.ReadAllText(_ediFilePath);
            if (_rawFileContents.Length == 0)
            {
                ErrorMsg = "Raw Edi file " + _ediFilePath + " is empty !";
                _continue = false;
                return;
            }
        }

        /// <summary>
        /// Calculate the path of the EDI folder using the path of the Sysfile
        /// </summary>
        /// <returns>EDI application path</returns>
        private string GetEDIBasePath()
        {
            string _ediPath = AriaConnection.Aria27SysFilesPath;
            _ediPath = _ediPath.EndsWith("\\") ? _ediPath : _ediPath + "\\";
            int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA27\\SYSFILES\\");
            if (_a27WordPostion > 0)
            {
                _ediPath = _ediPath.Remove(_a27WordPostion) + "Aria3Edi\\";
                return _ediPath;
            }
            return null;
        }

        /// <summary>
        /// Read the raw file pos and save them in array
        /// </summary>
        private void ReadEDIRawPOS()
        {
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
                _ediLibDtPOS.Add(_rawFileContents.Substring(start, length));
            }
            BatchMode = _ediLibDtPOS.Count > 1;
        }

        /// <summary>
        /// Fill the property of the warehouse like EDI old code because the main control screen of EDI needs it
        /// </summary>
        private void FillWareHouse()
        {
            var warehousesList = WAREHOUS.Select(AriaConnection.DbfsConnection, "");
            if (warehousesList.Count == 1)
                Location = warehousesList[0].cwarecode;
        }

        #endregion
    }
}