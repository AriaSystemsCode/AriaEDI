*:***************************************************************************
*: Program file  : SMEDITR
*: Program desc. : Sync Style and Customer Data
*: Tracking#     : E304210[I46]
*:        System : Aria 4 XP
*:        Module : IC
*:     Developer : Mariam Mazhar (MMT)
*:***************************************************************************
Parameters lcRequestID, lcXMLFileName, ClientID

#INCLUDE d:\Shared-Build\aria4xp\prgs\sm\SMEDITR.h

*!*	IF TYPE('lcXMLFileName') != 'C'
*!*	  lcRequestID = '292cb607-6c14-438e-a997-bb58eb9b9f01'
*!*	  lcXMLFileName	= '\\10.0.1.18\DBFs_Databases\DEP02SH\Aria4XP\OUTPUT\XY0WKVNG.xml'
*!*	  ClientId = 'DEP02'
*!*	ENDIF

Strtofile(Chr(10)+ Chr(13) + "Request program 10000000000000000" , "D:\Shared\notes.txt",.T.)

If Type('lcXMLFileName') = 'C'
  Strtofile(Chr(10)+ Chr(13) + "Request program 11" , "D:\Shared\notes.txt",.T.)
  *!*	  PRIVATE loAgent
  *!*	  loAgent = goRemoteCall.GetRemoteObject("Aria.EnterpriseServices.RequestHandler.AriaRequestAgent")

  *!*	  PRIVATE loProgress
  *!*	  loProgress = CREATEOBJECT("Aria.DataTypes.RequestHandler.AriaRequestProgress")
  *!*
  *!*	  loProgress.Percent = 0
  *!*	  loProgress.DESCRIPTION = "Opening Data Files..."
  *!*	  loAgent.UpdateObjectProgress(lcRequestID, loProgress, ClientId)

  *!*	  LOCAL loEnvironment
  *!*	  loEnvironment = goRemoteCall.GetRemoteObject("Aria.Environment.AriaEnviromentVariables")
  *!*	  loEnvironment.ClientId = ClientId

  *!*	  LOCAL lcCurrentProcedure
  *!*	  lcCurrentProcedure = loEnvironment.Aria40SharedPath
  *!*	  loEnvironment.ConnectionsRefresh()
  *!*	  SET DEFAULT TO &lcCurrentProcedure.

  *!*	  DO (lcCurrentProcedure + "SRVPRGS\SY\ariamain.fxp") WITH loAgent.GetRequestCompany(lcRequestID, ClientID )  , ClientID
  *!*	  oAriaEnvironment.XML.RestoreFromXML(FILETOSTR(lcXMLFileName),.T.)

  *!*	  oAriaEnvironment.REPORT.gcAct_Appl = 'SM'
  *!*	  PUBLIC gcAct_Appl
  *!*	  gcAct_Appl = 'SM'
  *!*	  oAriaEnvironment.activeModuleID = 'SM'
  lfSyncData(lcRequestID, lcXMLFileName, ClientID)

Else
  lcExpr = gfOpGrid('SMEDITR' , .T.)&&,.F.,.F.,.T.,.T.)
Endif


*!*************************************************************
*! Name      : lfwRepWhen
*: Developer : Mariam Mazhar (MMT)
*: Date      : 06/26/2025
*! Purpose   : OG When function
*!*************************************************************
Function lfwRepWhen
=gfOpenTable('EDITRANS','TYPEKEY')
=gfOpenTable('SYCEDITR','CODETYPE')        && CEDITRNCOD+CEDITRNTYP
=gfOpenTable('EDIACPRT','ACCFACT')   && TYPE+CPARTNER

*!*************************************************************
*! Name      : lfvTrnType
*: Developer : Mariam Mazhar (MMT)
*: Date      : 06/26/2025
*! Purpose   : Transaction Type Validation
*!*************************************************************
Function lfvTrnType
Select SYCEDITR
If Empty(lcRpTRNTYP) Or '?' $ lcRpTRNTYP Or !gfSeek(lcRpTRNTYP,'SYCEDITR','CODETYPE')
  =gfSeek('')
  Private latemp
  Dimension latemp[1]                && array holr the return value from ariabrow
  latemp   = ''
  lcBrFields = [ceditrntyp :12:h=LANG_TRANSACTION_TYPE,ceditrnnam:35: H=LANG_TRANSACTION_NAME]
  llReturn = ariabrow('',LANG_TRANSACTION_TYPES, .F., .F., .F., .F.,'','','ceditrntyp','laTemp')            && call ariabrow to select or cancel
  If llReturn
    lcRpTRNTYP=latemp[1]
  Endif
Endif
*!*************************************************************
*! Name      : lfvTranPartner
*: Developer : Mariam Mazhar (MMT)
*: Date      : 06/26/2025
*! Purpose   : Partner Type Validation
*!*************************************************************
Function lfvTranPartner
Select EDIACPRT
If Empty(lcRpPartner) Or '?' $ lcRpPartner Or !gfSeek(lcRpPartner,'EDIACPRT','CPARTCODE')
  =gfSeek('')
  Private latemp
  Dimension latemp[2]                && array holr the return value from ariabrow
  latemp   = ''
  lcBrFields = [type:12:h=LANG_TYPE,cpartcode:35: H=LANG_EDI_PARTNER_CODE,cpartner :35: H=LANG_PARTNER]
  llReturn = ariabrow('',LANG_PARTNERS, .F., .F., .F., .F.,'','','type,cpartner','laTemp')            && call ariabrow to select or cancel
  If llReturn
    lcRpPartner=latemp[2]
  Endif
Endif
*!*************************************************************
*! Name      : lfvTranNumber
*: Developer : Mariam Mazhar (MMT)
*: Date      : 06/26/2025
*! Purpose   : Transaction# Validation
*!*************************************************************
Function lfvTranNumber

Select EDITRANS
If Empty(lcRpKEY) Or '?' $ lcRpKEY &&OR !gfSeek(lcRpKEY,'EDIACPRT','CPARTCODE')
  =gfSeek('')
  Private latemp
  Dimension latemp[1]                && array holr the return value from ariabrow
  latemp   = ''
  lcBrFields = [type:12:h=LANG_TYPE,Key:35: H=LANG_KEY,ceditrntyp :35: H=LANG_TRANSACTION_TYPE,cpartner :35: H=LANG_PARTNER]
  llReturn = ariabrow('','LANG_KEY', .F., .F., .F., .F.,'','','Key','laTemp')            && call ariabrow to select or cancel
  If llReturn
    lcRpKEY =latemp[1]
  Endif
Endif
*!*************************************************************
*! Name      : lfSyncData
*: Developer : Mariam Mazhar (MMT)
*: Date      : 06/26/2025
*! Purpose   : Sync Style and Customer data
*!*************************************************************
Function lfSyncData
Parameters lcRequestID, lcXMLFileName, ClientID
If Type('lcXMLFileName') = 'C'
  Strtofile(Chr(10)+ Chr(13) + "Request program 10" , "D:\Shared\notes.txt",.T.)
  calledPath = Justpath(Sys(16, 1))
  Strtofile(Chr(10)+ Chr(13) + "Request program 10 calledPath" , "D:\Shared\notes.txt",.T.)
  calledPath ="D:\Shared-Build\Aria4XP\PRGs\SM"
  Do (calledPath+"\runrequestedi.PRG") With lcRequestID, lcXMLFileName, ClientID
Endif
Endfunc


