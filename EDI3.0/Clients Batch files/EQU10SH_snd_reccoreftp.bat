"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -d /fromvan/ -p X:\aria3edi\ftp_history\  -log logFromVan.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -u X:\aria3edi\edi\outbox\EXP01OUT.EDI -p /tovan/ -log logToVan.TXT

X:\aria3edi\archive.EXE  "EXP01OUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "EXP01OUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -d /fromvan/ -p X:\aria3edi\ftp_history\ -log logFromVan.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -u X:\aria3edi\edi\outbox\EXP02OUT.EDI -p /tovan/ -log logToVan.TXT

X:\aria3edi\archive.EXE  "EXP02OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "EXP02OUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -d /fromvan/ -p X:\aria3edi\ftp_history\ -log logFromVan.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site EQUALS4_FTP -u X:\aria3edi\edi\outbox\EXP03OUT.EDI -p /tovan/ -log logToVan.TXT

X:\aria3edi\archive.EXE  "EXP03OUT.EDI" "X:\aria4xp\DBFS\03" "X:\aria3edi\EDI\OutBox" "03" "EXP03OUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"