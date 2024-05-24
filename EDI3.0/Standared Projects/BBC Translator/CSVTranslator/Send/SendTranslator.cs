using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Xml;
using System.IO;
using System.Data.SqlClient;

namespace CSVTranslator
{
    public class SendTranslator : SENDTRANSACTIONS
    {
        public DataSet DataDataset = new DataSet();
        XmlDocument mapxml = new XmlDocument();
        List<xmlMapClass> xmlMapList = new List<xmlMapClass>();
        StreamWriter streamWriter;
        string _dateFormat, mostParentTable, mostChildTable,transactionType,mostParentLoop;
        public delegates.BeforeReadingRelations BeforeReadingRelations;
        public delegates.AfterReadingRelations AfterReadingRelations;

        public SendTranslator() { }

        public void Translate(string AriaXmlPath, string MapSet, string MapVersion, string FileFormat, string OutgoingFile, string ClientId, string ActiveCompany, string MapXmlPath,string LcTransactionType)
        {
            try
            {
                //Derby
                transactionType = LcTransactionType;
                //Derby
                this.FileFormat = (FreeWayFileFormat)Enum.Parse(this.FileFormat.GetType(), FileFormat);
                this.MapVersion = MapVersion;
                this.MapSet = MapSet;
                streamWriter = new FileInfo(OutgoingFile).CreateText();
                ReadMapXml(MapXmlPath);
                if (!_continue) return;
                init(ClientId, ActiveCompany);
                if (!_continue) return;
                ReadAriaXml(AriaXmlPath);
                if (!_continue) return;
                ReadRelations();
                //DataDataset.WriteXml(@"D:\ariaXMl.XML", XmlWriteMode.WriteSchema);
                WriteFile();
                streamWriter.Close();
                if (!_continue) return;
            }
            catch (Exception ex)
            {
                ErrorMsg = ex.GetDetailedMessage();
                if (streamWriter != null)
                    streamWriter.Close();
            }

        }

