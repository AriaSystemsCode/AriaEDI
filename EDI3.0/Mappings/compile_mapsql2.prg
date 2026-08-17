ON ERROR DO CompileError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
COMPILE FORM mapsql2.scx
=STRTOFILE("mapsql2.scx compiled successfully.", "compile_mapsql2_done.txt", 0)
QUIT

PROCEDURE CompileError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + ;
  tcCode + CHR(13) + CHR(10) + tcProgram + ":" + TRANSFORM(tnLine), ;
  "compile_mapsql2_failed.txt", 0)
QUIT
ENDPROC
