*:******************************************************************************************************
*: Program desc. : Main Program.
*:*******************************************************************************************************
*B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.
*:*******************************************************************************************************
*E303418,1 RAS 09/12/2013 update EDI class to search for full network inbox file name [T20130910.0017]       
*********************************************************************************************************
PARAMETERS lcFileName, txt_comp_path, txtOutgoing,txt_comp_name,tcIncomingFile,tcHistoryPath,tcAriaPath

SET SAFETY OFF
SET DELE ON
SET EXCLUSIVE OFF
SET TALK OFF
SET STATUS BAR OFF
SET SYSMENU OFF
SET HOURS TO 24
SET DATE YMD

*Example
*D:\EDI3\archive.EXE  "EXPOUT.EDI" "D:\EDI3\DBFS\99" "D:\EDI3\EDI\OutBox" "99" "EXPIN.EDI" "D:\EDI3\FTP_HISTORY" "D:\EDI3"

*MESSAGEBOX("lcFileName"+lcFileName)
*MESSAGEBOX("txt_comp_path"+txt_comp_path)
*MESSAGEBOX("txtOutgoing"+txtOutgoing)
*MESSAGEBOX("txt_comp_name"+txt_comp_name)

STORE '' TO lcIncomingFile,lcHistoryPath,lcAriaPath

IF TYPE('tcIncomingFile') = "C" AND !EMPTY(tcIncomingFile)
  lcIncomingFile = tcIncomingFile
ELSE
  RETURN
ENDIF

IF TYPE('tcHistoryPath') = "C" AND !EMPTY(tcHistoryPath)
  lcHistoryPath = ADDBS(ALLTRIM(tcHistoryPath))
ELSE
  RETURN
ENDIF

IF TYPE('tcAriaPath') = "C" AND !EMPTY(tcAriaPath)
  lcAriaPath = ADDBS(ALLTRIM(tcAriaPath))
ELSE
  RETURN
ENDIF


*AHS - Creating IN and OUT files in FTP_HISTORY folder on Aria4
IF !DIRECTORY(lcHistoryPath+'\IN')
  MD (lcHistoryPath+'\IN')
ENDIF

IF !DIRECTORY(lcHistoryPath+'\OUT')
  MD (lcHistoryPath+'\OUT')
ENDIF
*AHS - Creating IN and OUT files in FTP_HISTORY folder on Aria4

lcEDILIBHD = ADDBS(ALLTRIM(txt_comp_path))+'edilibhd'
IF FILE(lcEDILIBHD+'.dbf')
  IF !USED('edilibhd')
    lcEDILIBHD = ADDBS(ALLTRIM(txt_comp_path))+'edilibhd'
    USE &lcEDILIBHD. SHARED IN 0 ORDER FILEPATH
    SELECT EDILIBHD
  ELSE
    SELECT EDILIBHD
    SET ORDER TO FILEPATH
  ENDIF

  IF TYPE("lcFileName") = "C" .AND. !EMPTY(lcFileName)
    LOCAL lcOutFileNamePath , lcOutFileCode , lcDistFile

    lcOutFileNamePath = ADDBS(ALLTRIM(txtOutgoing))+lcFileName

    * HES 07/14/2011
    ADIR(laArrOfFiles,lcOutFileNamePath)
    IF TYPE('laArrOfFiles') <> 'U' AND ALEN(laArrOfFiles,1) > 0
      FOR lnx = 1 TO ALEN(laArrOfFiles,1)
        lcFileName = laArrOfFiles(lnx,1)
        lcOutFileNamePath = ADDBS(ALLTRIM(txtOutgoing))+lcFileName
        * HES 07/14/2011

        * HES 08\03\2011
        *!*	        IF FILE(lcOutFileNamePath) .AND.;
        *!*	            SEEK("S" + PADR("OUTBOX\" , 60) + UPPER(PADR(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")
        IF FILE(lcOutFileNamePath) OR ;
            SEEK("S" + PADR("OUTBOX\" , 60) + UPPER(PADR(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")

          IF SEEK("S" + PADR("OUTBOX\" , 60) + UPPER(PADR(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")
            lcOutFileCode = EDILIBHD.cFileCode
            REPLACE cEDIFilNam WITH ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName),;
              cFilePath  WITH ALLTRIM(cFilePath) + "ARCHIVE\" IN EDILIBHD

            lcDistFile = ADDBS(ALLTRIM(txtOutgoing)) + "ARCHIVE\" +;
              ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName)
          ELSE 
            lcOutFileCode = (SUBSTR(SYS(2015),4))
            lcDistFile = ADDBS(ALLTRIM(txtOutgoing)) + "ARCHIVE\" +;
              ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName)            
          ENDIF
          
