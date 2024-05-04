* Documentations :
*B609494,1 HES 11/01/2011 Filter just the EDI users (Media) [T20101221.0056]
*B609510,1 WAM 01/26/2011 Display System updates [T20110109.0001]
*==============================================================================*

*E038729,1 AMH Add parameter to hold the Aria 4 XP classes folder [Start]
*E302729,1 HES Applied necessary changes in EDI executable file to call Screens,Reports,Prgs,BMPs,EDI and Work folders
               * - from new EDI folder and the folders SYSFILES and DBFS from parameter will be passed to the EDI 
                * - executable file for the location of Aria27 folder, also assign the Aria4 classes path to the property
                 * - from the new field Sycinst.CA4SYSDIR
*E302737,1 HES Remove classes, forms, prgs and most of BMPs from Aria3edi.exe and handle its calling [T20100818.0004]                   
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [T20090625.0014]  
*E611806,1 Sara.N 07/02/2019 [EDI facelift new login]                 
*===========================================================================================================================================================*


*E302729,1 HES Change the current paramter to be Aria27 sysfiles path instead of Aria4 clases path [Begin]
*!*	LPARAMETERS lcAria4Class
LPARAMETERS lcAria27Sys
*E302729,1 HES Change the current paramter to be Aria27 sysfiles path instead of Aria4 clases path [End  ]

*E038729,1 AMH [End]

CLEAR
on error do gfErrorTrap

DEACTIVATE WINDOW "Project Manager"

*E038729,1 AMH Comment clear all since it removes the parameters from memory [Start]
*CLEAR ALL CLASSES
*E038729,1 AMH [End]

_VFP.Visible = .T.

*-- All public vars will be released as soon as the application
*-- object is created. 

PUBLIC gcBaseWind, gnProgCopy, glInitMenu,gnMaxUsers,gcPrmtMdls,gcAct_Key,laCtrStat
*B607093,1 Adding active application varible HASSAN 07/14/2003 [BEGIN]
*PUBLIC glToolActv,glMsgREm,glUser_tsk,glAutoAdd,GlLog_Requ,glSys_log,gcAct_Comp
PUBLIC glToolActv,glMsgREm,glUser_tsk,glAutoAdd,GlLog_Requ,glSys_log,gcAct_Comp,gcAct_Appl
*B607093,1 Adding active application varible HASSAN 07/14/2003 [END  ]

PUBLIC oAriaApplication,gcPlatForm,gcLicence,gcCompName,lcProgName,glErrorHan
STORE .F. TO glToolActv,glMsgREm,glUser_tsk,glAutoAdd,GlLog_Requ,glSys_Log,glErrorHan
*B607093,1 Adding active application varible HASSAN 07/14/2003 [BEGIN]
*STORE "  " TO gcAct_Comp,gcLicence,gcCompName
 STORE "  " TO gcAct_Comp,gcLicence,gcCompName,gcAct_Appl
*B607093,1 Adding active application varible HASSAN 07/14/2003 [END  ]
gnMaxUsers = 0 

lcCurrentProcedure = UPPER(SYS(16,1))
lcCurrentProcedure = STRTRAN(lcCurrentProcedure, "\PRGS", "")
lnPathStart        = AT(":",lcCurrentProcedure)- 1
lnLenOfPath        = RAT("\", lcCurrentProcedure) - (lnPathStart)
lcCurPath          = SUBSTR(lcCurrentProcedure, lnPathStart, lnLenofPath)
SET DEFAULT TO (lcCurPath)
SET CLASSLIB TO

*E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
lcClientclassdir = ADDBS(STRTRAN(UPPER(ALLTRIM(ADDBS(lcAria27Sys))),"ARIA27\SYSFILES\",""))+'ARIA3EDI\Classes\'
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]

lcClasPath  = lcCurPath + "\CLASSES\"
lnClasses   = ADIR(laClasses, lcClasPath + "*.*", "D")
FOR lnClass = 1 TO lnClasses

  IF "D" $ laClasses[lnClass,5] AND !INLIST(laClasses[lnClass,1], ".", "..")
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
*!*	    = lpSetLibs (lcClasPath + laClasses[lnClass,1])
    = lpSetLibs (lcClasPath + laClasses[lnClass,1],lcClientclassdir)
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]
  ELSE  
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
*!*	    = lpSetFile (lcClasPath, laClasses[lnClass,1])
    = lpSetFile (lcClasPath, laClasses[lnClass,1],lcClientclassdir)
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]
  ENDIF
ENDFOR
RELEASE lcClass, lnClasses, lnClass, lcClasPath, lnLenOfPath, lnPathStart, lcCurrentProcedure

*E038729,1 AMH Add parameter to hold the Aria 4 XP classes folder [Start]
*oAriaApplication = CREATEOBJECT("AriaApplication")
**oAriaApplication = CREATEOBJECT("AriaApplication",IIF(TYPE('lcAria4Class')='C',lcAria4Class,.F.))

*E302729,1 HES Path the Aria27 sysfiles path instead of Aria4 classes path [Begin]
*!*	oAriaApplication = CREATEOBJECT("AriaApplication",IIF(TYPE('lcAria4Class')='C', Eval(lcAria4Class) ,.F.))
oAriaApplication = CREATEOBJECT("AriaApplication",IIF(TYPE('lcAria27Sys')='C', ADDBS(lcAria27Sys) ,.F.))
*E302729,1 HES Path the Aria27 sysfiles path instead of Aria4 classes path [End  ]

*E302737,1 HES - Set a path to be used for any calling instead of set a fixed path for each [Begin]  
** set the path to the folders Aria27\Screens\SY, Aria27\Prgs\SY AND Aria27\BMPs
** all screens and programs in either folder will be seen to all of aria programs and could be 
** called without putting the path to the needed file to call
LOCAL lcPath
lcPath = oAriaApplication.Screenhome+'SY\;'+oAriaApplication.ApplicationHome+'SY\;'+oAriaApplication.BitMapHome+';'+oAriaApplication.ClassDir
SET PATH TO (lcPath) ADDITIVE
RELEASE lcPath
*E302737,1 HES - Set a path to be used for any calling instead of set a fixed path for each [End  ]

*E038729,1 AMH [End]

IF TYPE('oAriaApplication') = "O"
  
  *E038729,1 AMH Create object to connect to data company [Start]
  IF !EMPTY(oAriaApplication.lcAria4Class)
    IF FILE(oAriaApplication.lcAria4Class+"MAIN.VCX") .AND. FILE(oAriaApplication.lcAria4Class+"UTILITY.VCX")
      DO (oAriaApplication.ApplicationHome+'REMOBJ.FXP')
    ENDIF
  ENDIF
  *E038729,1 AMH [End]
  
  *E302824,1 Hassan.I calling fix programs for 870 and EDIDIC[Begin]
  lcFixesHomePath = STRTRAN(ADDBS(oAriaApplication.Screenhome),'SCREENS\','')
  lcSysHomePath   = ADDBS(oAriaApplication.syspath)
  
  lcEDIDICFIX     = ADDBS(lcFixesHomePath)+'EDIDIC.EXE'
  lcEDIDICFIXFL   = ADDBS(oAriaApplication.syspath)+'FXEDIDIC.TXT'
  
  lcORDREPLNFIX   = ADDBS(lcFixesHomePath)+'FIX_ORDREPLN.EXE'
  lcORDREPLNFIXFL = ADDBS(oAriaApplication.syspath)+'FXORDREP.TXT'
  
*!*	  IF FILE(lcEDIDICFIX) AND !FILE(lcEDIDICFIXFL)
*!*	    DO EDIDIC.EXE WITH lcSysHomePath
*!*	  ENDIF 
*!*	  
*!*	  IF FILE(lcORDREPLNFIX) AND !FILE(lcORDREPLNFIXFL)
*!*	    DO FIX_ORDREPLN.EXE WITH lcSysHomePath
*!*	  ENDIF 
  *E302824,1 Hassan.I calling fix programs for 870 and EDIDIC[End]
    
  oAriaApplication.Do()
  oAriaApplication.oToolBar = null
  *E302737,1 HES - As we'll use it below [Begin]
  *!*	  oAriaApplication = null
  *E302737,1 HES - As we'll use it below [Begin]
ENDIF

SET CLASSLIB TO

*E302737,1 HES - Use a fixed path as the set path is empty by "oAriaApplication.Do()" [Begin]
*!*	CLEAR CLASSLIB MAIN
CLEAR CLASSLIB oAriaApplication.ClassDir+"MAIN"
oAriaApplication = null
*E302737,1 HES - Use a fixed path as the set path is empty by "oAriaApplication.Do()" [End  ]

CLEAR DLLS
RELEASE ALL EXTENDED
CLEAR ALL
* ------------------------------------------------------------------------------
PROCEDURE lpSetLibs
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
*!*	LPARAMETERS lcPathToSearch
LPARAMETERS lcPathToSearch, lcClntClassDir
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]
PRIVATE lnClasses, lnClass, laClasses

