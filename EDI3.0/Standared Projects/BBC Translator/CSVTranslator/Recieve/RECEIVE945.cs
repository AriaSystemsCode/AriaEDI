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
    public class RECEIVE945 : RecieveBase
    {
        #region Properties
        #endregion

        #region Private Variables
        #endregion

        #region Methods

        public RECEIVE945():base()
        {
            // Intialize Transaction Type With 945 [20/06/2017][MSH][Start]
            TransactionType = "945";
            // Intialize Transaction Type With 945 [20/06/2017][MSH][End]
        }

        /// <summary>
        ///  For documention related to fix# and functionalty of the program.
        /// </summary>
        protected override void Documentation() { }

        /// <summary>
        /// Main method for receiveing 850 files 
        /// </summary>
        /// <param name="lcFileCode">FileCode saved in Edi tables</param>
        /// <param name="lcFilter">Filter for targeted POS in the selected file</param>
        /// <param name="notused">NOT Used paramter -- just for EDI compatibility like old EDI Code</param>
        public override void DO(bool notused, string lcFileCode, string lcFilter)
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

                ReadEdiFile();
                if (!_continue)
                    return;


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
                var _tempEdiPd = EDIPD.Select(AriaConnection.DbfsConnection, "where cPartCode = '" + _eDILIBDT_List[0].cpartcode.Trim() + "' and ceditrntyp = '"+TransactionType+"'");
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
                        ErrorMsg = "Couldn't determine Freeway file type " + _rawFileContents.Substring(0, 5) + " !";
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
                string tempdb = CreateTempDatabase();
                if(tempdb==null)
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
            
        }

        /// <summary>
        /// Write data for processed PO in PO SQL
        /// </summary>
        private void UpdateTables()
        {
            bool insertSucessed = true;
            // MSH
            /*
            string sqlcmdstring = "";
            L_SHP_Header.ForEach(ShpHeader => sqlcmdstring += "'" + ShpHeader.PartnerID + "',");
            sqlcmdstring = sqlcmdstring.EndsWith(",") ? sqlcmdstring.Remove(sqlcmdstring.Length - 1) : sqlcmdstring;
            ShippingOrderHeader_T.Delete(AriaConnection.CompanyConnection, " where PartnerID in(" + sqlcmdstring + ")");
            L_SHP_Header.ForEach(ShpHeader => insertSucessed = ShpHeader.ExecuteSqlInsert(AriaConnection.CompanyConnection) > 0);
            if (!insertSucessed)
            {
                ErrorMsg = "Error Inserting into ShippingOrderHeader_T Tables !";
                _continue = false;
                return;
            }
            L_SHP_Header.ForEach(ShpHeader => _extractionKey.Add(ShpHeader.PartnerID));
            */
            /*
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
            */
        }


        public bool checkforcartonsmarksandnumber(string Temp_DB_Name, string table_name, string values, out string CartonOID)
        {
            bool answer = false;
            CartonOID = null;
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            sb.InitialCatalog=Temp_DB_Name;
            string connectionString = sb.ConnectionString;
            string selectStatment = "";
            selectStatment = "select * from " + table_name + " where CartonSerialNumber = '" + values + "'";
            SqlConnection con = new SqlConnection(connectionString);
            con.Open();
            SqlCommand comd = new SqlCommand(selectStatment, con);
            try
            {
                using (SqlDataReader reader = comd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        CartonOID = "'" + reader["OID"].ToString() + "'" ;
                        answer = true;
                    }
                }
            }
            catch (Exception ex)
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = ex.Message;
            }
            finally
            {
                con.Close();
            }
            return answer;
        }
        
        
        protected override void Import(string tempdb)
        {
            string ShippingOrderHeader_T_guid = Generate_Row_Guide_ID();
            string ShippingOrderHeader_T_values = ShippingOrderHeader_T_guid;
            string ShippingOrderHeader_T_columns = "OID,SenderID,PartnerID,ShippingOrder,PurchaseOrderNumber,Weight,TransportationMethod,StandardCarrierAlphaCode,Routing,TransactionPurposeCode,TransactionPurpose";

            int start = 0;
            bool continueloop = false;
            String MWAREHOUSE="";
            String MACCOUNTID = "";
            String MPIKTKT = "";
            // header table start
            if (VariableChechker<string>("MWAREHOUSE", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MWAREHOUSE"][start].ToString() + "'";
                MWAREHOUSE = _variablesDictionary["MWAREHOUSE"][start].ToString();
            }

            if (VariableChechker<string>("MACCOUNTID", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MACCOUNTID"][start].ToString() + "'";
                MACCOUNTID = _variablesDictionary["MACCOUNTID"][start].ToString();
            }

            if (VariableChechker<string>("MPIKTKT", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MPIKTKT"][start].ToString() + "'";
                MPIKTKT = _variablesDictionary["MPIKTKT"][start].ToString();
            }

            if (VariableChechker<string>("MCUSTPO", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MCUSTPO"][start].ToString() + "'";
            }

            if (VariableChechker<int>("MTOTWGHT", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + int.Parse(_variablesDictionary["MTOTWGHT"][start].ToString()) + "'";
            }
                // FODA [BEGIN]
            else if (VariableChechker<float>("MTOTWGHT", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + float.Parse(_variablesDictionary["MTOTWGHT"][start].ToString()) + "'";
            }
            // FODA [END]

            if (VariableChechker<string>("MTRANMTHD", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MTRANMTHD"][start].ToString() + "'";
            }

            if (VariableChechker<string>("MCACODE", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MCACODE"][start].ToString() + "'";
            }

            if (VariableChechker<string>("MCARRIER", start))
            {
                ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + "," + "'" + _variablesDictionary["MCARRIER"][start].ToString() + "'";
            }

            ShippingOrderHeader_T_values = ShippingOrderHeader_T_values + " , '' , '' ";  // static due to TransactionPurposeCode and TransactionPurpose doesn't has value and not null
            // foda
            insertintotempdatabase(tempdb, "ShippingOrderHeader_T", ShippingOrderHeader_T_columns, ShippingOrderHeader_T_values, start+1, _variablesDictionary["MPIKTKT"][start].ToString());
            // header table END


            // shipping order reference start
            string ShippingOrderReference_T_guid = Generate_Row_Guide_ID();
            string ShippingOrderReference_T_values = ShippingOrderReference_T_guid + "," + ShippingOrderHeader_T_guid;
            string ShippingOrderReference_T_columns = "OID,ShippingOrder,ReferenceType,ReferenceNo";
            if (VariableChechker<string>("MBOL", start))
            {
                ShippingOrderReference_T_values = ShippingOrderReference_T_values + "," + "'" + "Vics BOL" + "'" + "," + "'" + _variablesDictionary["MBOL"][start].ToString() + "'";
            }
            //foda
            insertintotempdatabase(tempdb, "ShippingOrderReference_T", ShippingOrderReference_T_columns, ShippingOrderReference_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());

            ShippingOrderReference_T_guid = Generate_Row_Guide_ID();
            ShippingOrderReference_T_values = ShippingOrderReference_T_guid + "," + ShippingOrderHeader_T_guid;
            ShippingOrderReference_T_columns = "OID,ShippingOrder,ReferenceType,ReferenceNo";

            if (VariableChechker<int>("MTOTQTYSH", start))
            {
                ShippingOrderReference_T_values = ShippingOrderReference_T_values + "," + "'" + "Quantity Shipped" + "'" + "," + "'" + int.Parse(_variablesDictionary["MTOTQTYSH"][start].ToString()) + "'";
            }
                // FODA [BEGIN]
            else if (VariableChechker<float>("MTOTQTYSH", start))
            {
                ShippingOrderReference_T_values = ShippingOrderReference_T_values + "," + "'" + "Quantity Shipped" + "'" + "," + "'" + float.Parse(_variablesDictionary["MTOTQTYSH"][start].ToString()) + "'";
            }
            // FODA [END]
            //foda
            insertintotempdatabase(tempdb, "ShippingOrderReference_T", ShippingOrderReference_T_columns, ShippingOrderReference_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());

            ShippingOrderReference_T_guid = Generate_Row_Guide_ID();
            ShippingOrderReference_T_values = ShippingOrderReference_T_guid + "," + ShippingOrderHeader_T_guid;
            ShippingOrderReference_T_columns = "OID,ShippingOrder,ReferenceType,ReferenceNo";

            if (VariableChechker<int>("MTOTCART", start))
            {
                ShippingOrderReference_T_values = ShippingOrderReference_T_values + "," + "'" + "BOL total carton" + "'" + "," + "'" + int.Parse(_variablesDictionary["MTOTCART"][start].ToString()) + "'";
            }
                // FODA [BEGIN]
            else if (VariableChechker<float>("MTOTCART", start))
            {
                ShippingOrderReference_T_values = ShippingOrderReference_T_values + "," + "'" + "BOL total carton" + "'" + "," + "'" + float.Parse(_variablesDictionary["MTOTCART"][start].ToString()) + "'";
            }
            // FODA [END]
            // FODA
            insertintotempdatabase(tempdb, "ShippingOrderReference_T", ShippingOrderReference_T_columns, ShippingOrderReference_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());
            // shipping order reference end

            // shipping order dates start

            string ShippingOrderDates_T_guid = Generate_Row_Guide_ID();
            string ShippingOrderDates_T_values = ShippingOrderDates_T_guid + "," + ShippingOrderHeader_T_guid;
            string ShippingOrderDates_T_columns = "OID,ShippingOrder,Type,Date";

            if (VariableChechker<DateTime>("MSHIP", start))
            {
                ShippingOrderDates_T_values = ShippingOrderDates_T_values + "," + "'" + "Start" + "'" + "," + "'" + DateTime.Parse(_variablesDictionary["MSHIP"][start].ToString()) + "'";
            }
            else if (VariableChechker<string>("MSHIP", start))
            {
                ShippingOrderDates_T_values = ShippingOrderDates_T_values + "," + "'" + "Start" + "'" + "," +  "null" ; // foda
            }
            // FODA
            insertintotempdatabase(tempdb, "ShippingOrderDates_T", ShippingOrderDates_T_columns, ShippingOrderDates_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());
            // shipping order dates end



            // shipping order carton variables begin
            string ShippingOrderCarton_T_guid = "";
            string ShippingOrderCarton_T_values = "";
            string ShippingOrderCarton_T_columns = "";
            // shipping order carton variables END
            do
            {
                
                continueloop = false;
                // shipping order carton begin

                string CartonOID = "";
                if (!(checkforcartonsmarksandnumber(tempdb, "ShippingOrderCarton_T", _variablesDictionary["XBOX_SER"][start].ToString(), out CartonOID)))
                {
                    // XBOX SER Is Not Found In Carton Table
                    ShippingOrderCarton_T_guid = Generate_Row_Guide_ID();
                    CartonOID = ShippingOrderCarton_T_guid;
                    ShippingOrderCarton_T_values = ShippingOrderCarton_T_guid + "," + ShippingOrderHeader_T_guid;
                    ShippingOrderCarton_T_columns = "OID,ShippingOrder,SenderID,PartnerID,ShippingorderID,CartonSerialNumber";

                    ShippingOrderCarton_T_values = ShippingOrderCarton_T_values + "," + "'" + MWAREHOUSE  + "'";

                    ShippingOrderCarton_T_values = ShippingOrderCarton_T_values + "," + "'" + MACCOUNTID + "'";

                    ShippingOrderCarton_T_values = ShippingOrderCarton_T_values + "," + "'" + MPIKTKT + "'";
                    

                    if (VariableChechker<string>("XBOX_SER", start))
                    {
                        ShippingOrderCarton_T_values = ShippingOrderCarton_T_values + "," + "'" + _variablesDictionary["XBOX_SER"][start].ToString() + "'";
                    }
                    // FODA
                    insertintotempdatabase(tempdb, "ShippingOrderCarton_T", ShippingOrderCarton_T_columns, ShippingOrderCarton_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());
                }
               
                // shipping order carton end

                // shipping order item begin
                string ShippingOrderItem_T_guid = Generate_Row_Guide_ID();
                string ShippingOrderItem_T_values = ShippingOrderItem_T_guid + "," + ShippingOrderHeader_T_guid;
                string ShippingOrderItem_T_columns = "OID,ShippingOrder,VendorStyleNumber,ItemUPC,BuyerStyleNumber,QuantityUOMCode,QuantityOrdered,SenderID,PartnerID,ShippingorderID,AssignedNumber";
                

                if (VariableChechker<string>("MSTYLE", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + _variablesDictionary["MSTYLE"][start].ToString() + "'";
                    if (_variablesDictionary["MSTYLE"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MUPC", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + _variablesDictionary["MUPC"][start].ToString() + "'";
                    if (_variablesDictionary["MUPC"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MSKU", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + _variablesDictionary["MSKU"][start].ToString() + "'";
                    if (_variablesDictionary["MSKU"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<string>("MUOM", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + _variablesDictionary["MUOM"][start].ToString() + "'";
                    if (_variablesDictionary["MUOM"].Count > start + 1) continueloop = true;
                }

                if (VariableChechker<int>("MQTY", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + int.Parse(_variablesDictionary["MQTY"][start].ToString()) + "'";
                    if (_variablesDictionary["MQTY"].Count > start + 1) continueloop = true;
                }
                    // FODA [BEGIN]
                else if (VariableChechker<float>("MQTY", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + float.Parse(_variablesDictionary["MQTY"][start].ToString()) + "'";
                    if (_variablesDictionary["MQTY"].Count > start + 1) continueloop = true;
                }
                // FODA [END]
                
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + MWAREHOUSE + "'";

                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + MACCOUNTID + "'";

                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + MPIKTKT + "'";
                
                

                if (VariableChechker<int>("MLINE", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + int.Parse(_variablesDictionary["MLINE"][start].ToString()) + "'";
                    if (_variablesDictionary["MLINE"].Count > start + 1) continueloop = true;
                }
                    // FODA [BEGIN]
                else if (VariableChechker<float>("MLINE", start))
                {
                    ShippingOrderItem_T_values = ShippingOrderItem_T_values + "," + "'" + float.Parse(_variablesDictionary["MLINE"][start].ToString()) + "'";
                    if (_variablesDictionary["MLINE"].Count > start + 1) continueloop = true;
                }
                // FODA [END]
                // FODA
                insertintotempdatabase(tempdb, "ShippingOrderItem_T", ShippingOrderItem_T_columns, ShippingOrderItem_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());
                // shipping order item end

                // ShippingOrderItemCartons_T begin
                string ShippingOrderItemCartons_T_guid = Generate_Row_Guide_ID();
                //string ShippingOrderItemCartons_T_values = ShippingOrderItemCartons_T_guid + "," + ShippingOrderCarton_T_guid + "," + ShippingOrderItem_T_guid;
                string ShippingOrderItemCartons_T_values = ShippingOrderItemCartons_T_guid + "," + CartonOID + "," + ShippingOrderItem_T_guid;
                string ShippingOrderItemCartons_T_columns = "Packno,CartonID,ItemID,QTY";

                if (VariableChechker<int>("MSHQTY", start))
                {
                    ShippingOrderItemCartons_T_values = ShippingOrderItemCartons_T_values + "," + "'" + int.Parse(_variablesDictionary["MSHQTY"][start].ToString()) + "'";
                    if (_variablesDictionary["MSHQTY"].Count > start + 1) continueloop = true;
                }
                    // FODA [BEGIN]
                else if (VariableChechker<float>("MSHQTY", start))
                {
                    ShippingOrderItemCartons_T_values = ShippingOrderItemCartons_T_values + "," + "'" + float.Parse(_variablesDictionary["MSHQTY"][start].ToString()) + "'";
                    if (_variablesDictionary["MSHQTY"].Count > start + 1) continueloop = true;
                }
                // FODA [END]
                // FODA
                insertintotempdatabase(tempdb, "ShippingOrderItemCartons_T", ShippingOrderItemCartons_T_columns, ShippingOrderItemCartons_T_values, start + 1, _variablesDictionary["MPIKTKT"][start].ToString());
                // ShippingOrderItemCartons_T end MSHQTY
                start++;
            }
            while (continueloop);


        }


        public void insertintotempdatabase(string Temp_DB_Name, string table_name, string columns, string values , int line_no , string tran_Number) // foda add two parameters
        {
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
            sb.InitialCatalog = Temp_DB_Name;
            string connectionString = sb.ConnectionString;
            string insertStatment = "";
            insertStatment = "insert into " + table_name + " ( " + columns + " ) values ( " + values + " ) ";
            doCommand(insertStatment, connectionString, line_no, tran_Number);
        }

        public void doCommand(string ComText, string ConnectionString , int line_no , string trans_number) // foda add two parameters
        { 

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand comd = new SqlCommand(ComText, con);
            try
            {
                con.Open();
                comd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]

                // foda [Begin]
                ErrorMsg = "error on line : "+ line_no + " and on transaction : " + trans_number;
                _continue = false;
                return;
                // foda [END]
            }
            finally
            {
                con.Close();
            }

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

        // MSH 
        private string Generate_Row_Guide_ID()
        {
            return "'" + Guid.NewGuid().ToString().Replace("'", "") + "'";
        }
        // MSH
     
        private void Update_Temp_Table(string TempDB, string SqlQuery)
        {
            if(TempDB == null || TempDB == "")
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Given Temp Database Is Empty.";
                _continue = false;
                return;
            }
            if (SqlQuery == null || SqlQuery == "")
            {
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][Start]
                HasError = true;
                // Adding Boolean To Check If Error Exist - [20/06/2017] [MSH][End]
                ErrorMsg = "Given Sql Query In Database " + TempDB + " Is Empty.";
                _continue = false;
                return;
            }
            try
            {
                // Get Connection String
                SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder(AriaConnection.ClientMasterConnection.ConnectionString);
                sb.InitialCatalog = TempDB;
                SqlCommand cmd = AriaConnection.ClientMasterConnection.CreateCommand();
                cmd.Connection.ConnectionString = sb.ConnectionString;
                cmd.Connection.Open();
                cmd.CommandText = SqlQuery;
                //cmd.CommandText = "INSERT INTO ShippingOrderHeader_T (" + ShippingOrderHeader_T_columns + " ) VALUES (" + ShippingOrderHeader_T_values + ")";
                cmd.ExecuteNonQuery();
                cmd.Connection.Close();
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
    }
}