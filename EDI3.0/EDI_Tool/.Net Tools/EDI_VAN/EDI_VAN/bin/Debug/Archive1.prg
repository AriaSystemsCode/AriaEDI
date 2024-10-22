*:******************************************************************************************************
*: Program desc. : Main Program.
*:*******************************************************************************************************
*B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.
*E303418,1 RAS 09/12/2013 update EDI class to search for full network inbox file name [T20130910.0017]
*RAS 09-19-2013 add parameter decide to delete output file after copy or not [T20130821.0012]
*E303596,1 AEG 08/19/2015 upgrade 850 transaction for send  [T20150130.0005]
*E303823,1 DERBY 5/18/2017 Handle IDMissMatch more efficent.[T20170516.0013]
*B611358,1 MSH - 07/13/2017 - Update Arichive Program To Check Files With No EDI Extension [T20170710.0010]
*E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [T20170710.0010]
*B611480,1 Derby - Error when running the VAN [T20171107.0024]
*B612271,1 Hassan.I Add error log to try and catch [T20201026.0001]
*:*******************************************************************************************************

*RAS 09-19-2013 add parameter decide to delete output file after copy or not [Begin]
*!*  PARAMETERS lcFileName, txt_comp_path, txtOutgoing,txt_comp_name,tcIncomingFile,tcHistoryPath,tcAriaPath
Parameters lcFileName, txt_comp_path, txtOutgoing,txt_comp_name,tcIncomingFile,tcHistoryPath,tcAriaPath,LLNoDelete,lcLogFile, lcTitle
*RAS 09-19-2013 add parameter decide to delete output file after copy or not [end]

_SCREEN.Visible = .T.
DEBUG

SET STEP ON 

Set Safety Off
Set Dele On
Set Exclusive Off
Set Talk Off
Set Status Bar Off
Set Sysmenu Off
Set Hours To 24
Set Date YMD

If Type('lcLogFile') != 'C'
  lcLogFile = 'Archive_Errors_Log.TXT'
Endif
If Type('lcLogFile') != 'C'
  lcTitle = "Aria Systems - Archive APP. - Errors"
Endif

*Example
*D:\EDI3\archive.EXE  "EXPOUT.EDI" "D:\EDI3\DBFS\99" "D:\EDI3\EDI\OutBox" "99" "EXPIN.EDI" "D:\EDI3\FTP_HISTORY" "D:\EDI3"

*!*	txtOutgoing = "X:\ARIA3EDI\EDI\OUTBOX"
*!*	lcFileName = "invout.edi"
*!*	txt_comp_path = "X:\ARIA4XP\DBFs\01"
*!*	txtOutgoing = "X:\ARIA3EDI\EDI\OUTBOX"
*!*	txt_comp_name = "01"
*!*	tcIncomingFile = "INVIN.EDI"
*!*	tcHistoryPath = "X:\ARIA3EDI\FTP_HISTORY"
*!*	tcAriaPath = "X:\ARIA3EDI"

Strtofile(Ttoc(Datetime()) + '| Starting Archive '+ Chr(13)+Chr(10), 'Archive_Errors_Log.TXT', 1)
  
Store '' To lcIncomingFile,lcHistoryPath,lcAriaPath
If Type('tcIncomingFile') = "C" And !Empty(tcIncomingFile)
  lcIncomingFile = tcIncomingFile
Else
  Return
Endif

If Type('tcHistoryPath') = "C" And !Empty(tcHistoryPath)
  lcHistoryPath = Addbs(Alltrim(tcHistoryPath))
Else
  Return
Endif

If Type('tcAriaPath') = "C" And !Empty(tcAriaPath)
  lcAriaPath = Addbs(Alltrim(tcAriaPath))
Else
  Return
Endif

*AHS - Creating IN and OUT files in FTP_HISTORY folder on Aria4
If !Directory(lcHistoryPath+'\IN')
  Md (lcHistoryPath+'\IN')
Endif

If !Directory(lcHistoryPath+'\OUT')
  Md (lcHistoryPath+'\OUT')
Endif
*AHS - Creating IN and OUT files in FTP_HISTORY folder on Aria4
lcEDILIBHD = Addbs(Alltrim(txt_comp_path))+'edilibhd'

*E303596,1 AEG 08/19/2015 upgrade send 850 transaction [begin]
lcEDIACPRT = Addbs(Alltrim(txt_comp_path))+'EDIACPRT'
lcEDIPH = Addbs(Alltrim(txt_comp_path))+'EDIPH'
lcEDINET = Addbs(Alltrim(txt_comp_path))+'edinet'

