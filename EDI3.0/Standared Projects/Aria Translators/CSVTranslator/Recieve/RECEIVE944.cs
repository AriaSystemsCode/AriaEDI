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
using CSVTranslator.Recieve;

namespace CSVTranslator
{
    // Updating Class To Inherit From Abstract Recieve Class [20/06/2017][MSH][Start][End]
    public class RECEIVE944 : RecieveBase
    {
        #region Properties
        //foda begin
        public string MACCOUNT
        {
            get;
            set;
        }
        //foda end
        #endregion

        #region Private Variables
        #endregion

        #region Methods

        public RECEIVE944():base() // foda
        {
            // Intialize Transaction Type With 944 [20/06/2017][MSH][Start]
            TransactionType = "944";
            // Intialize Transaction Type With 944 [20/06/2017][MSH][End]
        }

        /// <summary>
        ///  For documention related to fix# and functionalty of the program.
        /// </summary>
        protected override void Documentation() { }

        //FODA -Overloading DO Method [START]
        //public override void DO(bool notused, string lcFileCode, string lcFilter, string trans_no)
        //{
        //    DO(notused, lcFileCode, lcFilter);
        //}
        //FODA -Overloading DO Method [END]

        /// <summary>
        /// Main method for receiveing 850 files 
        /// </summary>
        /// <param name="lcFileCode">FileCode saved in Edi tables</param>
        /// <param name="lcFilter">Filter for targeted POS in the selected file</param>
        /// <param name="notused">NOT Used paramter -- just for EDI compatibility like old EDI Code</param>
        //public override void DO(bool notused, string lcFileCode, string lcFilter)
        //{
        //    try
        //    {
        //        _continue = true;
        //        if (!lcFileCode.HasValue())
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Empty FileCode !";
        //            _continue = false;
        //            return;
        //        }
        //        var ediLibHDList = EDILIBHD.Select(AriaConnection.DbfsConnection, "where cedifiltyp+cfilecode = 'R" + lcFileCode + "'");
        //        _ediLibHD = ediLibHDList != null && ediLibHDList.Count > 0 ? ediLibHDList[0] : null;
        //        if (_ediLibHD == null)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find data in EdiLibHD for FileCode " + lcFileCode + " !";
        //            _continue = false;
        //            return;
        //        }


        //        lcFilter = lcFilter.HasValue() ? " And " + lcFilter : "";

        //        _eDILIBDT_List = EDILIBDT.Select(AriaConnection.DbfsConnection, " where cfilecode = '" + lcFileCode + "'" + lcFilter);

        //        if (_eDILIBDT_List == null || _eDILIBDT_List.Count == 0)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find data in EdiLibDT for FileCode " + lcFileCode + " with Filter " + lcFilter + " !";
        //            _continue = false;
        //            return;
        //        }

        //        // MSH Not Trim Because We Cannot use it.
        //        var _tempEdiPd = EDIPD.Select(AriaConnection.DbfsConnection, "where cPartCode = '" + _eDILIBDT_List[0].cpartcode.Trim() + "' and ceditrntyp = '"+TransactionType+"'");
        //        if (_tempEdiPd == null || _tempEdiPd.Count == 0)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find data in map for CpartCode " + _eDILIBDT_List[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
        //            _continue = false;
        //            return;
        //        }

        //        this.MappingCode = _tempEdiPd[0].cmapset.Trim();
        //        this.Version = _tempEdiPd[0].cversion.Trim();
        //        // foda begin
        //        List<EDIACPRT> _tempEdiAcPrt = EDIACPRT.Select(AriaConnection.DbfsConnection, "where cpartcode = '" + _tempEdiPd[0].cpartcode + "'");
        //        if (_tempEdiAcPrt == null || _tempEdiAcPrt.Count == 0)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find EDI Account for CpartCode " + _tempEdiPd[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
        //            _continue = false;
        //            return;
        //        }
        //        MACCOUNT = _tempEdiAcPrt[0].cpartner.Trim();
                
