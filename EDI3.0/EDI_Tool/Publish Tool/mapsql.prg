CLOSE ALL
RELEASE ALL
SET sysmenu OFF
_screen.WindowState = 2 
SET CLASSLIB TO classes\mapsmain.vcx
SET CENTURY ON 
PUBLIC lcTracSysF, lcServName, lcDBasName, lcUserName, lcPassWord ,lcliveServername ,lcUserNameLive  ,lcPassWordLive 

lcTracSysF = ''
lcServName = ''
lcDBasName = ''
lcUserName = ''
lcPassWord = ''
lcliveServername = ''
lcUserNameLive   = ''
lcPassWordLive   = ''

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
SET STEP ON 
*T20120122.0004,1 HIA Upload program Modifications, related to MMT 21-Jan-2012 [End]

IF FILE('PARAMINF.MEM')
  RESTORE FROM PARAMINF.MEM
ELSE
  DO FORM parminf TO llReturn
  IF !llReturn
    CLOSE ALL
    SET SYSMENU TO DEFAULT 
    RETURN 
  ENDIF
  SAVE ALL TO PARAMINF.MEM
ENDIF

&& Look, you should remove this.
*lcTracSysF ="D:\EDI3\SYSFILES\"
PUBLIC lcUser

lcUser  = ''
DO menu1.mpr
*DO FORM frmlogin
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
