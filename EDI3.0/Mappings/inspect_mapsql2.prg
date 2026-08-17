LOCAL lcOutput
lcOutput = ""
USE mapsql2.scx IN 0 SHARED ALIAS inspectform
SELECT inspectform
SCAN
  IF ATC("CreateMappingZip", inspectform.methods) > 0 OR ;
     ATC("GetLatestVersionFile", inspectform.methods) > 0 OR ;
     ATC("CreateMappingZip", inspectform.properties) > 0
    lcOutput = lcOutput + "RECNO=" + TRANSFORM(RECNO()) + CHR(13) + CHR(10) + ;
      "PARENT=" + ALLTRIM(inspectform.parent) + CHR(13) + CHR(10) + ;
      "OBJNAME=" + ALLTRIM(inspectform.objname) + CHR(13) + CHR(10) + ;
      "CLASS=" + ALLTRIM(inspectform.class) + CHR(13) + CHR(10) + ;
      "BASECLASS=" + ALLTRIM(inspectform.baseclass) + CHR(13) + CHR(10) + ;
      "PROPERTIES=" + inspectform.properties + CHR(13) + CHR(10) + ;
      "METHODS=" + inspectform.methods + CHR(13) + CHR(10) + ;
      REPLICATE("=", 70) + CHR(13) + CHR(10)
  ENDIF
ENDSCAN
=STRTOFILE(lcOutput, "mapsql2_inspection.txt", 0)
USE IN inspectform
QUIT