If File(lcEDIACPRT+'.dbf')
  If !Used('EDIACPRT')
    lcEDIACPRT = Addbs(Alltrim(txt_comp_path))+'EDIACPRT'
    Use &lcEDIACPRT. Shared In 0
    Select EDIACPRT
  Else
    Select EDIACPRT
  Endif
Endif

If File(lcEDIPH+'.dbf')
  If !Used('EDIPH')
    lcEDIPH = Addbs(Alltrim(txt_comp_path))+'EDIPH'
    Use &lcEDIPH. Shared In 0
  Endif
Endif

If File(lcEDINET+'.dbf')
  If !Used('edinet')
    lcEDINET = Addbs(Alltrim(txt_comp_path))+'edinet'
    Use &lcEDINET. Shared In 0
  Endif
Endif

Declare laINTERPART[1]
Goto Top
lncount=1
Scan Rest For lInterComp=.T.
  If Seek(cpartcode,'EDIPH','PARTNER')
    If Seek(EDIPH.cnetwork,'edinet','NETWORKID')
      Dimension laINTERPART(lncount)
      laINTERPART[lncount]=Upper(Alltrim(edinet.coutfile))
      lncount=lncount+1
    Endif
  Endif
Endscan

*E303596,1 AEG 08/19/2015 upgrade send 850 transaction [End]
If File(lcEDILIBHD+'.dbf')
  If !Used('edilibhd')
    lcEDILIBHD = Addbs(Alltrim(txt_comp_path))+'edilibhd'
    Use &lcEDILIBHD. Shared In 0 Order FILEPATH
    Select EDILIBHD
  Else
    Select EDILIBHD
    Set Order To FILEPATH
  Endif

  If Type("lcFileName") = "C" .And. !Empty(lcFileName)
    *E303596,1 AEG 08/19/2015 upgrade send 850 transaction [begin]
    *!* LOCAL lcOutFileNamePath , lcOutFileCode , lcDistFile
    Local lcOutFileNamePath , lcOutFileCode , lcDistFile ,lchistrootfile
    *E303596,1 AEG 08/19/2015 upgrade send 850 transaction [End]

    lcOutFileNamePath = Addbs(Alltrim(txtOutgoing))+lcFileName

    * HES 07/14/2011
    Adir(laArrOfFiles,lcOutFileNamePath)
    If Type('laArrOfFiles') <> 'U' And Alen(laArrOfFiles,1) > 0
      For lnx = 1 To Alen(laArrOfFiles,1)
        lcFileName = laArrOfFiles(lnx,1)
        lcOutFileNamePath = Addbs(Alltrim(txtOutgoing))+lcFileName
        * HES 07/14/2011

        * HES 08\03\2011
        *!*          IF FILE(lcOutFileNamePath) .AND.;
        *!*              SEEK("S" + PADR("OUTBOX\" , 60) + UPPER(PADR(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")
        If File(lcOutFileNamePath) Or ;
            SEEK("S" + Padr("OUTBOX\" , 60) + Upper(Padr(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")

          If Seek("S" + Padr("OUTBOX\" , 60) + Upper(Padr(lcFileName , 12)) , "EDILIBHD" , "FILEPATH")
            lcOutFileCode = EDILIBHD.cFileCode
            Replace cEDIFilNam With Alltrim(txt_comp_name) + lcOutFileCode +'.'+Justext(lcFileName),;
              cFilePath  With Alltrim(cFilePath) + "ARCHIVE\" In EDILIBHD

            lcDistFile = Addbs(Alltrim(txtOutgoing)) + "ARCHIVE\" +;
              ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+Justext(lcFileName)
          Else
            lcOutFileCode = (Substr(Sys(2015),4))
            lcDistFile = Addbs(Alltrim(txtOutgoing)) + "ARCHIVE\" +;
              ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+Justext(lcFileName)
          Endif

          *!*            lcOutFileCode = EDILIBHD.cFileCode
          *!*            REPLACE cEDIFilNam WITH ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName),;
          *!*              cFilePath  WITH ALLTRIM(cFilePath) + "ARCHIVE\" IN EDILIBHD

          *!*            lcDistFile = ADDBS(ALLTRIM(txtOutgoing)) + "ARCHIVE\" +;
          *!*              ALLTRIM(txt_comp_name) + lcOutFileCode +'.'+JUSTEXT(lcFileName)
          * HES 08\03\2011
          *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
          errorVar = ""
          Try
            Copy File &lcOutFileNamePath. To &lcDistFile.
          Catch To errorVar
            =ErrorLog(errorVar, lcLogFile, lcTitle)
          Endtry
          *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]

          *E303596,1 AEG 08/19/2015 upgrade send 850 transaction [begin]
          lchistrootfile=  lcHistoryPath+lcFileName
          If Ascan(laINTERPART,Upper(Alltrim(lcFileName)))>0
            *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
            errorVar = ""
            Try
              Copy File &lcOutFileNamePath. To &lchistrootfile.
            Catch To errorVar
              =ErrorLog(errorVar, lcLogFile, lcTitle)
            Endtry
            *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
          Endif
          *E303596,1 AEG 08/19/2015 upgrade send 850 transaction [End]

        Endif
        *AHS - Copying the EDI file from EDI\outbox to FTP_HISTORY\OUT
        If File(lcOutFileNamePath)
          lctt=Dtos(Date())+Alltrim(Str(Hour(Datetime()))) + Alltrim(Str(Minute(Datetime())))+Alltrim(Str(Sec(Datetime()) ))
          lctt =Addbs(lcHistoryPath+'OUT')+lctt
          * AEG 03/06/2017 bug related to directory allready created [BGN]
          *MD (lctt)
          If !Directory(lctt)
            Md (lctt)
          Endif
          * AEG 03/06/2017 bug related to directory allready created [END]
          lchistory_FILES  = lctt+'\*.*'
          *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
          errorVar = ""
          Try
            Copy File &lcOutFileNamePath. To (lchistory_FILES )
          Catch To errorVar
            =ErrorLog(errorVar, lcLogFile, lcTitle)
          Endtry
          *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
          *COPY FILE &lcOutFileNamePath. TO (lcHistoryPath+'\OUT')

          *RAS 09-19-2013 add parameter decide to delete output file after copy or not [begin]
          If !(Type('LLNoDelete')='C' And LLNoDelete='T')
            *RAS 09-19-2013 add parameter decide to delete output file after copy or not [end]
            *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001] [Begin]
            errorVar = ""
            Try
              Delete File &lcOutFileNamePath.
            Catch To errorVar
              =ErrorLog(errorVar, lcLogFile, lcTitle)
            Endtry
            *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
            *RAS 09-19-2013 add parameter decide to delete output file after copy or not [begin]
          Endif
          *RAS 09-19-2013 add parameter decide to delete output file after copy or not [end]

        Endif
        *AHS - Copying the EDI file from EDI\outbox to FTP_HISTORY\OUT

        * HES 07/14/2011
      Endfor
    Endif
    * HES 07/14/2011
  Endif
Endif
Strtofile(Ttoc(Datetime()) + '| Starting Auto Rename Archive '+ Chr(13)+Chr(10), 'Archive_Errors_Log.TXT', 1)
*AutoRename incoming raw files
=AutoRename()
Strtofile(Ttoc(Datetime()) + '| Ending Archive '+ Chr(13)+Chr(10), 'Archive_Errors_Log.TXT', 1)
**********************************************************
*
*       AutoRename
*
**********************************************************
Function AutoRename
lccurrPath = lcAriaPath
lcInBoxPath = Addbs(Alltrim(lccurrPath)) +'EDI\INBOX\'

Local lc_FILE_Name , lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID
Store '' To  lc_FILE_Name ,lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID,lcTran_Type
llGXS_passed = .F.

Cd (lcInBoxPath)
lctmp = 'A'+Sys(2015)
Md (lctmp)
txt_sys_path = Strtran(Upper(lcAriaPath),"ARIA3EDI","Aria4XP")+'SYSFILES'

*B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.
&& Get the number of files downloaded
LN  = 0
Cd (lcHistoryPath)
LN = Adir(ARR,'*.*')
*B609198,1 WLD 04/01/2010 T20100329.0013 Archive program can't open the file for more than one comapany.
*E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
Dimension RCV_fls_arrN(1,5)
lcSycinst = Addbs(Alltrim(txt_sys_path))+'SYCINST'
If File(lcSycinst +'.dbf')
  If !Used('SYCINST')
    Use &lcSycinst. Shared In 0
  Endif
Endif
If !Empty(Alltrim(txt_sys_path))
  Store '' To lcClient
  If File(Alltrim(txt_sys_path)+ '\Client_Setting.xml')
    Xmltocursor(Alltrim(txt_sys_path)+ '\Client_Setting.xml','ClientXml',512)
    lcClient =ClientXml.ClientID
  Endif
Endif
*E303823,1 DERBY - Handle IDMissMatch more efficent.[End]
&& Get their local names from EDINET files
If LN > 0
  new_linner = 0
  For linner = 1 To LN
    If .T. && this.gxs_file(ARR(linner,1))
      llGXS_passed = .T.
      new_linner = new_linner + 1
      *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
      *!*Dimension RCV_fls_arr(new_linner,5)
      Dimension RCV_fls_arr(new_linner,6)
      *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]

      RCV_fls_arr(new_linner,1) = ARR(linner,1)
      **B611480 Derby - Error when running the VAN [Start]
      *l_file_hand = Fopen(ARR(linner,1),12)
      l_file_hand = Fopen(ARR(linner,1))

      Alines(LaFileSegments, Filetostr(ARR(linner,1)))
      If Alen(LaFileSegments)== 1

        lcISA_LINE = Fgets(l_file_hand)
        lcISA_SEP = Substr(lcISA_LINE,4,1)
        lcISA_Sender_QUALIfier = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,5)+1,At(lcISA_SEP,lcISA_LINE,6)-At(lcISA_SEP,lcISA_LINE,5)-1)
        lcISA_Sender_ID = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,6)+1,At(lcISA_SEP,lcISA_LINE,7)-At(lcISA_SEP,lcISA_LINE,6)-1)
        lcISA_Recv_QUALIfier = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,7)+1,At(lcISA_SEP,lcISA_LINE,8)-At(lcISA_SEP,lcISA_LINE,7)-1)
        lcISA_Recv_ID= Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,8)+1,At(lcISA_SEP,lcISA_LINE,9)-At(lcISA_SEP,lcISA_LINE,8)-1)

        lnStartPos=1
        lcLineSep= Substr(Substr(lcISA_LINE ,lnStartPos),At(lcISA_SEP,Substr(lcISA_LINE ,lnStartPos),16)+2,1)

        lcGS_LINE =Substr(lcISA_LINE,At(lcLineSep ,lcISA_LINE,1)+1,At(lcLineSep ,lcISA_LINE,2)-At(lcLineSep ,lcISA_LINE,1))
        lcTran_Type =  Substr(lcGS_LINE,4,2)

        lcST_LINE  = Substr(lcISA_LINE,At(lcLineSep ,lcISA_LINE,2)+1,At(lcLineSep ,lcISA_LINE,3)-At(lcLineSep ,lcISA_LINE,2))
        lcTran_No =  Substr(lcST_LINE ,4,3)

      Else
        **B611480 Derby - Error when running the VAN [END]

        lcISA_LINE = Fgets(l_file_hand)
        lcISA_SEP = Substr(lcISA_LINE,4,1)

        lcISA_Sender_QUALIfier = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,5)+1,At(lcISA_SEP,lcISA_LINE,6)-At(lcISA_SEP,lcISA_LINE,5)-1)
        lcISA_Sender_ID = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,6)+1,At(lcISA_SEP,lcISA_LINE,7)-At(lcISA_SEP,lcISA_LINE,6)-1)

        lcISA_Recv_QUALIfier = Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,7)+1,At(lcISA_SEP,lcISA_LINE,8)-At(lcISA_SEP,lcISA_LINE,7)-1)
        lcISA_Recv_ID= Substr(lcISA_LINE,At(lcISA_SEP,lcISA_LINE,8)+1,At(lcISA_SEP,lcISA_LINE,9)-At(lcISA_SEP,lcISA_LINE,8)-1)

        lcGS_LINE = Fgets(l_file_hand)
        lcTran_Type =  Substr(lcGS_LINE,4,2)

        *E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
        lcST_LINE = Fgets(l_file_hand)
        lcTran_No =  Substr(lcST_LINE ,4,3)
        *E303823,1 DERBY - Handle IDMissMatch more efficent.[End]

        **B611480 Derby - Error when running the VAN [Start]
      Endif
      **B611480 Derby - Error when running the VAN [END]
      If lcTran_Type='FA' And lcISA_Sender_ID ='2128847072'
        Rename lcHistoryPath+ARR(linner,1) To lcHistoryPath+"977\"+ARR(linner,1)
        Loop
      Endif
      = Fclose(l_file_hand)
      lc_FILE_Name = get_aria_download_name(lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID)

      ** B611358,1 MSH - 13/07/2017 - Update Arichive Program To Check Files With No EDI Extension [Start]
      ** Check If File Is Not X12 EDI File
      If Empty(lc_FILE_Name) And Upper(Substr(lcISA_LINE, 1, 3)) <> "ISA" And Upper(Substr(lcGS_LINE, 1, 2)) <> "GS"
        lc_FILE_Name = lcIncomingFile
      Endif
      * Endif
      ** B611358,1 MSH - 13/07/2017 - Update Arichive Program To Check Files With No EDI Extension [End]
      RCV_fls_arr(new_linner,2) = lc_FILE_Name
    Endif
  Endfor
  *E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
  If !Empty(RCV_fls_arrN)
    =Asort(RCV_fls_arrN)
    Store '' To lcAttch
    PrvId=RCV_fls_arrN(1,1)
    For I = 1 To Alen(RCV_fls_arrN,1)
      If RCV_fls_arrN(I,1)==PrvId
        lcAttch =lcAttch +RCV_fls_arrN(I,5)+','
        If I= Alen(RCV_fls_arrN,1)
          If Messagebox(RCV_fls_arrN(I,2),1+48+512,"Aria Systems - Archive APP. - Unrecognized file downloaded!")=1
            Send_Mail(lcAttch,RCV_fls_arrN(I,3),RCV_fls_arrN(I,4))
          Endif
        Endif
      Else
        If Messagebox(RCV_fls_arrN(I-1,2),1+48+512,"Aria Systems - Archive APP. - Unrecognized file downloaded!")=1
          Send_Mail(lcAttch,RCV_fls_arrN(I-1,3),RCV_fls_arrN(I-1,4))
          lcAttch =RCV_fls_arrN(I,5)+','
          PrvId=RCV_fls_arrN(I,1)
        Else
          lcAttch =RCV_fls_arrN(I,5)+','
          PrvId=RCV_fls_arrN(I,1)
        Endif
        If I= Alen(RCV_fls_arrN,1)
          If Messagebox(RCV_fls_arrN(I,2),1+48+512,"Aria Systems - Archive APP. - Unrecognized file downloaded!")=1
            Send_Mail(lcAttch,RCV_fls_arrN(I,3),RCV_fls_arrN(I,4))
          Endif
        Endif
      Endif
    Endfor
  Endif
  *E303823,1 DERBY - Handle IDMissMatch more efficent.[End]
  If Empty(Alltrim(lcHistoryPath)) And !Empty(Alltrim(txt_sys_path))
    lcHistoryPath = Addbs(Alltrim(txt_sys_path))
    lcHistoryPath = Substr(lcHistoryPath,1,Rat('\', lcHistoryPath,2))
  Endif
Endif &&ln > 0

Cd (lcHistoryPath)

If llGXS_passed
  LN = Alen(RCV_fls_arr,1)
Endif
**B611480 Derby - Error when running the VAN [Start]
lctt= ''
**B611480 Derby - Error when running the VAN [END]
If LN > 0 And llGXS_passed
  For linner = 1 To LN
    && Get the last file seq in the inbox file
    Cd (lcInBoxPath)
    LN1 = 0
    *LN1 = Adir(ARR1,Juststem(RCV_fls_arr(linner,2))+'*.*')
    LN1 = Adir(ARR1,'*.*')

    *    CD (lcInBoxPath)
    *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
    lMerge = RCV_fls_arr(linner,6) && ASH,  05/18/2017, get the merge flag from the 3rd column of the array as set by aria_get_download_name
    lnstart = 0                     && There are files already under the inbox with a sequence
    *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]

    If LN1 > 0
      *!*lnstart = 0
      For I = 1 To LN1
        lcstart = Juststem( ARR1(I,1))
        If At('_',lcstart) > 0
          lcstart = Substr(lcstart,Rat('_',lcstart)+1,10)
        Else
          lcstart=''
        Endif
        lnstart = Iif(Val(lcstart)>lnstart,Val(lcstart),lnstart)
      Endfor

      *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
      *!*lnstart = lnstart + 1
    Endif
    *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]

    *E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
    If !Empty(RCV_fls_arr(linner,2))
      *E303823,1 DERBY - Handle IDMissMatch more efficent.[End]

      **B611480 Derby - Error when running the VAN [Start]
      Set Step On
      If Empty(lctt)
        If  !Empty(Alltrim(lcHistoryPath))
          lchistory_IN_DIR  = Addbs(Upper(Alltrim(lcHistoryPath)))+'IN'
          If !Directory(lchistory_IN_DIR)
            Md (lchistory_IN_DIR  )
          Endif
          lctt=Dtos(Date())+Alltrim(Str(Hour(Datetime()))) + Alltrim(Str(Minute(Datetime())))+Alltrim(Str(Sec(Datetime()) ))
          lctt=Addbs(lchistory_IN_DIR  )+lctt
          Md (lctt)
          lchistory_FILES  = lctt+'\*.*'
        Endif
      Endif
      *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
      errorVar = ""
      Try
        Copy File (lcHistoryPath+RCV_fls_arr(linner,1)) To (lchistory_FILES)
      Catch To errorVar
        =ErrorLog(errorVar, lcLogFile, lcTitle)
      Endtry
      *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
      **B611480 Derby - Error when running the VAN [END]

      *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
      Cd (lctmp)
      lnstart = Iif(lMerge,lnstart,lnstart+1)
      lctt_name = Upper(Juststem(RCV_fls_arr(linner,2)))
      If !lMerge
        lctt_name = lctt_name + '_' + Alltrim(Str(lnstart)) + '.' + Justext(RCV_fls_arr(linner,2))
      Endif
      *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
      errorVar = ""
      Try
        If !lMerge

          Copy File (lcHistoryPath + RCV_fls_arr(linner,1)) To (lctt_name)
          Copy File (lctt_name)  To (lcInBoxPath+'*.*')
          Delete File (lctt_name)
        Else
          Strtofile(Filetostr(lcHistoryPath + RCV_fls_arr(linner,1)), lctt_name + '.' + Justext(RCV_fls_arr(linner,2)) ,1)  && ASH append to the file, avoid using an intermediate variable to work around fox's limitations
        Endif
        Delete File (lcHistoryPath + RCV_fls_arr(linner,1))
      Catch To errorVar
        =ErrorLog(errorVar, lcLogFile, lcTitle)
      Endtry
      *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
      *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]

      *E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
    Endif
    *E303823,1 DERBY - Handle IDMissMatch more efficent.[End]
  Endfor
