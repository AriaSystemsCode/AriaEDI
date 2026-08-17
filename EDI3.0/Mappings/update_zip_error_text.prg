CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
USE mapsql2.scx IN 0 EXCLUSIVE ALIAS fixmessages
SELECT fixmessages
SCAN FOR ATC("tar.exe exit code", methods) > 0
  REPLACE methods WITH STRTRAN(methods, "tar.exe exit code", "ZIP command exit code", -1, -1, 1)
ENDSCAN
FLUSH
USE IN fixmessages
QUIT
