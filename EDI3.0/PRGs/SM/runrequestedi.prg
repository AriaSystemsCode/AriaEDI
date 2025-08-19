*Set Classlib To  D:\Shared\aria4xp\srvclss\sy\ariaMain.vcx AddI
*Set Classlib To "D:\shared\ARIA4XP\SRVCLSS\SY\requesthandler.vcx" AddI
*goRemoteCall = Createobject("RemoteObject")
*goRemoteCall.cInstanceName = ""
*goRemoteCall.cServerName   = "ARIATESTING"
*goRemoteCall.nPort         = 1500
*gcRequestId ='078c8e78-359e-4e5b-8948-b0f138df2331'
*gcClientId ='DAC10'
*gcXMLFile = '\\10.0.1.8\DAC10sh\Aria4XP\OUTPUT\X10UKHLD.xml'
*do d:\shared\aria4xp\reports\so\soorcn.prg WITH gcRequestId,gcXMLFile,gcClientId
*--------------------------------------------------------------------------------
*:***************************************************************************

Parameters lcRequestID, lcXMLFileName, ClientId

*!*	lcRequestID = 'f9c1210c-bceb-4e9a-910a-37c2974c805e'
*!*	lcXMLFileName	= '\\10.0.1.8\DEP02SH\Aria4XP\OUTPUT\XS0VY94J.xml'
*!*	ClientId = 'DEP02'
*!*	lcClinetID= ClientId


*sharedPath = "D:\Shared-build"
*replaceX = "\\10.0.1.18\DBFs_Databases"

If Type('lcXMLFileName') != 'C'
  lcRequestID = '292cb607-6c14-438e-a997-bb58eb9b9f01'
  lcXMLFileName	= '\\10.0.1.18\DBFs_Databases\DEP02SH\Aria4XP\OUTPUT\XY0WKVNG.xml'
  ClientId = 'DEP02'
Endif


*!*	Set Classlib To  D:\Shared\aria4xp\srvclss\sy\ariaMain.vcx AddI
*!*	Set Classlib To "D:\shared\ARIA4XP\SRVCLSS\SY\requesthandler.vcx" AddI
*!*	goRemoteCall = Createobject("RemoteObject")
*!*	goRemoteCall.cInstanceName = ""
*!*	goRemoteCall.cServerName   = "ARIATESTING"
*!*	goRemoteCall.nPort         = 1500
*--------------------------------------------------------------------------------
*:***************************************************************************


*E303352,1 SAB 02/14/2013 RB Enhancement to work with one EXE [Start]
If Type('lcRequestID') = 'C' .And. 'TEMP.TXT' $ Upper(lcRequestID)
  *! E303437,1 SAB 12/24/2013 Modify Aria RB Troubleshooting tool to run with R13[Troublshooting R13][Start]
  *! E303437,1 SAB 12/24/2013 Modify Aria RB Troubleshooting tool to run with R13[Troublshooting R13][End]
  Return
Endif

