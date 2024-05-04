using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.IO;


namespace CSVTranslator
{
    public class SENDTRANSACTIONS
    {
        public string ErrorMsg { get; set; }
        public int FileHandler { get; set; }
        public string TransactionType { get; set; }
        public string MapSet { get; set; }
        public string MapVersion { get; set; }
        public FreeWayFileFormat FileFormat { get; set; }
        public string DateFormat { get; set; }
        public string FileSegments { get; set; }
        public List<string> FieldsArray { get; set; }
        public Dictionary<string, object> VariablesDictionary { get; set; }
        protected List<TRANSACTION_SEGMENTS_T> _segmentsList;
        protected List<TRANSACTION_MAP_T> _segmentsMappingList;
        protected bool _continue;

        public SENDTRANSACTIONS()
        {
            VariablesDictionary = new Dictionary<string, object>();
            FieldsArray = new List<string>();
            _continue = true;
        }

        public void Documentation()
        {

        }

        public virtual void DO(string lcTransactionFile, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany)
        {

            //FileFormat = "COMMA";
            //DateFormat = "DD/MM/YYYY";
            //FileSegments = "HEAD LINE VAT  TLR                 " 810;
            //FileSegments = "HEAD SUNITLINE TLR                 " 856;

            //SqlCommand ConnectionString = GetConnection( ClientId,  ActiveCompany);

            // ** Create and open outgoing file
            //FileInfo FileHandler = new FileInfo(OutgoingFile);
            //StreamWriter FileStreem = FileHandler.CreateText();

            // ** Write Structure record
            //WriteStructureRecord(FileStreem);

            // ** Loop AriaXML file and fill variables
            //Dictionary["XSHIPAMT"] = 100;
            //WriteLoop(MapSet, MapVersion, "H-01", ConnectionString, FileStreem);

            //WriteLoop(MapSet, MapVersion, "D-01", ConnectionString, FileStreem);


            //WriteLoop(MapSet, MapVersion, "T-01", ConnectionString, FileStreem);

            //FileStreem.Close();
        }

        public void init(string ClientID, string ActiveCompany)
        {
            try
            {
                if (!AriaConnection.init(ClientID, ActiveCompany))
                {
                    ErrorMsg = AriaConnection.ErrorMsg;
                    return;
                }
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                return;
            }
            FillSegmentsData();
        }

        public void WriteStructureRecord(StreamWriter FileStreem)
        {
            string lcFileLine = FileFormat.ToString().PadRight(5) + DateFormat + "hh:mm:ss" + FileSegments + "NY";
            FileStreem.WriteLine(lcFileLine);
        }

        private void FillSegmentsData()
        {
            string Segmentswhere = " WHERE [TRANSACTION_SEGMENTS_T].[DIRECTION]='S' " +
          " AND [TRANSACTION_SEGMENTS_T].[TRANSACTION_TYPE] = '" + this.TransactionType + "'" +
          " AND [TRANSACTION_SEGMENTS_T].[MAP_SET]='" + MapSet + "'" +
          " AND [TRANSACTION_SEGMENTS_T].VERSION ='" + MapVersion + "'" +
          " ORDER BY [SEGMENT_ORDER]";
            _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.ClientMasterConnection, Segmentswhere);
            if (_segmentsList.Count == 0)
            {
                ErrorMsg = "Couldn't find data in TRANSACTION_SEGMENTS_T for Transaction:" + TransactionType + " Mapset:" + MapSet + " version:" + MapVersion;
                _continue = false;
                return;
            }
            string segmentsKeys = "";
            _segmentsList.ForEach(segment => segmentsKeys = segmentsKeys + segment.TRANSACTION_SEGMENTS_KEY + ",");
            segmentsKeys = segmentsKeys.EndsWith(",") ? segmentsKeys.Remove(segmentsKeys.Length - 1) : segmentsKeys;
            _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.ClientMasterConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
            if (_segmentsMappingList.Count == 0)
            {
                ErrorMsg = "Couldn't find data in TRANSACTION_MAP_T for Transaction:" + TransactionType + " Mapset:" + MapSet + " version:" + MapVersion;
                _continue = false;
                return;
            }
        }

        public void WriteLoop(string MapSet, string MapVersion, string LoopId, SqlCommand ConnectionString, StreamWriter FileStreem)
        {
            var currentLoopList = _segmentsList.Where(_segment => _segment.LOOP_ID == LoopId).ToList();
            foreach (TRANSACTION_SEGMENTS_T SegmentObj in currentLoopList)
            {
                string mapWhere = " WHERE [TRANSACTION_SEGMENTS_KEY]='" + SegmentObj.TRANSACTION_SEGMENTS_KEY + "' ORDER BY [FIELD_ORDER]";
                var Segments_Map_list = _segmentsMappingList.Where(_segmentMap => _segmentMap.TRANSACTION_SEGMENTS_KEY == SegmentObj.TRANSACTION_SEGMENTS_KEY).OrderBy(_segmentMap => _segmentMap.FIELD_ORDER);

                FieldsArray.Clear();

                short currentAfield = 0;
                //bool valueAdded = false;
                foreach (var SegmentMap in Segments_Map_list)
                {
                    if (SegmentMap.FIELD_ORDER.Value == currentAfield)
                    {
                        if (VariablesDictionary.ContainsKey(SegmentMap.VALUE.ToUpper().Trim()))
                            FieldsArray[FieldsArray.Count - 1] = VariablesDictionary[SegmentMap.VALUE.ToUpper().Trim()].ToString();
                    }
                    else
                    {
                        for (int x = SegmentMap.FIELD_ORDER.Value; x - 1 > currentAfield; x--)
                            FieldsArray.Add(null);
                        if (VariablesDictionary.ContainsKey(SegmentMap.VALUE.Trim()))
                            FieldsArray.Add(VariablesDictionary[SegmentMap.VALUE.Trim()].ToString());
                        else
                            FieldsArray.Add(null);
                    }
                    currentAfield = SegmentMap.FIELD_ORDER.Value;
                }
                WriteRecord(FileStreem);
            }
        }

        public void WriteRecord(StreamWriter FileStreem)
        {
            string lcFileLine = "";
            for (int i = 0; i < FieldsArray.Count; i++)
            {
                if (FileFormat == FreeWayFileFormat.CSV)
                {
                    lcFileLine = lcFileLine + "\"" + FieldsArray[i] + "\"";
                }
                else
                {
                    lcFileLine = lcFileLine + FieldsArray[i];
                }

                if ((FileFormat == FreeWayFileFormat.COMMA || FileFormat == FreeWayFileFormat.CSV) && i != FieldsArray.Count - 1)
                {
                    lcFileLine = lcFileLine + ",";
                }
            }
            FileStreem.WriteLine(lcFileLine);
        }

        public void WriteEndOfFileRecord()
        {

        }
    }
}