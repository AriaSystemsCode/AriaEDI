CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
IF !FILE("mapsql_before_cleanup.pjx")
  COPY FILE mapsql.pjx TO mapsql_before_cleanup.pjx
  COPY FILE mapsql.pjt TO mapsql_before_cleanup.pjt
ENDIF
USE mapsql.pjx IN 0 EXCLUSIVE ALIAS cleanproject
SELECT cleanproject
DELETE ALL FOR ATC("browse.scx", name) > 0 AND ATC("nbrowse.scx", name) = 0
DELETE ALL FOR ATC("menu1.mnx", name) > 0
PACK
USE IN cleanproject
QUIT
