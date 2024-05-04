cTest = "Record Type,Parent Code,Code,Name,Language,Email Address,Phone1 Type,Phone1 Code,Phone1 Number,Phone1 Ext.,Phone2 Type,Phone2 Code,"+;
"Phone2 Number,Phone2 Ext.,Phone3 Type,Phone3 Code,Phone3 Number,Phone3 Ext.,First Name,Last Name,Title,Trade Name,Account Type,About us,Currency,"+;
"Website,Business Classification 1,Business Classification 2,Business Classification 3,Department 1,Department 2,Department 3,Address1 Type,Address1 Code,"+;
"Address1 Name,Address1 Line1,Address1 Line2,Address1 City,Address1 State,Address1 Postal Code,Address1 Country,Address2 Type,Address2 Code,Address2 Name,"+;
"Address2 Line1,Address2 Line2,Address2 City,Address2 State,Address2 Postal Code,Address2 Country,Address3 Type,Address3 Code,Address3 Name,Address3 Line1,"+;
"Address3 Line2,Address3 City,Address3 State,Address3 Postal Code,Address3 Country,Address4 Type,Address4 Code,Address4 Name,Address4 Line1,Address4 Line2,"+;
"Address4 City,Address4 State,Address4 Postal Code,Address4 Country,Image1 Type,Image1 File Name,Image2 Type,Image2 File Name,Image3 Type,Image3 File Name,"+;
"Image4 Type,Image4 File Name,Image5 Type,Image5 File Name"

n= ALINES(arr, STRTRAN(cTest,",",CHR(13))) 


lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim("AriaTesting\AriaSQLServer")+";DATABASE="+Alltrim("TAJ01.MASTER")+;
  ";uid="+Alltrim("sa")+";pwd="+Alltrim("aria_123"))

lnRes =SQLExec(lnConnHandler,"USE [TAJ01.MASTER]" )

*! Customer ***********************************************************************************

lcFields = "INSERT INTO [TAJ01.MASTER].[dbo].[TRANSACTION_MAP_T] "+;
  "([TRANSACTION_SEGMENTS_KEY] "+;
  ",[FIELD_ORDER] "+;
  ",[START_POSITION] "+;
  ",[FIELD_LENGTH] "+;
  ",[FIELD_NAME] "+;
  ",[CONDITION] "+;
  ",[VALUE] "+;
  ",[DATA_TYPE] "+;
  ",[USAGE] "+;
  ",[TRANSACTION_MAP_KEY] "+;
  ",[IS_KEY]) "
TRANSACTION_SEGMENTS_KEY = 2000
TRANSACTION_MAP_KEY = 5100
tablename="Header"
Loop="03"

For i = 1 To n

  lcvar = Strtran(arr(i)," ","")

  If Len(lcvar+"03") > 21
    lcvar = Strtran(arr(i)," ","")
    lcvar = Strtran(lcvar,"Business","")

  Endif
  If Len(lcvar+"03") > 21
    Wait Window lcvar
  ENDIF
  TRANSACTION_MAP_KEY = TRANSACTION_MAP_KEY + 1
  lcvar=lcvar+Loop
  lcValues = " VALUES ("+;
    ALLTRIM(STR(TRANSACTION_SEGMENTS_KEY))+","+;
    ALLTRIM(STR(i))+","+;
    "0,"+;
    "0,"+;
    "'"+lcvar+"',"+;
    " '',"+;
    "'"+lcvar+"',"+;
    "'C',"+;
    "'M',"+;
    ALLTRIM(STR(TRANSACTION_MAP_KEY))+","+;
    "0" + ")"
    _cliptext = lcFields+lcValues

  lnRes = SQLExec(lnConnHandler,lcFields+lcValues )
Endfor

WAIT WINDOW "Done"