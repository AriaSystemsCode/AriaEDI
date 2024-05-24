"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site TPSINV -d /fromvan/ -p X:\ARIA3EDI\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site TPSINV -u X:\ARIA3EDI\edi\outbox\invout.EDI -p /tovan/
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site TPSINV -u X:\ARIA3EDI\edi\outbox\invout1.EDI -p /tovan/

X:\ARIA3EDI\archive.EXE  "invout.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "invout.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"
X:\ARIA3EDI\archive.EXE  "invout1.EDI" "X:\aria4xp\DBFS\01" "X:\ARIA3EDI\EDI\OutBox" "01" "invout1.EDI" "X:\ARIA3EDI\ftp_history" "X:\ARIA3EDI"