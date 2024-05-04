"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site PID10_INV_FTP -d /fromvan/ -p X:\ARIA3EDI\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site PID10_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INVOUT.EDI -p /tovan/
X:\ARIA3EDI\archive.EXE  "INVOUT.EDI" "X:\aria27\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "INVIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"