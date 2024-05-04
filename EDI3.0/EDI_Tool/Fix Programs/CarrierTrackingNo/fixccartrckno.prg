*:***********************************************************************************************************
*: Program file  : FIXCCARTRCKNO
*: Program desc. : Fix program to InvHdr File For (E302725.122)
*:        System : Aria Advantage Series.
*:        Module : (EDI3).
*:     Developer : Walid Hamed (WLD)
*:          Date : 09/08/2010
*:***********************************************************************************************************

_SCREEN.CAPTION = 'Carrier Tracking No in Invoice Header file fix'
_SCREEN.WINDOWSTATE = 2
SET DELETE ON
CLOSE DATA

= MESSAGEBOX("Please select the System Files Directory.",64,'Carrier Tracking No Fix ')
lcSysDir = GETDIR()
IF !FILE(lcSysDir+'SYDFILES.DBF')
  = MESSAGEBOX("This is not the System Files Directory. Cannot proceed.",16,'Carrier Tracking No ')
  RETURN
ENDIF
USE lcSysDir+"SYCCOMP" SHARE IN 0
SELECT  SYCCOMP
SCAN
  lcDataDir = ALLT(ccom_Ddir)
  WAIT WIND 'Company ' + ALLTRIM(UPPER(ccom_Ddir)) NOWAIT
  USE lcDataDir+'INVHDR' in 0 SHARED 
  REPLACE Ccartrckno WITH ALLTRIM(cCodTrckNo) FOR EMPTY(Ccartrckno) in Invhdr   
  IF USED('INVHDR')
    USE IN  ('INVHDR')
  ENDIF
  SELECT  SYCCOMP
ENDSCAN
=MESSAGEBOX('Fix Done,Carrier Tracking No is replaced in Invoice Header file',64,'Carrier Tracking No ')
CLOSE DATA



