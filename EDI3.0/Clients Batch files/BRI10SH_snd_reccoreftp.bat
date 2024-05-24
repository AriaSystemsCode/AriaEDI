"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_INV_FTP -d /fromvan/ -p X:\ARIA3EDI\ftp_history\  -log LOG_INV_D.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INVOUT.EDI -p /tovan/  -log LOG_INV_U.TXT


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_INV_FTP  -u X:\ARIA3EDI\edi\outbox\BRIS.EDI -p /tovan/  -log LOG_INV_U.TXT

 
X:\ARIA3EDI\archive.EXE  "INVOUT.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "INVIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_PTC_FTP -d /BRISCO/*.txt -p X:\ARIA3EDI\ftp_history\  -log LOG_PTC_D.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_PTC_FTP -d /*.* -p X:\ARIA3EDI\ftp_history\  -log LOG_PTC_D.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_PTC_FTP  -u X:\ARIA3EDI\EDI\OUTBOX\BRIS810.20* -p /INV/  -log LOG_PTCU.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BRI10_PTC_FTP  -u X:\ARIA3EDI\edi\outbox\BRIS997.20* -p /INV/  -log LOG_PTC_U.TXT


X:\ARIA3EDI\archive.EXE  "BRIS.EDI*" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "EXPIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"
X:\ARIA3EDI\archive.EXE  "BRIS810.20*" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "EXPIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"
X:\ARIA3EDI\archive.EXE  "BRIS997.20*" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "EXPIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"