Endif

Cd (lcInBoxPath+lctmp)
If LN > 0
  *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
  lnMerged = Adir(laMerged, '*.*') && We're merging under lctmp, one file per network, e.g. INVIN, GXSIN, now we need to give those files a sequence and move them to the inbox
  For I = 1 To lnMerged
    lnstart = lnstart + 1
    lcInboxName = Upper(Juststem(laMerged(I,1))) + '_' + Alltrim(Str(lnstart)) + '.' + Justext(laMerged(I,1))
    *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
    errorVar = ""
    Try
      Copy File (laMerged(I,1)) To (lcInBoxPath + lcInboxName)
    Catch To errorVar
      =ErrorLog(errorVar, lcLogFile, lcTitle)
    Endtry
    *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
  Endfor
  *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]
  *!* COPY FILE *.* TO ..\*.*
  *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
  errorVar = ""
  Try
    Delete File *.*
  Catch To errorVar
    =ErrorLog(errorVar, lcLogFile, lcTitle)
  Endtry
  *B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][End]
  Cd ..
  Rd (lctmp)
  Cd (lccurrPath)
Else
  Cd ..
  Rd (lctmp)
  Cd (lccurrPath)
Endif

***********************************************************
*
*      get_aria_download_name
*
***********************************************************
Function get_aria_download_name

