using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data;
using System.Data.Common;
using System.IO;
using X12Translator;


namespace X12Translator
{
    public class ReceiveFile
    {

        #region Properties

        public Boolean Error { get; set; }
        public string ErrorMsg { get; set; }
        public string StatusMsg { get; set; }
        public string ClientID { get; set; }
        public string activecompany { get; set; }
        public string Filecode { get; set; }

        #endregion

        #region Private Variables

        Dictionary<string, object> _variablesDictionary = new Dictionary<string, object>();

        List<EDILIBDT> _eDILIBDT_List;

        bool _continue=true;
        string _FileCode;
        EDILIBHD _ediLibHD;
        sequence _Sequence;
        int lnAccLength = 0;
        //Derby-Change TransactionType to be 945 [Start]
        //string _TranType = "850";
        string _TranType = "945";
        string Mstatus="";
        //Derby-Change TransactionType to be 945 [End]
        string _PartCode = "";
        char _FormatType;
        string _StartSeg;
        string _rawFileContents;
        string ReceivedFilePath;
        string mAccount;
        string cOldFile;
        string cFileName;
        string cFileExt;
        string cArcvPath;
        string _ActiveComp;
        string cArcvFile;
        string cEdiPath;
        int TrnCount=0;
        //Derby-add variable to hold the rejected transaction number [Start]
        int Nrejtran = 0;
        //Derby-add variable to hold the rejected transaction number [End]
        bool lFirst;

        #endregion

        #region Methods

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
                _ActiveComp = ActiveCompany.Trim();
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
            StatusMsg = "Connected Succeccfully";
        }

        private void Documentation() { }

        public void Receive(string lcFileCode)
        {
            try
            {
                _FileCode = lcFileCode;
                if (!lcFileCode.HasValue())
                {
                    Error = true;
                    ErrorMsg = "Empty File Code !";
                }

                var ediLibHDList = EDILIBHD.Select(AriaConnection.DbfsConnection, " where cedifiltyp+cfilecode='R" + lcFileCode + "'");
                _ediLibHD = ediLibHDList != null && ediLibHDList.Count > 0 ? ediLibHDList[0] : null;

                if (_ediLibHD == null)
                {
                    ErrorMsg = "Couldn't find data in EdiLibHD for FileCode " + lcFileCode + " !";
                    _continue = false;
                    return;
                }

                if (ifNeedSeq(lcFileCode, _ediLibHD.cnetwork))
                {
                    string _SeqNo = "";
                    _SeqNo = GetSeq();
                    DB.UpdateEdiLibHd(lcFileCode, _SeqNo);
                    DB.UpdateSeq(_Sequence.cseq_type, _Sequence.nseq_no.Value + 1);
                    _FileCode = _SeqNo;
                }

                cEdiPath = GetEDIBasePath().Trim();
                ReceivedFilePath = cEdiPath + _ediLibHD.cfilepath.Trim() + _ediLibHD.cedifilnam.Trim();

                if (Convert.ToString(_ediLibHD.cstatus).HasValue())
                {
                    EDIERORH.Delete(AriaConnection.DbfsConnection, " where cFileCode = '" + lcFileCode + "'");
                    EDIERORD.Delete(AriaConnection.DbfsConnection, " where cFileCode = '" + lcFileCode + "'");
                    _eDILIBDT_List = EDILIBDT.Select(AriaConnection.DbfsConnection, " where cFileCode = '" + lcFileCode + "'");
                    foreach (EDILIBDT _EdiLDitem in _eDILIBDT_List)
                    {
                        _PartCode = _EdiLDitem.cpartcode;
                        var cEdiAcPrt = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartCode = '" + _PartCode + "'");
                        if (cEdiAcPrt[0].type == 'A')
                            mAccount = cEdiAcPrt[0].cpartner.Substring(0, 5);
                        else
                            mAccount = cEdiAcPrt[0].cpartner;
                        DeleteTrans(mAccount, _EdiLDitem);
                    }
                }
                // MSH
                EDILIBDT.Delete(AriaConnection.DbfsConnection, " where rtrim(cedifiltyp)+rtrim(cfilecode) = 'R" + lcFileCode + "'");
                // MSH 
                ReadCSVFile(ReceivedFilePath);
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
        }

        private void ReadCSVFile(string ReceivedFilePath)
        {
            ReadEdiFile();
            //Derby-Pass ReceivedFilePath to ReadStruRec [Start]
            //ReadStruRec(_rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.None)[0]);
            ReadStruRec(_rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.None)[0],ReceivedFilePath);
            //Derby-Pass ReceivedFilePath to ReadStruRec [End]
            UpdateEDILibDT();
            ArchiveFile();
            //Derby-Pass the rejected transaction number to be updated on EDILBHDR [Start]
            if (Nrejtran > 0)
            {
                ErrorMsg = "Some error happend while Receiving file, Please check the reported errors report.";
                Mstatus += ".";
                DB.updateEdiLDStatus("FFFTF",_FileCode);
            }
            else
            {
                Mstatus = "CSV file is succesfully Received.";
                DB.updateEdiLDStatus("FFFFF",_FileCode);
            }
            DB.updateEdiLHStatus(TrnCount,Nrejtran, _FileCode,Mstatus);
            //DB.updateEdiLHStatus(TrnCount, _FileCode);
            
            //Derby-Pass the rejected transaction number to be updated on EDILBHDR && Update EDILBDT [END]
        }
        
