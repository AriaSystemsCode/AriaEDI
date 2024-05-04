ECHO OFF
CLS
:MENU
ECHO.
ECHO              IKEDDI    EDIVAN
ECHO ..........................................
ECHO Please select one of the folowing options:
ECHO ..........................................
ECHO.
ECHO 1 - SPSVAN          Send/Receive EDI Raw Files.
ECHO 2 - INOVIS          Send/Receive EDI Raw Files.
ECHO 3 - CIT439T          Send/Receive EDI Raw Files.
ECHO 4 - CIT500E         Send/Receive EDI Raw Files.
ECHO 5 - CIT1853         Send/Receive EDI Raw Files.
ECHO 6 - CIT1854         Send/Receive EDI Raw Files.
ECHO 7 - EXIT.
ECHO.
SET /P M=Type 1,2,3,4,5 or 6 then press Enter:  
IF %M%==1 GOTO SPSVAN
IF %M%==2 GOTO INOVIS
IF %M%==3 GOTO 439T 
IF %M%==4 GOTO 500E
IF %M%==5 GOTO 1853
IF %M%==6 GOTO 1854
IF %M%==7 GOTO END
Goto END

:SPSVAN
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site DI-IKEDDI28 -d /out/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site DI-IKEDDI28 -u X:\aria3edi\edi\outbox\SPSOUT28.EDI -p /in/

X:\aria3edi\ikearchive.EXE  "SPSOUT28.EDI" "X:\aria4xp\DBFS\28" "X:\aria3edi\EDI\OutBox" "28" "SPSOUT28.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site DI-IKEDDI02 -d /out/ -p X:\aria3edi\ftp_history\

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site DI-IKEDDI02 -u X:\aria3edi\edi\outbox\SPSOUT02.EDI -p /in/

X:\aria3edi\ikearchive.EXE  "SPSOUT02.EDI" "X:\aria4xp\DBFS\02" "X:\aria3edi\EDI\OutBox" "02" "SPSOUT02.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"


Goto END

:INOVIS
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site Ikeddi -d /fromvan/ -p X:\aria3edi\ftp_history\ -log log.txt

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site Ikeddi -u X:\aria3edi\edi\outbox\INVOUT28.EDI -p /tovan/ -log log.txt

X:\aria3edi\ikearchive.EXE  "INVOUT28.EDI" "X:\aria4xp\DBFS\28" "X:\aria3edi\EDI\OutBox" "28" "INVOUT28.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site Ikeddi -d /fromvan/ -p X:\aria3edi\ftp_history\ -log log.txt

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site Ikeddi -u X:\aria3edi\edi\outbox\INVOUT.EDI -p /tovan/ -log log.txt

X:\aria3edi\ikearchive.EXE  "INVOUT.EDI" "X:\aria4xp\DBFS\01" "X:\aria3edi\EDI\OutBox" "01" "INVOUT.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

 
Goto END

:439T
ren X:\ARIA3EDI\edi\outbox\GSX_439T.EI temp.EI
echo.>X:\ARIA3EDI\edi\outbox\GSX_439T.EI
type X:\ARIA3EDI\edi\outbox\temp.EI >>X:\ARIA3EDI\edi\outbox\GSX_439T.EI
del X:\ARIA3EDI\edi\outbox\temp.EI
FTP -s:439T.txt
 
Goto END

:500E
ren X:\ARIA3EDI\edi\outbox\GXS_500E.EI temp.EI
echo.>X:\ARIA3EDI\edi\outbox\GXS_500E.EI
type X:\ARIA3EDI\edi\outbox\temp.EI >>X:\ARIA3EDI\edi\outbox\GXS_500E.EI
del X:\ARIA3EDI\edi\outbox\temp.EI
FTP -s:500E.txt 
Goto END

:1853
ren X:\ARIA3EDI\edi\outbox\GXS_1853.EI temp.EI
echo.>X:\ARIA3EDI\edi\outbox\GXS_1853.EI
type X:\ARIA3EDI\edi\outbox\temp.EI >>X:\ARIA3EDI\edi\outbox\GXS_1853.EI
del X:\ARIA3EDI\edi\outbox\temp.EI
FTP -s:1853.txt 

Goto END


:1854
ren X:\ARIA3EDI\edi\outbox\GXS_1854.EI temp.EI
echo.>X:\ARIA3EDI\edi\outbox\GXS_1854.EI
type X:\ARIA3EDI\edi\outbox\temp.EI >>X:\ARIA3EDI\edi\outbox\GXS_1854.EI
del X:\ARIA3EDI\edi\outbox\temp.EI
FTP -s:1854.txt 

Goto END

:END
Exit