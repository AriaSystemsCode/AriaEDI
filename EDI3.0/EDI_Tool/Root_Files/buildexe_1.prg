lcPath = GETDIR('','','Select Sysfiles Folder Please')
IF !EMPTY(lcPath )
  lcSystemPath = lcPath
  lcMapPath    = lcPath
  CD (lcSystemPath)
  *******************

SET TALK OFF
SET TEXTMERGE ON
STORE FCREATE(lcPath+'Mappings.prg') TO _TEXT
TEXT NOSHOW

PROCEDURE OpenFile
LPARAMETERS lcFile, lcTag
LOCAL oFile
*oFile = CREATEOBJECT('MapClass')
*oFile.OPEN(lcFile, lcTag)
*RELEASE oFile
*CLEAR CLASS 'MapClass'

*DEFINE CLASS MapClass AS Custom
*  PROCEDURE Open
*  LPARAMETERS lcFile, lcTag
*  IF !USED(lcFile)
*    USE (lcFile) IN 0 ORDER TAG (lcTag) SHARED
*  ELSE
*    SELECT (lcFile)
*    SET ORDER TO TAG (lcTag) IN (lcFile)
*  ENDIF
*  ENDPROC
*ENDDEFINE

IF !USED(lcFile)
  USE (lcFile) IN 0 ORDER TAG (lcTag) SHARED
ELSE
  SELECT (lcFile)
  SET ORDER TO TAG (lcTag) IN (lcFile)
ENDIF
  ENDTEXT
  =FCLOSE(_TEXT)


STORE FCREATE(lcPath+'Temp.prg') TO _TEXT
TEXT NOSHOW
PROCEDURE Temp
DECLARE laMapFiles[19]
  *!*	laMapFiles[1] = 'SycEdiPh'
  *!*	laMapFiles[2] = 'SycEdiPd'
  *!*	laMapFiles[3] = 'SycEdiTr'
  *!*	laMapFiles[4] = 'SycEdiFs'
  *!*	laMapFiles[5] = 'SycEdiSf'
  *!*	laMapFiles[6] = 'SycEdiSg'
  *!*	laMapFiles[7] = 'SycEdiSh'
  *!*	laMapFiles[8] = 'SYCEDITX'
  *!*	laMapFiles[9] = 'SYCASNLB'
  *!*	laMapFiles[10]= 'SYCEDISC'
  *!*	laMapFiles[11]= 'SYCEDIPR'
  *!*	laMapFiles[12]= 'SYCEDIRS'
  *!*	laMapFiles[13]= 'SYCEDISM'
  *!*	laMapFiles[14]= 'SYCEDIPO'
  *!*	laMapFiles[15]= 'SYCEDIPA'
  *!*	laMapFiles[16]= 'SYCEDIPC'
  *!*	laMapFiles[17]= 'SYCEDICD'
  *!*	laMapFiles[18]= 'SYCEDIRF'
  *!*	laMapFiles[19]= 'SYCUPCLB'
  *!*	laMapFiles[20]= 'SYCEDIOW'
  *!*	laMapFiles[21]= 'SYCASNHD'
  *!*	laMapFiles[22]= 'SYCASNDT'
  laMapFiles[1] = 'SycEdiFs'
  laMapFiles[2] = 'SycEdiSf'
  laMapFiles[3] = 'SycEdiSg'
  laMapFiles[4] = 'SycEdiSh'
  laMapFiles[5] = 'SYCEDITX'
  laMapFiles[6] = 'SYCASNLB'
  laMapFiles[7]= 'SYCEDISC'
  laMapFiles[8]= 'SYCEDIPR'
  laMapFiles[9]= 'SYCEDIRS'
  laMapFiles[10]= 'SYCEDISM'
  laMapFiles[11]= 'SYCEDIPO'
  laMapFiles[12]= 'SYCEDIPA'
  laMapFiles[13]= 'SYCEDIPC'
  laMapFiles[14]= 'SYCEDICD'
  laMapFiles[15]= 'SYCEDIRF'
  laMapFiles[16]= 'SYCUPCLB'
  laMapFiles[17]= 'SYCEDIOW'
  laMapFiles[18]= 'SYCASNHD'
  laMapFiles[19]= 'SYCASNDT'

CREATE PROJECT (lcPath+'mappings') NOSHOW SAVE nowait
FOR lnCount = 1 TO ALEN(laMapFiles)
  IF FILE(lcSystemPath+laMapFiles[lnCount]+'.DBF')
    APPLICATION.PROJECTS(1).Files.Add(lcSystemPath+laMapFiles[lnCount]+'.DBF')
    APPLICATION.PROJECTS(1).Files(laMapFiles[lnCount]+'.DBF').Exclude = .F.
  ENDIF
  IF FILE(lcSystemPath+'BackUp\'+laMapFiles[lnCount]+'.DBF')
    APPLICATION.PROJECTS(1).Files.Add(lcSystemPath+'BackUp\'+laMapFiles[lnCount]+'.DBF')
    APPLICATION.PROJECTS(1).Files(laMapFiles[lnCount]+'.DBF').Exclude = .F.
  ENDIF
ENDFOR

APPLICATION.PROJECTS(1).Files.Add(lcPath+'mappings.prg')
APPLICATION.PROJECTS(1).Files(lcPath+'mappings.prg').Exclude=.F.
APPLICATION.PROJECTS(1).setmain(lcPath+'mappings.prg')

APPLICATION.PROJECTS(1).BUILD(lcPath+'mappings',3)
APPLICATION.PROJECTS(1).close

IF !DIRECTORY(lcSystemPath+'BackUp')
  MD (lcSystemPath+'BackUp')
ENDIF
FOR lnCount = 1 TO ALEN(laMapFiles)
  IF FILE(lcSystemPath+laMapFiles[lnCount]+'.DBF')
    COPY FILE (lcSystemPath+laMapFiles[lnCount]+'.*') TO (lcSystemPath+'BackUp\'+laMapFiles[lnCount]+'.*')
    ERASE (lcSystemPath+laMapFiles[lnCount]+'.*')
  ENDIF
ENDFOR
ERASE (lcPath+'Mappings.prg')
ERASE (lcPath+'Mappings.pjx')
ERASE (lcPath+'Mappings.pjt')
  ENDTEXT
  =FCLOSE(_TEXT)
ENDIF

*x=NEWOBJECT("MapClass","Mappings.prg","d:\mappings\mappings.exe")
*DO openfile WITH 'sycedifs','network' IN d:\mappings\mappings.exe
KEYBOARD '{ALT+F4}'
