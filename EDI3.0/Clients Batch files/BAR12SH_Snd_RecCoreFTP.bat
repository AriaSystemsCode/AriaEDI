"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BAR12_INV_FTP -d /fromvan/ -p X:\ARIA3EDI\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BAR12_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INV01OUT.EDI -p /tovan/
X:\ARIA3EDI\archive.EXE  "INV01OUT.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "INV01IN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BAR12_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INV02OUT.EDI -p /tovan/
X:\ARIA3EDI\archive.EXE  "INV02OUT.EDI" "X:\aria4xp\DBFS\02" "X:\ARIA3EDI\EDI\OutBox" "02" "INV02IN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site BAR12_INV_FTP  -u X:\ARIA3EDI\edi\outbox\INV03OUT.EDI -p /tovan/
X:\ARIA3EDI\archive.EXE  "INV03OUT.EDI" "X:\aria4xp\DBFS\03" "X:\ARIA3EDI\EDI\OutBox" "03" "INV03IN.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"