Lparameters lcISA_Sender_QUALIfier ,lcISA_Sender_ID ,lcISA_Recv_QUALIfier ,lcISA_Recv_ID

lcISA_Sender_QUALIfier = Alltrim(lcISA_Sender_QUALIfier)
lcISA_Sender_ID = Alltrim(lcISA_Sender_ID)
lcISA_Recv_QUALIfier =Alltrim(lcISA_Recv_QUALIfier)
lcISA_Recv_ID = Alltrim(lcISA_Recv_ID)

Local lcFile_Name,lcSyccomp,lcEDIPH ,lcEDIPD,lcEDIACPRT

Store '' To lcFile_Name,lcSyccomp,lcEDIPH ,lcEDIACPRT

If !Empty(Alltrim(txt_sys_path))
  lcSyccomp = Addbs(Alltrim(txt_sys_path))+'SYCCOMP'

  If File(lcSyccomp+'.dbf')

    If !Used('Syccomp')
      Use &lcSyccomp. Shared In 0
    Endif &&!USED('lcSyccomp')

    Select SYCCOMP
    Set Order To CCOMP_ID
    Scan
      If Empty(lcFile_Name)

        lcEDIPH    = Addbs(Alltrim(SYCCOMP.ccom_ddir))+'EDIPH'
        lcEDIPD    = Addbs(Alltrim(SYCCOMP.ccom_ddir))+'EDIPD'
        lcEDIACPRT = Addbs(Alltrim(SYCCOMP.ccom_ddir))+'EDIACPRT'
        lcEDINET    = Addbs(Alltrim(SYCCOMP.ccom_ddir))+'EDINET'

        If File(lcEDIPH+'.dbf')
          If !Used('ediph')
            Use &lcEDIPH. Shared In 0 Order PARTNER  && SET ORDER TO PARTNER   && CPARTCODE+CNETWORK+CVERSION
          Endif
          Set Order To PARTNER In EDIPH

          If !Used('ediNET')
            Use &lcEDINET. Shared In 0 Order NETWORKID   &&SET ORDER TO PARTNER   && CPARTCODE+CNETWORK+CVERSION
          Endif
          Set Order To NETWORKID In edinet && CNETWORK

          If !Used('edipd')
            Use &lcEDIPD. Shared In 0 Order PARTTRANS &&PARTTRANS   && CPARTCODE+CEDITRNTYP+CTRANACTV+CPARTID
          Endif
          Set Order To PARTTRANS In edipd

          If !Used('ediACPRT')
            Use &lcEDIACPRT. Shared In 0 Order PARTNER &&PARTTRANS   && CPARTCODE+CEDITRNTYP+CTRANACTV+CPARTID
          Endif
          Set Order To PARTNER In  EDIACPRT && CPARTCODE

          Select edipd



          * E304088,1 Sara.n Compare Values should be on Upper case on both sides [Start ]
          *!*                  Select Dist edinet.cinfile As cnetwork, edinet.lMerge As mergeflag;
          *!*          FROM edipd,EDIPH,EDIACPRT,edinet ;
          *!*          WHERE edipd.cpartcode == EDIPH.cpartcode    And ;
          *!*          edipd.cpartcode == EDIACPRT.cpartcode And ;
          *!*          EDIPH.cnetwork  ==  edinet.cnetwork  And;
          *!*          EDIACPRT.cCmpISAQl == Padr(lcISA_Recv_QUALIfier, 2) And ;
          *!*          EDIACPRT.cCmpISAId == Padr(lcISA_Recv_ID, 15) And ;
          *!*          edipd.cpartqual    == Padr(lcISA_Sender_QUALIfier, 2) And ;
          *!*          edipd.cPartID      == Padr(lcISA_Sender_ID, 15)  ;
          *!*          INTO Cursor CurrAccount

          Select Dist edinet.cinfile As cnetwork, edinet.lMerge As mergeflag;
            FROM edipd,EDIPH,EDIACPRT,edinet ;
            WHERE ;
            UPPER(edipd.cpartcode)    == Upper(EDIPH.cpartcode)    And ;
            UPPER(edipd.cpartcode)    == Upper(EDIACPRT.cpartcode) And ;
            UPPER(EDIPH.cnetwork)     == Upper(edinet.cnetwork)    And;
            UPPER(EDIACPRT.cCmpISAQl) == Upper(Padr(lcISA_Recv_QUALIfier,2)) And ;
            UPPER(EDIACPRT.cCmpISAId) == Upper(Padr(lcISA_Recv_ID, 15)) And ;
            UPPER(edipd.cpartqual)    == Upper(Padr(lcISA_Sender_QUALIfier,2)) And ;
            UPPER(edipd.cPartID)      == Upper(Padr(lcISA_Sender_ID, 15))  ;
            INTO Cursor CurrAccount
          * E304088,1 Sara.n Compare Values should be on Upper case on both sides [End ]

          *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]

          If Used('ediph')
            Use In EDIPH
          Endif

          If Used('edipd')
            Use In edipd
          Endif
          If Used('ediacprt')
            Use In EDIACPRT
          Endif
          If Used('ediNET')
            Use In edinet
          Endif

          If _Tally => 1
            Select CurrAccount
            Go Top
            *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [BEGIN]
            RCV_fls_arr(new_linner,6)= CurrAccount.mergeflag && ASH, set the merge flag in the array, 04/17/2017
            *!* E303850,1 ASH - 07/17/2017 - Combining incoming EDI rawfiles per network if enabled on the Network Setup screen  [END]
            If !Empty(Alltrim(CurrAccount.cnetwork))
              lcFile_Name =  Alltrim(CurrAccount.cnetwork)
              Exit
            Endif
          Endif

        Endif
        Select SYCCOMP
      Endif  &&EMPTY(lcFile_Name)
    Endscan &&SycComp
  Endif &&FILE(lcSyccomp+'.dbf')

