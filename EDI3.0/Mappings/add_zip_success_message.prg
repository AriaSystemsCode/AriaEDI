CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
LOCAL lcOld, lcNew
lcOld = "    IF lnZipResult <> 0" + CHR(13) + CHR(10) + ;
  "      MESSAGEBOX('Unable to create mapping ZIP. ZIP command exit code: ' + TRANSFORM(lnZipResult), 16, 'Generate ZIP')" + CHR(13) + CHR(10) + ;
  "      RETURN .F." + CHR(13) + CHR(10) + ;
  "    ENDIF"
lcNew = lcOld + CHR(13) + CHR(10) + ;
  "    MESSAGEBOX('Mapping ZIP created successfully.', 64, 'Generate ZIP')"

USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixsuccess
SELECT fixsuccess
SCAN FOR ATC(lcOld, methods) > 0
  IF ATC("Mapping ZIP created successfully", methods) = 0
    REPLACE methods WITH STRTRAN(methods, lcOld, lcNew, -1, -1, 1)
  ENDIF
ENDSCAN

lcOld = "  IF lnZipResult <> 0" + CHR(13) + CHR(10) + ;
  "    MESSAGEBOX('Unable to create mapping ZIP. ZIP command exit code: ' + TRANSFORM(lnZipResult), 16, 'Generate ZIP')" + CHR(13) + CHR(10) + ;
  "    llDone = .F." + CHR(13) + CHR(10) + ;
  "  ENDIF"
lcNew = "  IF lnZipResult <> 0" + CHR(13) + CHR(10) + ;
  "    MESSAGEBOX('Unable to create mapping ZIP. ZIP command exit code: ' + TRANSFORM(lnZipResult), 16, 'Generate ZIP')" + CHR(13) + CHR(10) + ;
  "    llDone = .F." + CHR(13) + CHR(10) + ;
  "  ELSE" + CHR(13) + CHR(10) + ;
  "    MESSAGEBOX('Mapping ZIP created successfully.', 64, 'Generate ZIP')" + CHR(13) + CHR(10) + ;
  "  ENDIF"
GO TOP
SCAN FOR ATC(lcOld, methods) > 0
  REPLACE methods WITH STRTRAN(methods, lcOld, lcNew, -1, -1, 1)
ENDSCAN
FLUSH
USE IN fixsuccess
QUIT
