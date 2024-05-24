using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

class DataHelper
{

    public static Dictionary<string, List<DataRow>> GetData(List<DataRow> MostChildRows, Dictionary<string, List<DataRow>> RowsDictionary, List<string> RankList)
    {
        foreach (DataRow row in MostChildRows)
        {
            if (!RowsDictionary.ContainsKey(row.Table.TableName))
            {
                RowsDictionary.Add(row.Table.TableName, new List<DataRow>());
                if (RankList != null)
                    RankList.Add(row.Table.TableName);
            }
            RowsDictionary[row.Table.TableName].Add(row);
            foreach (DataRelation relation in row.Table.ParentRelations)
            {
                List<DataRow> rows = row.GetParentRows(relation).ToList();
                RowsDictionary = GetData(rows, RowsDictionary, RankList);
            }
        }
        return RowsDictionary;
    }
    public static int test(DataRow datarow, List<string> ChildTables)
    {
        int returnValue = 0;
        foreach (DataRelation relation in datarow.Table.ChildRelations)
        {
            if (ChildTables.Contains(relation.ChildTable.TableName))
            {
                var data = datarow.GetChildRows(relation);
                foreach (var row in data)
                {
                    returnValue += test(row, ChildTables);
                }
            }
        }
        return returnValue;
    }


    public static bool GetChildData(List<DataRow> TopHeaderRows, List<string> ChildTablesNames, Dictionary<string, List<DataRow>> retData)
    {
        var childTablesNamesBackup = ChildTablesNames.ToList();
        var status = true;
        var x = 0;
        foreach (DataRow HeaderRow in TopHeaderRows)
        {
            ChildTablesNames = childTablesNamesBackup.ToList();
            status = status && GetChildData(HeaderRow, ChildTablesNames, retData, x > 0);
            x++;
        }
        return status;
    }

    public static bool GetChildData(DataRow HeaderRow, List<string> ChildTablesNames, Dictionary<string, List<DataRow>> retData, bool successedBefore)
    {
        var status = false;
        foreach (DataRelation relation in HeaderRow.Table.ChildRelations)
        {
            List<DataRow> relationData = new List<DataRow>();

            relationData.AddRange(HeaderRow.GetChildRows(relation));
            if (successedBefore)
            {
                if (!retData.Keys.Contains(HeaderRow.Table.TableName))
                    retData.Add(HeaderRow.Table.TableName, new List<DataRow>());
                if (!retData[HeaderRow.Table.TableName].Contains(HeaderRow))
                    retData[HeaderRow.Table.TableName].Add(HeaderRow);
            }
            status = false;
            status = ChildTablesNames.Contains(relation.ChildTable.TableName);
            if (!status)
            {
                status = GetChildData(relationData, ChildTablesNames, retData);
            }
            if (status)
            {
                if (!retData.Keys.Contains(relation.ChildTable.TableName))
                    retData.Add(relation.ChildTable.TableName, new List<DataRow>());
                foreach (DataRow relRow in relationData)
                    if (!retData[relation.ChildTable.TableName].Contains(relRow))
                        retData[relation.ChildTable.TableName].Add(relRow);
                if (!retData.Keys.Contains(HeaderRow.Table.TableName))
                    retData.Add(HeaderRow.Table.TableName, new List<DataRow>());
                if (!retData[HeaderRow.Table.TableName].Contains(HeaderRow))
                    retData[HeaderRow.Table.TableName].Add(HeaderRow);
                ChildTablesNames.Remove(relation.ChildTable.TableName);
                if (ChildTablesNames.Count == 0)
                {
                    int max = 0;
                    foreach (var key in retData.Keys)
                    {
                        max = Math.Max(max, retData[key].Count);
                    }
                    foreach (var key in retData.Keys)
                    {
                        while (retData[key].Count < max && retData[key].Count > 0)
                            retData[key].Add(retData[key][retData[key].Count - 1]);
                    }
                    return status;
                }
                else
                    return (GetChildData(relationData, ChildTablesNames, retData));
                {
                    if (!retData.Keys.Contains(relation.ChildTable.TableName))
                        retData.Add(relation.ChildTable.TableName, new List<DataRow>());
                    foreach (DataRow relRow in relationData)
                        if (!retData[relation.ChildTable.TableName].Contains(relRow))
                            retData[relation.ChildTable.TableName].Add(relRow);
                    ChildTablesNames.Remove(relation.ChildTable.TableName);
                    return true;
                }
            }
        }
        return status;
    }


    /// <summary>
    /// search for relation between the searchedtable and the relations collection passed , if relation found it will be added to the out relations.
    /// </summary>
    /// <param name="relations">relations to search in them</param>
    /// <param name="searchedTable"> table to search for it in the relations</param>
    /// <param name="outRelations"> the relation collection to add relation to </param>
    /// <returns></returns>
    private static bool GetRelationChain(DataTable Table, string TargetTable, ref List<DataRelation> outRelations)
    {
        foreach (DataRelation relation in Table.ChildRelations)
        {
            if (relation.ChildTable.TableName.ToUpper() == TargetTable.ToUpper())
            {
                outRelations.Add(relation);
                return true;
            }
            else if (relation.ChildTable.ChildRelations.Count > 0)
            {
                if (GetRelationChain(relation.ChildTable, TargetTable, ref outRelations))
                {
                    outRelations.Add(relation);
                    return true;
                }
                else
                    return false;
            }
        }
        return false;
    }

    /// <summary>
    /// Returns list of datarow from child datatable related to passed row
    /// </summary>
    /// <param name="topRelationRow">the parent row</param>
    /// <param name="ParentToChildRelations">list of relations</param>
    /// <returns></returns>
    private static List<DataRow> GetChildRowsData(List<DataRow> topRelationRow, List<DataRelation> ParentToChildRelations)
    {
        foreach (DataRelation relation in ParentToChildRelations)
        {
            topRelationRow = GetRelationData(topRelationRow, relation);
        }
        return topRelationRow;
    }

    /// <summary>
    /// returns list of datarows which are child of rows passed and the passed relation
    /// </summary>
    /// <param name="RowsList">rows to get child rows of them</param>
    /// <param name="relation">relation used to get child rows</param>
    /// <returns></returns>
    private static List<DataRow> GetRelationData(List<DataRow> RowsList, DataRelation relation)
    {
        List<DataRow> AllDataTable = new List<DataRow>();
        foreach (DataRow row in RowsList)
        {
            string condition = "";
            foreach (DataColumn column in relation.ParentColumns)
                condition += "(" + column.Caption + " = '" + row[column] + "'" + ")" + " AND ";
            if (condition.EndsWith("AND "))
                condition = condition.Remove(condition.Length - 4);
            string oldcondition = relation.ChildTable.DefaultView.RowFilter;
            if (oldcondition.Trim() != "")
                condition = " ( " + oldcondition + " ) " + " AND " + "(" + condition + ")";
            relation.ChildTable.DefaultView.RowFilter = condition;

            foreach (DataRowView rowview in relation.ChildTable.DefaultView)
                AllDataTable.Add(rowview.Row);

            relation.ChildTable.DefaultView.RowFilter = oldcondition;
        }
        return AllDataTable;
    }
}