*E303352,1 SAB 02/14/2013 RB Enhancement to work with one EXE [End]
Set Step On
If Type('lcXMLFileName') = 'C'
  Private loAgent
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][Start]
  *loAgent = CREATEOBJECT("Aria.EnterpriseServices.RequestHandler.AriaRequestAgent")
  loAgent = goRemoteCall.GetRemoteObject("Aria.EnterpriseServices.RequestHandler.AriaRequestAgent")
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][End]
  Private loProgress
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][Start]
  loProgress = Createobject("Aria.DataTypes.RequestHandler.AriaRequestProgress")
  *loProgress = goRemoteCall.GetRemoteObject("Aria.DataTypes.RequestHandler.AriaRequestProgress")
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][End]
  loProgress.Percent = 0
  loProgress.Description = "Opening Data Files..."
  loAgent.UpdateObjectProgress(lcRequestID, loProgress, ClientId)
  Local loEnvironment
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][Start]
  *loEnvironment = CREATEOBJECT("Aria.Environment.AriaEnviromentVariables")
  loEnvironment = goRemoteCall.GetRemoteObject("Aria.Environment.AriaEnviromentVariables")
  *E303361,1 SAB 02/28/2013 Merge RB R13 modification with R12 and update R13 VSS [Aria5.2 R13 Media][End]
  loEnvironment.ClientId = ClientId
  Local lcCurrentProcedure
  lcCurrentProcedure =    loEnvironment.Aria40SharedPath
  loEnvironment.ConnectionsRefresh()
  Local lcRequestCompany, lcClientRoot, lcEnvOutput
  lcRequestCompany = loAgent.GetRequestCompany(lcRequestID, ClientId)
  lcClientRoot = loEnvironment.Aria40SharedPath

  lcEnvOutput = loEnvironment.GetAria27CompanyDataConnectionString(lcRequestCompany)
  Do (lcCurrentProcedure + "SRVPRGS\SY\ariamain.fxp") With lcRequestCompany , ClientId, lcCurrentProcedure, loEnvironment
  oAriaEnvironment.XML.RestoreFromXML(Filetostr(lcXMLFileName),.T.)

  lcActiveMod = 'EB'
  oAriaEnvironment.Report.gcAct_Appl = lcActiveMod
  oAriaEnvironment.activeModuleID = 'EB'
  oAriaEnvironment.RequestID = lcRequestID
  Public gcAct_Appl
  gcAct_Appl = lcActiveMod
  If Left(gcDevice, 7) = "PRINTER"
    oAriaEnvironment.gcDevice = "PRINTER"
  Else
    oAriaEnvironment.gcDevice = "FILE"
  Endif
  oAriaEnvironment.Report.cCROrientation = 'P'
  =gfOpenFile('NOTEPAD','NOTEPAD')
  =gfOpenFile('ORDHDR','ORDHDR')
  =gfOpenFile('CUSTOMER','CUSTOMER')
  =gfOpenFile('Warehous','WAREHOUS')
  =gfOpenFile('Ordline','Ordline')
  =gfOpenFile('OBJLINK','OBJLNKTY')
  =gfOpenFile('OBJECTS','OBJECTID')
  =gfOpenFile('OBJLINK','OBJLNKTY','SH','OBJLINK_A')
  =gfOpenFile('OBJECTS','OBJECTID','SH','OBJECTS_A')
  =gfOpenFile('SCALE','SCALE')
  =gfOpenFile('Style','Style')
Endif
*!E303292,1 MMT 11/07/2012 Enhance Order confirmation report to work from request builder[End]
Set Classlib To ("D:\Shared-build\aria3edi\classes\main.vcx") Additive
Set Classlib To ("D:\Shared-build\aria3edi\classes\edi_dll.vcx") Additive

A4oAriaApplication = oAriaApplication

