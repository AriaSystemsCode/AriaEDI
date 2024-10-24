SET STEP ON

lcImpSrc = "\\tsClient\C\EDI\Import\"
lcExpSrc = "C:\test\Aria3EDI\EDI\OutBox\"
lcExpDes = "\\tsClient\C\EDI\Export"
lcImpDes = "C:\test\Aria3EDI\EDI\InBox\"
lcFile = ""
lcDbfs = "C:\test\Aria27\DBFs\04\EDINET.DBF"
LCEdipaTH = "C:\test\Aria3EDI\EDI\"
LCEdiOutArPth = "C:\test\Aria3EDI\EDI\Outbox\Archive\"

IF !USED('EDINET')
  USE &lcDbfs SHARED IN 0
ENDIF

SELECT EDINET

SCAN FOR ALLTRIM(cNetwork) = 'FREE'
  lcFile = ALLTRIM(cInFile)
  lcOutFile = ALLTRIM(cOutFile)
ENDSCAN
lcEDIFile  = ADDBS(ALLTRIM(lcImpSrc)) + "order.fwy"

WAIT WINDOW "Checking the file..." NOWAIT
IF FILE(lcEDIFile)
  IF FILE(ADDBS(ALLTRIM(lcImpDes))+lcFile)
    CD (ALLTRIM(lcImpDes))
    LN1 = 0
    LN1 = ADIR(ARR1,'*.*')
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
    ENDIF
    lcInboxFilePath = ALLTRIM(LCEdipaTH)+'INBOX\'+JUSTSTEM(lcFile)+"_"+ALLTRIM(STR(lnstart))+".EDI"
  ELSE
    lcInboxFilePath = ALLTRIM(LCEdipaTH)+'INBOX\'+JUSTSTEM(lcFile)+".EDI"
  ENDIF
  
  WAIT WINDOW "Importing..." NOWAIT
  RENAME (lcEDIFile) TO (lcInboxFilePath)
  MESSAGEBOX("Importing done.",64+512,_SCREEN.CAPTION)
ELSE
  MESSAGEBOX("No Freeway files in the Import folder!",64+512,_SCREEN.CAPTION)
ENDIF

CD (ALLTRIM(lcExpSrc))
LN1 = ADIR(ARR1,'*.*')
lFound = .F.
lcDTFolder = TTOC(DATETIME(),1)
MD(LCEdiOutArPth+lcDTFolder)
IF LN1 > 0
  FOR i = 1 TO LN1
    lcstart = ARR1(i,1)
    IF UPPER(JUSTSTEM(lcOutFile)) $ UPPER(JUSTSTEM(lcstart))
      WAIT WINDOW "Exporting & Archiving..." NOWAIT
      COPY FILE (lcExpSrc+lcstart) TO (lcExpDes)
      RENAME (lcExpSrc+lcstart) TO (ADDBS(LCEdiOutArPth+lcDTFolder))+lcstart
      lFound = .T.
    ENDIF 
  ENDFOR
ENDIF
IF !lFound 
  MESSAGEBOX("No Freeway files found to be exported!",64+512,_SCREEN.CAPTION)
ELSE 
  MESSAGEBOX("Exporting done",64+512,_SCREEN.CAPTION)
ENDIF


