"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site VISION_GXS_FTP -d /receive/ -p X:\aria3edi\ftp_history\ -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site VISION_GXS_FTP  -u X:\aria3edi\edi\outbox\GEOUT.EDI -p /send/ -log LOG.TXT

X:\aria3edi\archive.EXE  "GEOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "GEIN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"