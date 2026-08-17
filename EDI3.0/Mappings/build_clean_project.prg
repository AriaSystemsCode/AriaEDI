ON ERROR DO CleanBuildError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
LOCAL loProject, loFile, lnI
DIMENSION laFiles[23]
laFiles[1] = "mapsql.prg"
laFiles[2] = "classes\mapsmain.vcx"
laFiles[3] = "mapsql.scx"
laFiles[4] = "parminf.scx"
laFiles[5] = "userinf.scx"
laFiles[6] = "nbrowse.scx"
laFiles[7] = "newtrans.scx"
laFiles[8] = "prtnrinf.scx"
laFiles[9] = "newpartner.scx"
laFiles[10] = "mapsql2.scx"
laFiles[11] = "customer.scx"
laFiles[12] = "ppartner_browse.scx"
laFiles[13] = "mailer.prg"
laFiles[14] = "frmmappingshow.scx"
laFiles[15] = "frmuccshow.scx"
laFiles[16] = "frmupcshow.scx"
laFiles[17] = "frmsvshow.scx"
laFiles[18] = "frmlogin.scx"
laFiles[19] = "custommessagebox.scx"
laFiles[20] = "discriminant.scx"
laFiles[21] = "discremenant_report.frx"
laFiles[22] = "discremenant_report_lbl.frx"
laFiles[23] = "menu1.mpr"

CREATE PROJECT mapsql_build NOWAIT
loProject = _VFP.ActiveProject
FOR lnI = 1 TO ALEN(laFiles)
  loFile = loProject.Files.Add(FULLPATH(laFiles[lnI]))
  IF lnI = 1
    loFile.SetMain()
  ENDIF
ENDFOR

IF loProject.Build(FULLPATH("mapsql.exe"), 3, .F., .F., .F.)
  =STRTOFILE("mapsql.exe built successfully from clean project.", "clean_build_done.txt", 0)
ELSE
  =STRTOFILE("The clean project Build method returned false.", "clean_build_failed.txt", 0)
ENDIF
loProject.Close()
QUIT

PROCEDURE CleanBuildError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + ;
  tcCode + CHR(13) + CHR(10) + tcProgram + ":" + TRANSFORM(tnLine), ;
  "clean_build_failed.txt", 0)
QUIT
ENDPROC
