using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.IO;


namespace X12Translator
{
    public class SENDTRANSACTIONS
    {
        public string ErrorMsg { get; set; }
        public int FileHandler { get; set; }
        public string TransactionType { get; set; }
        public string MapSet { get; set; }
        public string MapVersion { get; set; }
        public string FileFormat { get; set; }
        public string DateFormat { get; set; }
        public string FileSegments { get; set; }
        public List<string> FieldsArray { get; set; }
        public Dictionary<string, string> VariablesDictionary { get; set; }
        protected List<TRANSACTION_SEGMENTS_T> _segmentsList;
        protected List<TRANSACTION_MAP_T> _segmentsMappingList;
        protected bool _continue;

        public SENDTRANSACTIONS()
        {
            VariablesDictionary = new Dictionary<string, string>();
            FieldsArray = new List<string>();
            _continue = true;
        }

        public void Documentation()
        {

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

        private void FillSegmentsData()
        {
            string Segmentswhere = " WHERE [TRANSACTION_SEGMENTS_T].[DIRECTION]='S' " +
          " AND [TRANSACTION_SEGMENTS_T].[TRANSACTION_TYPE] = '" + this.TransactionType + "'" +
          " AND [TRANSACTION_SEGMENTS_T].[MAP_SET]='" + MapSet + "'" +
          " AND [TRANSACTION_SEGMENTS_T].VERSION ='" + MapVersion + "'" +
          " ORDER BY [SEGMENT_ORDER]";
            _segmentsList = TRANSACTION_SEGMENTS_T.Select(AriaConnection.EdiMappingConnection, Segmentswhere);
            if (_segmentsList.Count == 0)
            {
                ErrorMsg = "Couldn't find data in TRANSACTION_SEGMENTS_T for Transaction:" + TransactionType + " Mapset:" + MapSet + " version:" + MapVersion;
                _continue = false;
                return;
            }
            string segmentsKeys = "";
            _segmentsList.ForEach(segment => segmentsKeys = segmentsKeys + segment.TRANSACTION_SEGMENTS_KEY + ",");
            segmentsKeys = segmentsKeys.EndsWith(",") ? segmentsKeys.Remove(segmentsKeys.Length - 1) : segmentsKeys;
            _segmentsMappingList = TRANSACTION_MAP_T.Select(AriaConnection.EdiMappingConnection, " where TRANSACTION_SEGMENTS_KEY in (" + segmentsKeys + ") order by TRANSACTION_SEGMENTS_KEY,FIELD_ORDER");
            if (_segmentsMappingList.Count == 0)
            {
                ErrorMsg = "Couldn't find data in TRANSACTION_MAP_T for Transaction:" + TransactionType + " Mapset:" + MapSet + " version:" + MapVersion;
                _continue = false;
                return;
            }
        }

    }
}