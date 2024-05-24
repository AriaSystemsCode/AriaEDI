using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data;
using System.Data.Common;
using System.IO;
using Freeway;


namespace Freeway
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

        bool _continue;
        string _FileCode;
        EDILIBHD _ediLibHD;
        sequence _Sequence;
        int lnAccLength = 0;
        string _TranType = "850";
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
        int TrnCount;
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
                ReadFreeWayFile(ReceivedFilePath);
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                _continue = false;
                return;
            }
        }

        private void ReadFreeWayFile(string ReceivedFilePath)
        {
            ReadEdiFile();
            ReadStruRec(_rawFileContents.Split(new string[] { Environment.NewLine }, StringSplitOptions.None)[0]);
            UpdateEDILibDT();
            ArchiveFile();
            DB.updateEdiLHStatus(TrnCount+1,_FileCode);
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

        private void UpdateEDILibDT()
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

        private void ReadStruRec(string structureLine)
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
            int _a27WordPostion = _ediPath.ToUpper().IndexOf("ARIA27\\SYSFILES\\");
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