        //        ReadEdiFile();
        //        if (!_continue)
        //            return;
        //        //foda end
        //        // MSH Check If File Is CSV
        //        if (Path.GetExtension(_TempRowFilePath).ToUpper() == ".CSV")
        //        {
        //            _formatType = FreeWayFileFormat.CSV;
        //        }
        //        else
        //        {
        //            if (_rawFileContents.StartsWith("COMMA"))
        //                _formatType = FreeWayFileFormat.COMMA;
        //            else if (_rawFileContents.StartsWith("FIXED"))
        //                _formatType = FreeWayFileFormat.FIXED;
        //            else if (_rawFileContents.StartsWith("CSV"))
        //                _formatType = FreeWayFileFormat.CSV;
        //            else
        //            {
        //                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //                HasError = true;
        //                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //                ErrorMsg = "Couldn't determine CSV file type " + _rawFileContents.Substring(0, 5) + " !";
        //                _continue = false;
        //                return;
        //            }
        //        }

        //        _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, " where direction='R' And map_Set='" + MappingCode + "' And transaction_Type='" + TransactionType + "' And version='" + Version + "'");

        //        if (_segmentsList == null || _segmentsList.Count == 0)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find Segments for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
        //            _continue = false;
        //            return;
        //        }
        //        string segmentsKeys = "";
        //        _segmentsList.ForEach(segment => segmentsKeys = segmentsKeys + segment.TRANSACTION_SEGMENTS_KEY + ",");
        //        segmentsKeys = segmentsKeys.EndsWith(",") ? segmentsKeys.Remove(segmentsKeys.Length - 1) : segmentsKeys;
        //        _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
        //        if (_segmentsMappingList == null || _segmentsMappingList.Count == 0)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't find Segments Map  for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
        //            _continue = false;
        //            return;
        //        }
        //        //MSH
        //        //FillWareHouse();
        //        ReadEDIRawPOS();
        //        // MSH
        //        string tempdb = this.CreateTempDatabase();
                
        //        if(tempdb==null)
        //        {
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //            HasError = true;
        //            // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //            ErrorMsg = "Couldn't create temp Database !";
        //            _continue = false;
        //            return;
        //        }

        //        if (!_continue) return;
        //        // FillFreeSegments();
        //        foreach (string Pocontent in _ediLibDtPOS)
        //        {   
        //            //msh
        //            ProcessPO(Pocontent, tempdb);
        //            // FODA [BEGIN]
        //            if (!_continue) break;
        //            // FODA [END]
        //        }
        //        // FODA [BEGIN]
        //        if (_continue)
        //        // FODA [END]
        //        CreateTemporaryFiles(tempdb);
        //        DeleteTempDatabase(tempdb);
        //    }
        //    catch (Exception ex)
        //    {
        //        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
        //        HasError = true;
        //        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
        //        ErrorMsg = ex.GetDetailedMessage();
        //        _continue = false;
        //        return;
        //    }
        //}
        public override void DO(bool notused, string lcFileCode, string lcFilter, string trans_no)
        {
            try
            {
                _continue = true;
                if (!lcFileCode.HasValue())
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Empty FileCode !";
                    _continue = false;
                    return;
                }
                var ediLibHDList = EDILIBHD.Select(AriaConnection.DbfsConnection, "where cedifiltyp+cfilecode = 'R" + lcFileCode + "'");
                _ediLibHD = ediLibHDList != null && ediLibHDList.Count > 0 ? ediLibHDList[0] : null;
                if (_ediLibHD == null)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't find data in EdiLibHD for FileCode " + lcFileCode + " !";
                    _continue = false;
                    return;
                }


                lcFilter = lcFilter.HasValue() ? " And " + lcFilter : "";

                _eDILIBDT_List = EDILIBDT.Select(AriaConnection.DbfsConnection, " where cfilecode = '" + lcFileCode + "'" + lcFilter);

