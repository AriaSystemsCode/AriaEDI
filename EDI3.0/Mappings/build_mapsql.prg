ON ERROR DO BuildError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
_GENMENU = FULLPATH("genmenu.prg")
BUILD EXE mapsql.exe FROM mapsql
=STRTOFILE("mapsql.exe rebuilt successfully.", "build_mapsql_done.txt", 0)
QUIT

PROCEDURE BuildError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + ;
  tcCode + CHR(13) + CHR(10) + tcProgram + ":" + TRANSFORM(tnLine), ;
  "build_mapsql_failed.txt", 0)
QUIT
ENDPROC
