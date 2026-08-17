CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
USE mapsql.pjx IN 0 EXCLUSIVE ALIAS fixproject
SELECT fixproject
LOCATE FOR LOWER(JUSTFNAME(ALLTRIM(name))) == "browse.scx"
IF FOUND() AND !FILE(ALLTRIM(name))
  REPLACE exclude WITH .T.
ENDIF
GO 17
IF ATC("menu1.mnx", name) > 0
  REPLACE exclude WITH .T.
ENDIF
FLUSH
USE IN fixproject
QUIT
