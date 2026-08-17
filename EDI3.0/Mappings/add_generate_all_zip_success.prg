ON ERROR DO AddError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
LOCAL lcNeedle, lcReplacement
lcNeedle = "    llDone = .F." + CHR(13) + CHR(10) + ;
  "  ENDIF" + CHR(13) + CHR(10) + ;
  "ENDIF" + CHR(13) + CHR(10) + CHR(13) + CHR(10) + ;
  "If llDone"
lcReplacement = "    llDone = .F." + CHR(13) + CHR(10) + ;
  "  ELSE" + CHR(13) + CHR(10) + ;
  "    MESSAGEBOX('Mapping ZIP created successfully.', 64, 'Generate ZIP')" + CHR(13) + CHR(10) + ;
  "  ENDIF" + CHR(13) + CHR(10) + ;
  "ENDIF" + CHR(13) + CHR(10) + CHR(13) + CHR(10) + ;
  "If llDone"

USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixallmessage
SELECT fixallmessage
LOCATE FOR EMPTY(parent) AND UPPER(ALLTRIM(objname)) == "FORMSET"
IF ATC(lcNeedle, methods) > 0
  REPLACE methods WITH STRTRAN(methods, lcNeedle, lcReplacement, 1, 1, 1)
  FLUSH
  =STRTOFILE("added", "add_generate_all_done.txt", 0)
ELSE
  =STRTOFILE("target block not found", "add_generate_all_failed.txt", 0)
ENDIF
USE IN fixallmessage
QUIT

PROCEDURE AddError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + tcCode, ;
  "add_generate_all_failed.txt", 0)
QUIT
ENDPROC
