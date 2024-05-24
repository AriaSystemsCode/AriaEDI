ECHO OFF
CLS
:MENU
ECHO.
ECHO              SHARON    EDIVAN
ECHO ..........................................
ECHO Please select one of the folowing options:
ECHO ..........................................
ECHO.
ECHO 1 - INOVIS          Send/Receive EDI Raw Files for Inovis.
ECHO 2 - S2CIT           Send/Receive EDI Raw Files for CIT-Sharon Young.
ECHO 3 - J1CIT           Send/Receive EDI Raw Files for CIT-Jerell and WB-Westbound.
ECHO 4 - CGCIT           Send/Receive EDI Raw Files for CIT-City Girl and TL-Tru Luxe.
ECHO 5 - EXIT.
ECHO.
SET /P M=Type 1,2,3,4 or 5 then press Enter:  
IF %M%==1 GOTO INOVIS
IF %M%==2 GOTO S2CIT
IF %M%==3 GOTO J1CIT
IF %M%==4 GOTO CGCIT
IF %M%==5 GOTO END
Goto END

:INOVIS
"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP -d /fromvan/ -p X:\aria3edi\ftp_history\ -log x:\LOG.TXT

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP  -u X:\aria3edi\edi\outbox\INVJ1OUT.EDI -p /tovan/ -log x:\LOG.TXT
X:\aria3edi\archive.EXE  "INVJ1OUT.EDI" "X:\aria4xp\DBFS\J1" "X:\aria3edi\EDI\OutBox" "J1" "INVJ1IN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP  -u X:\aria3edi\edi\outbox\INVS2OUT.EDI -p /tovan/ -log x:\LOG.TXT
X:\aria3edi\archive.EXE  "INVS2OUT.EDI" "X:\aria4xp\DBFS\S2" "X:\aria3edi\EDI\OutBox" "S2" "INVS2IN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP  -u X:\aria3edi\edi\outbox\INVWBOUT.EDI -p /tovan/ -log x:\LOG.TXT
X:\aria3edi\archive.EXE  "INVWBOUT.EDI" "X:\aria4xp\DBFS\WB" "X:\aria3edi\EDI\OutBox" "WB" "INVWBIN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP  -u X:\aria3edi\edi\outbox\INVTLOUT.EDI -p /tovan/ -log x:\LOG.TXT
X:\aria3edi\archive.EXE  "INVTLOUT.EDI" "X:\aria4xp\DBFS\TL" "X:\aria3edi\EDI\OutBox" "TL" "INVTLIN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

"C:\Program Files (x86)\CoreFTP\coreftp.exe" -site SHA13_INV_FTP  -u X:\aria3edi\edi\outbox\INVCHOUT.EDI -p /tovan/ -log x:\LOG.TXT
X:\aria3edi\archive.EXE  "INVCHOUT.EDI" "X:\aria4xp\DBFS\CH" "X:\aria3edi\EDI\OutBox" "CH" "INVCHIN.EDI" "X:\aria3edi\ftp_history" "X:\aria3edi"

Goto END

:J1CIT
ren X:\ARIA3EDI\edi\outbox\J1CIT.EDI data.DI 
FTP -s:J1CIT.txt
del X:\ARIA3EDI\edi\outbox\data.DI

Goto END

:CGCIT
ren X:\ARIA3EDI\edi\outbox\CGCIT.EDI data.DI
FTP -s:CGCIT.txt 
del X:\ARIA3EDI\edi\outbox\data.DI

Goto END

:S2CIT
ren X:\ARIA3EDI\edi\outbox\S2CIT.EDI data.DI
FTP -s:S2CIT.txt 
del X:\ARIA3EDI\edi\outbox\data.DI

Goto END

:END
Exit