ON ERROR DO ReplaceError WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
=STRTOFILE("started", "replace_method_started.txt", 0)
LOCAL lcMethod, lnMethodStart
lcMethod = FILETOSTR("create_mapping_zip_method.txt")
USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixform
SELECT fixform
LOCATE FOR EMPTY(parent) AND UPPER(ALLTRIM(objname)) == "FORMSET"
lnMethodStart = ATC("PROCEDURE CreateMappingZip", fixform.methods)
IF lnMethodStart > 0
  REPLACE fixform.methods WITH LEFT(fixform.methods, lnMethodStart - 1) + lcMethod
ELSE
  REPLACE fixform.methods WITH fixform.methods + CHR(13) + CHR(10) + lcMethod
ENDIF
FLUSH
USE IN fixform
=STRTOFILE("replaced", "replace_method_done.txt", 0)
QUIT

PROCEDURE ReplaceError
LPARAMETERS tnError, tcMessage, tcCode, tcProgram, tnLine
=STRTOFILE("Error " + TRANSFORM(tnError) + ": " + tcMessage + CHR(13) + CHR(10) + ;
  tcCode + CHR(13) + CHR(10) + tcProgram + ":" + TRANSFORM(tnLine), ;
  "replace_method_failed.txt", 0)
QUIT
ENDPROC
