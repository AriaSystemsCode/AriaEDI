CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
LOCAL lcOut
lcOut = ""
USE mapsql.pjx IN 0 SHARED ALIAS projectinfo
SELECT projectinfo
SCAN
  lcOut = lcOut + "REC=" + TRANSFORM(RECNO()) + ;
    " TYPE=" + projectinfo.type + ;
    " EXCLUDE=" + TRANSFORM(projectinfo.exclude) + ;
    " MAIN=" + TRANSFORM(projectinfo.mainprog) + ;
    " NAME=" + ALLTRIM(projectinfo.name) + CHR(13) + CHR(10)
ENDSCAN
USE IN projectinfo
=STRTOFILE(lcOut, "project_contents.txt", 0)
QUIT
