"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SAND_FTP -d /edi/send/*.EDI  -p X:\Aria3EDI\ftp_history\  -log LOG_PTC_D.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SAND_FTP  -u X:\Aria3EDI\EDI\OUTBOX\INVAVL*.XLS -p /text/receive/  -log LOG_PTCU.TXT


R:\AriaLive\Client\Aria3EDI\archive.EXE  "INVAVL*.XLS" "X:\Aria4XP\DBFS\01" "X:\Aria3EDI\EDI\OutBox" "01" "INVAVL*.XLS" "X:\Aria3EDI\ftp_history" "X:\Aria3EDI"



"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GXS_FTPs -d /receive/ -p X:\aria3edi\ftp_history\ -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GXS_FTPs  -u X:\aria3edi\edi\outbox\GEOUT.EDI -p /send/ -log LOG.TXT
rem "C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GXS_FTPs  -u X:\aria3edi\edi\outbox\WLMIN.EDI -p /send/ -log LOG.TXT
rem "C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GXS_FTPs  -u X:\aria3edi\edi\outbox\QRSOUT.EDI -p /send/ -log LOG.TXT

X:\aria3edi\archive.EXE  "GEOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "GEOUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
rem X:\aria3edi\archive.EXE  "WLMIN.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "WLMIN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
rem X:\aria3edi\archive.EXE  "QRSOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\QRSOUT" "01" "QRSOUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