                if (_eDILIBDT_List == null || _eDILIBDT_List.Count == 0)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't find data in EdiLibDT for FileCode " + lcFileCode + " with Filter " + lcFilter + " !";
                    _continue = false;
                    return;
                }

                // MSH Not Trim Because We Cannot use it.
                var _tempEdiPd = EDIPD.Select(AriaConnection.DbfsConnection, "where cPartCode = '" + _eDILIBDT_List[0].cpartcode.Trim() + "' and ceditrntyp = '" + TransactionType + "'");
                if (_tempEdiPd == null || _tempEdiPd.Count == 0)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't find data in map for CpartCode " + _eDILIBDT_List[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
                    _continue = false;
                    return;
                }

                this.MappingCode = _tempEdiPd[0].cmapset.Trim();
                this.Version = _tempEdiPd[0].cversion.Trim();
                // foda begin
                List<EDIACPRT> _tempEdiAcPrt = EDIACPRT.Select(AriaConnection.DbfsConnection, "where cpartcode = '" + _tempEdiPd[0].cpartcode + "'");
                if (_tempEdiAcPrt == null || _tempEdiAcPrt.Count == 0)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't find EDI Account for CpartCode " + _tempEdiPd[0].cpartcode.Trim() + " For Transaction " + TransactionType + " !";
                    _continue = false;
                    return;
                }
                MACCOUNT = _tempEdiAcPrt[0].cpartner.Trim();

                ReadEdiFile();
                if (!_continue)
                    return;
                //foda end
                // MSH Check If File Is CSV
                if (Path.GetExtension(_TempRowFilePath).ToUpper() == ".CSV")
                {
                    _formatType = FreeWayFileFormat.CSV;
                }
                else
                {
                    if (_rawFileContents.StartsWith("COMMA"))
                        _formatType = FreeWayFileFormat.COMMA;
                    else if (_rawFileContents.StartsWith("FIXED"))
                        _formatType = FreeWayFileFormat.FIXED;
                    else if (_rawFileContents.StartsWith("CSV"))
                        _formatType = FreeWayFileFormat.CSV;
                    else
                    {
                        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                        HasError = true;
                        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                        ErrorMsg = "Couldn't determine CSV file type " + _rawFileContents.Substring(0, 5) + " !";
                        _continue = false;
                        return;
                    }
                }

                _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, " where direction='R' And map_Set='" + MappingCode + "' And transaction_Type='" + TransactionType + "' And version='" + Version + "'");

                if (_segmentsList == null || _segmentsList.Count == 0)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
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
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't find Segments Map  for Mapcode:" + MappingCode + " Transaction:" + TransactionType + " Version:" + Version + " !";
                    _continue = false;
                    return;
                }
                //MSH
                //FillWareHouse();
                ReadEDIRawPOS();
                // MSH
                string tempdb = this.CreateTempDatabase();

                if (tempdb == null)
                {
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                    HasError = true;
                    // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                    ErrorMsg = "Couldn't create temp Database !";
                    _continue = false;
                    return;
                }

                if (!_continue) return;
                // FillFreeSegments();
                foreach (string Pocontent in _ediLibDtPOS)
                {
                    //msh
                    ProcessPO(Pocontent, tempdb);
                    // FODA [BEGIN]
                    if (!_continue) break;
                    // FODA [END]
                }
                // FODA [BEGIN]
                if (_continue)
                    // FODA [END]
                    CreateTemporaryFiles(tempdb);
                DeleteTempDatabase(tempdb);
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
        /// Process single PO at a time
        /// </summary>
        /// <param name="poContent">PO Content to recieve</param>
        protected override void ProcessPO(string poContent, string tempdb)
        {
            _variablesDictionary.Clear();
            foreach (string line in poContent.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries))
            {
                //string _segment = line.Substring(0, 5).Trim();
                // MSH  Bad Bad Bad.
                bool isSegmentBase=true;
                var _segment = line.Split(',')[0];
                var _segmentsKey = _segmentsList.Where(segment => segment.SEGMENT_ID == _segment);
                if (_segmentsKey.Count() == 0)
                {
                    _segment = "LINE";
                    isSegmentBase = false;
                    _segmentsKey = _segmentsList.Where(segment => segment.SEGMENT_ID == _segment);
                    if (_segmentsKey.Count() == 0)
                    {
                        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                        HasError = true;
                        // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                        ErrorMsg = "Couldn't find Segment :" + _segment + " in Segments datatable!";
                        _continue = false;
                        return;
                    }
                }
                var _mappings = _segmentsMappingList.Where(segmentMap => segmentMap.TRANSACTION_SEGMENTS_KEY == _segmentsKey.First().TRANSACTION_SEGMENTS_KEY).OrderBy(segmentMap => segmentMap.FIELD_ORDER);
                mReadRecord(line, _mappings, isSegmentBase);
            }

            Import(tempdb);
            //foda begin 
            if (!_continue)
                return;
            //foda end       
        }
        
        /// <summary>
        /// Fill data objects with data in the Variables Dictionary
        /// </summary>
        //foda begin
        protected override void Import(string tempdb)
        {
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            sb.InitialCatalog = tempdb;
            SqlConnection Sc = new SqlConnection(sb.ConnectionString);
            int start = 0;
            bool continueloop = false;
            CTKTRCVH Hdr = new CTKTRCVH();
            Hdr.CWARECODE  = MACCOUNT;
            Hdr.TMPRCVNUM = "";

            if (VariableChechker<string>("MCONTNO", start))
                Hdr.CONTAINERNo = _variablesDictionary["MCONTNO"][start].ToString();

            if (VariableChechker<string>("MSEAL", start))
                Hdr.SEALNO = _variablesDictionary["MSEAL"][start].ToString();

            if (VariableChechker<string>("MHANGER", start))
                Hdr.HANGER = _variablesDictionary["MHANGER"][start].ToString();

            if (VariableChechker<string>("MTICKET", start))
                Hdr.TICKET = _variablesDictionary["MTICKET"][start].ToString();

            if (VariableChechker<string>("MCUSTPO", start))
            {
                Hdr.PONO =  _variablesDictionary["MCUSTPO"][start].ToString();
            }

            if (VariableChechker<DateTime>("MRECDATE", start))
            {
                Hdr.DDATE =   DateTime.Parse(_variablesDictionary["MRECDATE"][start].ToString());
            }
            else if (VariableChechker<string>("MRECDATE", start))
            {
                Hdr.DDATE = null; // foda
            }

            // MSH - 11/07/2017 - Adding SHIP NO [Start]
            if (VariableChechker<string>("MSHIPNO", start))
                Hdr.SHIPNO = _variablesDictionary["MSHIPNO"][start].ToString();
            // MSH - 11/07/2017 - Adding SHIP NO [End]

            try
            {
                Hdr.ExecuteSqlInsert(Sc);
            }
            catch(Exception Ex)
            {
              _continue = false;
              // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
              HasError = true;
              // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
              // Updating Error Message Content - [20/06/2017] [MSH][Start]  
              ErrorMsg = Ex.Message;
              // Updating Error Message Content - [20/06/2017] [MSH][End]
              return;
            }

            do
            {
               CTKTRCVL Det = new CTKTRCVL();
               continueloop = false;
               Det.TMPRCVNUM = Hdr.TMPRCVNUM; 
               Det.PONO = Hdr.PONO;
               
               // MSH Update WareCode Account B/W In Header & Detail & Calculate LineNum. [Start]
               Det.CWARECODE = Hdr.CWARECODE;
               Det.LINENUM = start + 1;
               // MSH Update WareCode Account B/W In Header & Detail & Calculate LineNum. [End]

               /*
               MSH - Should Be Deleted [Start]
               if (VariableChechker<int>("MTOTQTYREC", start)  ||  VariableChechker<float>("MTOTQTYREC", start))
               { 
                    Det.TOTRECQTY =  int.Parse(_variablesDictionary["MTOTQTYREC"][start].ToString());
                     if (_variablesDictionary["MTOTQTYREC"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.TOTRECQTY = 0;
                   if (_variablesDictionary["MTOTQTYREC"].Count > start + 1) continueloop = true;
               }
               MSH - Should Be Deleted [End]
               */

               // Add Mapping Link To MISPREPCK - To Get If Its Prepack Or Not [MSH][Start]
               if (VariableChechker<string>("MISPACK", start))
               {
                   Det.CISPREPK = _variablesDictionary["MISPACK"][start].ToString();
                   if (_variablesDictionary["MISPACK"].Count > start + 1) continueloop = true;
               }
               // Add Mapping Link To MISPREPCK - To Get If Its Prepack Or Not [MSH][End]

               if (VariableChechker<string>("MRECNO", start))
               {
                   Det.RecNo = _variablesDictionary["MRECNO"][start].ToString();
                   // Check If It Has Multiple Lines [MSH][Start]
                   if (_variablesDictionary["MRECNO"].Count > start + 1) continueloop = true;
                   // Check If It Has Multiple Lines [MSH][End]
               }

               if (VariableChechker<string>("MSTYLE", start))
               {
                   Det.STYLE = _variablesDictionary["MSTYLE"][start].ToString();
                   // Check If It Has Multiple Lines [MSH][Start]
                   if (_variablesDictionary["MSTYLE"].Count > start + 1) continueloop = true;
                   // Check If It Has Multiple Lines [MSH][End]
               }

               if (VariableChechker<string>("MSIZE", start))
               {
                   Det.SIZECODE = _variablesDictionary["MSIZE"][start].ToString();
                   // Check If It Has Multiple Lines [MSH][Start]
                   if (_variablesDictionary["MSIZE"].Count > start + 1) continueloop = true;
                   // Check If It Has Multiple Lines [MSH][End]
               }

               #region MUNITSPERPACK
               // Check Value Type Related To Var : "MUNITSPERPACK" [MSH][Start]
               if (VariableChechker<int>("MUNITSPERPACK", start))
               {
                   Det.UNITSPERPACK = int.Parse(_variablesDictionary["MUNITSPERPACK"][start].ToString());
                   if (_variablesDictionary["MUNITSPERPACK"].Count > start + 1) continueloop = true;
               }
               else if (VariableChechker<float>("MUNITSPERPACK", start))
               {
                   Det.UNITSPERPACK = float.Parse(_variablesDictionary["MUNITSPERPACK"][start].ToString());
                   if (_variablesDictionary["MUNITSPERPACK"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.UNITSPERPACK = 0;
                   if (_variablesDictionary["MUNITSPERPACK"].Count > start + 1) continueloop = true;
               }
               // Check Value Type Related To Var : "MUNITSPERPACK" [MSH][End]
               #endregion

               if (VariableChechker<int>("MTOTNOCRTNS", start) || VariableChechker<float>("MTOTNOCRTNS", start))
               {
                   Det.TOTALNOOFCRTNS = int.Parse(_variablesDictionary["MTOTNOCRTNS"][start].ToString());
                   if (_variablesDictionary["MTOTNOCRTNS"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.TOTALNOOFCRTNS = 0;
                   if (_variablesDictionary["MTOTNOCRTNS"].Count > start + 1) continueloop = true;
               }

               if (VariableChechker<int>("MTOTAL", start) || VariableChechker<float>("MTOTAL", start))
               {
                   Det.TOTQTY = int.Parse(_variablesDictionary["MTOTAL"][start].ToString());
                   if (_variablesDictionary["MTOTAL"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.TOTQTY = 0;
                   if (_variablesDictionary["MTOTAL"].Count > start + 1) continueloop = true;
               }

               #region MLENGTH
               // Check Value Type Related To Var : "MLENGTH" [MSH][Start]
               if (VariableChechker<int>("MLENGTH", start))
               {
                   Det.nLength = int.Parse(_variablesDictionary["MLENGTH"][start].ToString());
                   if (_variablesDictionary["MLENGTH"].Count > start + 1) continueloop = true;
               }
               else if (VariableChechker<float>("MLENGTH", start))
               {
                   Det.nLength = float.Parse(_variablesDictionary["MLENGTH"][start].ToString());
                   if (_variablesDictionary["MLENGTH"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.nLength = 0;
                   if (_variablesDictionary["MLENGTH"].Count > start + 1) continueloop = true;
               }
               // Check Value Type Related To Var : "MLENGTH" [MSH][End]
               #endregion

               #region MWIDTH
               // Check Value Type Related To Var : "MWIDTH" [MSH][Start]
               if (VariableChechker<int>("MWIDTH", start))
               {
                   Det.nWidth = int.Parse(_variablesDictionary["MWIDTH"][start].ToString());
                   if (_variablesDictionary["MWIDTH"].Count > start + 1) continueloop = true;
               }
               else if (VariableChechker<float>("MWIDTH", start))
               {
                   Det.nWidth = float.Parse(_variablesDictionary["MWIDTH"][start].ToString());
                   if (_variablesDictionary["MWIDTH"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.nWidth = 0;
                   if (_variablesDictionary["MWIDTH"].Count > start + 1) continueloop = true;
               }
               // Check Value Type Related To Var : "MWIDTH" [MSH][End]
               #endregion

               #region MHEIGHT
               // Check Value Type Related To Var : "MHEIGHT" [MSH][Start]
               if (VariableChechker<int>("MHEIGHT", start))
               {
                   Det.nHeight = int.Parse(_variablesDictionary["MHEIGHT"][start].ToString());
                   if (_variablesDictionary["MHEIGHT"].Count > start + 1) continueloop = true;
               }
               else if (VariableChechker<float>("MHEIGHT", start))
               {
                   Det.nHeight = float.Parse(_variablesDictionary["MHEIGHT"][start].ToString());
                   if (_variablesDictionary["MHEIGHT"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.nHeight = 0;
                   if (_variablesDictionary["MHEIGHT"].Count > start + 1) continueloop = true;
               }
               // Check Value Type Related To Var : "MHEIGHT" [MSH][End]
               #endregion

               #region MWIGHT
               // Check Value Type Related To Var : "MWIGHT" [MSH][Start]
               if (VariableChechker<int>("MWIGHT", start))
               {
                   Det.nWeigth = int.Parse(_variablesDictionary["MWIGHT"][start].ToString());
                   if (_variablesDictionary["MWIGHT"].Count > start + 1) continueloop = true;
               }
               else if (VariableChechker<float>("MWIGHT", start))
               {
                   Det.nWeigth = float.Parse(_variablesDictionary["MWIGHT"][start].ToString());
                   if (_variablesDictionary["MWIGHT"].Count > start + 1) continueloop = true;
               }
               else
               {
                   Det.nWeigth = 0;
                   if (_variablesDictionary["MWIGHT"].Count > start + 1) continueloop = true;
               }
               // Check Value Type Related To Var : "MWIGHT" [MSH][End]
               #endregion

                try
                {
                  Det.ExecuteSqlInsert(Sc); 
                }
                catch(Exception Ex)
               {
                  _continue = false;
                  // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                  HasError = true;
                  // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                  // Updating Error Message Content - [20/06/2017] [MSH][Start]  
                  ErrorMsg = Ex.Message;
                  // Updating Error Message Content - [20/06/2017] [MSH][End]
                  return;
               }

                //continueloop = false;  commented by foda
                 start++;
            }
            while (continueloop);
        }
        //foda end
   
        #endregion
    }
}