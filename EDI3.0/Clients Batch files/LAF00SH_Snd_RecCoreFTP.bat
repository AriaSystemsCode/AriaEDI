"C:\Program Files\CoreFTP\coreftp.exe" -site LAF00_INV_FTP -d /fromvan/ -p X:\ARIA3EDI\FTP_HISTORY\  -log LOG.TXT

"C:\Program Files\CoreFTP\coreftp.exe" -site LAF00_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INVOUT.EDI -p /tovan/  -log LOG.TXT
X:\ARIA3EDI\archive.EXE  "INVOUT.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "INVIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"


"C:\Program Files\CoreFTP\coreftp.exe" -site LAF00_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INV_OUT.EDI -p /tovan/  -log LOG.TXT
X:\ARIA3EDI\archive.EXE  "INV_OUT.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "INV_IN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"


"C:\Program Files\CoreFTP\coreftp.exe" -site SAKSRADIAL -d /Live/Get/ -p X:\ARIA3EDI\FTP_HISTORY\  -log LOG.TXT

"C:\Program Files\CoreFTP\coreftp.exe" -site SAKSRADIAL  -u X:\ARIA3EDI\edi\outbox\SAKSOUT.EDI -p /Live/Put/  -log LOG.TXT
X:\ARIA3EDI\archive.EXE  "SAKSOUT.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "SAKSIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"