Endif &&!EMPTY(ALLTRIM(THIS.txt_sys_path))
* HES

** B611358,1 MSH - 13/07/2017 - Update Arichive Program To Check Files With No EDI Extension [Start]
* If Empty(lcFile_Name)
&& IF File Is Not EDI File Then We Should Not Continue To Display Message Of Wrong Qualifier In EDI File
If Empty(lcFile_Name) And Upper(Substr(lcISA_LINE, 1, 3)) = "ISA" And Upper(Substr(lcGS_LINE, 1, 2)) = "GS"
  ** B611358,1 MSH - 13/07/2017 - Update Arichive Program To Check Files With No EDI Extension [End]


  *E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
  If Type('RCV_fls_arrN(1,1)')="L"
    ArrNum =1
  Else
    ArrNum =Alen(RCV_fls_arrN,1)+1
    Dimension RCV_fls_arrN(ArrNum ,5)
  Endif
  RCV_fls_arrN(ArrNum,1)= lcISA_Sender_QUALIfier+lcISA_Sender_ID
  RCV_fls_arrN(ArrNum,2)= "EDI system downloaded a file with unrecognized sender or receiver Qual\ID's as follows:"+Chr(10)+Chr(13)+Chr(10)+Chr(13)+" -First Transaction Type : "+lcTran_No +Chr(10)+Chr(13)+" - Sender Qual\ID : "+ lcISA_Sender_QUALIfier +"\"+lcISA_Sender_ID +Chr(10)+Chr(13)+" - Receiver Qual\ID : "+ lcISA_Recv_QUALIfier +"\"+lcISA_Recv_ID +Chr(10)+Chr(13)+Chr(10)+Chr(13)+"Press [OK] if you need to send an E-Mail with the issue details to Aria Customer Care or [Cancel] if you can fix the issue and then re-run the EDI VAN to try again later."
  RCV_fls_arrN(ArrNum,3)="ID mismatch problem's ID:" + lcISA_Sender_QUALIfier+lcISA_Sender_ID+Dtos(Datetime())+Strtran(Time(),":")
  RCV_fls_arrN(ArrNum,4)="-Client Name :"+lcClient +Chr(10)+Chr(13)+;
    "-Sender Qual\ID : "+ lcISA_Sender_QUALIfier +"\"+lcISA_Sender_ID +Chr(10)+Chr(13)+;
    "-Receiver Qual\ID : "+ lcISA_Recv_QUALIfier +"\"+lcISA_Recv_ID +Chr(10)+Chr(13)
  RCV_fls_arrN(ArrNum,5)= lcHistoryPath+ "\" + ARR(linner,1)