        public virtual void WriteFile()
        {
            //WriteStructureRecord(streamWriter);
            List<string> rankList = new List<string>();
            bool LFirst = false;
            Dictionary<string, List<DataRow>> shipmentDictionary = new Dictionary<string, List<DataRow>>();
            List<DataRow> list = new List<DataRow>();
            foreach (DataRow row in DataDataset.Tables[mostChildTable].Rows)
            {
                list.Add(row);
            }

            var ss = DataHelper.GetData(list, shipmentDictionary, rankList);
            int mainLoopsCount = DataDataset.Tables[mostParentTable].Rows.Count;

            ////Write CSV H-01 Loop
            //var Header_Loop = _segmentsList.Select(_segment => _segment.LOOP_ID==mostParentLoop);
            //foreach (var Hloop in Header_Loop)
            // {

            // }
          
            var Loops = _segmentsList.Select(_segment => _segment.LOOP_ID).Distinct();
            for (int x = 0; x < mainLoopsCount; x++)
            {
                var mainHeaderRow = DataDataset.Tables[mostParentTable].Rows[x];
                foreach (var loop in Loops)
                {
                    //Derby
                    if (loop.ToString().ToUpper().Trim() == mostParentLoop.ToString().ToUpper().Trim() && LFirst) continue;
                    LFirst = loop.ToString().ToUpper().Trim() == mostParentLoop.ToString().ToUpper().Trim() ? true : LFirst;
                    //Derby
                    var currentLoopSegments = _segmentsList.Where(_segment => _segment.LOOP_ID == loop);
                    List<string> loopMappingValues = new List<string>();
                    List<TRANSACTION_MAP_T> loopMapping = new List<TRANSACTION_MAP_T>();
                    foreach (var currentLoopSeg in currentLoopSegments)
                        loopMapping.AddRange(_segmentsMappingList.Where(segmentMap => segmentMap.TRANSACTION_SEGMENTS_KEY == currentLoopSeg.TRANSACTION_SEGMENTS_KEY));
                    loopMapping.ForEach(loopMap => loopMappingValues.Add(loopMap.VALUE));
                    var segmentTables = xmlMapList.Where(map => loopMappingValues.Contains(map.Variable) && map.Table.HasValue() && map.Table != mostParentTable).Select(map => map.Table).Distinct();

                    List<DataRow> xxx = new List<DataRow>();
                    xxx.Add(mainHeaderRow);
                    Dictionary<string, List<DataRow>> currentLoop = new Dictionary<string, List<DataRow>>();
                    List<string> TablesNames = new List<string>();
                    TablesNames.AddRange(segmentTables);
                    currentLoop.Add(mostParentTable, new List<DataRow>());
                    currentLoop[mostParentTable].Add(mainHeaderRow);
                    //DataHelper.GetChildData(xxx, TablesNames, currentLoop);
                    DataHelper.GetChildData1(xxx[0], currentLoop);

                    //int leasttableRank = 1000;
                    //foreach (var table in segmentTables)
                    //    leasttableRank = Math.Min(leasttableRank, rankList.IndexOf(table));
                    //List<DataRow> childRows = new List<DataRow>();
                    //foreach (DataRow row in DataDataset.Tables[rankList[leasttableRank]].Rows)
                    //    childRows.Add(row);
                    //  Dictionary<string, List<DataRow>> currentLoop = new Dictionary<string, List<DataRow>>();
                    // DataHelper.GetData(childRows, currentLoop, null);
                    int completedDataRows;
                    completedDataRows = loop.ToString().ToUpper().Trim()==mostParentLoop.ToString().ToUpper().Trim() ? currentLoop.Values.First().Count: currentLoop[mostChildTable].Count();

                    //int completedDataRows = currentLoop.Values.First().Count;
                    //int completedDataRows = currentLoop[mostChildTable].Count();
                    //segmentTables.ToList().ForEach(tableName => completedDataRows = Math.Max(mainHeaderRow.GetChildRows(tableName).Length, completedDataRows));
                    //segmentTables.ToList().ForEach(tableName => completedDataRows = Math.Max(DataHelper.GetChildData(shipmentDictionary[mainTable], tableName).Count, completedDataRows));
                    for (int y = 0; y < completedDataRows; y++)
                    {
                        
                        DataHelper.GetChildData1(currentLoop[mostChildTable][y], currentLoop);
                        VariablesDictionary.Clear();
                        foreach (var segment in _segmentsList.Where(_segment => _segment.LOOP_ID == loop))
                        {
                            var segmentMappings = _segmentsMappingList.Where(segmentMap => segmentMap.TRANSACTION_SEGMENTS_KEY == segment.TRANSACTION_SEGMENTS_KEY).OrderBy(segmentMap => segmentMap.FIELD_ORDER);
                            foreach (var segmentMaping in segmentMappings)
                            {
                                if (VariablesDictionary.ContainsKey(segmentMaping.VALUE)) continue;
                                //var xmlMapItems = xmlMapList.Where(xmlmap => xmlmap.Variable == segmentMaping.VALUE);
                                var xmlMapItems = from xmlMap in xmlMapList where (xmlMap.Variable == segmentMaping.VALUE + "_TempData1" || xmlMap.Variable == segmentMaping.VALUE + "_TempData2" || xmlMap.Variable == segmentMaping.VALUE + "_TempData3" || xmlMap.Variable == segmentMaping.VALUE) && xmlMap.Loop == loop select xmlMap;  // xmlMapList.Where(xmlmap => xmlmap.Variable == segmentMaping.VALUE);
                                foreach (var xmlMapitem in xmlMapItems)
                                {

                                    string _valuestring = "";
                                    if (xmlMapitem.fixd != null && xmlMapitem.fixd.Count > 0)
                                    {
                                        xmlMapClass.Fixed Fixed = xmlMapitem.fixd[0];
                                        if (Fixed.experssion.Contains("*") || Fixed.experssion.Contains("+") || Fixed.experssion.Contains("/") || Fixed.experssion.Contains("-"))
                                        {
                                            bool mul = Fixed.experssion.Contains("*"), plus = Fixed.experssion.Contains("+"), minus = Fixed.experssion.Contains("-"), divide = Fixed.experssion.Contains("/");
                                            string lhs = "", rhs = "";
                                            if (mul)
                                                lhs = Fixed.experssion.Substring(0, Fixed.experssion.IndexOf("*"));
                                            else if (plus)
                                                lhs = Fixed.experssion.Substring(0, Fixed.experssion.IndexOf("+"));
                                            else if (minus)
                                                lhs = Fixed.experssion.Substring(0, Fixed.experssion.IndexOf("-"));
                                            else if (divide)
                                                lhs = Fixed.experssion.Substring(0, Fixed.experssion.IndexOf("/"));
                                            rhs = Fixed.experssion.Remove(0, lhs.Length + 1);
                                            decimal lhsDecimal = 0, rhsDecimal = 0;
                                            if (Fixed.type == "Decimal")
                                            {
                                                if (Fixed.lhsSource == "Map")
                                                    lhsDecimal = Convert.ToDecimal(lhs);
                                                else if (Fixed.lhsSource == "Dictionary")
                                                    lhsDecimal = Convert.ToDecimal(VariablesDictionary[lhs]);

                                                if (Fixed.rhsSource == "Map")
                                                    rhsDecimal = Convert.ToDecimal(rhs);
                                                else if (Fixed.rhsSource == "Dictionary")
                                                    rhsDecimal = Convert.ToDecimal(VariablesDictionary[rhs]);

                                                decimal result = decimal.Zero;
                                                if (mul)
                                                    result = lhsDecimal * rhsDecimal;
                                                else if (plus)
                                                    result = lhsDecimal + rhsDecimal;
                                                else if (minus)
                                                    result = lhsDecimal - rhsDecimal;
                                                else if (divide)
                                                    result = lhsDecimal / rhsDecimal;
                                                _valuestring = result.ToString(segmentMaping.DATA_TYPE.Trim());
                                            }
                                        }

                                        else if (Fixed.experssion.StartsWith("LinesCount("))
                                        {
                                            string tableName = Fixed.experssion.Remove(Fixed.experssion.Length - 1).Replace("LinesCount(", "");

                                            if (currentLoop.Keys.Contains(tableName))
                                                _valuestring = currentLoop[tableName].Count.ToString();
                                            else
                                            {
                                                List<string> childtables = new List<string>();
                                                childtables.Add(tableName);
                                                Dictionary<string, List<DataRow>> returnData = new Dictionary<string, List<DataRow>>();
                                                DataHelper.GetChildData(mainHeaderRow, childtables, returnData, false);
                                                if (returnData.Keys.Contains(tableName))
                                                    _valuestring = returnData[tableName].Count.ToString();
                                            }
                                        }
                                        else
                                            _valuestring = Fixed.experssion;
                                    }
                                    else if (xmlMapitem.Table.HasValue() && xmlMapitem.Column.HasValue())
                                    {
                                        object _value = null;
                                        //Derby -Change the way of reading the value to select the matched record first[Start]
                                        //_value = currentLoop[xmlMapitem.Table][y][xmlMapitem.Column];
                                        //if (xmlMapitem.relatedtype.HasValue() && xmlMapitem.relatedtypevalue.HasValue())
                                        //{
                                        //    _value = currentLoop[xmlMapitem.Table].Where(r => r[xmlMapitem.relatedtype].ToString().ToUpper() == xmlMapitem.relatedtypevalue.ToString().ToUpper());

                                        //    //_value = currentLoop[xmlMapitem.Table].Where(r => r[xmlMapitem.relatedtype] == xmlMapitem.relatedtypevalue);
                                        //}
                                        //else
                                        //{
                                        //    _value = currentLoop[xmlMapitem.Table][y][xmlMapitem.Column];
                                        //} 


                                        if (xmlMapitem.relatedtype.HasValue() && xmlMapitem.relatedtypevalue.HasValue())
                                        {
                                            foreach (var rowTable in currentLoop[xmlMapitem.Table])
                                            {
                                                _value="";
                                                if (rowTable[xmlMapitem.relatedtype].ToString().ToUpper().Trim() == xmlMapitem.relatedtypevalue.ToString().ToUpper().Trim())
                                                {
                                                    _value = rowTable[xmlMapitem.Column];
                                                    break;
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                           _value = currentLoop[xmlMapitem.Table][xmlMapitem.Table.ToUpper().Trim() != mostChildTable.ToString().ToUpper().Trim() ? 0 : y][xmlMapitem.Column];
                                        }
                                        //Derby -Change the way of reading the value to select the matched record first[End]
                                        if (xmlMapitem.Temp)
                                        {
                                            _valuestring = Convert.ToString(_value);
                                        }
                                        else
                                        {
                                            if (segmentMaping.DATA_TYPE.Trim() == "D")
                                            {
                                                //_valuestring = Convert.ToDateTime(_value).ToString(_dateFormat);
                                                _valuestring = Convert.ToDateTime(_value).ToShortDateString().ToString();
                                            }
                                            else if (segmentMaping.DATA_TYPE.StartsWith("N"))
                                            {
                                                decimal dec = decimal.Zero;
                                                decimal.TryParse(Convert.ToString(_value), out dec);
                                                //_valuestring = dec.ToString(segmentMaping.DATA_TYPE.Trim());
                                                _valuestring = dec.ToString();
                                            }
                                            else
                                                _valuestring = Convert.ToString(_value);
                                        }
                                    }
                                    VariablesDictionary.Add(xmlMapitem.Variable, _valuestring);

                                    #region Condition
                                    bool conditionResult = true;
                                    foreach (var condition in xmlMapitem.Condition)
                                    {
                                        bool gt = condition.experssion.Contains(">"), st = condition.experssion.Contains("<"), notequal = condition.experssion.Contains("!="), equal = condition.experssion.Contains("==");
                                        if (gt || st || notequal || equal)
                                        {

                                            string lhs = "", rhs = "";
                                            if (gt)
                                                lhs = condition.experssion.Substring(0, condition.experssion.IndexOf(">")).Trim();
                                            else if (st)
                                                lhs = condition.experssion.Substring(0, condition.experssion.IndexOf("<")).Trim();
                                            else if (notequal)
                                                lhs = condition.experssion.Substring(0, condition.experssion.IndexOf("!=") - 1).Trim();
                                            else if (equal)
                                                lhs = condition.experssion.Substring(0, condition.experssion.IndexOf("==") - 1).Trim();
                                            if (notequal || equal)
                                                rhs = condition.experssion.Remove(0, lhs.Length + 4).Trim();
                                            else
                                                rhs = condition.experssion.Remove(0, lhs.Length + 2);
                                            decimal lhsDecimal = decimal.Zero, rhsDecimal = decimal.Zero;
                                            string lhsString = null, rhsString = null;
                                            if (condition.type == "Decimal")
                                            {
                                                if (condition.lhsSource == "Map")
                                                    lhsDecimal = Convert.ToDecimal(lhs);
                                                else if (condition.lhsSource == "Dictionary")
                                                    lhsDecimal = Convert.ToDecimal(VariablesDictionary[lhs]);

                                                if (condition.rhsSource == "Map")
                                                    rhsDecimal = Convert.ToDecimal(rhs);
                                                else if (condition.rhsSource == "Dictionary")
                                                    rhsDecimal = Convert.ToDecimal(VariablesDictionary[rhs]);

                                                if (gt)
                                                    conditionResult = lhsDecimal > rhsDecimal;
                                                else if (st)
                                                    conditionResult = lhsDecimal < rhsDecimal;
                                                else if (notequal)
                                                    conditionResult = lhsDecimal != rhsDecimal;
                                                else if (equal)
                                                    conditionResult = lhsDecimal == rhsDecimal;
                                            }
                                            else if (condition.type == "String")
                                            {
                                                if (condition.lhsSource == "Map")
                                                    lhsString = lhs;
                                                else if (condition.lhsSource == "Dictionary")
                                                    lhsString = Convert.ToString(VariablesDictionary[lhs]);

                                                if (condition.rhsSource == "Map")
                                                    rhsString = rhs;
                                                else if (condition.rhsSource == "Dictionary")
                                                    rhsString = Convert.ToString(VariablesDictionary[rhs]);

                                                if (notequal)
                                                    conditionResult = lhsString != rhsString;
                                                else if (equal)
                                                    conditionResult = lhsString == rhsString;
                                            }
                                        }
                                        if (!conditionResult)
                                        {
                                            VariablesDictionary.Remove(segmentMaping.VALUE);
                                            break;
                                        }
                                    }
                                    #endregion
                                }
                            }
                        }
                        List<string> TempDataKeys = new List<string>();
                        foreach (string key in VariablesDictionary.Keys)
                            if (key.Contains("_TempData"))
                                TempDataKeys.Add(key);
                        foreach (string tempKey in TempDataKeys)
                            VariablesDictionary.Remove(tempKey);
                        WriteLoop(this.MapSet, this.MapVersion, loop, AriaConnection.ClientMasterConnection.CreateCommand(), streamWriter);
                        DataHelper.RemoveChildFromCurrentLoop(currentLoop[mostChildTable][y], currentLoop);
                    }
                }
            }
        }

        private void ReadMapXml(string MapXmlPath)
        {
            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string xmlMappath = dllLocation + "\\" + MapXmlPath;
            if (!File.Exists(xmlMappath))
            {
                //Derby
                //ErrorMsg = "Send856 map " + xmlMappath + " couldn't be found!";
                ErrorMsg ="Send" +transactionType + "  " + xmlMappath + " couldn't be found!";
                //Derby
                
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
            try { 
            //Derby
            mostParentLoop = mapxml.SelectSingleNode("//MostParentLoop").InnerText;
            //Derby
            
                }
            catch(Exception){}
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
            core.TempDataBaseCreator(TransactionType, tempDB, sb.DataSource, sb.UserID, sb.Password);

            core.Import(TransactionType, sb.DataSource, tempDB, sb.UserID, sb.Password, xmlPath);

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

        private void ReadRelations()
        {
            if (BeforeReadingRelations != null)
                BeforeReadingRelations();
            if (mapxml.SelectSingleNode("//Relations/Source/Add") != null)
            {
                foreach (XmlNode node in mapxml.SelectNodes("//Relations/Source/Add/Relation"))
                {
                    XmlNodeList parentcolumnsnodes = node.SelectNodes("ParentColumns/Column");
                    DataColumn[] ParentColumns = new DataColumn[parentcolumnsnodes.Count];
                    XmlNodeList childcolumnsnodes = node.SelectNodes("ChildColumns/Column");
                    DataColumn[] ChildColumns = new DataColumn[childcolumnsnodes.Count];
                    DataTable parent = DataDataset.Tables[node["ParentTable"].InnerText];
                    DataTable child = DataDataset.Tables[node["ChildTable"].InnerText];
                    for (int parentColumnIndex = 0; parentColumnIndex < parentcolumnsnodes.Count; parentColumnIndex++)
                        ParentColumns[parentColumnIndex] = parent.Columns[parentcolumnsnodes[parentColumnIndex].InnerText];
                    for (int childColumnIndex = 0; childColumnIndex < childcolumnsnodes.Count; childColumnIndex++)
                        ChildColumns[childColumnIndex] = child.Columns[childcolumnsnodes[childColumnIndex].InnerText];
                    DataRelation relation = new DataRelation(child.TableName, ParentColumns, ChildColumns);
                    parent.ChildRelations.Add(relation);
                }
            }
            if (AfterReadingRelations != null)
                AfterReadingRelations();
        }

        class xmlMapClass
        {
            //Derby -Adding the new RelatedType & relatedTypeeValue variables.
            public string Variable, Table, Column, Loop, DataType ,relatedtype, relatedtypevalue;
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

        public class delegates
        {
            public delegate void BeforeReadingRelations();
            public delegate void AfterReadingRelations();
        }
    }
}