        private void ArchiveFile()
        {
            cOldFile = _ediLibHD.cedifilnam.Trim();
            cFileName = cEdiPath + _ediLibHD.cfilepath.Trim() + _ediLibHD.cedifilnam.Trim();
            cFileExt = Path.GetExtension(cFileName);
            cArcvPath = cEdiPath + @"INBOX\ARCHIVE\";
            cArcvFile = _ActiveComp.Trim() + _FileCode + cFileExt.Trim();

            File.Move(cFileName, cArcvPath+cArcvFile);
            DB.UpdateArchEdiLibHd(cArcvFile, @"INBOX\ARCHIVE\", _FileCode);
            SYCEDILH.Delete(AriaConnection.SysFilesConnection, " where cEDIFilNam = '" + cOldFile + "'");
        }

        private void UpdateEDILibDTOld()
        {
            string[] fileLines = _rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            int start = 0, length = 0;
            EDILIBDT _ediLibDt = new EDILIBDT();
            _ediLibDt.cedifiltyp = 'R';
            _ediLibDt.cfilecode = _FileCode;
            _ediLibDt.ceditrntyp = _TranType;
            _ediLibDt.crejreason = "FFFFF";
            _ediLibDt.cgsrejreas = "FFFFF";
            _ediLibDt.crecfldsep = _FormatType;
            string lcPrtner = "";
            TrnCount = 0;
            lFirst = true;
            for (int lineNo = 0; lineNo < fileLines.Length; lineNo++)
            {
                string currentLine = fileLines[lineNo];
                if (currentLine.StartsWith(_StartSeg))
                {
                    if (length > 0 && start > 0)
                    {
                        _ediLibDt.mtrantext = "START|" + (start-1).ToString() + "|LENGTH|" + length.ToString() + "|";
                        _ediLibDt.ctranseq = TrnCount.ToString().Trim();
                        EDILIBDT.Delete(AriaConnection.DbfsConnection, " where rtrim(cedifiltyp)+rtrim(cfilecode)+rtrim(cpartcode)+rtrim(cTranSeq)+rtrim(ceditrntyp) = '" + _ediLibDt.cedifiltyp.ToString().Trim() + _ediLibDt.cfilecode.ToString().Trim() + _ediLibDt.cpartcode.ToString().Trim() + _ediLibDt.ctranseq.ToString().Trim() + _ediLibDt.ceditrntyp.ToString().Trim() + "'");
                        _ediLibDt.ExecuteVFPnsert(AriaConnection.DbfsConnection);
                        TrnCount += 1;
                    }
                    _ediLibDt.cediref = currentLine.Substring(65, 25);
                    lcPrtner = currentLine.Substring(26, 5);
                    var _ediAcPrtRow = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartner = '" + lcPrtner.Trim() + "'");
                    try
                    {
                        _ediLibDt.cpartcode = _ediAcPrtRow[0].cpartcode;
                    }
                    catch
                    {
                        ErrorMsg = "No lines for Account# " + lcPrtner.Trim();
                    }

                    start = lnAccLength + 1;
                    length = currentLine.Length + Environment.NewLine.Length;
                }
                else
                {
                    if (!((currentLine.StartsWith("FIXED") || currentLine.StartsWith("CSV") || currentLine.StartsWith("COMMA")) && !lFirst))
                    {
                        length += currentLine.Length + Environment.NewLine.Length;
                    }                    
                    lFirst = false;
                    if (lineNo + 1 == fileLines.Length && length > 0 && start > 0)
                    {
                        _ediLibDt.ctranseq = TrnCount.ToString().Trim();
                        _ediLibDt.mtrantext = "START|" + (start - 1).ToString() + "|LENGTH|" + length.ToString() + "|";
                        EDILIBDT.Delete(AriaConnection.DbfsConnection, " where rtrim(cedifiltyp)+rtrim(cfilecode)+rtrim(cpartcode)+rtrim(cTranSeq)+rtrim(ceditrntyp) = '" + _ediLibDt.cedifiltyp.ToString().Trim() + _ediLibDt.cfilecode.ToString().Trim() + _ediLibDt.cpartcode.ToString().Trim() + _ediLibDt.ctranseq.ToString().Trim() + _ediLibDt.ceditrntyp.ToString().Trim() + "'");
                        _ediLibDt.ExecuteVFPnsert(AriaConnection.DbfsConnection);
                    }
                }

                lnAccLength += currentLine.Length + Environment.NewLine.Length;
            }
        }
        private void UpdateEDILibDT()
        {
            // MSH - Applying Detail Desing - 11/05/2017 [Start]
            // https://docs.google.com/spreadsheets/d/1Scf1qhhK6UdpUu80QCFfcRmO4-vYuMrMCooemmhpix0/edit?ts=591093c8#gid=0
            // MSH - Applying Detail Desing - 11/05/2017 [End]

            string[] fileLines = _rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            if (fileLines.Length > 0)
            {
                /*
                // Old 
                int start = 0, length = 0;
                EDILIBDT _ediLibDt = new EDILIBDT();
                _ediLibDt.cedifiltyp = 'R';
                _ediLibDt.cfilecode = _FileCode;
                _ediLibDt.ceditrntyp = _TranType;
                _ediLibDt.crejreason = "FFFFF";
                _ediLibDt.cgsrejreas = "FFFFF";
                _ediLibDt.crecfldsep = _FormatType;
                */

                string lcPrtner = "";
                TrnCount = 0;
                lFirst = true;

                //string[] PrevLineFields = fileLines[0].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                string[] PrevLineFields = fileLines[0].Split(new string[] { "," },StringSplitOptions.None);

                // [MSH][Start]
                // Check If Having Any Bad Characters - [Excel File Under With CSV Extension][CSV File With ASCII Codes Bigger Than 127]
                //if (PrevLineFields[0].Any(C => C > 127))
                if (string.Join("", PrevLineFields).Trim().Any(C => C > 127))
                {
                    Mstatus += " Line No: 1 - CSV File Contains Courrupted Data, Please make sure that the file is in CSV format." + ".|";
                    Nrejtran = ++TrnCount;
                    _continue = false;
                    return;
                }
                //string A1 = System.Text.RegularExpressions.Regex.Replace(PrevLineFields[0], @"[^\u0020-\u007F]", String.Empty);
                //string A2 = Encoding.ASCII.GetString(Encoding.ASCII.GetBytes(PrevLineFields[0]));
                // Check If Having Any Bad Characters - [Excel File Under With CSV Extension][CSV File With ASCII Codes Bigger Than 127]
                // [MSH][End]

                // MSH - Applying Detail Design Step #5 #6 [Start]
                _TranType = "";
                string PrevISAKey = null;
                if (ValidateKeyValues(PrevLineFields, 1) != true)
                {
                    Nrejtran = ++TrnCount;
                    return;
                }

                //MSH - Update ISA Key && EDI Transaction Value [Start]
                PrevISAKey = PrevLineFields[0];
                _TranType = PrevLineFields[1];
                //MSH - Update ISA Key && EDI Transaction Value [End]

                List<EDIPD> PrevEDIPD = EDIPD.Select(AriaConnection.DbfsConnection, " where cpartid = '" + PrevISAKey.Trim() + "' AND ceditrntyp = '" + _TranType + "' ");
                // Validating If Transaction Is Registered. [New] [Start]
                if (PrevEDIPD.Count == 0)
                {
                    Mstatus += " Line No: 1 - ISA Key " + PrevISAKey.Trim() + " Is Not Found For EDI Transaction " + _TranType + ".|";
                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }
                // Validating If Transaction Is Registered. [New] [END]

                // MSH - Applying Detail Design Step #9 [Start]
                EDIPD PrevObjFileEdiPd = new EDIPD();
                if (PrevEDIPD.Count > 0)
                {
                    PrevObjFileEdiPd.cmapset = PrevEDIPD[0].cmapset;
                    PrevObjFileEdiPd.cversion = PrevEDIPD[0].cversion;
                    PrevObjFileEdiPd.cpartcode = PrevEDIPD[0].cpartcode;
                }
                // MSH - Applying Detail Design Step #9 [END]

                // MSH - Applying Detail Design Step #10#11 [Start]
                string TempWhereQuery = "where map_set = '" + PrevObjFileEdiPd.cmapset + "' and version='" + PrevObjFileEdiPd.cversion + "' and TRANSACTION_TYPE = '" + _TranType + "' and Direction = 'R'";
                List<TRANSACTION_SEGMENTS_T> PrevTransSegs_T = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, TempWhereQuery);
                // MSH Validating If TRANSACTION_SEGMENTS_T Records Not Returned [New] [Start]
                if (PrevTransSegs_T.Count == 0)
                {
                    Mstatus += " Line No: 1 - Cannot Load Transaction Segments For EDI Transaction " + PrevObjFileEdiPd.ceditrntyp + " For : " + PrevISAKey + " .|";
                    _continue = false;

                    Nrejtran = ++TrnCount;
                    return;
                }
                // MSH Validating If TRANSACTION_SEGMENTS_T Records Not Returned [New] [End]
                string _Transaction_segments_key = "";
                if (PrevTransSegs_T.Count > 0)
                    _Transaction_segments_key = PrevTransSegs_T[0].TRANSACTION_SEGMENTS_KEY.ToString();
                // MSH - Applying Detail Design Step #10#11 [END]

                // MSH - Applying Detail Design Step #12#13#14 [Start]
                TempWhereQuery = "where Transaction_segments_key = '" + _Transaction_segments_key + "' and IS_KEY = 'True'";
                List<TRANSACTION_MAP_T> PrevTransMap_T = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, TempWhereQuery);
                if (PrevTransMap_T.Count == 0)
                {
                    Mstatus += " Line No: 1 - Cannot Load Transaction Map For EDI Transaction " + _TranType + " For Mapset : " + PrevTransSegs_T[0].MAP_SET + 
                               " For Key " + (string.IsNullOrEmpty(_Transaction_segments_key) ? "Empty Key" : _Transaction_segments_key) + ".|";
                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }
                //MSH - Get Field Position From Table To Get TransKey Index. && Validate Get Field Position [Start]
                short PrevFieldOrd = -1;
                if (PrevTransMap_T.Count > 0 && PrevTransMap_T[0].FIELD_ORDER != null && !PrevTransMap_T[0].FIELD_ORDER.HasValue)
                {
                    PrevFieldOrd = -1;
                    Mstatus += " Line No: 1 - Transaction Key Field Order Is Empty For EDI Transaction : " + PrevTransSegs_T[0].TRANSACTION_TYPE + 
                               " For Mapset : " + PrevTransSegs_T[0].MAP_SET + ".|";

                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }
                if (PrevTransMap_T.Count > 0 && PrevTransMap_T[0].FIELD_ORDER.HasValue)
                    PrevFieldOrd = PrevTransMap_T[0].FIELD_ORDER.Value;
                //MSH - Get Field Position From Table To Get TransKey Index. && Validate Get Field Position [End]

                //MSH - Get Field Position From Table & Validate Its Not Less Than Zero [Start]
                if (PrevFieldOrd < 1)
                {
                    Mstatus += " Line No: 1 - Transaction Key Field Order Is Less Than Zero For EDI Transaction : " + PrevTransSegs_T[0].TRANSACTION_TYPE +
                               " For Mapset : " + PrevTransSegs_T[0].MAP_SET + ".|";
                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }
 
                if (PrevFieldOrd > PrevLineFields.Length)
                {
                    Mstatus += " Line No: 1 - Transaction Key Field Order Position " + PrevFieldOrd +  " For EDI Transaction : " + PrevTransSegs_T[0].TRANSACTION_TYPE +
                               " For Mapset : " + PrevTransSegs_T[0].MAP_SET + " Is Bigger Than Num Of Columns In CSV File.|";
                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }
                //MSH - Get Field Position From Table & Validate Its Not Less Than Zero [End]

                string PrevTransKeyIndex = PrevLineFields[PrevFieldOrd-1];
                if (PrevTransKeyIndex.Trim() == "" )
                {
                    Mstatus += " Line No: 1 - Transaction Key Index Value is Empty In Position: " + PrevFieldOrd + " For EDI Transaction " + PrevObjFileEdiPd.ceditrntyp + 
                               " For Mapset : " + PrevTransSegs_T[0].MAP_SET + ".|";
                    _continue = false;
                    Nrejtran = ++TrnCount;
                    return;
                }

                // MSH - Applying Detail Design Step #12#13#14 [END]

                // MSH - Applying Detail Design Step #5 #6 [End]

                //OLD
                //string prevLineKey = PrevLineFields[0].Trim().ToUpper() + PrevLineFields[1].Trim().ToUpper() + PrevLineFields[2].Trim().ToUpper();

                // MSH - Applying Detail Design Step #15 [Start]
                string PrevLineKey = PrevISAKey.Trim().ToUpper() + _TranType.Trim().ToUpper() + PrevTransKeyIndex.Trim().ToUpper();
                // MSH - Applying Detail Design Step #15[End]

                int startrec = 0;
                for (int lineNo = 0; lineNo < fileLines.Length; lineNo++)
                {
                    string[] LineFields = fileLines[lineNo].Split(new string[] { "," }, StringSplitOptions.None);

                    // MSH - Adding Documentation - Validateing If ISAKey , Transaction Type Are Not Empty [Start][End]
                    if (ValidateKeyValues(LineFields, lineNo + 1) != true)
                    {
                        Nrejtran = ++TrnCount;
                        return;
                    }

                    // MSH - Applying Detail Design Step #18#19#20 [Start]
                    string CurISAKey = LineFields[0];
                    
                    EDIPD CurLoopObjFileEdiPd = new EDIPD();
                    // Get EDI Transaction
                    _TranType = LineFields[1];
                    CurLoopObjFileEdiPd.ceditrntyp = _TranType;


                    List<EDIPD> CurEDIPD = EDIPD.Select(AriaConnection.DbfsConnection, " where cpartid = '" + CurISAKey.Trim() + "' AND ceditrntyp = '" + _TranType + "' ");
                    // Validating If Transaction Is Registered From Current ISAKey. [New] [Start]
                    if (CurEDIPD.Count == 0)
                    {
                        Mstatus += " Line No:" + lineNo + " - ISA Key: " + CurISAKey.Trim() + " Is Not Found For EDI Transaction: " + CurLoopObjFileEdiPd.ceditrntyp + ".|";
                        _continue = false;
                        // I Should Check Next Transaction .. No Need To Continue.
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    else if (CurEDIPD.Count > 0)
                    {
                        CurLoopObjFileEdiPd.cmapset = CurEDIPD[0].cmapset;
                        CurLoopObjFileEdiPd.cversion = CurEDIPD[0].cversion;
                        CurLoopObjFileEdiPd.cpartcode = CurEDIPD[0].cpartcode;
                    }
                    // Validating If Transaction Is Registered From Current ISAKey. [New] [END]

                    // MSH - Applying Detail Design Step #18#19#20 [End]

                    // MSH - Applying Detail Design Step #21#22 [Start]
                    TempWhereQuery = "where map_set = '" + CurLoopObjFileEdiPd.cmapset + "' and version='" + CurLoopObjFileEdiPd.cversion + "' and TRANSACTION_TYPE = '" + CurLoopObjFileEdiPd.ceditrntyp + "' and Direction = 'R'";
                    List<TRANSACTION_SEGMENTS_T> CurTransSeg_T = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, TempWhereQuery);
                    // MSH - Validating If TRANSACTION_SEGMENTS_T Records Not Returned [New] [Start]
                    if (CurTransSeg_T.Count == 0)
                    {
                        Mstatus += " Line No:" + lineNo + " - Cannot Load Transaction Segments For EDI Transaction " + CurLoopObjFileEdiPd.ceditrntyp + " For : " + CurLoopObjFileEdiPd.cmapset + " .|";
                        _continue = false;
                        //continue;

                        Nrejtran = ++TrnCount;
                        return;
                    }
                    // MSH - Validating If TRANSACTION_SEGMENTS_T Records Not Returned [New] [End]
                    else if (CurTransSeg_T.Count > 0)
                             _Transaction_segments_key = CurTransSeg_T[0].TRANSACTION_SEGMENTS_KEY.ToString();
                    // MSH - Applying Detail Design Step #21#22 [End]

                    // MSH - Applying Detail Design Step #23#24#25 [Start]
                    TempWhereQuery = "where Transaction_segments_key = '" + _Transaction_segments_key + "' and IS_KEY = 'True'";
                    List<TRANSACTION_MAP_T> CurTransaction_Map_T = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, TempWhereQuery);
                    // MSH - Validating If TRANSACTION_MAP_T Records Not Returned [New] [Start]
                    if (CurTransaction_Map_T.Count == 0)
                    {
                        Mstatus += " Line No:" + lineNo + " - Cannot Load Transaction Map For EDI Transaction " + CurLoopObjFileEdiPd.ceditrntyp + 
                                   " For Mapset : " + CurLoopObjFileEdiPd.cmapset + " For Key : " + _Transaction_segments_key + ".|";
                        _continue = false;
                        //continue;

                        Nrejtran = ++TrnCount;
                        return;
                    }
                    // MSH - Validating If TRANSACTION_MAP_T Records Not Returned [New] [End]

                    // MSH - Get & Validate If Current Field Order [New] [Start]
                    short Curfieldord = -1;
                    if (CurTransaction_Map_T.Count > 0 && CurTransaction_Map_T[0].FIELD_ORDER != null && !CurTransaction_Map_T[0].FIELD_ORDER.HasValue)
                    {
                        Curfieldord = -1;
                        Mstatus += " Line No:" + lineNo + " - Transaction Key Field Order Is Empty For EDI Transaction " + CurLoopObjFileEdiPd.ceditrntyp + 
                                   " For Mapset : " + CurLoopObjFileEdiPd.cmapset + 
                                   " For Key " + (string.IsNullOrEmpty(_Transaction_segments_key) ? "Empty Key" : _Transaction_segments_key) + ".|";
                        _continue = false;
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    Curfieldord = CurTransaction_Map_T[0].FIELD_ORDER.Value;
                    //MSH - Get Field Position From Table & Validate Its Not Less Than Zero [Start]
                    if (Curfieldord < 1)
                    {
                        Mstatus += " Line No: 0 - Transaction Key Field Order Is Less Than Zero For EDI Transaction : " + CurLoopObjFileEdiPd.ceditrntyp +
                                   " For Mapset : " + CurTransSeg_T[0].MAP_SET + ".|";
                        _continue = false;
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    if (Curfieldord > LineFields.Length)
                    {
                        Mstatus += " Line No:" + lineNo + " - Transaction Key Field Order Position " + Curfieldord + " For EDI Transaction : " + CurLoopObjFileEdiPd.ceditrntyp +
                                   " For Mapset : " + CurTransSeg_T[0].MAP_SET + " Is Bigger Than Num Of Columns In CSV File.|";
                        _continue = false;
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    //MSH - Get Field Position From Table & Validate Its Not Less Than Zero [End]

                    // MSH - Get & Validate If Current Field Order [New] [End] 

                    // MSH - Validating Third Key [Start]
                    string CurTransKeyIndex = LineFields[Curfieldord-1];

                    if (string.IsNullOrEmpty(CurTransKeyIndex.Trim().ToUpper()))
                    {
                        Mstatus += " Line No:" + lineNo + " - Transaction Key Index Value is Empty In Position: " + Curfieldord + 
                                   " For EDI Transaction " + CurLoopObjFileEdiPd.ceditrntyp + " For Mapset : " + CurLoopObjFileEdiPd.cmapset + " .|";
                        _continue = false;
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    // MSH - Validating Third Key [End]

                    // MSH - Applying Detail Design Step #23#24#25 [End]

                    //string Key = LineFields[0].Trim().ToUpper() + LineFields[3].Trim().ToUpper() + LineFields[1].Trim().ToUpper();
                    
                    // OLD
                    //string Key = LineFields[0].Trim().ToUpper() + LineFields[1].Trim().ToUpper() + LineFields[2].Trim().ToUpper();

                    // MSH - Applying Detail Design Step #27 [End]
                    string Key = CurISAKey.Trim().ToUpper() + _TranType.Trim().ToUpper() + CurTransKeyIndex.Trim().ToUpper();
                    // MSH - Applying Detail Design Step #27 [End]

                    if (Key.Equals(PrevLineKey) && lineNo != fileLines.Length - 1) continue;



                    // MSH - Applying Detail Design Step #28 [Start]
                    EDILIBDT _ediLibDt = new EDILIBDT();
                    _ediLibDt.cedifiltyp = 'R';
                    _ediLibDt.cfilecode = _FileCode;
                    _ediLibDt.crejreason = "FFFFF";
                    _ediLibDt.cgsrejreas = "FFFFF";
                    _ediLibDt.crecfldsep = _FormatType;
                    // MSH - Applying Detail Design Step #28 [End]
                    
                    //Update Fox Table ediLibDt

                    //lcPrtner = prevline// get first column in prevline
                    lcPrtner = PrevLineFields[0];

                    // OLD
                    //var _ediAcPrtRow = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartner = '" + lcPrtner.Trim() + "'");

                    // MSH - Applying Detail Design Step #30 [Start]
                    var _ediAcPrtRow = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartcode = '" + PrevObjFileEdiPd.cpartcode + "'");
                    // MSH - Validate If Partner Exist In EDIACPRT DBF [Start]
                    if (_ediAcPrtRow.Count == 0)
                    {
                        Mstatus += " Line No:" + lineNo + " - Cannot Find Partner : " + PrevObjFileEdiPd.cpartcode + " In Network.|";
                        _continue = false;
                        Nrejtran = ++TrnCount;
                        return;
                    }
                    // MSH - Validate If Partner Exist In EDIACPRT DBF [END]
                    // MSH - Applying Detail Design Step #30 [END]
                    try
                    {
                        //OLD
                        //_ediLibDt.cpartcode = _ediAcPrtRow[0].cpartcode;

                        // MSH - Applying Detail Design Step #31 [Start]
                        _ediLibDt.cpartcode = PrevObjFileEdiPd.cpartcode;
                        // MSH - Applying Detail Design Step #31 [END]

                        ValidateNetwork(_ediLibDt.cpartcode, lcPrtner, lineNo);
                    }
                    catch
                    {
                        //MStatus
                        Mstatus += " Line no:" + lineNo + " Partner : " + lcPrtner.Trim() + " is not EDI Partnar.|";
                        //ErrorMsg = "No lines for Account# " + lcPrtner.Trim();
                        _continue = false;
                    }

                    // insert transaction in edilibdt with start and end pos and update the _ediLibDt.cediref _ediLibDt.ceditranno
                    // with second column value in prevline

                    int endrec = lineNo == fileLines.Length - 1 && Key.Equals(PrevLineKey) ? lineNo : lineNo - 1;
                    _ediLibDt.mtrantext = "START|" + (startrec).ToString() + "|END|" + endrec.ToString() + "|";
                    
                    // OLD
                    // _ediLibDt.cediref = PrevLineFields[2];

                    // MSH - Applying Detail Design Step #32 [Start]
                    _ediLibDt.cediref = PrevTransKeyIndex;
                    // MSH - Applying Detail Design Step #32 [END]

                    TrnCount += 1;
                    _ediLibDt.ctranseq = TrnCount.ToString().Trim();

                    // MSH - Applying Detail Design Step #35 [Start]
                    _TranType = PrevLineFields[1].Trim();
                    _ediLibDt.ceditrntyp = _TranType;
                    // MSH - Applying Detail Design Step #35 [END]

                    if (_ediLibDt.cpartcode != null)
                    {
                        // MSH - Adding Documentation [Start]
                        // MSH - Update = Delete + Insert ==>>> Delete Any Records Related To Current Files Then Insert New Record.
                        // MSH - Adding Documentation [END]

                        _ediLibDt.ExecuteVFPnsert(AriaConnection.DbfsConnection);
                    }


                    //Update Previous Line fields, Key & Start Position to be used in the next loop.
                    if (lineNo != fileLines.Length - 1)
                        PrevLineKey = Key;
                    PrevLineFields = LineFields;
                    // MSH - Updating Third Key Value [New][Start]
                    PrevTransKeyIndex = CurTransKeyIndex;
                    // MSH - Updating Third Key Value [New][End]
                    startrec = lineNo;

                    // MSH - Adding Documentation [Start]
                    // MSH - Check If Current Line Is Last Line And Current Data Not Saved.
                    // MSH - Adding Documentation [END]

                    if (lineNo == fileLines.Length - 1 && !Key.Equals(PrevLineKey))
                    {
                        lcPrtner = LineFields[0];

                        //OLD
                        //_ediAcPrtRow = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartner = '" + lcPrtner.Trim() + "'");

                        // MSH - Applying Detail Design Step #36 [Start]
                        _ediAcPrtRow = EDIACPRT.Select(AriaConnection.DbfsConnection, " where cPartcode = '" + CurLoopObjFileEdiPd.cpartcode + "'");
                        // MSH - Validate If Partner Exist In EDIACPRT DBF [New][Start]
                        if (_ediAcPrtRow.Count == 0)
                        {
                            Mstatus += "Line No:" + lineNo + " - Cannot Find Partner : " + CurLoopObjFileEdiPd.cpartcode + " In Network.|";
                            _continue = false;
                            Nrejtran = ++TrnCount;
                            return;
                        }
                        // MSH - Validate If Partner Exist In EDIACPRT DBF [New][END]
                        // MSH - Applying Detail Design Step #36 [END]
                        try
                        {
                            //OLD
                            //_ediLibDt.cpartcode = _ediAcPrtRow[0].cpartcode;

                            // MSH - Applying Detail Design Step #37 [Start]
                            _ediLibDt.cpartcode = CurLoopObjFileEdiPd.cpartcode;
                            // MSH - Applying Detail Design Step #37 [END]
                        }
                        catch
                        {
                            //ErrorMsg = "No lines for Account# " + lcPrtner.Trim();
                            Mstatus += " Line no:" + lineNo + " Partner : " + lcPrtner.Trim() + " is not EDI Partnar.|";
                            _continue = false;
                        }
                        _ediLibDt.mtrantext = "START|" + (lineNo).ToString() + "|END|" + lineNo.ToString() + "|";
                        TrnCount += 1;
                        _ediLibDt.ctranseq = TrnCount.ToString().Trim();
                        
                        //OLD
                        //_ediLibDt.cediref = LineFields[2];

                        // MSH - Applying Detail Design Step #38 #39 #40 [Start]
                        _ediLibDt.cediref = CurTransKeyIndex;
                        _TranType = LineFields[1].Trim();
                        _ediLibDt.ceditrntyp = _TranType;
                        // MSH - Applying Detail Design Step #38 #39 #40 [END]
                        if (_ediLibDt.cpartcode != null)
                        {
                            
                            _ediLibDt.ExecuteVFPnsert(AriaConnection.DbfsConnection);
                        }
                    }
                }
                //Check if there are any errors while reciving any file dim the whole file.
                if (_continue == false)
                    Nrejtran = TrnCount;
            }
            else
            {
                //ErrorMsg = "CSV File is Empty!";
                //Nrejtran = 2;
                Nrejtran = ++TrnCount;
                Mstatus += "CSV File is Empty!";
                _continue = false;
            }
            
        }
        private bool ValidateKeyValues(string[] LineFields, int lineNo)
        {
            bool flag = true;
            if (string.IsNullOrEmpty(LineFields[0].Trim().ToUpper()))
            {
                // OLD
                //Mstatus += " Line no:" + lineNo + "Warehouse Value is Empty.|";

                // MSH - Applying Detail Design Step #26 [Start]
                Mstatus += " Line No:" + lineNo + "ISA Key Value Is Empty.|";
                // MSH - Applying Detail Design Step #26 [End]

                flag = false;
                _continue = false;
            }
            if (string.IsNullOrEmpty(LineFields[1].Trim().ToUpper()))
            {
                // OLD
                //Mstatus += " Line no:" + lineNo + "Account Value is Empty.|";

                // MSH - Applying Detail Design Step #26 [Start]
                Mstatus += " Line No:" + lineNo + "Transaction Type Is Empty.|";
                // MSH - Applying Detail Design Step #26 [End]

                flag = false;

            }
            /*
            MSH - Commented [Start]
            if (string.IsNullOrEmpty(LineFields[2].Trim().ToUpper()))
            {
                Mstatus += " Line no:" + lineNo + "Pick-Ticket Number Value is Empty.|";
                flag = false;
            }
            MSH - Commented [END]
            */
            return flag;
        }
        private void ValidateNetwork(string cpartcode,string lcPrtner, int lineNo)
        {
            var _ediPhRow = EDIPH.Select(AriaConnection.DbfsConnection, " where cpartcode = '" + cpartcode + "'");
            if (_ediPhRow != null)
            {
                //Check Partnar on Network
                var _ediNetRow = EDINET.Select(AriaConnection.DbfsConnection, " where cnetwork = '" + _ediPhRow[0].cnetwork + "'");
                if (_ediNetRow != null)
                {
                    if (_ediNetRow[0].cedityps.ToString().Trim().ToUpper() != "CSV")
                    {
                        Mstatus += " Line no:" + lineNo + " Network " + _ediNetRow[0].cnetname.Trim() + " for Partner:" + lcPrtner.Trim() + " is not a CSV format network.|";
                        _continue = false;
                    }
                }
                else
                {
                    //MStatus
                    Mstatus += " Line no:" + lineNo + " There is no network assigned to partner : " + lcPrtner.Trim() + ".|";
                    _continue = false;
                }

            }
            else
            {
                //MStatus
                Mstatus += " Line no:" + lineNo + " Partner : " + lcPrtner.Trim() + " is not EDI Partner|";
                _continue = false;
            }
     
        }
        private void ReadStruRec(string structureLine, string ReceivedFilePath)
        {

            //Derby- Determine File Extension "CSV" from FilePath [Start]
            //if (structureLine.StartsWith("COMMA"))
            //    _FormatType = 'C';
            //else if (structureLine.StartsWith("FIXED"))
            //    _FormatType = 'F';
            //else if (structureLine.StartsWith("CSV"))
            //    _FormatType = 'S';
            //else
            //{
            //    ErrorMsg = "Couldn't determine Freeway file type " + _rawFileContents.Substring(0, 5) + " !";
            //    _continue = false;
            //    return;
            //}
            //_StartSeg = structureLine.Substring(24, 5);

            if (Path.GetExtension(ReceivedFilePath).Replace(".", "") == "CSV")
            {
                _FormatType = 'S';
                //_StartSeg = structureLine.Substring(24, 5);            ?????
            }
            else
            {
                if (structureLine.StartsWith("COMMA"))
                    _FormatType = 'C';
                else if (structureLine.StartsWith("FIXED"))
                    _FormatType = 'F';
                else if (structureLine.StartsWith("CSV"))
                    _FormatType = 'S';
                else
                {
                    ErrorMsg = "Couldn't determine Freeway file type " + _rawFileContents.Substring(0, 5) + " !";
                    _continue = false;
                    return;
                }

                _StartSeg = structureLine.Substring(24, 5);
            }
            //Derby- Determine File Extension "CSV" from FilePath [Start]
            

        }

        private bool ReadEdiFile()
        {
            _rawFileContents = File.ReadAllText(ReceivedFilePath);
            if (_rawFileContents.Length == 0)
            {
                ErrorMsg = "Raw Edi file " + ReceivedFilePath + " is empty !";
                _continue = false;
                return false;
            }
            return true;
        }

        private void DeleteTrans(string mAccount, EDILIBDT _EdiLDitem)
        {
            if (_EdiLDitem.ceditranno.Trim().HasValue())
            {
                EDISOHD.Delete(AriaConnection.DbfsConnection, " where Account+Order = '" + mAccount + _EdiLDitem.ceditranno + "'");
                EDISODT.Delete(AriaConnection.DbfsConnection, " where Account+Order = '" + mAccount + _EdiLDitem.ceditranno + "'");
                edipkinf.Delete(AriaConnection.DbfsConnection, " where ORDER = '" + _EdiLDitem.ceditranno + "'");
                orderchg.Delete(AriaConnection.DbfsConnection, " where CORDTYPE+ORDER = '" + "T" + _EdiLDitem.ceditranno + "'");
                ORDHDR.Delete(AriaConnection.DbfsConnection, " where CORDTYPE+ORDER = '" + "T" + _EdiLDitem.ceditranno + "'");
                ORDLINE.Delete(AriaConnection.DbfsConnection, " where CORDTYPE+ORDER = '" + "T" + _EdiLDitem.ceditranno + "'");
                EDINOTE.Delete(AriaConnection.DbfsConnection, " where TYPE+KEY = '" + "B" + ("T" + _EdiLDitem.ceditranno).PadRight(20) + "'");
            }
        }

        private string GetSeq()
        {
            var sequenceList = sequence.Select(AriaConnection.DbfsConnection, " where cSeq_Type = 'CFILECODE'");
            _Sequence = sequenceList != null && sequenceList.Count > 0 ? sequenceList[0] : null;
            decimal Seq = _Sequence.nseq_no.Value + 1;
            string SeqPrefx = (((int)_Sequence.cseq_chr) == 0 ? "" : "Z" + ((int)_Sequence.cseq_chr).ToString());
            string cSeq = Seq.ToString().Substring(0, Math.Min(Seq.ToString().Length, 6 - SeqPrefx.Length)).PadLeft(6 - SeqPrefx.Length, '0');
            string sequencestring = SeqPrefx + cSeq;
            return sequencestring;      
        }

        private string GetEDIInboxPath()
        {
            string _ediPath = AriaConnection.Aria27SysFilesPath;
            _ediPath = _ediPath.EndsWith("\\") ? _ediPath : _ediPath + "\\";
            int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA27\\SYSFILES\\");
            if (_a27WordPostion > 0)
            {
                _ediPath = _ediPath.Remove(_a27WordPostion) + "Aria3Edi\\EDI\\Inbox\\";
                return _ediPath;
            }
            return null;
        }

        private bool ifNeedSeq(string cFileCode, string cNetWork)
        {
            int _underScoreSep = cFileCode.ToUpper().IndexOf("_");
            if (_underScoreSep > 0)
            {
                cFileCode = cFileCode.Remove(_underScoreSep);
                if (cFileCode.Trim() == cNetWork.Trim())
                {
                    return true;
                }
            }
            return false;
        }

        private string GetEDIBasePath()
        {
            string _ediPath = AriaConnection.Aria27SysFilesPath;
            _ediPath = _ediPath.EndsWith("\\") ? _ediPath : _ediPath + "\\";
            //Derby-Change Sysfiles directory from Aria27 to Aria4xp [Start]
            //int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA27\\SYSFILES\\");
            int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA4XP\\SYSFILES\\");
            //Derby-Change Sysfiles directory from Aria27 to Aria4xp [End]
            if (_a27WordPostion > 0)
            {
                _ediPath = _ediPath.Remove(_a27WordPostion) + "Aria3Edi\\EDI\\";
                return _ediPath;
            }
            return null;
        }
        #endregion
    }
}

