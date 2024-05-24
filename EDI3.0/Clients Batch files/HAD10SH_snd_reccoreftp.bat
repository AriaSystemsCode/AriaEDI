"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site HAD10_INV_FTP -d /fromvan/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site HAD10_INV_FTP  -u X:\aria3edi\edi\outbox\INVOUT01.EDI -p /tovan/

X:\aria3edi\archive.EXE  "INVOUT01.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "INVOUT01.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site HAD10_INV_FTP  -u X:\aria3edi\edi\outbox\INVOUT02.EDI -p /tovan/

X:\aria3edi\archive.EXE  "INVOUT02.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "INVOUT02.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site HAD10_INV_FTP  -u X:\aria3edi\edi\outbox\INVOUT03.EDI -p /tovan/

X:\aria3edi\archive.EXE  "INVOUT03.EDI" "X:\aria4xp\DBFS\03" "X:\aria3edi\EDI\OutBox" "03" "INVOUT03.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"