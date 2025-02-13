Set Classlib To  D:\Shared\aria4xp\srvclss\sy\ariaMain.vcx AddI
Set Classlib To "D:\shared\ARIA4XP\SRVCLSS\SY\requesthandler.vcx" AddI
goRemoteCall = Createobject("RemoteObject")
goRemoteCall.cInstanceName = ""
goRemoteCall.cServerName   = "ARIATESTING"
goRemoteCall.nPort         = 1500
gcRequestId ='078c8e78-359e-4e5b-8948-b0f138df2331'
gcClientId ='DAC10'
gcXMLFile = '\\10.0.1.8\DAC10sh\Aria4XP\OUTPUT\X10UKHLD.xml'
*do d:\shared\aria4xp\reports\so\soorcn.prg WITH gcRequestId,gcXMLFile,gcClientId
*--------------------------------------------------------------------------------
*:***************************************************************************

* PARAMETERS lcRequestID, lcXMLFileName, ClientId

lcRequestID = gcRequestId
lcXMLFileName	= gcXMLFile
ClientId = gcClientId
lcClinetID= gcClientId
*E303352,1 SAB 02/14/2013 RB Enhancement to work with one EXE [Start]
If Type('lcRequestID') = 'C' .And. 'TEMP.TXT' $ Upper(lcRequestID)
  *! E303437,1 SAB 12/24/2013 Modify Aria RB Troubleshooting tool to run with R13[Troublshooting R13][Start]
  *STRTOFILE("2.0.0.1", lcRequestID, .F.)
  Strtofile("3.0.0.0", lcRequestID, .F.)
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
Set Classlib To "D:\shared\aria3edi\classes\main.vcx" Additive
Set Classlib To "D:\shared\aria3edi\classes\edi_dll.vcx" Additive

A4oAriaApplication = oAriaApplication
oAriaApplication = Createobject('AriaApplication', 'X:\ARIA4XP\SYSFILES\')
oAriaApplication.DataDir = A4oAriaApplication.DataDir
= ADDPROPERTY(oAriaApplication,'SystemconnectionString')

oAriaApplication.SystemconnectionString = A4oAriaApplication.SystemconnectionString
Release Classlib D:\Shared\aria4xp\srvclss\sy\ariaMain.vcx
set step on 
release procedure 'D:\SHARED\ARIA4XP\SRVPRGS\SY\ariamain.FXP'
set procedure to "d:\shared\aria3edi\prgs\sy\aria3edi.fxp"
*look
Set Step On

Debug
oAriaApplication.ActiveCompanyid='04'
oAriaApplication.DataDir = "X:\ARIA4XP\DBFS\04\"
*oAriaApplication.IsRemoteComp = .t.
*oAriaApplication.EDIMAPPINGCONNECTION =oAriaApplication.activecompanyconstr
Set Step On
If !Empty(oAriaApplication.SystemMasterConnectionString)
  If !Empty(lcClinetID)
    Local lnConnHandle, lnRemResult
    lnConnHandle = Sqlstringconnect(oAriaApplication.SystemMasterConnectionString)
    If lnConnHandle < 1
      Messagebox('Wrong connection information in the client setting file, please contact Aria technical support team.',0+16,'ARIA3EDI initiation error')
      Return
    Else
      oAriaApplication.SQLSysFilesConnectionString = oAriaApplication.SystemMasterConnectionString
      lnRemResult = SQLExec(lnConnHandle,"Select * from Clients where CCLIENTID='" + lcClinetID + "'","Clients")
      oAriaApplication.Aria5SystemManagerConnection = "Driver={SQL Server};server=" + Alltrim(CCONSERVER) + ";DATABASE=" + Alltrim(CCONDBNAME) + ";uid=" + Alltrim(CCONUSERID) + ";pwd=" + Alltrim(CCONPASWRD)

      *E303856, Derby- OAriaapplication to save EDI SQL mapping connection string [Start]
      oAriaApplication.EDIMAPPINGCONNECTION= "Driver={SQL Server};server=" + Alltrim(CCONSERVER) + ";DATABASE=EDIMappings;uid=" + Alltrim(CCONUSERID) + ";pwd=" + Alltrim(CCONPASWRD)
      *E303856, Derby- OAriaapplication to save EDI SQL mapping connection string [End]
      *B610418,1 SAB 08/07/2013 Fix main control screen is not opening in EDI problem [T20130612.0015][Start]
      oAriaApplication.Aria4SysFilesConnection = "Driver={Microsoft Visual FoxPro Driver};UID=;PWD=;SourceDB=" + Alltrim(ARIA40SYS) + ";SourceType=DBF;Exclusive=No;BackgroundFetch=No;Collate=Machine;Null=No;Deleted=Yes;"
      *B610418,1 SAB 08/07/2013 Fix main control screen is not opening in EDI problem [T20130612.0015][End]
    Endif
  Else
    Messagebox('Client ID information is missing from the client setting file, please contact Aria technical support team.',0+16,'ARIA3EDI initiation error')
    Return
  Endif
Endif


objEDI = Createobject('edi_dll.main')
objEDI.receivingpipeline(loAgent,gcRequestId,gcClientId)
