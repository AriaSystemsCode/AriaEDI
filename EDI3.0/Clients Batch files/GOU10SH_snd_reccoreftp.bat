ECHO OFF
CLS
:MENU
ECHO.
ECHO        GORDINI U.S.A   EDIVAN
ECHO ..........................................
ECHO Please select one of the folowing options:
ECHO ..........................................
ECHO.
ECHO 1 - KOM  	 Send/Receive EDI Raw Files.
ECHO 2 - GOR  	 Send/Receive EDI Raw Files.
ECHO 3 - KOM/GOR	 Send/Receive EDI Raw Files.
ECHO 4 - CS	         Send/Receive EDI Raw Files.
ECHO 5 - EXIT.
ECHO.
SET /P M=Type 1,2,3,4 or 5 then press ENTER:
IF %M%==1 GOTO KOM
IF %M%==2 GOTO GOR
IF %M%==3 GOTO BOTH
IF %M%==4 GOTO CS
IF %M%==5 GOTO END
Goto END
:KOM
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI -d /fromvan/ -p X:\aria3edi\ftp_history\KOM -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI -u X:\aria3edi\edi\outbox\KOM_OUT.EDI -p /tovan/ -log LOG.TXT

X:\aria3edi\archive.EXE  "KOM_OUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "KOM_OUT.EDI" "X:\aria3edi\ftp_history\KOM" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI_WM -d /inbox/ -p X:\aria3edi\ftp_history\KOM -log LOG.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI_WM -u X:\aria3edi\edi\outbox\WM_OUT1.EDI -p /outbox/ -log LOG.TXT
X:\aria3edi\archive.EXE  "WM_OUT1.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "WM_OUT1.EDI" "X:\aria3edi\ftp_history\KOM" "X:\aria3edi"

Goto END
:GOR
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GORDINIUSA -d /fromvan/ -p X:\aria3edi\ftp_history\GOR -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GORDINIUSA -u X:\aria3edi\edi\outbox\GXS_OUT.EDI -p /tovan/ -log LOG.TXT

X:\aria3edi\archive.EXE  "GXS_OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "GXS_OUT.EDI" "X:\aria3edi\ftp_history\GOR" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GOU_WALMART -d /inbox/ -p X:\aria3edi\ftp_history\GOR -log LOG.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GOU_WALMART -u X:\aria3edi\edi\outbox\WM_OUT2.EDI -p /outbox/ -log LOG.TXT
X:\aria3edi\archive.EXE  "WM_OUT2.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "WM_OUT2.EDI" "X:\aria3edi\ftp_history\GOR" "X:\aria3edi"

Goto END
:BOTH
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI -d /fromvan/ -p X:\aria3edi\ftp_history\KOM -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI -u X:\aria3edi\edi\outbox\KOM_OUT.EDI -p /tovan/ -log LOG.TXT

X:\aria3edi\archive.EXE  "KOM_OUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "KOM_OUT.EDI" "X:\aria3edi\ftp_history\KOM" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GORDINIUSA -d /fromvan/ -p X:\aria3edi\ftp_history\GOR -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GORDINIUSA -u X:\aria3edi\edi\outbox\GXS_OUT.EDI -p /tovan/ -log LOG.TXT

X:\aria3edi\archive.EXE  "GXS_OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "GXS_OUT.EDI" "X:\aria3edi\ftp_history\GOR" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI_WM -d /inbox/ -p X:\aria3edi\ftp_history\KOM -log LOG.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site KOMBI_WM -u X:\aria3edi\edi\outbox\WM_OUT1.EDI -p /outbox/ -log LOG.TXT
X:\aria3edi\archive.EXE  "WM_OUT1.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "WM_OUT1.EDI" "X:\aria3edi\ftp_history\KOM" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GOU_WALMART -d /inbox/ -p X:\aria3edi\ftp_history\GOR -log LOG.TXT
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site GOU_WALMART -u X:\aria3edi\edi\outbox\WM_OUT2.EDI -p /outbox/ -log LOG.TXT
X:\aria3edi\archive.EXE  "WM_OUT2.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "WM_OUT2.EDI" "X:\aria3edi\ftp_history\GOR" "X:\aria3edi"
Goto END

:CS
X:\aria3edi\archive.EXE  "CS_OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "CS_OUT.EDI" "X:\aria3edi\ftp_history\CS" "X:\aria3edi" "T"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site CS -d /EDI/OUT/ -p X:\aria3edi\ftp_history\CS -log LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site CS -u X:\aria3edi\edi\outbox\CS_OUT.EDI -p /EDI/IN/

X:\aria3edi\archive.EXE  "CS_OUT.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "CS_OUT.EDI" "X:\aria3edi\ftp_history\CS" "X:\aria3edi"

Goto END
:END
Exit