*!*	          lcOutFileCode = EDILIBHD.cFileCode
*!*	          REPLACE cEDIFilNam WITH ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName),;
*!*	            cFilePath  WITH ALLTRIM(cFilePath) + "ARCHIVE\" IN EDILIBHD

*!*	          lcDistFile = ADDBS(ALLTRIM(txtOutgoing)) + "ARCHIVE\" +;
*!*	            ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName)
          * HES 08\03\2011
          
          COPY FILE &lcOutFileNamePath. TO &lcDistFile.

        ENDIF
        *AHS - Copying the EDI file from EDI\outbox to FTP_HISTORY\OUT
        IF FILE(lcOutFileNamePath)
          lctt=DTOS(DATE())+ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+ALLTRIM(STR(SEC(DATETIME()) ))
          lctt =ADDBS(lcHistoryPath+'OUT')+lctt
          MD (lctt)
          lchistory_FILES  = lctt+'\*.*'
          COPY FILE &lcOutFileNamePath. TO (lchistory_FILES )
          *COPY FILE &lcOutFileNamePath. TO (lcHistoryPath+'\OUT')
          DELETE FILE &lcOutFileNamePath.
        ENDIF
        *AHS - Copying the EDI file from EDI\outbox to FTP_HISTORY\OUT

        * HES 07/14/2011
      ENDFOR
    ENDIF
    * HES 07/14/2011

  ENDIF
ENDIF



*AutoRename incoming raw files
=AutoRename()

***************************************************
*
*       AutoRename
*
***************************************************
*!*	FUNCTION AutoRename

*!*	  lccurrPath = lcAriaPath
*!*	  lcInBoxPath = ADDBS(ALLTRIM(lccurrPath)) +'EDI\INBOX\'
*!*	  *lcHistoryPath = Addbs(Alltrim(lccurrPath)) + "FTP_HISTORY\"

*!*	  IF !DIRECTORY(lcHistoryPath)
*!*	    MD (lcHistoryPath)
*!*	  ENDIF
*!*	  CD (lcHistoryPath)
*!*	  lnInFile = ADIR(lainFile,'*.*')

*!*	  IF !EMPTY(lcFileName) AND lnInFile >0
*!*	    IF  !EMPTY(ALLTRIM(lcHistoryPath))
*!*	      lchistory_IN_DIR  = ADDBS(UPPER(ALLTRIM(lcHistoryPath)))+'IN'
*!*	      IF !DIRECTORY(lchistory_IN_DIR)
*!*	        MD (lchistory_IN_DIR  )
*!*	      ENDIF
*!*	      *lctt=DTOS(DATE())+ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+ALLTRIM(STR(SEC(DATETIME()),3))
*!*	      lctt=DTOS(DATE())+ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+SUBSTR(ALLTRIM(STR(SEC(DATETIME()),2)),1,1)
*!*	      lctt=ADDBS(lchistory_IN_DIR)+lctt
*!*	      MD (lctt)

*!*	      lchistory_FILES  = lctt+'\*.*'
*!*	      IF EMPTY(lcIncomingFile)
*!*	        *lcNewFileName = UPPER(LEFT(ALLTRIM(lcFileName),3))+'IN' + ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+ALLTRIM(STR(SEC(DATETIME()),3))
*!*	        lcNewFileName = UPPER(LEFT(ALLTRIM(lcFileName),3))+'IN' + ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+SUBSTR(ALLTRIM(STR(SEC(DATETIME()),2)),1,1)
*!*	      ELSE
*!*	        *lcNewFileName = UPPER(ALLTRIM(SUBSTR(lcIncomingFile,1,LEN(lcIncomingFile)-4))) + ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+ALLTRIM(STR(SEC(DATETIME()),3))
*!*	        lcNewFileName = UPPER(ALLTRIM(SUBSTR(lcIncomingFile,1,LEN(lcIncomingFile)-4))) + ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+SUBSTR(ALLTRIM(STR(SEC(DATETIME()),2)),1,1)
*!*	      ENDIF