Endif


Return lcFile_Name
*E303823,1 DERBY - Handle IDMissMatch more efficent.[Start]
***********************************************************
*
*      Send Email Function
*
***********************************************************
Function Send_Mail

Lparameters lcAttchment,lcSubject,lcBody
Store '' To lcErrorMsg
If !Empty(SYCINST.Cediinspth)
  If File(Alltrim(SYCINST.Cediinspth)+ 'PRGs\MailConfig.xml')
    Xmltocursor(Alltrim(SYCINST.Cediinspth)+ 'PRGs\MailConfig.xml','ConfigFile',512)
    If !Empty(ConfigFile.Email) And !Empty(ConfigFile.Password) And !Empty(ConfigFile.To)
      Do (Alltrim(SYCINST.Cediinspth)+ 'PRGS\mailer.FXP') With ConfigFile.Email, ConfigFile.Password, lcAttchment,ConfigFile.To, lcSubject, lcBody
    Endif
    If Empty(lcErrorMsg)
      Messagebox("An E-Mail already sent to Aria Customer care with the details of the problem with the following subject :"+Chr(10)+Chr(13)+Chr(10)+Chr(13)+;
        "'ID mismatch problem's ID: "+lcSubject+;
        "So please follow up with Aria customer care.",48+512,"Aria Systems - Archive APP. - Unrecognized file downloaded!")
    Else
      Messagebox(lcErrorMsg,16+512,"Aria Systems - Archive APP. - " + _Screen.Caption)
    Endif
  Endif
Endif
Endfunc
*E303823,1 DERBY - Handle IDMissMatch more efficent.[End]
*B612271,1 Hassan.I Add error log to try and catch [T20201026.0001][Begin]
*****************************************************************************************************************************
*
*     Error message and log
*
*****************************************************************************************************************************
Function ErrorLog

Lparameters errorVar, lcLogFileName

*Messagebox(errorVar, lcLogFileName)
If Type('errorVar') = 'O' And Type('errorVar.Message')='C'
  Strtofile(Ttoc(Datetime()) + '|' + errorVar.Message + Chr(13)+Chr(10), 'Archive_Errors_Log.TXT', 1)
Endif
Endfunc
*B612271,1 Hassan.I Add error log to try and catch [T20201026.0001] [End]
