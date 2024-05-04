ECHO OFF
CLS
:MENU
ECHO.
ECHO       FY Global OUTSOURCING EDIVAN
ECHO ..........................................
ECHO Please select one of the folowing options:
ECHO ..........................................
ECHO.
ECHO 1 - Lorena Sarbue   Send/Receive EDI Raw Files.
ECHO 2 - EXIT.
ECHO.
SET /P M=Type 1 or 2 then press ENTER:
IF %M%==1 GOTO Lorena
IF %M%==2 GOTO END
Goto END
:Lorena
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site 01_Lorena -d /fromvan/ -p X:\aria3edi\ftp_history\LOR -log LOG_LOR.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site 01_Lorena -u X:\aria3edi\edi\outbox\INVOUT.EDI -p /tovan/ -log LOG_LOR.TXT

X:\aria3edi\archive.EXE  "INVOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "INVOUT.EDI" "X:\aria3edi\ftp_history\LOR" "X:\aria3edi"

Goto END
:END
Exit