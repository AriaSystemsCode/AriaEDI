using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Data.SqlClient;
using System.Data.Common;
using System.Data.Odbc;
using System.Data.OleDb;

public class EDIACPRT
{
    #region Properties

    public char type { get; set; }

    public string cpartner { get; set; }

    public string cpartcode { get; set; }

    public string ccmpisaql { get; set; }

    public string ccmpisaid { get; set; }

    public string ccmpgsid { get; set; }

    public string cremit { get; set; }

    public string cedifob { get; set; }

    public bool? ldetlabel { get; set; }

    public string casn_ver { get; set; }

    public char cmulucclbl { get; set; }

    public string cpckchcode { get; set; }

    public string cpckdscode { get; set; }

    public string cdtclblver { get; set; }

    public bool? lpkchrdes { get; set; }

    public string duns { get; set; }

    public char cmtchpoprc { get; set; }

    public bool? linvunship { get; set; }

    public bool? ljcpstdash { get; set; }

    public bool? lintercomp { get; set; }

    public string csiteid { get; set; }

    public char cordstatus { get; set; }

    public string cowner { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string ucc9 { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string cacccode { get; set; }

    public char cmtchpotrm { get; set; }

    public string cporcvline { get; set; }

    public string ccmpscql { get; set; }

    public char crcvpodisc { get; set; }

    public bool? lsndcrt { get; set; }

    public string ccmpscid { get; set; }

    public string ui_pkey { get; set; }

    public bool? laslines { get; set; }

    public bool? lupdout { get; set; }

    public bool? lshowmsg { get; set; }

    #endregion

	#region Methods

	public static EDIACPRT Create(DataRow row)
    {
        EDIACPRT newRow = new EDIACPRT();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDIACPRT> Create(DataTable Table)
    {
        List<EDIACPRT> EDIACPRTlist = new List<EDIACPRT>();
        foreach (DataRow row in Table.Rows)
        {
            EDIACPRT newObject = Create(row);
            EDIACPRTlist.Add(newObject);
        }
        return EDIACPRTlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIACPRT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIACPRT (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIACPRT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIACPRT (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDIACPRT ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDIACPRT> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDIACPRT ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDIERORD
{
    #region Properties

    public string cfilecode { get; set; }

    public string cpartcode { get; set; }

    public string cintchgseq { get; set; }

    public string cgroupseq { get; set; }

    public string ceditrntyp { get; set; }

    public string cerrseqnce { get; set; }

    public char cstatus { get; set; }

    public string merrorcode { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static EDIERORD Create(DataRow row)
    {
        EDIERORD newRow = new EDIERORD();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDIERORD> Create(DataTable Table)
    {
        List<EDIERORD> EDIERORDlist = new List<EDIERORD>();
        foreach (DataRow row in Table.Rows)
        {
            EDIERORD newObject = Create(row);
            EDIERORDlist.Add(newObject);
        }
        return EDIERORDlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIERORD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIERORD (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIERORD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIERORD (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDIERORD ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDIERORD> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDIERORD ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDIERORH
{
    #region Properties

    public string cfilecode { get; set; }

    public string segid { get; set; }

    public string cpartcode { get; set; }

    public string cintchgseq { get; set; }

    public string cerrseqnce { get; set; }

    public string merrorcode { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static EDIERORH Create(DataRow row)
    {
        EDIERORH newRow = new EDIERORH();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDIERORH> Create(DataTable Table)
    {
        List<EDIERORH> EDIERORHlist = new List<EDIERORH>();
        foreach (DataRow row in Table.Rows)
        {
            EDIERORH newObject = Create(row);
            EDIERORHlist.Add(newObject);
        }
        return EDIERORHlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIERORH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIERORH (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIERORH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIERORH (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDIERORH ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDIERORH> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDIERORH ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDILIBDT
{
    #region Properties

    public char cedifiltyp { get; set; }

    public string cfilecode { get; set; }

    public string cpartcode { get; set; }

    public string cintchgseq { get; set; }

    public string cgroupseq { get; set; }

    public string ctranseq { get; set; }

    public string ceditrntyp { get; set; }

    public string ceditranno { get; set; }

    public string cediref { get; set; }

    public char crecfldsep { get; set; }

    public char cackstatus { get; set; }

    public DateTime? ddate { get; set; }

    public string ctime { get; set; }

    public string crejreason { get; set; }

    public string cgsrejreas { get; set; }

    public char ceditrnst { get; set; }

    public char cstatus { get; set; }

    public string mtrantext { get; set; }

    public string mstatus { get; set; }

    public bool? lintercomp { get; set; }

    public DateTime? dackdate { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string merr { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string cupctype { get; set; }

    public bool? lprtsys { get; set; }

    #endregion

	#region Methods

	public static EDILIBDT Create(DataRow row)
    {
        EDILIBDT newRow = new EDILIBDT();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDILIBDT> Create(DataTable Table)
    {
        List<EDILIBDT> EDILIBDTlist = new List<EDILIBDT>();
        foreach (DataRow row in Table.Rows)
        {
            EDILIBDT newObject = Create(row);
            EDILIBDTlist.Add(newObject);
        }
        return EDILIBDTlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDILIBDT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDILIBDT (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDILIBDT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDILIBDT (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDILIBDT ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDILIBDT> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDILIBDT ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDILIBHD
{
    #region Properties

    public string cfilecode { get; set; }

    public string cedifilnam { get; set; }

    public string cfilepath { get; set; }

    public char cedifiltyp { get; set; }

    public DateTime? ddate { get; set; }

    public string ctime { get; set; }

    public string cnetwork { get; set; }

    public char cstatus { get; set; }

    public decimal? ntrannumb { get; set; }

    public decimal? nrejtran { get; set; }

    public decimal? nproctran { get; set; }

    public string macktext { get; set; }

    public string cprocessby { get; set; }

    public string cowner { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static EDILIBHD Create(DataRow row)
    {
        EDILIBHD newRow = new EDILIBHD();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDILIBHD> Create(DataTable Table)
    {
        List<EDILIBHD> EDILIBHDlist = new List<EDILIBHD>();
        foreach (DataRow row in Table.Rows)
        {
            EDILIBHD newObject = Create(row);
            EDILIBHDlist.Add(newObject);
        }
        return EDILIBHDlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDILIBHD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDILIBHD (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDILIBHD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDILIBHD (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDILIBHD ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDILIBHD> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDILIBHD ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDINET
{
    #region Properties

    public string cnetwork { get; set; }

    public string cnetname { get; set; }

    public string coutfile { get; set; }

    public string cinfile { get; set; }

    public bool? lsendack { get; set; }

    public bool? lsendbyem { get; set; }

    public bool? file_type { get; set; }

    public decimal? fix { get; set; }

    public string cadd_time { get; set; }

    public string cadd_user { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    public string cedit_user { get; set; }

    public decimal? ninterval { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public bool? lsndcntseg { get; set; }

    public string cedityps { get; set; }

    public bool? lsndlnsep { get; set; }

    public bool? ltmrexst { get; set; }

    #endregion

	#region Methods

	public static EDINET Create(DataRow row)
    {
        EDINET newRow = new EDINET();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDINET> Create(DataTable Table)
    {
        List<EDINET> EDINETlist = new List<EDINET>();
        foreach (DataRow row in Table.Rows)
        {
            EDINET newObject = Create(row);
            EDINETlist.Add(newObject);
        }
        return EDINETlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDINET().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDINET (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDINET().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDINET (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDINET ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDINET> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDINET ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDINOTE
{
    #region Properties

    public char type { get; set; }

    public string key { get; set; }

    public string cdesc { get; set; }

    public string mnotes { get; set; }

    public char flag { get; set; }

    public string cowner { get; set; }

    #endregion

	#region Methods

	public static EDINOTE Create(DataRow row)
    {
        EDINOTE newRow = new EDINOTE();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDINOTE> Create(DataTable Table)
    {
        List<EDINOTE> EDINOTElist = new List<EDINOTE>();
        foreach (DataRow row in Table.Rows)
        {
            EDINOTE newObject = Create(row);
            EDINOTElist.Add(newObject);
        }
        return EDINOTElist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDINOTE().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDINOTE (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDINOTE().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDINOTE (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDINOTE ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDINOTE> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDINOTE ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDIPD
{
    #region Properties

    public string cpartcode { get; set; }

    public string ceditrntyp { get; set; }

    public char ctranactv { get; set; }

    public bool? ltrade { get; set; }

    public string cversion { get; set; }

    public string cpartqual { get; set; }

    public string cpartid { get; set; }

    public decimal? ntranseq { get; set; }

    public string cmapset { get; set; }

    public string cowner { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cpartgsid { get; set; }

    public string cedit_user { get; set; }

    public char ctrantype { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string cintchgver { get; set; }

    #endregion

	#region Methods

	public static EDIPD Create(DataRow row)
    {
        EDIPD newRow = new EDIPD();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDIPD> Create(DataTable Table)
    {
        List<EDIPD> EDIPDlist = new List<EDIPD>();
        foreach (DataRow row in Table.Rows)
        {
            EDIPD newObject = Create(row);
            EDIPDlist.Add(newObject);
        }
        return EDIPDlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIPD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIPD (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIPD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIPD (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDIPD ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDIPD> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDIPD ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDIPH
{
    #region Properties

    public string cpartcode { get; set; }

    public string cpartname { get; set; }

    public string cintchgver { get; set; }

    public string cversion { get; set; }

    public string cnetwork { get; set; }

    public string cfieldsep { get; set; }

    public string clinesep { get; set; }

    public decimal? nintchgseq { get; set; }

    public decimal? ngroupseq { get; set; }

    public decimal? nackseq { get; set; }

    public string casnlbl1 { get; set; }

    public string casnlbl2 { get; set; }

    public char ccrtntype { get; set; }

    public bool? lpltshp { get; set; }

    public string cpltlbl { get; set; }

    public bool? lsendack { get; set; }

    public bool? ledipaswrd { get; set; }

    public string cedipaswrd { get; set; }

    public bool? lgrmhang { get; set; }

    public string cowner { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public bool? ldtlbl { get; set; }

    public string cdtlbl { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public char cisacnstid { get; set; }

    public bool? lsnprkcomp { get; set; }

    public char crcvsln { get; set; }

    public char csubelesep { get; set; }

    public bool? lusegross { get; set; }

    public string mstndins { get; set; }

    #endregion

	#region Methods

	public static EDIPH Create(DataRow row)
    {
        EDIPH newRow = new EDIPH();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDIPH> Create(DataTable Table)
    {
        List<EDIPH> EDIPHlist = new List<EDIPH>();
        foreach (DataRow row in Table.Rows)
        {
            EDIPH newObject = Create(row);
            EDIPHlist.Add(newObject);
        }
        return EDIPHlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIPH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIPH (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDIPH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDIPH (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDIPH ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDIPH> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDIPH ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class edipkinf
{
    #region Properties

    public string order { get; set; }

    public decimal? lineno { get; set; }

    public string style { get; set; }

    public string size { get; set; }

    public string pack_id { get; set; }

    public decimal? npackunits { get; set; }

    public decimal? ninnerpack { get; set; }

    public string ccrtnvltyp { get; set; }

    public string ccarrctnid { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string cowner { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static edipkinf Create(DataRow row)
    {
        edipkinf newRow = new edipkinf();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<edipkinf> Create(DataTable Table)
    {
        List<edipkinf> edipkinflist = new List<edipkinf>();
        foreach (DataRow row in Table.Rows)
        {
            edipkinf newObject = Create(row);
            edipkinflist.Add(newObject);
        }
        return edipkinflist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new edipkinf().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into edipkinf (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new edipkinf().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into edipkinf (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from edipkinf ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<edipkinf> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from edipkinf ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDISODT
{
    #region Properties

    public string account { get; set; }

    public string order { get; set; }

    public decimal? line_no { get; set; }

    public decimal? counter { get; set; }

    public string seg_id { get; set; }

    public string edi_lines { get; set; }

    public string csz_pack { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cedit_user { get; set; }

    #endregion

	#region Methods

	public static EDISODT Create(DataRow row)
    {
        EDISODT newRow = new EDISODT();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDISODT> Create(DataTable Table)
    {
        List<EDISODT> EDISODTlist = new List<EDISODT>();
        foreach (DataRow row in Table.Rows)
        {
            EDISODT newObject = Create(row);
            EDISODTlist.Add(newObject);
        }
        return EDISODTlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDISODT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDISODT (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDISODT().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDISODT (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDISODT ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDISODT> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDISODT ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class EDISOHD
{
    #region Properties

    public string account { get; set; }

    public string order { get; set; }

    public decimal? counter { get; set; }

    public string seg_id { get; set; }

    public string edi_lines { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public DateTime? dedit_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_time { get; set; }

    public string cedit_user { get; set; }

    #endregion

	#region Methods

	public static EDISOHD Create(DataRow row)
    {
        EDISOHD newRow = new EDISOHD();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<EDISOHD> Create(DataTable Table)
    {
        List<EDISOHD> EDISOHDlist = new List<EDISOHD>();
        foreach (DataRow row in Table.Rows)
        {
            EDISOHD newObject = Create(row);
            EDISOHDlist.Add(newObject);
        }
        return EDISOHDlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDISOHD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDISOHD (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new EDISOHD().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into EDISOHD (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from EDISOHD ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<EDISOHD> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from EDISOHD ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class orderchg
{
    #region Properties

    public char cordtype { get; set; }

    public string order { get; set; }

    public decimal? lineno { get; set; }

    public string cchrgcode { get; set; }

    public decimal? nchrgamnt { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    public string cedit_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static orderchg Create(DataRow row)
    {
        orderchg newRow = new orderchg();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<orderchg> Create(DataTable Table)
    {
        List<orderchg> orderchglist = new List<orderchg>();
        foreach (DataRow row in Table.Rows)
        {
            orderchg newObject = Create(row);
            orderchglist.Add(newObject);
        }
        return orderchglist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new orderchg().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into orderchg (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new orderchg().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into orderchg (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from orderchg ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<orderchg> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from orderchg ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class ORDHDR
{
    #region Properties

    public char cordtype { get; set; }

    public string order { get; set; }

    public char status { get; set; }

    public string account { get; set; }

    public string store { get; set; }

    public string dept { get; set; }

    public bool? multipo { get; set; }

    public string custpo { get; set; }

    public string note1 { get; set; }

    public string note2 { get; set; }

    public string priority { get; set; }

    public string cordercat { get; set; }

    public string season { get; set; }

    public string cdivision { get; set; }

    public char bulk { get; set; }

    public char creorder { get; set; }

    public char consol { get; set; }

    public char multi { get; set; }

    public string ctermcode { get; set; }

    public string shipvia { get; set; }

    public string spcinst { get; set; }

    public string stname { get; set; }

    public char cinsur { get; set; }

    public string buyer { get; set; }

    public string phone { get; set; }

    public string cfaccode { get; set; }

    public string factacct { get; set; }

    public string approval { get; set; }

    public decimal? appramt { get; set; }

    public DateTime? decl_date { get; set; }

    public string decl_code { get; set; }

    public string rep1 { get; set; }

    public decimal? comm1 { get; set; }

    public string rep2 { get; set; }

    public decimal? comm2 { get; set; }

    public DateTime? entered { get; set; }

    public DateTime? start { get; set; }

    public DateTime? complete { get; set; }

    public DateTime? cancelled { get; set; }

    public decimal? disc { get; set; }

    public decimal? book { get; set; }

    public decimal? bookamt { get; set; }

    public decimal? cancel { get; set; }

    public decimal? cancelamt { get; set; }

    public decimal? ship { get; set; }

    public decimal? shipamt { get; set; }

    public decimal? open { get; set; }

    public decimal? openamt { get; set; }

    public decimal? lastline { get; set; }

    public decimal? totcut { get; set; }

    public char flag { get; set; }

    public string link_code { get; set; }

    public string gl_sales { get; set; }

    public string int_vend { get; set; }

    public string event_cod { get; set; }

    public string billno { get; set; }

    public string merc_type { get; set; }

    public string blank_ord { get; set; }

    public string distrb_no { get; set; }

    public string cclass { get; set; }

    public char mon_flg { get; set; }

    public decimal? labels { get; set; }

    public bool? alt_shpto { get; set; }

    public string cwarecode { get; set; }

    public string ccancreson { get; set; }

    public string caddress1 { get; set; }

    public string caddress2 { get; set; }

    public string caddress3 { get; set; }

    public string caddress4 { get; set; }

    public string caddress5 { get; set; }

    public string ccurrcode { get; set; }

    public decimal? nexrate { get; set; }

    public decimal? ncurrunit { get; set; }

    public string cfromorder { get; set; }

    public bool? direct_inv { get; set; }

    public bool? lhasnotes { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public bool? lediorder { get; set; }

    public string cowner { get; set; }

    public string cedit_time { get; set; }

    public DateTime? dedit_date { get; set; }

    public bool? lfromweb { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string ccontref { get; set; }

    public string cbilltype { get; set; }

    public bool? printed { get; set; }

    public bool? lsendack { get; set; }

    public char cackstatus { get; set; }

    public string creqshpst { get; set; }

    public bool? lstrdirct { get; set; }

    public string creleaseno { get; set; }

    public string ui_pkey { get; set; }

    #endregion

	#region Methods

	public static ORDHDR Create(DataRow row)
    {
        ORDHDR newRow = new ORDHDR();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<ORDHDR> Create(DataTable Table)
    {
        List<ORDHDR> ORDHDRlist = new List<ORDHDR>();
        foreach (DataRow row in Table.Rows)
        {
            ORDHDR newObject = Create(row);
            ORDHDRlist.Add(newObject);
        }
        return ORDHDRlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new ORDHDR().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into ORDHDR (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new ORDHDR().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into ORDHDR (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from ORDHDR ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<ORDHDR> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from ORDHDR ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class ORDLINE
{
    #region Properties

    public char cordtype { get; set; }

    public string order { get; set; }

    public string account { get; set; }

    public string cwarecode { get; set; }

    public decimal? lineno { get; set; }

    public decimal? shipments { get; set; }

    public string store { get; set; }

    public string custpo { get; set; }

    public string style { get; set; }

    public string altstyle { get; set; }

    public string altcolor { get; set; }

    public string season { get; set; }

    public string desc1 { get; set; }

    public string scale { get; set; }

    public char group { get; set; }

    public char prepak { get; set; }

    public decimal? ppqty { get; set; }

    public decimal? price { get; set; }

    public decimal? nsugretpri { get; set; }

    public decimal? gros_price { get; set; }

    public decimal? disc_pcnt { get; set; }

    public DateTime? start { get; set; }

    public DateTime? complete { get; set; }

    public decimal? qty1 { get; set; }

    public decimal? qty2 { get; set; }

    public decimal? qty3 { get; set; }

    public decimal? qty4 { get; set; }

    public decimal? qty5 { get; set; }

    public decimal? qty6 { get; set; }

    public decimal? qty7 { get; set; }

    public decimal? qty8 { get; set; }

    public decimal? totqty { get; set; }

    public decimal? book1 { get; set; }

    public decimal? book2 { get; set; }

    public decimal? book3 { get; set; }

    public decimal? book4 { get; set; }

    public decimal? book5 { get; set; }

    public decimal? book6 { get; set; }

    public decimal? book7 { get; set; }

    public decimal? book8 { get; set; }

    public decimal? totbook { get; set; }

    public decimal? pik1 { get; set; }

    public decimal? pik2 { get; set; }

    public decimal? pik3 { get; set; }

    public decimal? pik4 { get; set; }

    public decimal? pik5 { get; set; }

    public decimal? pik6 { get; set; }

    public decimal? pik7 { get; set; }

    public decimal? pik8 { get; set; }

    public decimal? totpik { get; set; }

    public string piktkt { get; set; }

    public DateTime? pikdate { get; set; }

    public bool? picked { get; set; }

    public string invoice { get; set; }

    public DateTime? invdate { get; set; }

    public char flag { get; set; }

    public string cuttkt { get; set; }

    public string dyelot { get; set; }

    public decimal? allocated { get; set; }

    public decimal? cut1 { get; set; }

    public decimal? cut2 { get; set; }

    public decimal? cut3 { get; set; }

    public decimal? cut4 { get; set; }

    public decimal? cut5 { get; set; }

    public decimal? cut6 { get; set; }

    public decimal? cut7 { get; set; }

    public decimal? cut8 { get; set; }

    public decimal? totcut { get; set; }

    public decimal? poalo1 { get; set; }

    public decimal? poalo2 { get; set; }

    public decimal? poalo3 { get; set; }

    public decimal? poalo4 { get; set; }

    public decimal? poalo5 { get; set; }

    public decimal? poalo6 { get; set; }

    public decimal? poalo7 { get; set; }

    public decimal? poalo8 { get; set; }

    public decimal? tot_poalo { get; set; }

    public decimal? npck1 { get; set; }

    public decimal? npck2 { get; set; }

    public decimal? npck3 { get; set; }

    public decimal? npck4 { get; set; }

    public decimal? npck5 { get; set; }

    public decimal? npck6 { get; set; }

    public decimal? npck7 { get; set; }

    public decimal? npck8 { get; set; }

    public decimal? npwght { get; set; }

    public string note_mem { get; set; }

    public decimal? comm1 { get; set; }

    public decimal? comm2 { get; set; }

    public string po { get; set; }

    public decimal? cost { get; set; }

    public string gl_sales { get; set; }

    public string gl_cost { get; set; }

    public string pack_id { get; set; }

    public decimal? npolineno { get; set; }

    public string cfromorder { get; set; }

    public decimal? bulklineno { get; set; }

    public string clinestat { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string cowner { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string cpkcolor { get; set; }

    public string cpcksize { get; set; }

    public string cpkversion { get; set; }

    public decimal? npkslprice { get; set; }

    public char callocatby { get; set; }

    public string cpckacc { get; set; }

    public decimal? npackno { get; set; }

    public bool? lrange { get; set; }

    public bool? lpckprpiec { get; set; }

    public decimal? npriceadd { get; set; }

    public string employee { get; set; }

    public decimal? npkpack { get; set; }

    public string ui_pkey { get; set; }

    #endregion

	#region Methods

	public static ORDLINE Create(DataRow row)
    {
        ORDLINE newRow = new ORDLINE();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<ORDLINE> Create(DataTable Table)
    {
        List<ORDLINE> ORDLINElist = new List<ORDLINE>();
        foreach (DataRow row in Table.Rows)
        {
            ORDLINE newObject = Create(row);
            ORDLINElist.Add(newObject);
        }
        return ORDLINElist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new ORDLINE().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into ORDLINE (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new ORDLINE().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into ORDLINE (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from ORDLINE ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<ORDLINE> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from ORDLINE ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_ADDRESS_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public string ADDRESS_TYPE { get; set; }

    public string LOCATION_CODE { get; set; }

    public string NAME { get; set; }

    public string ADDRESS_LINE_1 { get; set; }

    public string ADDRESS_LINE_2 { get; set; }

    public string CITY { get; set; }

    public string STATE { get; set; }

    public string ZIP_CODE { get; set; }

    public string COUNTRY { get; set; }

    public string CONTACT { get; set; }

    public string PHONE { get; set; }

    public string EMAIL_ADDRESS { get; set; }

    public string GLN_NUMBER { get; set; }

    public string DUNS_NUMBER { get; set; }

    public Guid? PO_ADDRESS_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_ADDRESS_T Create(DataRow row)
    {
        PO_ADDRESS_T newRow = new PO_ADDRESS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_ADDRESS_T> Create(DataTable Table)
    {
        List<PO_ADDRESS_T> PO_ADDRESS_Tlist = new List<PO_ADDRESS_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_ADDRESS_T newObject = Create(row);
            PO_ADDRESS_Tlist.Add(newObject);
        }
        return PO_ADDRESS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ADDRESS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ADDRESS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ADDRESS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ADDRESS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_ADDRESS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_ADDRESS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_ADDRESS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_CHARGES_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public Int64? ITEM_LINE_NO { get; set; }

    public string CHARGE_TYPE { get; set; }

    public string CHARGE_CODE { get; set; }

    public string CHARGE_DESCRIPTION { get; set; }

    public decimal? CHARGE_AMOUNT { get; set; }

    public string METHOD_OF_HANDLING { get; set; }

    public Guid? PO_CHARGES_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_CHARGES_T Create(DataRow row)
    {
        PO_CHARGES_T newRow = new PO_CHARGES_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_CHARGES_T> Create(DataTable Table)
    {
        List<PO_CHARGES_T> PO_CHARGES_Tlist = new List<PO_CHARGES_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_CHARGES_T newObject = Create(row);
            PO_CHARGES_Tlist.Add(newObject);
        }
        return PO_CHARGES_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_CHARGES_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_CHARGES_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_CHARGES_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_CHARGES_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_CHARGES_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_CHARGES_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_CHARGES_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_HEADER_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public string TRANSACTION_TYPE { get; set; }

    public DateTime? ENTERED { get; set; }

    public string RELEASE_NUMBER { get; set; }

    public string BLANKET_NUMBER { get; set; }

    public string CONTRACT_NUMBER { get; set; }

    public string MERCHANDISE_TYPE { get; set; }

    public string PROMOTION_CODE { get; set; }

    public string PO_TYPE { get; set; }

    public string VENDOR_NUMBER { get; set; }

    public string DEPARTMENT { get; set; }

    public string BUYER { get; set; }

    public string ORDER_CONTACT { get; set; }

    public string DELIVERY_CONTACT { get; set; }

    public DateTime? DELIVERY_REQUESTED { get; set; }

    public DateTime? CANCEL_AFTER { get; set; }

    public DateTime? REQUESTED_SHIP { get; set; }

    public DateTime? SHIP_NOT_BEFORE { get; set; }

    public DateTime? DONT_DELIVER_AFTER { get; set; }

    public DateTime? DONT_DELIVER_BEFORE { get; set; }

    public string HANDLING_INSTRUCTIONS { get; set; }

    public string FULFILLMENTSERVICELEVEL { get; set; }

    public Guid? PO_HEADER_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_HEADER_T Create(DataRow row)
    {
        PO_HEADER_T newRow = new PO_HEADER_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_HEADER_T> Create(DataTable Table)
    {
        List<PO_HEADER_T> PO_HEADER_Tlist = new List<PO_HEADER_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_HEADER_T newObject = Create(row);
            PO_HEADER_Tlist.Add(newObject);
        }
        return PO_HEADER_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_HEADER_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_HEADER_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_HEADER_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_HEADER_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_HEADER_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_HEADER_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_HEADER_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_ITEMS_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public Int64? ITEM_LINE_NO { get; set; }

    public string VENDOR_ITEM { get; set; }

    public string VENDOR_STYLE { get; set; }

    public string VENDOR_COLOR { get; set; }

    public string VENDOR_SIZE { get; set; }

    public string BUYER_ITEM { get; set; }

    public string BUYER_STYLE { get; set; }

    public string BUYER_COLOR { get; set; }

    public string BUYER_SIZE { get; set; }

    public string COLOR_NRF { get; set; }

    public string SIZE_NRF { get; set; }

    public string UPC_NUMBER { get; set; }

    public string ITEM_DESCRIPTION { get; set; }

    public int? INNER_CONTAINERS { get; set; }

    public int? CONTAINER_EACHES { get; set; }

    public int? QUANTITY_ORDERED { get; set; }

    public string UOM { get; set; }

    public decimal? UNIT_PRICE { get; set; }

    public decimal? CATALOGUE_PRICE { get; set; }

    public decimal? RETAIL_PRICE { get; set; }

    public decimal? SUGGESTED_RETAIL_PRICE { get; set; }

    public decimal? PROMOTIONAL_PRICE { get; set; }

    public DateTime? REQUEST_SHIP_DATE { get; set; }

    public DateTime? DELIVERY_REQUESTED_DATE { get; set; }

    public string HANDLING_INSTRUCTIONS { get; set; }

    public Guid? PO_ITEMS_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_ITEMS_T Create(DataRow row)
    {
        PO_ITEMS_T newRow = new PO_ITEMS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_ITEMS_T> Create(DataTable Table)
    {
        List<PO_ITEMS_T> PO_ITEMS_Tlist = new List<PO_ITEMS_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_ITEMS_T newObject = Create(row);
            PO_ITEMS_Tlist.Add(newObject);
        }
        return PO_ITEMS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ITEMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ITEMS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ITEMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ITEMS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_ITEMS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_ITEMS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_ITEMS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_ITEM_DISTENTION_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public Int64? ITEM_LINE_NO { get; set; }

    public string LOCATION_ID { get; set; }

    public int? QUANTITY_ORDERED { get; set; }

    public string UOM { get; set; }

    public Guid? PO_ITEM_DISTENTION_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_ITEM_DISTENTION_T Create(DataRow row)
    {
        PO_ITEM_DISTENTION_T newRow = new PO_ITEM_DISTENTION_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_ITEM_DISTENTION_T> Create(DataTable Table)
    {
        List<PO_ITEM_DISTENTION_T> PO_ITEM_DISTENTION_Tlist = new List<PO_ITEM_DISTENTION_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_ITEM_DISTENTION_T newObject = Create(row);
            PO_ITEM_DISTENTION_Tlist.Add(newObject);
        }
        return PO_ITEM_DISTENTION_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ITEM_DISTENTION_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ITEM_DISTENTION_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_ITEM_DISTENTION_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_ITEM_DISTENTION_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_ITEM_DISTENTION_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_ITEM_DISTENTION_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_ITEM_DISTENTION_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_MESSAGES_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public Int64? ITEM_LINE_NO { get; set; }

    public int? MESSAGE_NO { get; set; }

    public string MESSAGE_TITLE { get; set; }

    public string MESSAGE { get; set; }

    public Guid? PO_MESSAGES_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_MESSAGES_T Create(DataRow row)
    {
        PO_MESSAGES_T newRow = new PO_MESSAGES_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_MESSAGES_T> Create(DataTable Table)
    {
        List<PO_MESSAGES_T> PO_MESSAGES_Tlist = new List<PO_MESSAGES_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_MESSAGES_T newObject = Create(row);
            PO_MESSAGES_Tlist.Add(newObject);
        }
        return PO_MESSAGES_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_MESSAGES_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_MESSAGES_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_MESSAGES_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_MESSAGES_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_MESSAGES_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_MESSAGES_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_MESSAGES_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_SUBLINE_ITEM_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public Int64? ITEM_LINE_NO { get; set; }

    public int? SUB_ITEM_LINE_NO { get; set; }

    public string VENDOR_ITEM { get; set; }

    public string VENDOR_STYLE { get; set; }

    public string VENDOR_COLOR { get; set; }

    public string VENDOR_SIZE { get; set; }

    public string BUYER_ITEM { get; set; }

    public string BUYER_STYLE { get; set; }

    public string BUYER_COLOR { get; set; }

    public string BUYER_SIZE { get; set; }

    public string COLOR_NRF { get; set; }

    public string SIZE_NRF { get; set; }

    public string UPC_NUMBER { get; set; }

    public int? QUANTITY_ORDERED { get; set; }

    public string UOM { get; set; }

    public decimal? UNIT_PRICE { get; set; }

    public Guid? PO_SUBLINE_ITEM_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_SUBLINE_ITEM_T Create(DataRow row)
    {
        PO_SUBLINE_ITEM_T newRow = new PO_SUBLINE_ITEM_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_SUBLINE_ITEM_T> Create(DataTable Table)
    {
        List<PO_SUBLINE_ITEM_T> PO_SUBLINE_ITEM_Tlist = new List<PO_SUBLINE_ITEM_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_SUBLINE_ITEM_T newObject = Create(row);
            PO_SUBLINE_ITEM_Tlist.Add(newObject);
        }
        return PO_SUBLINE_ITEM_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_SUBLINE_ITEM_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_SUBLINE_ITEM_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_SUBLINE_ITEM_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_SUBLINE_ITEM_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_SUBLINE_ITEM_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_SUBLINE_ITEM_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_SUBLINE_ITEM_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class PO_TERMS_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public string TERM_CODE { get; set; }

    public string TERM_DESCRIPTION { get; set; }

    public string BASIC_DATE_CODE { get; set; }

    public decimal? DISCOUNT_PERCENT { get; set; }

    public DateTime? DISCOUNT_DUE_DATE { get; set; }

    public int? DISCOUNT_DAYS_DUE { get; set; }

    public DateTime? NET_DUE_DATE { get; set; }

    public int? NET_DAYS { get; set; }

    public decimal? DISCOUNT_AMOUNT { get; set; }

    public DateTime? DEFERRED_DUE_DATE { get; set; }

    public decimal? DEFERRED_AMOUNT_DUE { get; set; }

    public int? PERCENT_INVOICE_PAYABLE { get; set; }

    public int? DAY_OF_MONTH { get; set; }

    public string PAYMENT_METHOD { get; set; }

    public Guid? PO_TERMS_KEY { get; set; }

    #endregion

	#region Methods

	public static PO_TERMS_T Create(DataRow row)
    {
        PO_TERMS_T newRow = new PO_TERMS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<PO_TERMS_T> Create(DataTable Table)
    {
        List<PO_TERMS_T> PO_TERMS_Tlist = new List<PO_TERMS_T>();
        foreach (DataRow row in Table.Rows)
        {
            PO_TERMS_T newObject = Create(row);
            PO_TERMS_Tlist.Add(newObject);
        }
        return PO_TERMS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_TERMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_TERMS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new PO_TERMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into PO_TERMS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from PO_TERMS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<PO_TERMS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from PO_TERMS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class sequence
{
    #region Properties

    public string cseq_type { get; set; }

    public char cseq_chr { get; set; }

    public string cseq_group { get; set; }

    public decimal? nseq_no { get; set; }

    public decimal? nfld_wdth { get; set; }

    public char cdata_typ { get; set; }

    public string cfile_nam { get; set; }

    public string cfile_tag { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static sequence Create(DataRow row)
    {
        sequence newRow = new sequence();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<sequence> Create(DataTable Table)
    {
        List<sequence> sequencelist = new List<sequence>();
        foreach (DataRow row in Table.Rows)
        {
            sequence newObject = Create(row);
            sequencelist.Add(newObject);
        }
        return sequencelist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new sequence().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into sequence (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new sequence().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into sequence (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from sequence ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<sequence> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from sequence ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_CONTAINERS_T
{
    #region Properties

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public Int64? SHIPMENT_CONTAINERS_KEY { get; set; }

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public string SSCC_18 { get; set; }

    public string SSCC_20 { get; set; }

    public string UPC_SHIPPING_CODE { get; set; }

    public string CARRIER_PACKAGE_ID { get; set; }

    public string SHIPPER_ID { get; set; }

    public int? QUANTITY_SHIPPED { get; set; }

    public string UOM { get; set; }

    public decimal? WIDTH { get; set; }

    public decimal? HEIGHT { get; set; }

    public decimal? LENGTH { get; set; }

    public string DIMENSIONS_UOM { get; set; }

    public decimal? WEIGHT { get; set; }

    public string WEIGHT_UOM { get; set; }

    public string PACKAGE_TYPE { get; set; }

    public string BUYING_PARTY_LOCATION { get; set; }

    public string BUYING_PARTY_GLN_NUMBER { get; set; }

    public string BUYING_PARTY_DUNS_NUMBER { get; set; }

    public string BUYING_PARTY_NAME { get; set; }

    public string BUYING_PARTY_ADDRESS_1 { get; set; }

    public string BUYING_PARTY_ADDRESS_2 { get; set; }

    public string BUYING_PARTY_CITY { get; set; }

    public string BUYING_PARTY_STATE { get; set; }

    public string BUYING_PARTY_ZIP { get; set; }

    public string BUYING_PARTY_COUNTRY { get; set; }

    public string BUYING_PARTY_CONTACT { get; set; }

    public string BUYING_PARTY_PHONE { get; set; }

    public string BUYING_PARTY_FAX { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_CONTAINERS_T Create(DataRow row)
    {
        SHIPMENT_CONTAINERS_T newRow = new SHIPMENT_CONTAINERS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_CONTAINERS_T> Create(DataTable Table)
    {
        List<SHIPMENT_CONTAINERS_T> SHIPMENT_CONTAINERS_Tlist = new List<SHIPMENT_CONTAINERS_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_CONTAINERS_T newObject = Create(row);
            SHIPMENT_CONTAINERS_Tlist.Add(newObject);
        }
        return SHIPMENT_CONTAINERS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_CONTAINERS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_CONTAINERS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_CONTAINERS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_CONTAINERS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_CONTAINERS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_CONTAINERS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_CONTAINERS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_DETAILS_T
{
    #region Properties

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public Int64? SHIPMENT_DETAILS_KEY { get; set; }

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public string RETAILER_PO_RELEASE { get; set; }

    public DateTime? RETAILER_PO_DATE { get; set; }

    public string BOL_NO { get; set; }

    public string SELLER_INVOICE { get; set; }

    public string VENDOR_ORDER { get; set; }

    public string VENDOR_NUMBER { get; set; }

    public string MERCHANDISE_TYPE { get; set; }

    public string PROMOTION_CODE { get; set; }

    public string DEPARTMENT { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_DETAILS_T Create(DataRow row)
    {
        SHIPMENT_DETAILS_T newRow = new SHIPMENT_DETAILS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_DETAILS_T> Create(DataTable Table)
    {
        List<SHIPMENT_DETAILS_T> SHIPMENT_DETAILS_Tlist = new List<SHIPMENT_DETAILS_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_DETAILS_T newObject = Create(row);
            SHIPMENT_DETAILS_Tlist.Add(newObject);
        }
        return SHIPMENT_DETAILS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_DETAILS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_DETAILS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_DETAILS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_DETAILS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_DETAILS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_DETAILS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_DETAILS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_HEADER_T
{
    #region Properties

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public DateTime? DATE { get; set; }

    public string BOL { get; set; }

    public string MASTER_BOL { get; set; }

    public string ALTERNATE_BOL { get; set; }

    public int? LADING_QUANTITY { get; set; }

    public decimal? GROSS_WEIGHT { get; set; }

    public string WEIGHT_UOM { get; set; }

    public string SHIP_FROM_LOCATION { get; set; }

    public string SHIP_FROM_GLN_NUMBER { get; set; }

    public string SHIP_FROM_DUNS_NUMBER { get; set; }

    public string SHIP_FROM_NAME { get; set; }

    public string SHIP_FROM_ADDRESS_1 { get; set; }

    public string SHIP_FROM_ADDRESS_2 { get; set; }

    public string SHIP_FROM_CITY { get; set; }

    public string SHIP_FROM_STATE { get; set; }

    public string SHIP_FROM_ZIP { get; set; }

    public string SHIP_FROM_COUNTRY { get; set; }

    public string SHIP_FROM_CONTACT { get; set; }

    public string SHIP_FROM_PHONE { get; set; }

    public string SHIP_FROM_FAX { get; set; }

    public string SHIP_TO_LOCATION { get; set; }

    public string SHIP_TO_GLN_NUMBER { get; set; }

    public string SHIP_TO_DUNS_NUMBER { get; set; }

    public string SHIP_TO_NAME { get; set; }

    public string SHIP_TO_ADDRESS_1 { get; set; }

    public string SHIP_TO_ADDRESS_2 { get; set; }

    public string SHIP_TO_CITY { get; set; }

    public string SHIP_TO_STATE { get; set; }

    public string SHIP_TO_ZIP { get; set; }

    public string SHIP_TO_COUNTRY { get; set; }

    public string SHIP_TO_CONTACT { get; set; }

    public string SHIP_TO_PHONE { get; set; }

    public string SHIP_TO_FAX { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_HEADER_T Create(DataRow row)
    {
        SHIPMENT_HEADER_T newRow = new SHIPMENT_HEADER_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_HEADER_T> Create(DataTable Table)
    {
        List<SHIPMENT_HEADER_T> SHIPMENT_HEADER_Tlist = new List<SHIPMENT_HEADER_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_HEADER_T newObject = Create(row);
            SHIPMENT_HEADER_Tlist.Add(newObject);
        }
        return SHIPMENT_HEADER_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_HEADER_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_HEADER_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_HEADER_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_HEADER_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_HEADER_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_HEADER_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_HEADER_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_ITEMS_T
{
    #region Properties

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public Int64? SHIPMENT_ITEMS_KEY { get; set; }

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public string VENDOR_ITEM { get; set; }

    public string VENDOR_STYLE { get; set; }

    public string VENDOR_COLOR { get; set; }

    public string VENDOR_SIZE { get; set; }

    public string BUYER_ITEM { get; set; }

    public string BUYER_STYLE { get; set; }

    public string BUYER_COLOR { get; set; }

    public string BUYER_SIZE { get; set; }

    public string COLOR_NRF { get; set; }

    public string SIZE_NRF { get; set; }

    public string UPC_NUMBER { get; set; }

    public int? INNER_CONTAINERS { get; set; }

    public int? QUANTITY_SHIPPED { get; set; }

    public string UOM { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_ITEMS_T Create(DataRow row)
    {
        SHIPMENT_ITEMS_T newRow = new SHIPMENT_ITEMS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_ITEMS_T> Create(DataTable Table)
    {
        List<SHIPMENT_ITEMS_T> SHIPMENT_ITEMS_Tlist = new List<SHIPMENT_ITEMS_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_ITEMS_T newObject = Create(row);
            SHIPMENT_ITEMS_Tlist.Add(newObject);
        }
        return SHIPMENT_ITEMS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ITEMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ITEMS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ITEMS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ITEMS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_ITEMS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_ITEMS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_ITEMS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_ITEM_CONTAINERS_T
{
    #region Properties

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public Int64? SHIPMENT_ITEMS_KEY { get; set; }

    public Int64? SHIPMENT_CONTAINERS_KEY { get; set; }

    public Int64? SHIPMENT_ITEM_CONTAINERS_KEY { get; set; }

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public string RETAILER_PO { get; set; }

    public int? QUANTITY_SHIPPED { get; set; }

    public string UOM { get; set; }

    public string SHIPMENT_STATUS { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_ITEM_CONTAINERS_T Create(DataRow row)
    {
        SHIPMENT_ITEM_CONTAINERS_T newRow = new SHIPMENT_ITEM_CONTAINERS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_ITEM_CONTAINERS_T> Create(DataTable Table)
    {
        List<SHIPMENT_ITEM_CONTAINERS_T> SHIPMENT_ITEM_CONTAINERS_Tlist = new List<SHIPMENT_ITEM_CONTAINERS_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_ITEM_CONTAINERS_T newObject = Create(row);
            SHIPMENT_ITEM_CONTAINERS_Tlist.Add(newObject);
        }
        return SHIPMENT_ITEM_CONTAINERS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ITEM_CONTAINERS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ITEM_CONTAINERS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ITEM_CONTAINERS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ITEM_CONTAINERS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_ITEM_CONTAINERS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_ITEM_CONTAINERS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_ITEM_CONTAINERS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SHIPMENT_ROUTING_T
{
    #region Properties

    public Int64? SHIPMENT_HEADER_KEY { get; set; }

    public Int64? SHIPMENT_ROUTING_KEY { get; set; }

    public string PARTNER_ID { get; set; }

    public string SHIPMENT_ID { get; set; }

    public string ROUTING_SEQUENCE { get; set; }

    public string CARRIER_CODE { get; set; }

    public string TRANSPORTATION_METHOD { get; set; }

    public string ROUTING_DESCRIPTION { get; set; }

    public string SHIPPER_TRACKING_NUMBER { get; set; }

    public string TRANSIT_TIME { get; set; }

    public string SERVICE_LEVEL { get; set; }

    #endregion

	#region Methods

	public static SHIPMENT_ROUTING_T Create(DataRow row)
    {
        SHIPMENT_ROUTING_T newRow = new SHIPMENT_ROUTING_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SHIPMENT_ROUTING_T> Create(DataTable Table)
    {
        List<SHIPMENT_ROUTING_T> SHIPMENT_ROUTING_Tlist = new List<SHIPMENT_ROUTING_T>();
        foreach (DataRow row in Table.Rows)
        {
            SHIPMENT_ROUTING_T newObject = Create(row);
            SHIPMENT_ROUTING_Tlist.Add(newObject);
        }
        return SHIPMENT_ROUTING_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ROUTING_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ROUTING_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SHIPMENT_ROUTING_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SHIPMENT_ROUTING_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SHIPMENT_ROUTING_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SHIPMENT_ROUTING_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SHIPMENT_ROUTING_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SYCCOMP
{
    #region Properties

    public string ccomp_id { get; set; }

    public string ccom_name { get; set; }

    public string ccompprnt { get; set; }

    public string caddress1 { get; set; }

    public string caddress2 { get; set; }

    public string caddress3 { get; set; }

    public string caddress4 { get; set; }

    public string caddress5 { get; set; }

    public string caddress6 { get; set; }

    public string ccom_phon { get; set; }

    public string ccom_fax { get; set; }

    public string ccurrcode { get; set; }

    public string ccom_ddir { get; set; }

    public string ccurr_yer { get; set; }

    public string ccurr_prd { get; set; }

    public string mcomp_mdl { get; set; }

    public string ccont_code { get; set; }

    public string mmodlset { get; set; }

    public string state { get; set; }

    public string cadd_user { get; set; }

    public DateTime? dadd_date { get; set; }

    public string cadd_time { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string ccondriver { get; set; }

    public string cedt_ver { get; set; }

    public string cconserver { get; set; }

    public string ccondbname { get; set; }

    public string cconuserid { get; set; }

    public string cconpaswrd { get; set; }

    public bool? lrunfroma4 { get; set; }

    #endregion

	#region Methods

	public static SYCCOMP Create(DataRow row)
    {
        SYCCOMP newRow = new SYCCOMP();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SYCCOMP> Create(DataTable Table)
    {
        List<SYCCOMP> SYCCOMPlist = new List<SYCCOMP>();
        foreach (DataRow row in Table.Rows)
        {
            SYCCOMP newObject = Create(row);
            SYCCOMPlist.Add(newObject);
        }
        return SYCCOMPlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCCOMP().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCCOMP (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCCOMP().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCCOMP (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SYCCOMP ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SYCCOMP> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SYCCOMP ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SYCEDILH
{
    #region Properties

    public string cfilecode { get; set; }

    public string cedifilnam { get; set; }

    public string cfilepath { get; set; }

    public string cnetwork { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    #endregion

	#region Methods

	public static SYCEDILH Create(DataRow row)
    {
        SYCEDILH newRow = new SYCEDILH();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SYCEDILH> Create(DataTable Table)
    {
        List<SYCEDILH> SYCEDILHlist = new List<SYCEDILH>();
        foreach (DataRow row in Table.Rows)
        {
            SYCEDILH newObject = Create(row);
            SYCEDILHlist.Add(newObject);
        }
        return SYCEDILHlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCEDILH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCEDILH (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCEDILH().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCEDILH (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SYCEDILH ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SYCEDILH> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SYCEDILH ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SYCEDITR
{
    #region Properties

    public string ceditrncod { get; set; }

    public string ceditrntyp { get; set; }

    public string ceditrnnam { get; set; }

    public char ctrantype { get; set; }

    public string mrclassnam { get; set; }

    public string msclassnam { get; set; }

    public string cicrclass { get; set; }

    public string cicsclass { get; set; }

    public string cbarmodule { get; set; }

    public string cowner { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public decimal? nrevision { get; set; }

    public string cfacttrn { get; set; }

    #endregion

	#region Methods

	public static SYCEDITR Create(DataRow row)
    {
        SYCEDITR newRow = new SYCEDITR();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SYCEDITR> Create(DataTable Table)
    {
        List<SYCEDITR> SYCEDITRlist = new List<SYCEDITR>();
        foreach (DataRow row in Table.Rows)
        {
            SYCEDITR newObject = Create(row);
            SYCEDITRlist.Add(newObject);
        }
        return SYCEDITRlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCEDITR().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCEDITR (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCEDITR().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCEDITR (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SYCEDITR ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SYCEDITR> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SYCEDITR ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class SYCINST
{
    #region Properties

    public bool? linsmuser { get; set; }

    public bool? linslogrq { get; set; }

    public bool? linspassw { get; set; }

    public bool? linsaudlg { get; set; }

    public bool? linswsreq { get; set; }

    public string cinscltyp { get; set; }

    public string cinsdfcom { get; set; }

    public string cinsdfclm { get; set; }

    public string cinsdfclc { get; set; }

    public bool? linsusdos { get; set; }

    public bool? linsuswin { get; set; }

    public bool? linsusunx { get; set; }

    public bool? linsusmac { get; set; }

    public string ccompath { get; set; }

    public string cservpath { get; set; }

    public string cinsysfdr { get; set; }

    public string cimagdir { get; set; }

    public string clibdir { get; set; }

    public string cscrdir { get; set; }

    public string cinsallcmp { get; set; }

    public string cinsrsrdr { get; set; }

    public string cinsdospd { get; set; }

    public string cinsdosrd { get; set; }

    public string cinsdoswd { get; set; }

    public string cinswinpd { get; set; }

    public string cinswinrd { get; set; }

    public string cinswinwd { get; set; }

    public string cinswinbm { get; set; }

    public string cdef_bmp { get; set; }

    public string cinsunxpd { get; set; }

    public string cinsunxrd { get; set; }

    public string cinsunxwd { get; set; }

    public string cinsmacpd { get; set; }

    public string cinsmacrd { get; set; }

    public string cinsmacwd { get; set; }

    public string cclassdir { get; set; }

    public string cedipath { get; set; }

    public string ccont_code { get; set; }

    public string ccursiteid { get; set; }

    public bool? llocksys { get; set; }

    public string cadd_user { get; set; }

    public string cedit_user { get; set; }

    public string cadd_time { get; set; }

    public string cedit_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public DateTime? dedit_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    #endregion

	#region Methods

	public static SYCINST Create(DataRow row)
    {
        SYCINST newRow = new SYCINST();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<SYCINST> Create(DataTable Table)
    {
        List<SYCINST> SYCINSTlist = new List<SYCINST>();
        foreach (DataRow row in Table.Rows)
        {
            SYCINST newObject = Create(row);
            SYCINSTlist.Add(newObject);
        }
        return SYCINSTlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCINST().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCINST (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new SYCINST().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into SYCINST (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from SYCINST ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<SYCINST> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from SYCINST ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class TRANSACTION_MAP_T
{
    #region Properties

    public int? TRANSACTION_SEGMENTS_KEY { get; set; }

    public short? FIELD_ORDER { get; set; }

    public string FIELD_NAME { get; set; }

    public int? TRANSACTION_MAP_KEY { get; set; }

    public string CONDITION { get; set; }

    public string VALUE { get; set; }

    public string DATA_TYPE { get; set; }

    public string USAGE { get; set; }

    public short? START_POSITION { get; set; }

    public short? FIELD_LENGTH { get; set; }

    #endregion

	#region Methods

	public static TRANSACTION_MAP_T Create(DataRow row)
    {
        TRANSACTION_MAP_T newRow = new TRANSACTION_MAP_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<TRANSACTION_MAP_T> Create(DataTable Table)
    {
        List<TRANSACTION_MAP_T> TRANSACTION_MAP_Tlist = new List<TRANSACTION_MAP_T>();
        foreach (DataRow row in Table.Rows)
        {
            TRANSACTION_MAP_T newObject = Create(row);
            TRANSACTION_MAP_Tlist.Add(newObject);
        }
        return TRANSACTION_MAP_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new TRANSACTION_MAP_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into TRANSACTION_MAP_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new TRANSACTION_MAP_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into TRANSACTION_MAP_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from TRANSACTION_MAP_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<TRANSACTION_MAP_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from TRANSACTION_MAP_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class TRANSACTION_SEGMENTS_T
{
    #region Properties

    public string DIRECTION { get; set; }

    public string TRANSACTION_TYPE { get; set; }

    public string MAP_SET { get; set; }

    public string VERSION { get; set; }

    public string LOOP_ID { get; set; }

    public short? SEGMENT_ORDER { get; set; }

    public string SEGMENT_ID { get; set; }

    public int? TRANSACTION_SEGMENTS_KEY { get; set; }

    public string USAGE { get; set; }

    #endregion

	#region Methods

	public static TRANSACTION_SEGMENTS_T Create(DataRow row)
    {
        TRANSACTION_SEGMENTS_T newRow = new TRANSACTION_SEGMENTS_T();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<TRANSACTION_SEGMENTS_T> Create(DataTable Table)
    {
        List<TRANSACTION_SEGMENTS_T> TRANSACTION_SEGMENTS_Tlist = new List<TRANSACTION_SEGMENTS_T>();
        foreach (DataRow row in Table.Rows)
        {
            TRANSACTION_SEGMENTS_T newObject = Create(row);
            TRANSACTION_SEGMENTS_Tlist.Add(newObject);
        }
        return TRANSACTION_SEGMENTS_Tlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new TRANSACTION_SEGMENTS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into TRANSACTION_SEGMENTS_T (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new TRANSACTION_SEGMENTS_T().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into TRANSACTION_SEGMENTS_T (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from TRANSACTION_SEGMENTS_T ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<TRANSACTION_SEGMENTS_T> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from TRANSACTION_SEGMENTS_T ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

public class WAREHOUS
{
    #region Properties

    public string cwarecode { get; set; }

    public string cdesc { get; set; }

    public string caddr1 { get; set; }

    public string caddr2 { get; set; }

    public string ccity { get; set; }

    public string cstate { get; set; }

    public string czip { get; set; }

    public string cphone { get; set; }

    public string ups { get; set; }

    public string cfax { get; set; }

    public bool? lflag { get; set; }

    public string ccountry { get; set; }

    public string gl_link { get; set; }

    public string caddress1 { get; set; }

    public string caddress2 { get; set; }

    public string caddress3 { get; set; }

    public string caddress4 { get; set; }

    public string caddress5 { get; set; }

    public string caddress6 { get; set; }

    public bool? lstyinv { get; set; }

    public bool? lmatinv { get; set; }

    public string ccont_code { get; set; }

    public string csiteid { get; set; }

    public string cadd_user { get; set; }

    public string cadd_time { get; set; }

    public DateTime? dadd_date { get; set; }

    public bool? llok_stat { get; set; }

    public string clok_user { get; set; }

    public DateTime? dlok_date { get; set; }

    public string clok_time { get; set; }

    public string cowner { get; set; }

    public string cedit_user { get; set; }

    public DateTime? dedit_date { get; set; }

    public string cedit_time { get; set; }

    public string cadd_ver { get; set; }

    public string cedt_ver { get; set; }

    public string cthrdplpr { get; set; }

    public char cdefcode { get; set; }

    public bool? ldefware { get; set; }

    #endregion

	#region Methods

	public static WAREHOUS Create(DataRow row)
    {
        WAREHOUS newRow = new WAREHOUS();
        foreach (PropertyInfo property in newRow.GetType().GetProperties())
        {
            if (property.CanWrite && row.Table.Columns.Contains(property.Name))
            {
			    if (property.PropertyType == typeof(char) && row.Table.Columns[property.Name].DataType == typeof(string))
                    property.SetValue(newRow,Convert.ToChar(row[property.Name]), null);
                else
                property.SetValue(newRow, row[property.Name], null);
            }
        }
        return newRow;
    }

    public static List<WAREHOUS> Create(DataTable Table)
    {
        List<WAREHOUS> WAREHOUSlist = new List<WAREHOUS>();
        foreach (DataRow row in Table.Rows)
        {
            WAREHOUS newObject = Create(row);
            WAREHOUSlist.Add(newObject);
        }
        return WAREHOUSlist;
    }
	
	public int ExecuteSqlInsert(SqlConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new WAREHOUS().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
			else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double) || Value.GetType() == typeof(Int64) ||Value.GetType() == typeof(Int16) )
			{
			    Values += Value;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(DateTime))
			{
			    Values += "'" + ((DateTime)Value).ToString("MM/dd/yyyy") + "'";
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(bool))
			{
			    Values += (bool)Value ? 1 : 0;
				valueUsed = true;
			}
			else if (Value.GetType() == typeof(Guid))
			{
			    if (((Guid)Value) == Guid.Empty)
			        Values += "NEWID()";
			    else
			        Values += "'" + ((Guid)Value).ToString() + "'";
				valueUsed = true;
			}
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into WAREHOUS (" + Fields + ") values(" + Values + ")";
		SqlCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();		
		int count = cmd.ExecuteNonQuery();
        con.Close();
		return count;		
		}
		
	public int ExecuteVFPnsert(DbConnection con)
	{
		string Fields = string.Empty, Values = string.Empty;
		foreach (PropertyInfo property in new WAREHOUS().GetType().GetProperties())
		{
			bool valueUsed = false;
			object Value = property.GetValue(this, null);
			if (Value == null) continue;

 			if (Value.GetType() == typeof(string))
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(char) && ((char)Value) != 0)
            {
                Value = Value.ToString().Replace("'", "''");
                Values += "'" + Value.ToString() + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(int) || Value.GetType() == typeof(decimal) || Value.GetType() == typeof(double))
            {
                Values += Value;
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(DateTime))
            {
                Values += "'" + ((DateTime)Value).ToString("{^yyyy-MM-dd}") + "'";
				valueUsed = true;
            }
            else if (Value.GetType() == typeof(bool))
            {
                Values += (bool)Value ? ".T." : ".F.";
				valueUsed = true;
            }
			if (valueUsed)
			{
			    Fields += "[" + property.Name + "],";
			    Values += ",";
			}
		}
		Values = Values.Length > 0 ? Values.Remove(Values.Length - 1) : Values;
		Fields = Fields.Length > 0 ? Fields.Remove(Fields.Length - 1) : Fields;
		string sql = "Insert into WAREHOUS (" + Fields + ") values(" + Values + ")";
		DbCommand cmd = con.CreateCommand();
        cmd.CommandText = sql;
        if (con.State == ConnectionState.Closed)
            con.Open();
        int count = cmd.ExecuteNonQuery();
        con.Close();
        return count;
	}		
			
	public static int Delete(DbConnection con,string Wherecondition)
	{
	     DbCommand deleteCommand = con.CreateCommand();
	    deleteCommand.CommandText = "Delete from WAREHOUS ";
	    if (Wherecondition != null && Wherecondition.Trim()!= "")
	    {
	        if (Wherecondition.Trim().ToLower().StartsWith("where"))
	            deleteCommand.CommandText += Wherecondition;
	        else
	            deleteCommand.CommandText += " Where " + Wherecondition;
	    }
	  if (deleteCommand.Connection.State == ConnectionState.Closed || deleteCommand.Connection.State == ConnectionState.Broken)
            deleteCommand.Connection.Open();
        var x = deleteCommand.ExecuteNonQuery();
        deleteCommand.Connection.Close();
        return x;
	}
	
	public static List<WAREHOUS> Select(DbConnection con, string Wherecondition)
    {
        DbCommand cmd = con.CreateCommand();
        cmd.CommandText = "Select * from WAREHOUS ";
        if (Wherecondition != null && Wherecondition.Trim() != "")
        {
            if (Wherecondition.Trim().ToLower().StartsWith("where"))
                cmd.CommandText += Wherecondition;
            else
                cmd.CommandText += " Where " + Wherecondition;
        }
        DataTable dt = new DataTable("Results");
        DbDataAdapter dad = new SqlDataAdapter();
        if (con is OdbcConnection)
            dad = new OdbcDataAdapter((OdbcCommand)cmd);
        else if (con is OleDbConnection)
            dad = new OleDbDataAdapter((OleDbCommand)cmd);
        else if (con is SqlConnection)
            dad = new SqlDataAdapter((SqlCommand)cmd);
        dad.Fill(dt);
        return Create(dt);
    }
	
	public DataRow GetAsDataRow(DataTable parentTable)
    {
        DataRow row = parentTable.NewRow();
        foreach (DataColumn column in parentTable.Columns)
        {
            PropertyInfo property = this.GetType().GetProperty(column.ColumnName);
            if (property != null  && property.GetValue(this, null) != null)
            {
                row[column] = property.GetValue(this, null);
            }
        }
        return row;
    }

	#endregion
}

