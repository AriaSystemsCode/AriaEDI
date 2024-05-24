"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SWEETPEA -d /outbound/ -p X:\ARIA3EDI\ftp_history\  -log LOG_INV_D.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SWEETPEA  -u X:\ARIA3EDI\edi\outbox\QRSOUT.EDI -p /inbound/  -log LOG_INV_U.TXT

X:\ARIA3EDI\archive.EXE  "QRSOUT.EDI" "X:\aria4xp\DBFS\02" "X:\ARIA3EDI\EDI\OutBox" "02" "QRSIN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"