*!*	      lcNewFilePath= ADDBS(UPPER(lcInBoxPath)) + lcNewFileName

*!*	      FOR i= 1 TO lnINFile
*!*	        COPY FILE (ALLTRIM(lcHistoryPath)+ALLTRIM(laInFile(i,1))) TO (lchistory_FILES)
*!*	        RENAME (ALLTRIM(lcHistoryPath)+ALLTRIM(laInFile(i,1))+'.*') TO (UPPER(lcNewFileName+ALLTRIM(STR(i))+'.EDI'))
*!*	        COPY FILE (ALLTRIM(lcHistoryPath)+ALLTRIM(lcNewFileName+ALLTRIM(STR(i))+'.EDI')) TO (UPPER(lcNewFilePath+ALLTRIM(STR(i))+'.EDI'))
*!*	        DELETE FILE (ALLTRIM(lcHistoryPath)+ALLTRIM(lcNewFileName+ALLTRIM(STR(i))+'.EDI'))
*!*	      ENDFOR

*!*	    ENDIF
*!*	  ENDIF

*!*	ENDFUNC


**********************************************************
*
*       AutoRename
*
**********************************************************
FUNCTION AutoRename



  *!*	_screen.visible = .T.
  *!*	debug
  *!*	suspend


  lccurrPath = lcAriaPath
  lcInBoxPath = ADDBS(ALLTRIM(lccurrPath)) +'EDI\INBOX\'

  *B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany [Begin]
  *&& Get the number of files downloaded
  *LN  = 0
  *CD (lcHistoryPath)
  *LN = Adir(ARR,'*.*')
  *B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany [End]

  LOCAL lc_FILE_Name , lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID
  STORE '' TO  lc_FILE_Name ,lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID,lcTran_Type
  llGXS_passed = .F.



  CD (lcInBoxPath)
  lctmp = 'A'+SYS(2015)
  MD (lctmp)

  *AHS
  * HES
  *!*	txt_sys_path = lcAriaPath+'SYSFILES'
  txt_sys_path = STRTRAN(UPPER(lcAriaPath),"ARIA3EDI","Aria4XP")+'SYSFILES'
  * HES
  *AHS
  *B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.
  && Get the number of files downloaded
  LN  = 0
  CD (lcHistoryPath)
  LN = ADIR(ARR,'*.*')
  *B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.

  && Get their local names from EDINET files
  IF LN > 0
    new_linner = 0
    FOR linner = 1 TO LN
      IF .T. && this.gxs_file(ARR(linner,1))
        llGXS_passed = .T.
        new_linner = new_linner + 1
        *AHS
        * Dimension This.RCV_fls_arr(new_linner ,2)
        DIMENSION RCV_fls_arr(new_linner,2)
        * This.RCV_fls_arr(new_linner ,1) =ARR(linner,1)
        RCV_fls_arr(new_linner,1) = ARR(linner,1)
        *AHS

        l_file_hand = FOPEN(ARR(linner,1),12)

        lcISA_LINE = FGETS(l_file_hand)
        lcISA_SEP = SUBSTR(lcISA_LINE,4,1)

        lcISA_Sender_QUALIfier = SUBSTR(lcISA_LINE,AT(lcISA_SEP,lcISA_LINE,5)+1,AT(lcISA_SEP,lcISA_LINE,6)-AT(lcISA_SEP,lcISA_LINE,5)-1)
        lcISA_Sender_ID = SUBSTR(lcISA_LINE,AT(lcISA_SEP,lcISA_LINE,6)+1,AT(lcISA_SEP,lcISA_LINE,7)-AT(lcISA_SEP,lcISA_LINE,6)-1)

        lcISA_Recv_QUALIfier = SUBSTR(lcISA_LINE,AT(lcISA_SEP,lcISA_LINE,7)+1,AT(lcISA_SEP,lcISA_LINE,8)-AT(lcISA_SEP,lcISA_LINE,7)-1)
        lcISA_Recv_ID= SUBSTR(lcISA_LINE,AT(lcISA_SEP,lcISA_LINE,8)+1,AT(lcISA_SEP,lcISA_LINE,9)-AT(lcISA_SEP,lcISA_LINE,8)-1)

        lcGS_LINE = FGETS(l_file_hand)
        lcTran_Type =  SUBSTR(lcGS_LINE,4,2)
        = FCLOSE(l_file_hand)

        *AHS
        *lc_FILE_Name =This.get_aria_download_name(lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID)
        lc_FILE_Name =get_aria_download_name(lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID)
        * This.RCV_fls_arr(new_linner ,2) =lc_FILE_Name
        RCV_fls_arr(new_linner,2) = lc_FILE_Name
        *AHS
        *Balance

        *=This.add_balance_record(ARR(linner,1), ARR(linner,2), 1,0.1,'','R') &&DOWNLOAD
      ENDIF
    ENDFOR
    IF EMPTY(ALLTRIM(lcHistoryPath)) AND !EMPTY(ALLTRIM(txt_sys_path))
      lcHistoryPath = ADDBS(ALLTRIM(txt_sys_path))
      lcHistoryPath = SUBSTR(lcHistoryPath,1,RAT('\', lcHistoryPath,2))
    ENDIF
    && Save the downloaded files to history folder _in by date time hour min sec
    IF  !EMPTY(ALLTRIM(lcHistoryPath))
      lchistory_IN_DIR  = ADDBS(UPPER(ALLTRIM(lcHistoryPath)))+'IN'
      IF !DIRECTORY(lchistory_IN_DIR)
        MD (lchistory_IN_DIR  )
      ENDIF

      lctt=DTOS(DATE())+ALLTRIM(STR(HOUR(DATETIME()))) + ALLTRIM(STR(MINUTE(DATETIME())))+ALLTRIM(STR(SEC(DATETIME()) ))
      lctt=ADDBS(lchistory_IN_DIR  )+lctt
      MD (lctt)
      lchistory_FILES  = lctt+'\*.*'
      COPY FILE (lcHistoryPath+'*.*') TO (lchistory_FILES )
    ENDIF
  ENDIF &&ln > 0

  CD (lcHistoryPath)

  IF llGXS_passed
    LN = ALEN(RCV_fls_arr,1)
  ENDIF
  IF LN > 0 AND llGXS_passed
    FOR linner = 1 TO LN
      && Get the last file seq in the inbox file
      CD (lcInBoxPath)
      LN1 = 0
      *LN1 = Adir(ARR1,Juststem(RCV_fls_arr(linner,2))+'*.*')
      LN1 = ADIR(ARR1,'*.*')

      *    CD (lcInBoxPath)
      IF LN1 > 0
        lnstart = 0
        FOR i = 1 TO LN1
          lcstart = JUSTSTEM( ARR1(i,1))
          IF AT('_',lcstart) > 0
            lcstart = SUBSTR(lcstart,RAT('_',lcstart)+1,10)
          ELSE
            lcstart=''
          ENDIF
          lnstart = IIF(VAL(lcstart)>lnstart,VAL(lcstart),lnstart)
        ENDFOR

        lnstart = lnstart + 1
        CD (lctmp)
        lctt_name = UPPER(JUSTSTEM(RCV_fls_arr(linner,2))+'_'+ALLTRIM(STR(lnstart ))+'.'+JUSTEXT(RCV_fls_arr(linner,2)))
        *Rename (This.RCV_fls_arr(linner,1)) To (lctt_name)
        COPY FILE (lcHistoryPath + RCV_fls_arr(linner,1)) TO (lctt_name)
        DELETE  FILE (lcHistoryPath + RCV_fls_arr(linner,1))

        COPY FILE (lctt_name)  TO (lcInBoxPath+'*.*')
        DELETE FILE (lctt_name)
        *CD (lcHistoryPath)

      ELSE
        CD (lctmp)
        *E303418,1 RAS 09/12/2013 update EDI class to search for full network inbox file name [begin]       
*!*	        lctt_name = RCV_fls_arr(linner,2)
        lctt_name = UPPER(JUSTSTEM(RCV_fls_arr(linner,2))+'_1'+'.'+JUSTEXT(RCV_fls_arr(linner,2)))
        *E303418,1 RAS 09/12/2013 update EDI class to search for full network inbox file name [end]        
        COPY FILE (lcHistoryPath + RCV_fls_arr(linner,1)) TO (lctt_name)
        DELETE FILE (lcHistoryPath + RCV_fls_arr(linner,1))

        COPY FILE (lctt_name)  TO (lcInBoxPath+'*.*')
        DELETE FILE (lctt_name)
        CD (lcHistoryPath)
      ENDIF
    ENDFOR
  ENDIF

  CD (lcInBoxPath+lctmp)
  IF LN > 0
    *!* COPY FILE *.* TO ..\*.*
    DELETE FILE *.*
    CD ..
    RD (lctmp)
    CD (lccurrPath)
  ELSE
    CD ..
    RD (lctmp)
    CD (lccurrPath)
  ENDIF


  ***********************************************************
  *
  *      get_aria_download_name
  *
  ***********************************************************
FUNCTION get_aria_download_name

  LPARAMETERS lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID



  *!*	_screen.visible = .T.
  *!*	debug
  *!*	suspend

  lcISA_Sender_QUALIfier = ALLTRIM(lcISA_Sender_QUALIfier)
  lcISA_Sender_ID = ALLTRIM(lcISA_Sender_ID)
  lcISA_Recv_QUALIfier =ALLTRIM(lcISA_Recv_QUALIfier)
  lcISA_Recv_ID = ALLTRIM(lcISA_Recv_ID)

  LOCAL lcFile_Name,lcSyccomp,lcEDIPH ,lcEDIPD,lcEDIACPRT

  STORE '' TO lcFile_Name,lcSyccomp,lcEDIPH ,lcEDIACPRT

  IF !EMPTY(ALLTRIM(txt_sys_path))
    lcSyccomp = ADDBS(ALLTRIM(txt_sys_path))+'SYCCOMP'

    IF FILE(lcSyccomp+'.dbf')

      IF !USED('Syccomp')
        USE &lcSyccomp. SHARED IN 0
      ENDIF &&!USED('lcSyccomp')

      SELECT SYCCOMP
      SET ORDER TO CCOMP_ID
      SCAN
        IF EMPTY(lcFile_Name)
          lcEDIPH    = ADDBS(ALLTRIM(SYCCOMP.ccom_ddir))+'EDIPH'
          lcEDIPD    = ADDBS(ALLTRIM(SYCCOMP.ccom_ddir))+'EDIPD'
          lcEDIACPRT = ADDBS(ALLTRIM(SYCCOMP.ccom_ddir))+'EDIACPRT'
          lcEDINET    = ADDBS(ALLTRIM(SYCCOMP.ccom_ddir))+'EDINET'

          IF FILE(lcEDIPH+'.dbf')
            IF !USED('ediph')
              USE &lcEDIPH. SHARED IN 0 ORDER PARTNER  && SET ORDER TO PARTNER   && CPARTCODE+CNETWORK+CVERSION
            ENDIF
            SET ORDER TO PARTNER IN EDIPH

            IF !USED('ediNET')
              USE &lcEDINET. SHARED IN 0 ORDER NETWORKID   &&SET ORDER TO PARTNER   && CPARTCODE+CNETWORK+CVERSION
            ENDIF
            SET ORDER TO NETWORKID IN ediNET && CNETWORK

            IF !USED('edipd')
              USE &lcEDIPD. SHARED IN 0 ORDER PARTTRANS &&PARTTRANS   && CPARTCODE+CEDITRNTYP+CTRANACTV+CPARTID
            ENDIF
            SET ORDER TO PARTTRANS IN edipd

            IF !USED('ediACPRT')
              USE &lcEDIACPRT. SHARED IN 0 ORDER PARTNER &&PARTTRANS   && CPARTCODE+CEDITRNTYP+CTRANACTV+CPARTID
            ENDIF
            SET ORDER TO PARTNER IN  ediACPRT && CPARTCODE

            SELECT edipd

            SELECT DIST ediNET.cinfile AS cnetwork;
              FROM edipd,EDIPH,ediACPRT,ediNET ;
              WHERE edipd.cpartcode == EDIPH.cpartcode    AND ;
              edipd.cpartcode == ediACPRT.cpartcode AND ;
              EDIPH.cnetwork  ==  ediNET.cnetwork  AND;
              ediACPRT.cCmpISAQl == PADR(lcISA_Recv_QUALIfier, 2) AND ;
              ediACPRT.cCmpISAId == PADR(lcISA_Recv_ID, 15) AND ;
              edipd.cpartqual    == PADR(lcISA_Sender_QUALIfier, 2) AND ;
              edipd.cPartID      == PADR(lcISA_Sender_ID, 15)  ;
              INTO CURSOR CurrAccount

            IF _TALLY => 1
              SELECT CurrAccount
              GO TOP
              IF !EMPTY(ALLTRIM(CurrAccount.cnetwork))
                lcFile_Name =  ALLTRIM(CurrAccount.cnetwork)
                EXIT
              ENDIF
            ENDIF

            IF USED('ediph')
              USE IN EDIPH
            ENDIF

            IF USED('edipd')
              USE IN edipd
            ENDIF
            IF USED('ediacprt')
              USE IN ediACPRT
            ENDIF
            IF USED('ediNET')
              USE IN ediNET
            ENDIF


          ENDIF
          SELECT SYCCOMP
        ENDIF  &&EMPTY(lcFile_Name)
      ENDSCAN &&SycComp
    ENDIF &&FILE(lcSyccomp+'.dbf')

  ENDIF &&!EMPTY(ALLTRIM(THIS.txt_sys_path))


  * HES

  IF EMPTY(lcFile_Name)
    lcFile_Name = 'IDs Mismatch - ' + lcISA_Sender_QUALIfier + '-' +lcISA_Sender_ID +'.EDI'
    *!*	IF !EMPTY(ALLTRIM(txt_sys_path)) AND EMPTY(lcFile_Name)
    *!*	 && Get any network name from any edinet file at any comp
    *!*	 && as we did not find matched one [ as specs]

    *!*	 lcSyccomp = ADDBS(ALLTRIM(txt_sys_path))+'SYCCOMP'

    *!*	 IF FILE(lcSyccomp+'.dbf')

    *!*	  IF !USED('Syccomp')
    *!*	   USE &lcSyccomp. SHARED IN 0
    *!*	  ENDIF &&!USED('lcSyccomp')

    *!*	  SELECT SYCCOMP
    *!*	  SCAN
    *!*	   IF EMPTY(lcFile_Name)
    *!*	    lcEDINET    = ADDBS(ALLTRIM(SYCCOMP.ccom_ddir))+'EDINET'

    *!*	    IF !USED('ediNET')
    *!*	     USE &lcEDINET. SHARED IN 0 ORDER NETWORKID   &&SET ORDER TO PARTNER   && CPARTCODE+CNETWORK+CVERSION
    *!*	    ENDIF
    *!*	    SET ORDER TO NETWORKID IN ediNET && CNETWORK

    *!*	    SELECT ediNET
    *!*	    GO TOP
    *!*	    IF !EMPTY(ALLTRIM(ediNET.cinfile))
    *!*	     lcFile_Name =  ALLTRIM(ediNET.cinfile)
    *!*	     EXIT
    *!*	    ENDIF
    *!*	   ENDIF
    *!*	   IF USED('ediNET')
    *!*	    USE IN ediNET
    *!*	   ENDIF

    *!*	   SELECT SYCCOMP
    *!*	  ENDSCAN &&SycComp
    *!*	 ENDIF &&FILE(lcSyccomp+'.dbf')

    *!*	ENDIF
  ENDIF

  *!*	IF EMPTY(lcFile_Name)&& Initlize the file path name
  *!*	  lcFile_Name = 'IN_'+ALLTRIM(lcISA_Sender_ID)+'.EDI'
  *!*	ENDIF
  * HES

  RETURN lcFile_Name

