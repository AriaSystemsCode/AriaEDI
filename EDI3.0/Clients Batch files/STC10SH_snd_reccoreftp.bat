"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STYClub -d /fromvan/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STYClub -u X:\aria3edi\edi\outbox\INVOUT.EDI -p /tovan/
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STYClub -u X:\aria3edi\edi\outbox\INVOUT01.EDI -p /tovan/
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STYClub -u X:\aria3edi\edi\outbox\NIVOUT01.EDI -p /tovan/
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STYClub -u X:\aria3edi\edi\outbox\INVOUT04.EDI -p /tovan/

X:\aria3edi\archive.EXE  "INVOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "INVOUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
X:\aria3edi\archive.EXE  "INVOUT01.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "INVOUT01.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
X:\aria3edi\archive.EXE  "NIVOUT01.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "NIVOUT01.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
X:\aria3edi\archive.EXE  "INVOUT04.EDI" "X:\aria4xp\DBFS\04" "X:\aria3edi\EDI\OutBox" "04" "INVOUT04.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STC_GXS -d /receive/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site STC_GXS -u X:\aria3edi\edi\outbox\GXSOUT.EDI -p /send/

X:\aria3edi\archive.EXE  "GXSOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "GXSOUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"


"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site RockFTP -d /fromvan/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site RockFTP -u X:\aria3edi\edi\outbox\GXSOUT02.EDI -p /tovan/

X:\aria3edi\archive.EXE  "GXSOUT02.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "GXSOUT02.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"