*Release Classlib D:\shared-build\aria4xp\srvclss\sy\ariaMain.vcx
Set Step On
*!*	oooox = ""
*!*	TRY
oAriaApplication = Newobject("AriaApplication", "D:\Shared-build\aria3edi\classes\main.vcx", Null, "\\10.0.1.18\DBFs_Databases\dep02sh\ARIA4XP\SYSFILES\")
*!*	CATCH TO oooox
*!*	  STRTOFILE(chr(10)+ chr(13) + "Request program -type2111111:" , "D:\Shared\notes.txt",.t.)
*!*	  STRTOFILE(chr(10)+ chr(13) + "Request program -type21:"+MESSAGE() , "D:\Shared\notes.txt",.t.)
*!*	ENDTRY
*X
*oAriaApplication = Createobject('AriaApplication', 'X:\ARIA4XP\SYSFILES\')

oAriaApplication.DataDir = A4oAriaApplication.DataDir
oAriaApplication.APPLICATIONHOME= "D:\Shared-build\aria3EDI\PRGS\"
oAriaApplication.CLASSDIR = "D:\Shared-build\aria3EDI\CLASSES\"
oAriaApplication.reporthome = "D:\Shared-build\aria3EDI\reports\"
oAriaApplication.screenhome = "D:\Shared-build\aria3EDI\screens\"

AddProperty(oAriaApplication, "ClientProgramHome", "")
oAriaApplication.clientprogramhome = "\\10.0.1.18\DBFs_Databases\dep02sh\ARIA3EDI\screens\"
= AddProperty(oAriaApplication,'SystemconnectionString')

oAriaApplication.SystemconnectionString = A4oAriaApplication.SystemconnectionString

Release Procedure 'D:\Shared-build\aria4XP\SRVPRGS\SY\ariamain.FXP'
Set Procedure To "D:\Shared-build\aria3edi\prgs\sy\aria3edi.fxp"
*look
Set Step On

Debug
oAriaApplication.ActiveCompanyid=lcRequestCompany
*oAriaApplication.DataDir = "X:\ARIA4XP\DBFS\"+lcRequestCompany+"\"
*oAriaApplication.IsRemoteComp = .t.
*oAriaApplication.EDIMAPPINGCONNECTION =oAriaApplication.activecompanyconstr
= AddProperty(oAriaApplication,'SystemMasterConnectionString')

lcARIA40SYS = ''

If !Empty(oAriaApplication.SystemMasterConnectionString)
  
  If !Empty(ClientId)
    Local lnConnHandle, lnRemResult
    lnConnHandle = Sqlstringconnect(oAriaApplication.SystemMasterConnectionString)
   
    If lnConnHandle < 1
      *Messagebox('Wrong connection information in the client setting file, please contact Aria technical support team.',0+16,'ARIA3EDI initiation error')
      Return
    Else
      oAriaApplication.SQLSysFilesConnectionString = oAriaApplication.SystemMasterConnectionString
      lnRemResult = SQLExec(lnConnHandle,"Select * from Clients where CCLIENTID='" + ClientId+ "'","Clients")
     
      oAriaApplication.Aria5SystemManagerConnection = "Driver={SQL Server};server=" + Alltrim(CCONSERVER) + ";DATABASE=" + Alltrim(CCONDBNAME) + ";uid=" + Alltrim(CCONUSERID) + ";pwd=" + Alltrim(CCONPASWRD)
      
      *E303856, Derby- OAriaapplication to save EDI SQL mapping connection string [Start]
      oAriaApplication.EDIMAPPINGCONNECTION= "Driver={SQL Server};server=" + Alltrim(CCONSERVER) + ";DATABASE=EDIMappings;uid=" + Alltrim(CCONUSERID) + ";pwd=" + Alltrim(CCONPASWRD)
      *E303856, Derby- OAriaapplication to save EDI SQL mapping connection string [End]
      *B610418,1 SAB 08/07/2013 Fix main control screen is not opening in EDI problem [T20130612.0015][Start]
      lcARIA40SYS = Alltrim(ARIA40SYS)
      oAriaApplication.Aria4SysFilesConnection = "Driver={Microsoft Visual FoxPro Driver};UID=;PWD=;SourceDB=" + Alltrim(ARIA40SYS) + ";SourceType=DBF;Exclusive=No;BackgroundFetch=No;Collate=Machine;Null=No;Deleted=Yes;"
      *B610418,1 SAB 08/07/2013 Fix main control screen is not opening in EDI problem [T20130612.0015][End]
    Endif
  Else
    *Messagebox('Client ID information is missing from the client setting file, please contact Aria technical support team.',0+16,'ARIA3EDI initiation error')
    Return
  Endif
Endif


objEDI = Createobject('edi_dll.main')

*objEDI.receivingpipeline(loAgent,lcRequestID,ClientId)
Set Step On
If Used('EDINET')
  Use In EDINET
Endif

Dimension lcTransactions[1]
Dimension lcPartners[1] = lcrpPartner
lcTransactions[1] = lcrpKey
lcPartners[1] = lcrpPartner
Lsilent = .t.
objEDI.SENDingpipeline(loAgent,lcRequestID,ClientId,      'S', lcrpTrnTyp, 'D', @lcPartners, @lcTransactions )
*                       loAgent,lcRequestID,lcClientId, lcType, lcEdiTrnTyp, lcPartnerType, lcTransactions, llAll
