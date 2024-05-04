"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KAROL_WREN -d /receive/ -p X:\aria3edi\ftp_history -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KAROL_WREN  -u X:\aria3edi\edi\outbox\GXS_OUT.EDI -p /send/ -log LOG.TXT

X:\aria3edi\archive.EXE  "GXS_OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "GXS_OUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KAROL_WREN  -u X:\aria3edi\edi\outbox\WRN*.EDI -p /send/ -log LOG.TXT

