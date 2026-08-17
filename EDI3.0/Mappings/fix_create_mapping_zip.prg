LOCAL lcMethod, lnMethodStart
CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
lcMethod = FILETOSTR("create_mapping_zip_method.txt")

USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixform
SELECT fixform
LOCATE FOR EMPTY(parent) AND UPPER(ALLTRIM(objname)) == "FORMSET"
IF !FOUND()
  =STRTOFILE("Formset record was not found.", "fix_create_mapping_zip_error.txt", 0)
  USE IN fixform
  QUIT
ENDIF

lnMethodStart = ATC("PROCEDURE CreateMappingZip", fixform.methods)
IF lnMethodStart > 0
  REPLACE fixform.methods WITH LEFT(fixform.methods, lnMethodStart - 1) + lcMethod
ELSE
  REPLACE fixform.methods WITH fixform.methods + CHR(13) + CHR(10) + lcMethod
ENDIF
USE IN fixform

COMPILE FORM mapsql2.scx
=STRTOFILE("CreateMappingZip added and mapsql2.scx compiled.", "fix_create_mapping_zip_done.txt", 0)
QUIT
