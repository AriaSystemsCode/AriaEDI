ON ERROR DO MenuError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
COMPILE menu1.mpr
=STRTOFILE("menu compiled", "compile_menu_done.txt", 0)
QUIT

PROCEDURE MenuError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + tcCode, ;
  "compile_menu_failed.txt", 0)
QUIT
ENDPROC
