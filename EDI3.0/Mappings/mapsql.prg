CLOSE ALL
RELEASE ALL
SET sysmenu OFF
**_screen.WindowState = 2 
SET CLASSLIB TO classes\mapsmain.vcx
SET CENTURY ON 
PUBLIC lcTracSysF, lcServName, lcDBasName, lcAuthentication, lcUserName, lcPassWord, lcHistoryDBasName 

lcTracSysF = ''
lcServName = ''
lcDBasName = ''
lcUserName = ''
lcPassWord = '' 

*T20120122.0004,1 HIA Upload program Modifications, related to MMT 21-Jan-2012 [Begin]
lcMailUserName       = ""
lcMailPassword       = ""
lcFrom               = ""
lcTo                 = ""
lcSubject            = ""
lcTextBody           = ""
lcAttachment         = ""
lcSupportManagerMail = ""
lcVSSManagerMail     = ""
lcPMOManagerMail     = ""
*T20120122.0004,1 HIA Upload program Modifications, related to MMT 21-Jan-2012 [End]

lcConfigFile = FULLPATH('Mappings.ini')
IF !FILE(lcConfigFile)
  MESSAGEBOX('Configuration file was not found:' + CHR(13) + lcConfigFile, 16, 'Mapping Tool')
  RETURN
ENDIF

lcTracSysF = ''
lcServName  = GetConfigValue(lcConfigFile, 'Mappings', 'Server', '')
lcDBasName  = GetConfigValue(lcConfigFile, 'Mappings', 'Database', '')
lcAuthentication = GetConfigValue(lcConfigFile, 'Mappings', 'Authentication', 'SqlServer')
lcUserName  = GetConfigValue(lcConfigFile, 'Mappings', 'UserName', '')
lcPassWord  = GetConfigValue(lcConfigFile, 'Mappings', 'Password', '')
lcHistoryDBasName = GetConfigValue(lcConfigFile, 'HistoryDatabase', 'Database', 'EDIMappingsHistory')

IF EMPTY(lcServName) OR EMPTY(lcDBasName)
  MESSAGEBOX('Mappings.ini is missing a required Mappings setting.', 16, 'Mapping Tool')
  RETURN
ENDIF

&& Look, you should remove this.
*lcTracSysF ="D:\EDI3\SYSFILES\"
PUBLIC lcUser

lcUser  = ''
*DO menu1.mpr
DO FORM frmlogin
*DO FORM mapSql WITH ALLTRIM(lcTracSysF),ALLTRIM(lcServName),ALLTRIM(lcDBasName),ALLTRIM(lcUserName),ALLTRIM(lcPassWord)

read events
SET SYSMENU TO default
CLOSE ALL
CLEAR ALL

**********

*!*************************************************************
*! Name      : gfBrowse
*! Developer : Hesham El-Sheltawi
*! Date      : 11/17/96
*! Purpose   : Browse a File and return .t. if the user select record
*!*************************************************************
*! Parameters: tcBrowseFields   && variable Hold the browse fields to
*!                              && be displayed with the headers if needed
*!             tcBrowseTitle    && browse title
*!             tcAlias          && alias to be browsed if not the default alias
*!             tcKey            && key to be filter in the browse
*!             tcFor            && FOR condition or FOR condition REST
*!             tcOptions        && Options for the shortcut to be displayed
*!*************************************************************
*! Called by : 
*!*************************************************************
*! Returns            : .t. if selected .f. if not
*!*************************************************************
*! Example   : llBrowseSelected=gfBrowse()
*!*************************************************************
*
FUNCTION gfBrowse
lParameters tcBrowseFields,tcBrowseTitle,tcAlias,tcKey,tcFor,tcOptions,tlSelect
LOCAL llReturnValue,lcAlias
lcAlias = SELECT()
IF !EMPTY(tcAlias)
  SELECT (tcAlias)
ENDIF
PRIVATE oBrowse
*oBrowse = .Null.
DO FORM NBROWSE   TO llReturnValue
*WITH tcBrowseFields,tcBrowseTitle,tcKey,tcFor,tcOptions,.T.;
   TO llReturnValue
SELECT (lcAlias)    
RETURN llReturnValue


FUNCTION GetConfigValue
LPARAMETERS tcFile, tcSection, tcKey, tcDefault
LOCAL lcText, laLines[1], lnLines, lnI, lcLine, lcSection, lnEquals
lcSection = ''
IF !FILE(tcFile)
  RETURN tcDefault
ENDIF
lcText = FILETOSTR(tcFile)
lnLines = ALINES(laLines, lcText)
FOR lnI = 1 TO lnLines
  lcLine = ALLTRIM(laLines[lnI])
  IF EMPTY(lcLine) OR INLIST(LEFT(lcLine,1), ';', '#')
    LOOP
  ENDIF
  IF LEFT(lcLine,1) == '[' AND RIGHT(lcLine,1) == ']'
    lcSection = UPPER(ALLTRIM(SUBSTR(lcLine,2,LEN(lcLine)-2)))
    LOOP
  ENDIF
  lnEquals = AT('=', lcLine)
  IF lcSection == UPPER(ALLTRIM(tcSection)) AND lnEquals > 1 AND UPPER(ALLTRIM(LEFT(lcLine,lnEquals-1))) == UPPER(ALLTRIM(tcKey))
    RETURN ALLTRIM(SUBSTR(lcLine,lnEquals+1))
  ENDIF
ENDFOR
RETURN tcDefault
ENDFUNC


FUNCTION OpenSqlConnection
LPARAMETERS tcServer, tcDatabase, tcUser, tcPassword, tcDescription
LOCAL lnHandle, laError[1], lcMessage
IF TYPE('lcAuthentication') = 'C' AND UPPER(ALLTRIM(lcAuthentication)) == 'WINDOWS' AND UPPER(ALLTRIM(tcServer)) == UPPER(ALLTRIM(lcServName))
  lnHandle = SQLSTRINGCONNECT('Driver={SQL Server};Server=' + ALLTRIM(tcServer) + ';Database=' + ALLTRIM(tcDatabase) + ';Trusted_Connection=Yes')
ELSE
  lnHandle = SQLSTRINGCONNECT('Driver={SQL Server};Server=' + ALLTRIM(tcServer) + ';Database=' + ALLTRIM(tcDatabase) + ';Uid=' + ALLTRIM(tcUser) + ';Pwd=' + tcPassword)
ENDIF
IF lnHandle < 1
  AERROR(laError)
  lcMessage = 'Could not connect to ' + tcDescription + ':' + CHR(13) + ALLTRIM(tcServer) + '\' + ALLTRIM(tcDatabase)
  IF ALEN(laError,1) > 0
    lcMessage = lcMessage + CHR(13) + TRANSFORM(laError[1,2])
  ENDIF
  MESSAGEBOX(lcMessage, 16, 'SQL Connection Error')
ENDIF
RETURN lnHandle
ENDFUNC
