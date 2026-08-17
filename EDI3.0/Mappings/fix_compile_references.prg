CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"

USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixmap
SELECT fixmap
SCAN FOR ATC("GetLatestVersionFile", methods) > 0
  IF ATC("EXTERNAL PROCEDURE GetLatestVersionFile", methods) = 0
    REPLACE methods WITH STRTRAN(methods, ;
      "PROCEDURE Click" + CHR(13) + CHR(10), ;
      "PROCEDURE Click" + CHR(13) + CHR(10) + ;
      "EXTERNAL PROCEDURE GetLatestVersionFile" + CHR(13) + CHR(10), 1, 1, 1)
  ENDIF
ENDSCAN
FLUSH
USE IN fixmap

USE newtrans.scx IN 0 EXCLUSIVE ALIAS fixnew
SELECT fixnew
SCAN FOR ATC("laSourceArray", methods) > 0
  IF ATC("EXTERNAL ARRAY laSourceArray", methods) = 0
    lnFirstLine = AT(CHR(13) + CHR(10), methods)
    REPLACE methods WITH STUFF(methods, lnFirstLine + 2, 0, ;
      "EXTERNAL ARRAY laSourceArray" + CHR(13) + CHR(10))
  ENDIF
ENDSCAN
FLUSH
USE IN fixnew

COMPILE FORM mapsql2.scx
COMPILE FORM newtrans.scx
QUIT
