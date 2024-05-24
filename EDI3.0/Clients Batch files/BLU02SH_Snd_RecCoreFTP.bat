rem "C:\Program Files\CoreFTP\coreftp.exe" -site BLU02_INV_FTP -d /fromvan/ -p x:\ARIA3EDI\ftp_history\ 

rem "C:\Program Files\CoreFTP\coreftp.exe" -site BLU02_INV_FTP  -u x:\ARIA3EDI\edi\outbox\INOVOUT.EDI -p /tovan/


"C:\Program Files\CoreFTP\coreftp.exe" -site BLU02_INV_FTP -d /fromvan/ -p x:\ARIA3EDI\ftp_history\ -log LOG.TXT

"C:\Program Files\CoreFTP\coreftp.exe" -site BLU02_INV_FTP  -u x:\ARIA3EDI\edi\outbox\INOVOUT.EDI -p /tovan/ -log LOG.TXT

x:\ARIA3EDI\archive.EXE  "INOVOUT.EDI" "X:\aria4xp\DBFS\BF" "x:\ARIA3EDI\EDI\OutBox" "BF" "INOVIN.EDI" "x:\ARIA3EDI\ftp_history" "x:\ARIA3EDI"


"C:\Program Files\CoreFTP\coreftp.exe" -site DISCO_FTP -d /out/*.edi -p x:\ARIA3EDI\ftp_history\ -log LOG.TXT
"C:\Program Files\CoreFTP\coreftp.exe" -site DISCO_FTP -d /out/*.EDI -p x:\ARIA3EDI\ftp_history\ -log LOG.TXT
"C:\Program Files\CoreFTP\coreftp.exe" -site DISCO_FTP  -u x:\ARIA3EDI\edi\outbox\DISOUT.EDI -p /in/ -log LOG.TXT

x:\ARIA3EDI\archive.EXE  "DISOUT.EDI" "X:\aria4xp\DBFS\BF" "x:\ARIA3EDI\EDI\OutBox" "BF" "DISOUT.EDI" "x:\ARIA3EDI\ftp_history" "x:\ARIA3EDI"