lcPathToSearch = IIF(RIGHT(lcPathToSearch,1)="\", lcPathToSearch, lcPathToSearch+"\")
lnClasses   = ADIR(laClasses, lcPathToSearch + "*.VCX")
FOR lnClass = 1 TO lnClasses
  *E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
*!*	  = lpSetFile (lcPathToSearch, laClasses[lnClass,1]) 
  = lpSetFile (lcPathToSearch, laClasses[lnClass,1],lcClntClassDir) 
  *E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]  
ENDFOR
* ------------------------------------------------------------------------------
PROCEDURE lpSetFile
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
*!*	LPARAMETERS lcPath, lcClassFileName 
LPARAMETERS lcPath, lcClassFileName,lcClntClassDir 
*E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]
PRIVATE lcClass, lcCommand



IF UPPER(RIGHT(lcClassFileName, 3)) = "VCX"
  lcClass   = lcPath + lcClassFileName 
  lcCommand = SPACE(0)
  
  *E302737,1 HES - As we removed all classes from Aria3Edi, so no need to include them again [Begin]
*!*	  IF INLIST(UPPER(lcClassFileName), "MAIN.VCX", "GLOBALS.VCX", "UTILITY.VCX")
*!*	    *E302729,1 HES Change the Aria.EXE name to be the new EDI folder's Name [Begin]
*!*	*!*	    lcCommand = "IN ARIA.EXE"
*!*	    lcCommand = "IN ARIA3EDI.EXE"    
*!*	    *E302729,1 HES Change the Aria.EXE name to be the new EDI folder's Name [End  ]
*!*	  ENDIF
  *E302737,1 HES - As we removed all classes from Aria3Edi, so no need to include them again [End  ]
  
  *B605053,1 Hassan [Begin]
  *IF !(lcClassFileName $ SET("CLASSLIB"))
  IF !("\"+lcClassFileName $ SET("CLASSLIB"))   
    
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [BEGIN]
    IF FILE(lcClntClassDir+lcClassFileName)
      lcClass = STRTRAN(lcClass,lcPath,lcClntClassDir)
    ENDIF 
    *E302925,1 03/07/2011 Add the feature of working with client classes if exist [END  ]
     
    SET CLASSLIB TO (lcClass) &lcCommand ADDITIVE
    
  ENDIF
  *B605053,1 Hassan [End]
ENDIF

*!*************************************************************
*! Name      : gfTempName
*! Developer : Yasser Saad Ibrahime
*! Date      : 1993-1995 
*! Purpose   : Creat temp file name
*!*************************************************************
*! Calls     : 
*!      Called by: ARIA3.PRG                
*!*************************************************************
*! Passed Parameters  : None
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
*:->
FUNCTION gfTempName
RETURN ("X"+SUBSTR(SYS(2015),4))
*!*************************************************************
*! Name      : gfSubStr
*! Developer : Yasser Saad Ibrahime
*! Date      : 1993-1995 
*! Purpose   : To extract element from string or to convert string to array
*!*************************************************************
*! Calls     : 
*!      Called by: ARIA3.PRG                
*!      Called by: GFSETUP()                (function  in ARIA3.PRG)
*!      Called by: GFSCRINI()               (function  in ARIA3.PRG)
*!      Called by: GFMODALGEN()             (function  in ARIA3.PRG)
*!      Called by: GFSEEKREC()              (function  in ARIA3.PRG)
*!      Called by: GFDBFFIELD()             (function  in ARIA3.PRG)
*!      Called by: GFFLOCK()                (function  in ARIA3.PRG)
*!      Called by: GFRLOCK()                (function  in ARIA3.PRG)
*!      Called by: GFWAIT()                 (function  in ARIA3.PRG)
*!      Called by: GFGETVLD()               (function  in ARIA3.PRG)
*!*************************************************************
*! Passed Parameters  : String to be used
*!                      poiter to array or element position
*!                      sparators used in the string
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
* This function will return eather a string part # OR an array of all
* the string parts according to the type of the second parameter. The
* firest parameter will be the string or string variable. If the
* second parameter have a numeric type, the function will return the
* but if it is an array the function will return the array with each
*  element having a part from the string.
* 
*:->
FUNCTION gfSubStr
PARAMETERS lcString,lnAryOrPos,lcSepta

lcSubstr  =' '
lnAryDim  = 1
lnAryRows = 1
lnAryCols = 1
lcSepta   = IIF(TYPE('lcSepta')='C',lcSepta,',') 

IF LEN(ALLTRIM(lcSepta))>1
  lcColSep  = SUBSTR(lcSepta,2,1)
  lcSepta   = LEFT(lcSepta,1)
  lnAryDim  = IIF(OCCURS(lcSepta,lcString)>0,;
              OCCURS(lcSepta,lcString)+;
              IIF(RIGHT(lcString,1)<>lcSepta,1,0),;
              lnAryDim)
  lnAryCols = IIF(OCCURS(lcColSep,lcString)>0,;
              OCCURS(lcColSep,lcString)+;
              IIF(RIGHT(lcString,1)<>lcColSep,1,0),;
              lnAryDim)
  lnAryRows = (lnAryDim+(lnAryCols-1)) / lnAryCols
  lnAryDim  = lnAryDim +(lnAryCols-1)     
  lcString  = STRTRAN(lcString,lcColSep,lcSepta)
ELSE
  lnAryDim = IIF(OCCURS(lcSepta,lcString)>0,;
             OCCURS(lcSepta,lcString)+;
             IIF(RIGHT(lcString,1)<>lcSepta,1,0),;
             lnAryDim)
ENDIF

*** Chek if second parameter array or numeric
DO CASE
  *** If no parameter found assume firest part of string
  CASE TYPE ('lnAryOrPos')='U'
    lnAryOrPos = 1

  *** If array strich it to hold all string parts
  CASE TYPE ('lnAryOrPos') $ 'C,L'    
    IF lnAryCols > 1
      DIMENSION lnAryOrPos[lnAryRows,lnAryCols]
    ELSE
      IF ALEN(lnAryOrPos,2) > 0
        DIMENSION lnAryOrPos[lnAryDim,ALEN(lnAryOrPos,2)]
      ELSE
        DIMENSION lnAryOrPos[lnAryDim]
      ENDIF  

    ENDIF
    lnAryOrPos  = ' '

ENDCASE

FOR lnArElem  = 1 TO lnAryDim
  IF TYPE ('lnAryOrPos')='N'
    lnArElem = lnAryOrPos
  ENDIF  

  DO CASE
    *** In case of firest string part
    CASE lnArElem = 1
      lcSubstr = SUBSTR(lcString,1,;
      IIF(lcSepta $ lcString,AT(lcSepta,lcString)-1,LEN(lcString)))

    *** In case of last string part
    CASE lnArElem = lnAryDim
      lcSubstr = SUBSTR(lcString,AT(lcSepta,lcString,lnArElem-1)+1)
      lcSubstr = IIF(RIGHT(lcSubstr,1)=lcSepta,;
                 SUBSTR(lcSubstr,1,LEN(lcSubstr)-1),lcSubstr)
    *** In case of any string part from the meddel
    CASE lnArElem > 1
      lcSubstr = SUBSTR(lcString,AT(lcSepta,lcString,lnArElem-1)+1,;
                 AT(lcSepta,lcString,lnArElem)-;
                 AT(lcSepta,lcString,lnArElem-1)-1)
  ENDCAS

  IF TYPE ('lnAryOrPos')='N'
    RETURN lcSubstr
  ENDIF  
  
  IF lnAryCols > 1
    lnAryOrPos[((lnArElem-1)%lnAryRows)+1,INT((lnArElem-1)/lnAryRows)+1] = lcSubstr
  ELSE
    lnAryOrPos[lnArElem] = lcSubstr
  ENDIF
ENDFOR




*!*************************************************************
*! Name      : gfGetTime
*! Developer : Hesham El-Sheltawi
*! Date      : 10/22/96
*! Purpose   : get the current time with am,pm format
*!*************************************************************
*! Calls     : 
*!*************************************************************
*! Passed Parameters  : current time
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
*:->
FUNCTION gfGetTime

lcCurrHour = IIF(VAL(SUBSTR(TIME(),1,2))=12 OR VAL(SUBSTR(TIME(),1,2))=0,;
             '12',ALLTRIM(STR(VAL(SUBSTR(TIME(),1,2))%12)))
             
lcCurrTime = IIF(VAL(lcCurrHour)<10,'0','')+lcCurrHour+;
             SUBSTR(TIME(),3)+IIF(VAL(SUBSTR(TIME(),1,2))>=12,' pm',' am')
             
RETURN (lcCurrTime)             


*!*************************************************************
*! Name      : gfMenuBar
*! Developer : Hesham El-Sheltawi
*! Date      : 10/22/96
*! Purpose   : Run a Menu option
*!*************************************************************
*! Calls     : 
*!*************************************************************
*! Passed Parameters  : lcPop_Name,lnBar_Pos
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
*:->
FUNCTION gfMenuBar
PARAMETERS lcPop_Name,lnBar_Pos
=oAriaApplication.MenuBar(lcPop_Name,lnBar_Pos)

*!*************************************************************
*! Name      : gfChngComp
*! Developer : Hesham El-Sheltawi
*! Date      : 10/22/96
*! Purpose   : Change the active company
*!*************************************************************
*! Calls     : 
*!*************************************************************
*! Passed Parameters  : lcComp_ID Company ID to be active
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
*:->
FUNCTION gfChngComp
PARAMETERS lcComp_id
=oAriaApplication.ChangeCompany(lcComp_Id)


*!*************************************************************
*! Name      : gfDoHelp
*! Developer : Hesham El-Sheltawi
*! Date      : 10/22/96
*! Purpose   : Activate the help screen for aria systems
*!*************************************************************
*! Calls     : 
*!*************************************************************
*! Passed Parameters  : 
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
*:->
FUNCTION gfDoHelp
HELP




FUNCTION GPEXIT
CLEAR WINDOWS
IF _SCREEN.FORMCOUNT <= 1
  oAriaApplication.Sysexit()
ENDIF  



*E611806,1 Sara.N 07/02/2019 [Start]
FUNCTION gfUserList
PARAMETERS llGetCount
PRIVATE ALL LIKE  L*
*SET DATASESSION TO 1
lcOldRep = SET('REPROCESS')
lnDataSession = set('datas')
SET DATASESSION TO 1
SET REPROCESS TO 1
SET STEP ON
llGetCount = IIF(TYPE('llGetCount')="U",.F.,llGetCount)

DECLARE laUserList[1]
llUserUsed = USED('SYUUSER')
lcCurrFile = ALIAS()
laUserList = " "
lnUsrRec   = 0
IF !USED("SYUSTATC")
  *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[Start]
  *USE (oAriaApplication.SysPath+"SYUSTATC") IN 0 SHARED 
  lcSQLDICPATH = oAriaApplication.DefaultPath + 'SQLDictionary\'
  
  *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[Start]
  IF oAriaApplication.multiinst 
    lcSQLDICPATH = 'X:\Aria4xp\SQLDictionary\'
  ENDIF 
  *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[End]

  
  USE (lcSQLDICPATH +"SYUSTATC") IN 0 SHARED 
  *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[End]
ENDIF
SELECT SYUSTATC

*B128052,1 AMH Set order to cuser_id to be sure the order tag is used [Start]
SET ORDER TO cUser_ID
*B128052,1 AMH [End]

*-- Hesham (Start)
*!*	IF !llUserUsed
*!*	  USE (oAriaApplication.SysPath+'SYUUSER') IN 0 ORDER TAG cuser_id
*!*	ENDIF
*!*	IF USED("SYUUSER")
*!*	  lnUsrRec = RECNO("SYUUSER")
*!*	ENDIF

*IF lnRemResult>=1

*-- Hesham (End)
*MAN Speed Optimization, use the curr user as a variable instead of obj. ref.
*!*	SELECT IIF(SYUSTATC.CUSER_ID = oAriaApplication.User_ID AND;
*!*	           SYUSTATC.cstation = oAriaApplication.Station,;
*!*	           "» ","  ")+;
*!*	           PADR(LFGETUSRNM(SYUSTATC.CUSER_ID),35) ;
*!*	     FROM (oAriaApplication.SysPath+"SYUSTATC");
*!*	     WHERE COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
*!*	            'INI'+'OLDVARS' ;
*!*	       .AND.;
*!*	             gfCheckUser(SYUSTATC.CUSER_ID,CSTATION) ;
*!*	       INTO ARRAY  laUserList     
lcCurUser= oAriaApplication.User_ID 
lcCurStat= oAriaApplication.Station
IF !llGetCount
 *sara
*  lnRemResult = oAriaApplication.remotesystemdata.execute("Select * from syuuser",'',"syuuser","",oAriaApplication.SystemConnectionString,3,"",1)
  *sara
  *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[Start]
  *SELECT IIF(SYUSTATC.CUSER_ID = lcCurUser AND;
           SYUSTATC.cstation = lcCurStat,;
           "» ","  ")+;
           PADR(LFGETUSRNM(SYUSTATC.CUSER_ID),35) ;
     FROM (oAriaApplication.SysPath+"SYUSTATC");
     WHERE COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
            'INI'+'OLDVARS' ;
       .AND.;
             gfCheckUser(SYUSTATC.CUSER_ID,CSTATION) ;
       INTO ARRAY  laUserList   
       *sara  
    *lcSQLDICPATH = oAriaApplication.DefaultPath + 'SQLDictionary\' 
    lcSQLDICPATH = oAriaApplication.syspath   
   *sara
   
   *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[Start]
  *sara
   IF oAriaApplication.multiinst 
    *lcSQLDICPATH = 'X:\Aria4xp\SQLDictionary\'
    lcSQLDICPATH = oAriaApplication.syspath
   ENDIF 
   *sara
   *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[End]
   
   SELECT IIF(SYUSTATC.CUSER_ID = lcCurUser AND;
           SYUSTATC.cstation = lcCurStat,;
           "» ","  ")+;
           PADR(LFGETUSRNM(SYUSTATC.CUSER_ID),35) ;
     FROM (lcSQLDICPATH+"SYUSTATC");
     WHERE COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
            'INI'+'OLDVARS' ;
       .AND.;
             gfCheckUser(SYUSTATC.CUSER_ID,CSTATION) ;
       INTO ARRAY  laUserList            
   *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[End]
ELSE
  IF !USED("SYUSTATC")
  
    *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[Start]
    USE (oAriaApplication.SysPath+"SYUSTATC") IN 0 SHARED 
   ** lcSQLDICPATH = oAriaApplication.DefaultPath + 'SQLDictionary\'
    
    *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[Start]
*!*	    IF oAriaApplication.multiinst 
*!*	      lcSQLDICPATH = 'X:\Aria4xp\SQLDictionary\'
*!*	    ENDIF 
    *! E302567,1 MMT 01/06/2009 Change file paths for SAAS[End]
    
   * USE (lcSQLDICPATH+"SYUSTATC") IN 0 SHARED 
    *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[End]
    
  ENDIF
  lnUserCount = 0
  SELECT SYUSTATC
  
  *B128052,1 AMH Use gfCheckUser function to privent lock records with out unlock them [Start]
  *COUNT FOR COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
            'INI'+'OLDVARS' AND !RLOCK() TO lnUserCount
  *UNLOCK 
  
  *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[Start]
  *COUNT FOR COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
            'INI'+'OLDVARS' AND !gfCheckUser(SYUSTATC.CUSER_ID,CSTATION) TO lnUserCount
   COUNT FOR COBJ_TYP+ALLTRIM(COBJ_NAME)+SYUSTATC.CUSER_ID+CSTATION=;
            'INI'+'OLDVARS' AND gfCheckUser(SYUSTATC.CUSER_ID,CSTATION) TO lnUserCount
  *! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[End]
  *B128052,1 AMH [End]
  
ENDIF

*! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[Start]
*IF oAriaApplication.UserStaticRecord < RECCOUNT('syuStatc')
IF oAriaApplication.UserStaticRecord <= RECCOUNT('syuStatc')
*! E302555,1 MMT 09/18/2008 Add Syustatc File For Aria4 and count A4 users[End]

  GO oAriaApplication.UserStaticRecord  IN syuStatc 
  SET REPROCESS TO 1
  =RLOCK('syuStatc')
ENDIF  
SET REPROCESS TO lcOldRep
IF !llGetCount
  oAriaApplication.DoFormRetVal(oAriaApplication.ScreenHome+"sy\syusrlst")
ENDIF  


IF !EMPTY(lcCurrFile)
  SELECT (lcCurrFile)
ENDIF  

*-- Hesham (Start)
*!*	IF lnUsrRec > 0 .AND. USED("SYUUSER")
*!*	  IF lnUsrRec <= RECCOUNT("SYUUSER")
*!*	    GO lnUsrRec IN SYUUSER
*!*	  ENDIF
*!*	ENDIF
*-- Hesham (End)
IF !llGetCount AND !llUserUsed
  USE IN SYUUSER
ENDIF

SET DATASESSION TO lnDataSession
IF llGetCount
  *RETURN _TALLY 
  RETURN lnUserCount
ENDIF

*E611806,1 Sara.N 07/02/2019 [End]

************************************************
FUNCTION gfCheckUser
PARAMETERS lcUserID, lcStation
lcStation=IIF(TYPE('lcStation')<>"C","",lcStation)
llRetFlag = .T.

*1119 HES START
IF !USED("SYUST_2")
  USE (oAriaApplication.SysPath+'SYUSTATC') SHARED ALIAS 'SYUST_2' AGAIN IN 0 ORDER TAG CUSER_ID   && COBJ_TYP+ALLTRIM(COBJ_NAME)+CUSER_ID+CSTATION
ENDIF
*1119 HES END  

*B609494,1 HES 11/01/2011 Filter just the EDI users [Begin]
*!*	IF SEEK('INI'+'OLDVARS'+lcUserID+lcStation,'SYUSTATC')
lnAlais= SELECT()

*1119 HES START
*!*	=SEEK('INI'+'OLDVARS'+lcUserID+lcStation,'SYUSTATC')
*!*	SELECT SYUSTATC
*!*	LOCATE REST WHILE cobj_typ+ALLTRIM(cobj_name)+cuser_id+cstation =  'INI'+'OLDVARS'+lcUserID+lcStation FOR SYUSTATC.cAdd_Ver = 'EDI'
=SEEK('INI'+'OLDVARS'+lcUserID+lcStation,'SYUST_2')
SELECT SYUST_2
LOCATE REST WHILE cobj_typ+ALLTRIM(cobj_name)+cuser_id+cstation =  'INI'+'OLDVARS'+lcUserID+lcStation FOR SYUST_2.cAdd_Ver = 'EDI'
*1119 HES END  

IF FOUND()
*B609494,1 HES 11/01/2011 Filter just the EDI users [End  ]
  *1119 HES START
*!*	  IF RLOCK('SYUSTATC') 
  IF RLOCK('SYUST_2')
  *1119 HES END  
    *B609494,1 HES 11/01/2011 Filter just the EDI users [Begin]
    IF !(lcUserID+lcStation = oAriaApplication.User_ID+oAriaApplication.Station)
    *B609494,1 HES 11/01/2011 (End) 
    *1119 HES START  
*!*	    UNLOCK IN SYUSTATC
    UNLOCK IN SYUST_2
    *1119 HES END  
    *B609494,1 HES 11/01/2011 Filter just the EDI users [Begin]
    ENDIF
    *B609494,1 HES 11/01/2011 (End)      
    llRetFlag = .F.
  ENDIF
ELSE
  llRetFlag = .F.
ENDIF  
RETURN llRetFlag .OR. (lcUserID+lcStation = oAriaApplication.User_ID+oAriaApplication.Station)

FUNCTION gfStation

lcStation = ALLTRIM(GETENV('P_STATION'))

IF !EMPTY(lcStation)
  lcStation = ALLTRIM(SYS(2007,lcStation))
ELSE
  lcStation = SUBSTR(SYS(3),4) 
ENDIF

RETURN (lcStation)


FUNCTION lfGetUsrNm
PARAMETER lcUser_ID
SELECT SYUUSER
IF SEEK(lcUser_ID)
   RETURN cUsr_Name
ELSE
    RETURN lcUser_ID
ENDIF

FUNCTION GPRELOGIN
IF _SCREEN.FORMCOUNT <= 1 
  oAriaApplication.Login()
  oAriaApplication.LogUser(.T.)
  OAriaApplication.SetMenu(OAriaApplication.ActiveModuleID,IIF(OAriaApplication.ActiveModuleID='SY','S','A'))
ELSE
  =MessageBox("You have to close all programs before login in with new use id",16)  
ENDIF



FUNCTION gfPrintSet
=SYS(1037)

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
*wab
*lParameters tcBrowseFields,tcBrowseTitle,tcAlias,tcKey,tcFor,tcOptions,tlSelect
lParameters tcBrowseFields,tcBrowseTitle,tcAlias,tcKey,tcFor,tcOptions,tlSelect ,;
            toSelectObj,tcSelectMethod,tcUserShortCut,tcTempFile,tcSelField
*wab
LOCAL llReturnValue,lcAlias
lcAlias = SELECT()
IF !EMPTY(tcAlias)
  SELECT (tcAlias)
  *B040061,AAH,,01/04/2005 [BEGIN]
  GO TOP
  IF EOF()
    RETURN .F.
  ENDIF 
  *B040061,AAH,,01/04/2005 [END]  
ENDIF
IF EMPTY(tcBrowseFields)
  tcBrowseFields=gfDataBaseProp('Get',ALIAS(),'Table','BrowseFields')
ENDIF
PRIVATE oBrowse
oBrowse = .Null.
*wab
DO FORM BROWSE WITH tcBrowseFields,tcBrowseTitle,tcKey,tcFor,tcOptions,tlSelect;
   TO llReturnValue
*DO FORM BROWSE WITH tcBrowseFields,tcBrowseTitle,tcKey,tcFor,tcOptions,tlSelect,;
*       toSelectObj,tcSelectMethod,tcUserShortCut,tcTempFile,tcSelField   TO llReturnValue
*wab
SELECT (lcAlias)    
RETURN llReturnValue


*!*************************************************************
*! Name      : gfDataBaseProp
*! Developer : Hesham El-Sheltawi
*! Date      : 11/20/96
*! Purpose   : Return Or Set or Remove User defined property value 
*!             from database
*!*************************************************************
*! Parameters: tcName          && object name in database
*!             tcType          && type of object in database
*!                             && Table,Field,Index,Relation
*!             tcProperty      && User Defined Property name
*!             tcPropertyValue && value of property to be saved
*!*************************************************************
*! Call      : 
*!*************************************************************
*! Returns            : VALUE OF Property value "Different types"
*!*************************************************************
*! Example   : lcVarName=gfDataBaseProp('Get',"syccomp.ccomp_id",'Field','BrowseField')
*!             WILL return from the database the value of the property
*!             called browsefield for the field ccomp_id in the table
*!             syccomp
*!*************************************************************
FUNCTION gfDataBaseProp
lParameters tcDatabaseFunction,tcName,tcType,tcProperty,tcPropertyValue

LOCAL lnCount,lcAlias,lcFieldName,lcTableName,lcDataBase,lcPath,lcRetrunValue
tcName = UPPER(tcName)
tcType = UPPER(tcType)
tcProperty = UPPER(tcProperty)
tcDatabaseFunction = PROP(ALLTRIM(tcDatabaseFunction))

IF tcType='FIELD'
  IF ATC('.',tcName)>0
    lcAlias = SUBSTR(tcName,1,ATC('.',tcName)-1)
    lcFieldName = SUBSTR(tcName,ATC('.',tcName)+1)
    lcTableName = CURSORGETPROP('Sourcename',lcAlias)
    lcTableName = STRTRAN(lcTableName,'.DBF','')
    tcName = lcTableName+'.'+lcFieldName
  ENDIF
ENDIF

DO CASE
  CASE tcType = 'DATABASE'
    IF DBUSED(tcName)
      SET DATABASE TO (tcName)
    ELSE
      RETURN tcName  
    ENDIF
  CASE tcType $ "FIELD,TABLE,VIEW"
    IF tcType = 'FIELD'
      lcDataBase = CURSORGETPROP("DATABASE",lcAlias)
     ELSE 
       lcDataBase = CURSORGETPROP("DATABASE",tcName)
     ENDIF 
     IF !EMPTY(lcDataBase)
       lcPath =''
       IF ATC('\',lcDataBase)>0
         lcPath = SUBSTR(lcDataBase,1,RAT('\',lcDataBase))
         lcDataBase = STRTRAN(lcDataBase,lcPath,'')
         lcDataBase = STRTRAN(lcDataBase,'.DBC','')
       ENDIF
       IF !DBUSED(lcDataBase)
         OPEN DATABASE (lcPath+lcDataBase)  
       ENDIF
       SET DATABASE TO (lcDataBase)     
     ELSE
       RETURN .F.  
     ENDIF  
ENDCASE
DO CASE
  CASE tcDatabaseFunction == 'Dbgetprop'
    lcRetrunValue = DBGetProp(tcName,tcType,tcProperty)  
  CASE tcDatabaseFunction == 'Dbsetprop'
    lcRetrunValue = DBSetProp(tcName,tcType,tcProperty,tcPropertyValue)  
  CASE tcDatabaseFunction == 'Get'
*    lcRetrunValue = sfsGETProp(tcName,tcType,tcProperty)
  CASE tcDatabaseFunction == 'Set'   
*    lcRetrunValue = sfsSetProp(tcName,tcType,tcProperty,tcPropertyValue)  
  CASE tcDatabaseFunction == 'Remove'   
*    lcRetrunValue = sfsRemoveProp(tcName,tcType,tcProperty)  
ENDCASE     
RETURN lcRetrunValue


*:************************************************************************
*: Program file  : GFGENFLT.PRG
*: Program desc. : 
*: For screen    :
*:         System: Aria advantage series
*:         Module: Main system 
*:      Developer: 
*:************************************************************************
*: Calls : 
*:         Procedures :
*:         Functions  : 
*:************************************************************************
*: Passed Parameters  : 
*:************************************************************************
FUNCTION GFGENFLT
PARAMETERS lcArray,llFilter
lcquery=''
lcElmSep=','


lcLineFeed=' ' &&+CHR(10)+CHR(13)
lnFltStart=1
DO WHILE (&lcArray[lnFltStart,1]='.OR.' OR EMPTY(&lcArray[lnFltStart,1]));
        AND !lnFltStart=ALEN(&lcArray,1)
  lnFltStart=lnFltStart+1
ENDDO 
lnFltEnd=ALEN(&lcArray,1)
DO WHILE (&lcArray[lnFltEnd,1]='.OR.' OR EMPTY(&lcArray[lnFltEnd,1]));
         AND lnFltEnd>1
  lnFltEnd=lnFltEnd-1
ENDDO 

lnOr=0       
IF lnFltStart>ALEN(&lcArray,1)
  RETURN ''
ENDIF
IF lnFltEnd=ALEN(&lcArray,1)
   lcWhichElm=lcArray+'['+ALLTRIM(STR(ALEN(&lcArray,1)))+',1]'
  IF TYPE(lcWhichElm)<>'C'
    RETURN ''
  ENDIF
  IF &lcArray[ALEN(&lcArray,1),1]='.OR.'
    RETURN ''
  ENDIF
ENDIF
lnCount=lnFltStart

DO WHILE  lnCount<=lnFltEnd
 IF  &lcArray[lnCount,3]='N' AND EMPTY(VAL(&lcArray[lnCount,6])) ;
     AND &lcArray[lnCount,7]='V'
    lnCount=lnCount+1
    LOOP
 ENDIF
IF !EMPTY(ALLTRIM(STRTRAN(STRTRAN(&lcArray[lnCount,6],lcElmSep,'');
   ,IIF(&lcArray[lnCount,3]='D','/',''),''))) OR &lcArray[lnCount,1]='.OR.'
  IF !EMPTY(&lcArray[lnCount,1])
    IF &lcArray[lnCount,1]<>'.OR.'
      lcQuery=lcQuery+lfGetQCond(lnCount,lcArray,llFilter)
    ELSE
      lcQuery= IIF(RIGHT(lcQuery,9)=lcElmSep+' .AND. '+lcElmSep,SUBSTR(lcQuery,1,LEN(lcQuery)-9),lcQuery)
      IF lnOr>0
       lcQuery=lcQuery+' ) '
       lnOr=0
      ENDIF
      ** THIS CONDITION IS ADDED BY HESHAM 3 AUG.    
      DO WHILE lnCount<lnFltEnd-1 AND (EMPTY(ALLTRIM(STRTRAN(STRTRAN(&lcArray[lnCount+1,6],lcElmSep,'');
      ,IIF(&lcArray[lnCount+1,3]='D','/  /',''),''))) OR &lcArray[lnCount+1,1]='.OR.')
        lnCount=lnCount+1
      ENDDO
      IF !EMPTY(ALLTRIM(STRTRAN(&lcArray[lnCount+1,6],lcElmSep,''))) AND !EMPTY(ALLTRIM(lcQuery))
        lcQuery=ALLTRIM(lcQuery)+' '+lcElmSep+' OR '+lcElmSep+'( '
         lnOr=1
      ENDIF   
    ENDIF  
  ENDIF 
ENDIF
lnCount=lnCount+1   
ENDDO
lcQuery= IIF(RIGHT(lcQuery,9)=lcElmSep+' .AND. '+lcElmSep,SUBSTR(lcQuery,1,LEN(lcQuery)-9),lcQuery)
 IF lnOr>0
   lcQuery=lcQuery+' ) '
 ENDIF    
 lcQuery=STRTRAN(lcQuery,lcElmSep+' .AND. '+lcElmSep,lcLineFeed+' AND '+lcLineFeed)
 lcQuery=STRTRAN(lcQuery,lcElmSep+' OR '+lcElmSep,lcLineFeed+' OR '+lcLineFeed) 
RETURN lcQuery


FUNCTION lfGetQCond
PARAMETERS lnCount,lcArray,llFilter
lcFiltExp=''
DO CASE
  CASE &lcArray[lnCount,5] = 'Contains'
  
       lcFiltExp=IIF(!&lcArray[lnCount,4],'','!(')+;
                 lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                 &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+;
                 ' $ '+ALLTRIM(&lcArray[lnCount,1])+' '+;
                 IIF(!&lcArray[lnCount,4],'',' ) ')+lcElmSep+' .AND. '+lcElmSep                       
                 
  CASE &lcArray[lnCount,5] = 'Like' OR &lcArray[lnCount,5] = 'Exactly Like'
  
       lcFiltExp=IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                  +IIF(&lcArray[lnCount,3]='D',")",'')+' '+IIF(!&lcArray[lnCount,4],;
                   IIF(&lcArray[lnCount,5] = 'Like','=','=='),'<>')+' '+;
                  lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                 &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+lcElmSep+' .AND. '+lcElmSep                
               
  CASE INLIST(&lcArray[lnCount,5],'Greater Than','Less Than','Greater Or Equal',;
              'Less Or Equal')     
        lcOperator=lfGetOper(ALLTRIM(&lcArray[lnCount,5]),!&lcArray[lnCount,4])              
        lcFiltExp=IIF(&lcArray[lnCount,4],'','!(')+;
                IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                  +IIF(&lcArray[lnCount,3]='D',")",'')+' '+lcOperator+' '+;
                  lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                 &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+IIF(!&lcArray[lnCount,4],'',' ) ')+;
                 lcElmSep+' .AND. '+lcElmSep                              
  CASE &lcArray[lnCount,5] = 'Between'
    IF llFilter
       lcFiltExp=IIF(!&lcArray[lnCount,4],'BETWEEN(','!BETWEEN(')+;
               IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                   +IIF(&lcArray[lnCount,3]='D',")",'')+','+;
                   lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                   &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+;
                   ')'+lcElmSep+' .AND. '+lcElmSep
    ELSE
         lcFiltExp= IIF(!&lcArray[lnCount,4],'','!(')+;
                    IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                   +IIF(&lcArray[lnCount,3]='D',")",'')+' BETWEEN '+;
                   lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                   &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+;
                   IIF(!&lcArray[lnCount,4],'',')')+lcElmSep+' .AND. '+lcElmSep    
    ENDIF  
  CASE &lcArray[lnCount,5] = 'In List'
    IF llFilter
       lcFiltExp=IIF(!&lcArray[lnCount,4],'INLIST(','!INLIST(')+;
               IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                   +IIF(&lcArray[lnCount,3]='D',")",'')+','+;
                   lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                   &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+;
                   ')'+lcElmSep+' .AND. '+lcElmSep
    ELSE
         lcFiltExp= IIF(!&lcArray[lnCount,4],'','!(')+;
                    IIF(&lcArray[lnCount,3]='D',"DTOS(",'')+ALLTRIM(&lcArray[lnCount,1]);
                   +IIF(&lcArray[lnCount,3]='D',")",'')+' IN('+;
                   lfrightGet(&lcArray[lnCount,6],&lcArray[lnCount,3],;
                   &lcArray[lnCount,5],lcElmSep,&lcArray[lnCount,7])+')'+;
                   IIF(!&lcArray[lnCount,4],'',')')+lcElmSep+' .AND. '+lcElmSep    
    ENDIF    
ENDCASE

RETURN lcFiltExp


FUNCTION lfGetOper              
PARAMETER lcOperator,llisnot
DO CASE
  CASE lcOperator = 'Greater Than'
     RETURN '>'
  CASE lcOperator = 'Less Than'
     RETURN '<'
  CASE lcOperator = 'Greater Or Equal'
    RETURN '>='
  CASE lcOperator = 'Less Or Equal'
    RETURN '<='
ENDCASE  


FUNCTION lfRightGet
PARAMETERS mRightHead,cLeftType,cOperator,lcElmSep,cRightType
lcRetVal=mRightHead
DO CASE
  CASE cRightType='V'
    DO CASE      
      CASE cLeftType $ 'CM'
          IF INLIST(COPERATOR,'Between','In List')
            lcSeper=IIF(!llFilter AND cOperator='Between',' AND ',',')
               lcRetVal='"'+STRTRAN(ALLTRIM(mRightHead),lcElmSep,'"'+lcSeper+'"')+'"'
          ELSE
             RETURN '"'+mrightHead+'"'   &&'"'+ALLTRIM(mrightHead)+'"'   
          ENDIF
      CASE cLeftType = 'N'
            lcSeper=IIF(COPERATOR='Between' AND !llFilter,' AND ',',')
            lcRetVal=STRTRAN(mRightHead,lcElmSep,lcSeper)
         IF EMPTY(lcRetVal)
           lcRetVal='0'
         ENDIF
      CASE cLeftType = 'D'
            IF INLIST(COPERATOR,'Between','In List')
            lcSeper=IIF(!llFilter AND cOperator='Between',' AND ALLTRIM(DTOS(',',ALLTRIM(DTOS(')            
               lcRetVal='ALLTRIM(DTOS({  '+STRTRAN(ALLTRIM(mRightHead),lcElmSep,'  }))'+lcSeper+'{  ')+'  }))'
            ELSE    
              lcRetVal='ALLTRIM(DTOS({  '+ALLTRIM(MRIGHTHEAD)+'  }))'
           ENDIF   
      CASE cLeftType = 'L'
           RETURN ' '+lcRetVal+' '
    ENDCASE  
  CASE cRightType='F'
    lcRetVal=STRTRAN(ALLTRIM(mRightHead),lcElmSep,',')
ENDCASE  
IF INLIST(cOperator,'Between','In List') AND EMPTY(ALLTRIM(mRightHead))
    lcSeper=IIF(!llFilter AND cOperator='Between',' AND ',',')
    lcRetVal=lcRetVal+lcSeper+lcRetVal
 ENDIF
RETURN lcRetVal



*!*************************************************************
*! Name      : GFCPTOP
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR FIRST
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPTOP
oAriaApplication.oToolBar.cmdTop.Click

*!*************************************************************
*! Name      : GFCPBTTM
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Bottom
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPBTTM
oAriaApplication.oToolBar.cmdend.Click

*!*************************************************************
*! Name      : GFCPNEXT
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR next
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPNEXT
oAriaApplication.oToolBar.cmdNext.Click

*!*************************************************************
*! Name      : GFCPPRVIS
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR previous
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPPRVIS
oAriaApplication.oToolBar.cmdPrev.Click

*!*************************************************************
*! Name      : GFVCPNEW
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR New
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFVCPNEW
oAriaApplication.oToolBar.cmdadd.Click


*!*************************************************************
*! Name      : GFVCPPRINT
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Print
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFVCPPRINT
oAriaApplication.oToolBar.cmdprint.Click

*!*************************************************************
*! Name      : GFCPEDIT
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Edit
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPEDIT
oAriaApplication.oToolBar.cmdedit.Click

*!*************************************************************
*! Name      : GFCPDELETE
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Delete
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPDELETE
oAriaApplication.oToolBar.cmddelete.Click

*!*************************************************************
*! Name      : GFCPBROWS
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Browse
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCPBROWS
oAriaApplication.oToolBar.cmdfind.Click

*!*************************************************************
*! Name      : GFCHNGORDR
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Order
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFCHNGORDR

*!*************************************************************
*! Name      : GFSETFILTR
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Filter
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GFSETFILTR


*!*************************************************************
*! Name      : GPRECHIST
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Record History
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION GPRECHIST

*!*************************************************************
*! Name      : gfCpSave
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Save
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION gfCpSave
oAriaApplication.oToolBar.cmdAdd.Click

*!*************************************************************
*! Name      : gfCpClose
*! Developer : Hesham El-Sheltawi
*! Date      : 07/08/98
*! Purpose   : 
*!*************************************************************
*! Parameters: 
*!*************************************************************
*! Called by : MENU BAR Close  / Cancel
*!*************************************************************
*! Returns            : 
*!*************************************************************
*! Example   : 
*!*************************************************************
*
FUNCTION gfCpClose
IF oAriaApplication.oToolBar.EditMode
  oAriaApplication.oToolBar.cmdEdit.Click
ELSE
  oAriaApplication.oToolBar.cmdexit.Click
ENDIF  

*!*************************************************************

FUNCTION GFTBARONOF
oAriaApplication.oToolBar.Visible = !oAriaApplication.oToolBar.Visible

*!*************************************************************

FUNCTION gfAbotAria

DO FORM syabout
*oAriaApplication.RunProg("SYABOUT")

*!*************************************************************

FUNCTION gfGetName
lParameters lcTagUser
LOCAL lcNames,laTo,laVal,lnCount
DIME laTo[1,1]
STORE '' TO laTo,lcNames
IF !EMPTY(lcTagUser)
  =gfSubStr(lcTagUser,@laTo,'|')
  FOR lnCount = 1 TO ALEN(laTo,1)
    DIMEN laVal[1,1]
    IF !EMPTY(laTo[lnCount,1])
      =gfSubStr(laTo[lnCount,1],@laVal,'~')
      lcNames = lcNames + IIF(EMPTY(lcNames),'',';')+ALLT(laVal[1,1])+'['+ALLT(laVal[1,3])+'] '
    ENDIF 
  ENDFOR  
ENDIF  
RETURN lcNames


FUNCTION gfGetAttch
LPARAMETERS lcMsgID
PRIVATE lnAlias,lcAttach
lnAlias = SELECT()
SELECT MTMSATCH
lcAttach = ""
IF SEEK(lcMsgID,'MTMSATCH')
  SCAN REST WHILE cMsgID = lcMsgID
    lcAttach = lcAttach + cattchfile + CHR(13)+CHR(10)
  ENDSCAN  
ENDIF
SELECT (lnAlias)
RETURN lcAttach


FUNCTION UPDDATE
DO Form syUpDate

*!*************************************************************
*! Name      : gfAdd_Info
*! Developer : Yasser Saad Ibrahime
*! Date      : 1993-1995 
*! Purpose   : To add  audit information to any file
*!*************************************************************
*! Calls     : 
*!      Called by: ARIA3.PRG                
*!      Called by: GFSCRINI()               (function  in ARIA3.PRG)
*!      Called by: GFSTATIC()               (function  in ARIA3.PRG)
*!      Called by: GFSEQUENCE()             (function  in ARIA3.PRG)
*!      Called by: GFCPSAVE()               (function  in ARIA3.PRG)
*!      Called by: GFSUSRPRG()              (function  in ARIA3.PRG)
*!          Calls: GFGETTIME()              (function  in ARIA3.PRG)
*!*************************************************************
*! Passed Parameters  : File name to add to
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : 
*!*************************************************************
* Update add user,date and time
*:->
FUNCTION gfAdd_Info

LPARAMETERS lcFileName, oForm

LOCAL oAddInfo

oAddInfo = CREATEOBJECT('AddUserInfo')

RETURN oAddInfo.Do(lcFileName , oForm)



FUNCTION gfErrorTrap
LPARAMETERS nError, cMethod, nLine

lcError   = IIF(TYPE("nError")  = "N", ALLTRIM(STR(nError)), ALLTRIM(STR(ERROR())))
lcMethod  = IIF(TYPE("cMethod") = "C", cMethod, "")
lcLine    = IIF(TYPE("nLine")   = "N", ALLTRIM(STR(nLine)), "")

lcNewLine = CHR(13)+CHR(10)
MessageBox("An error has occuerd..."         + lcNewLine + lcNewLine +;
           "Error Number : " + lcError    + lcNewLine +;
           "Error Message: " + MESSAGE()  + lcNewLine +;
           "Method 		: " + lcMethod   + lcNewLine +;
           "Line Number	: " + lcLine     + lcNewLine +;
           "Line Code	: " + MESSAGE(1) + lcNewLine )


CLEAR ALL
CLOSE ALL
QUIT

*!************************************************************!*************************************************************
*! Name      : gfDoTriger
*! Developer : WAB - Walid A. Wahab
*! Date      : 04/22/2002
*! Purpose   : Function to control any triggers found in the
*!             triggers file, customized processes and workflow
*!             server requests.
*!*************************************************************
*! Calls              : None.
*!*************************************************************
*! Passed Parameters  : 1) lcProgName, Object ID.
*!                      2) lcEvent, Event ID.
*!*************************************************************
*! Returns            : None.
*!*************************************************************
*! Example            :  =gfDoTriger()
*!*************************************************************
*E301903,1 WAB 
*!*************************************************************
*
FUNCTION gfDoTriger
PARAMETERS lcProgName , lcEvent

PRIVATE lnOldAlias , lcProgToDo , laParamExp , laParam , lcParmStr ,;
        lnCount    , llReturn , llIsOpen
llReturn = .T.
*-- If any of the parameters is not passed or passed incorrectly 
IF TYPE('lcProgName') <> 'C' .OR. EMPTY(lcProgName) .OR.;
   TYPE('lcEvent') <> 'C' .OR. EMPTY(lcEvent)
  RETURN
ENDIF

*-- Save the old alias
lnOldAlias = SELECT(0)

*-- Open the Trigger file if it was not opened
llIsOpen = .F.
IF !USED('SYCTRIGG')
    SELECT 0
    *** Open the
    USE (oARiaApplication.SysPath+"SYCTRIGG")
    SET ORDER TO 1
ENDIF

SELECT SYCTRIGG

*-- If there is triggers for this Object/Event
IF SEEK(PADR(lcProgName , 10) + PADR(lcEvent , 10))
  
  *-- Scan loop to scan the Object/Event triggers
  SCAN REST;
      WHILE cAPObjNam + cEvent_ID = PADR(lcProgName , 10) +;
            PADR(lcEvent , 10)
    
    *-- Get the name of the program that should be executed
    lcProgToDo = cTrig_ID
    *-- Initialize the parameter string variable
    lcParmStr  = ''
    
    *-- Restore the old alias to be able to evaluate the parameter
    *-- expressions properly
    SELECT (lnOldAlias)
    
    *-- If there is one or more parameters that should be passed to the
    *-- program
    IF !EMPTY(SYCTRIGG.mParmExpr)
      
      *-- Get the parameter expressions
      DIMENSION laParamExp[OCCURS('~' , SYCTRIGG.mParmExpr) + 1]
      =gfSubStr(SYCTRIGG.mParmExpr , @laParamExp , '~')
      
      *-- Initialize the parameters array
      DIMENSION laParam[ALEN(laParamExp , 1)]
      laParam = ""
      
      *-- Get the parameters values that will be passed to the program
      FOR lnCount = 1 TO ALEN(laParamExp , 1)
        laParam[lnCount] = EVALUATE(laParamExp[lnCount])
        lcParmStr = lcParmStr + IIF(lnCount = 1 , '' , ' , ') +;
                    'laParam[' + ALLTRIM(STR(lnCount)) + ']'
        
      ENDFOR    && End of FOR lnCount = 1 TO ALEN(laParamExp , 1)
    ENDIF    && End of IF !EMPTY(SYCTRIGG.mParmExpr)
    
    *-- If custom process
    *Hassan [Begin]
    lcOldPath = FullPath('')
    *MmTS
    IF oAriaApplication.multiinst
      lcNewPath = SubStr(oAriaApplication.ClientApplicationHome,1,Rat("\",oAriaApplication.ClientApplicationHome,2))
    ELSE
    *MMTS
      lcNewPath = SubStr(oAriaApplication.ApplicationHome,1,Rat("\",oAriaApplication.ApplicationHome,2))
    *MMtS
    ENDIF 
    *MMTS
    CD (lcNewPath) 
    *Hassan [End]
    IF SYCTRIGG.cActvTyp = 'C'
      *-- Call the program and get the returned value
      llReturn = &lcProgToDo(&lcParmStr)
    ENDIF    && End of IF SYCTRIGG.cActvTyp = 'C'
    *Hassan [Begin]
    CD (lcOldPath) 
    *Hassan [End]
    SELECT SYCTRIGG
  ENDSCAN    && End of SCAN REST WHILE cAPObjNam + cEvent_ID = ...
  


ELSE    &&  *In case the process doesn't exist.[START]
  llReturn = .F.
  
ENDIF    && End of IF SEEK(PADR(lcProgName , 10) + PADR(lcEvent , 10))

*-- Restore the old alias
SELECT (lnOldAlias)

RETURN (llReturn)

*!*************************************************************
*! Name : gpAdStyWar
*! Auth : Yasser Mohammed Aly (YMA).
*! Date : 05/03/94.
*!*************************************************************
*! Synopsis : Add a new record to the StyDye file.
*!*************************************************************
*! Passed :
*!        Parameters : 
*!          lcPStyle : The style.   
*!          lcPColor : The color.
*!          lcPDyelot: The Dyelot.
*!          lcPWare  : The Warehouse.
*!        Files      : The StyDye File should be opened.
*!                     The WareHouse File should be opened.
*!*************************************************************
*! Returned : 
*!        Files      : The StyDye File after appending the new record.
*!*************************************************************
*! Example :
*!        DO gpAdStyWar WITH lcStyle,lcColor,SPACE(10),lcWareCode
*!*************************************************************
PROCEDURE gpAdStyWar

PARAMETERS lcPStyle, lcPDyelot, lcPWare
PRIVATE lcDesc, lcAlias, lnCost , lcDiscCods


lcAlias = ALIAS()

*-- KHM 09/30/2004 Open the style file if it not open before [Begin]
PRIVATE llOpnStyFil
llOpnStyFil = .F.
IF !USED('STYLE')
  llOpnStyFil = .T.
  USE (oAriaApplication.DataDir+'STYLE') IN 0 ORDER TAG STYLE SHARED
ENDIF 
*-- KHM 09/30/2004 [End]

SELECT STYLE
IF SEEK (lcPStyle)
  lcDesc = Desc
  lnCost = Ave_Cost 
  lcDiscCods  = cDiscCode
  *!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [Start]
  lcGlCode = Link_Code
  *!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [Start]
ELSE
  lcDesc = SPACE(20)
  lnCost = 0 
  lcDiscCods  = cDiscCode  
  *!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [Start]
  lcGlCode = ""
  *!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [Start]
ENDIF

STORE .F. TO llSTYDYE,llSTYINVJL
IF !USED('STYDYE')
  llSTYDYE   = .T.
  USE (oAriaApplication.DataDir+'STYDYE') IN 0 ORDER TAG STYDYE SHARED
ENDIF
IF !USED('STYINVJL')
  llSTYINVJL = .T.
  USE (oAriaApplication.DataDir+'STYINVJL') IN 0 ORDER TAG STYINVJL SHARED
ENDIF
IF !USED('WareHous')
USE (oAriaApplication.DataDir+'WareHous') IN 0 ORDER TAG WareHous SHARED
ENDIF

SELECT STYDYE
SET RELATION TO
SET RELATION TO style+cwarecode INTO STYINVJL ADDITIVE

SELECT STYLE
SET RELATION TO
SET RELATION TO style INTO STYDYE ADDITIVE

SELECT WareHous
*!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [Start]
*lcGlCode = IIF(SEEK(lcPWare),GL_LINK,'DEFDEF')
lcGlCode = IIF(EMPTY(lcGlCode),'DEFDEF',lcGlCode)
*!B038241,1 AKA Update the GLLink Code with DEFDEF with the default Style Link Code [End]

SELECT StyDye
APPEND BLANK
REPLACE Style      WITH lcPStyle  ,;
        Desc       WITH lcDesc    ,;
        cDiscCode  WITH lcDiscCods,;
        Dyelot     WITH lcPDyelot ,;
        cWareCode  WITH lcPWare   ,;
        Ave_Cost   WITH IIF(EMPTY(Dyelot),lnCost,0) ,;
        GL_Link    WITH lcGlCode
=gfAdd_Info('STYDYE')

*C200171 TMI [Start] Gen Upcs in EDICATGD
*-- Run if EDI installed
IF ASCAN(oAriaApplication.laEvntTrig,PADR("GNUPCWH",10)) <> 0
  IF OCCURS('NC',oAriaApplication.CompanyInstalledModules)<>0
    lcWhCode   = lcPWare
    lcSty      = lcPStyle
    llFrmAdWre = .T.
    =gfDoTriger('ICSTYLE','GNUPCWH   ')
  ENDIF
ENDIF
*C200171 TMI [End  ] Gen Upcs in EDICATGD
IF !EOF('STYDYE') .AND. EOF('STYINVJL')
  SELECT STYDYE
  REPLACE REST WHILE STYLE = STYLE.STYLE ;
          AVE_COST WITH IIF(EMPTY(Dyelot),STYLE.AVE_COST,0)
ENDIF                   
SELECT STYDYE
SET RELATION TO
SELE STYLE
SET RELATION TO

*-- Close files
IF llSTYDYE
  USE IN STYDYE
ENDIF
IF llSTYINVJL
  USE IN STYINVJL
ENDIF
*KHM 09/30/2004 
IF llOpnStyFil
  USE IN Style
ENDIF
*KHM 09/30/2004 
IF !EMPTY(lcAlias)
  SELECT (lcAlias)
ENDIF
RETURN

*:******************************************************************
*! Function  : gfDispSpack
*! Developer : Wael Ali Mohamed
*! Date      : 01/26/2011
*! DESC      : function to display All installed tracking entries that was 
*:******************************************************************
*! Calls     : 
*!             Procedures : ....
*!             Functions  : ....
*!*************************************************************
*! Passed Parameters  : None
*!*************************************************************
*! Returns            : ............
*!*************************************************************
*! Example   : =gfDispSpack()
*!*************************************************************
*! B609510,1 WAM 01/26/2011 Display System updates [T20110109.0001]
*!*************************************************************
Function gfDispSpac

SELECT PADR(IIF(sydattach.centrytype='C',"Custom","System"),10) AS cType, sydattach.crelease ,sydattach.csrvpack,sydattach.cbuild,sydattach.centrytype,sydattach.centryid,sydexes.ticket,sydexes.ctrksdsc,;
sydexes.dgendate, sydexes.dinstdate,sydattach.cname,sydattach.ckey,sydattach.ctag ;
FROM (oAriaApplication.SysPath+"SYDATTACH") INNER JOIN (oAriaApplication.SysPath+"SYDEXES") ;
ON sydattach.crelease+sydattach.csrvpack+sydattach.cbuild+sydattach.centrytype+sydattach.centryid =  sydexeS.crelease+sydexes.csrvpack+sydexes.cbuild+sydexes.centrytype+sydexes.ctrackno ;
WHERE SYDEXES.cAdd_ver = 'EDI' ;
UNION ;
(SELECT "Temporary " AS cType, clients_apps.crelease ,clients_apps.csrvpack,SPACE(3) AS cbuild,clients_apps.centrytype,clients_apps.centryid,clients_apps.Ticket,clients_apps.ctrksdsc,;
TTOD(dgendate) AS dgendate,TTOD(dinstdate) AS dinstdate,clients_apps.cname,clients_apps.ckey,clients_apps.ctag ;
FROM (oAriaApplication.SysPath+"CLIENTS_APPS") WHERE clients_apps.cAdd_ver = 'EDI'  ) ;
ORDER BY  clients_apps.crelease,clients_apps.csrvpack,cbuild,clients_apps.centrytype,clients_apps.centryid INTO CURSOR SysUpdates

SELECT SysUpdates
lcBrFields =[crelease:H="Release#",csrvpack:H="Service Pack#",cbuild:H="Build#",centrytype:H="Type",centryid:H="Entry ID",ticket:H="Ticket#",ctrksdsc:H="Description",]
lcBrFields =lcBrFields +[dgendate:H="Generate Date", dinstdate:H="Install Date",cname:H="File name",ckey:H="Key",ctag:H="Tag Name",cType:H="Update Type"] 

=gfBrowse(lcBrFields,"System Updates","SysUpdates",.F.,.F.,'',.T.)

USE IN 'SysUpdates'
USE IN 'SYDATTACH'
USE IN 'SYDEXES'
USE IN 'CLIENTS_APPS'

