@echo off

if not exist c:\fciwebnet\USERNAME\out\*.* goto NOOUT
cd c:\fciwebnet\USERNAME\out\

FTP -i -s:c:\fciftp\ftpout.ftp edi.fciwebnet.com > c:\fciftp\ftpout.log
if errorlevel 1 goto ERROROUT

echo "Check ftp log for <Unknown host> errors ...."
findstr /l "Unknown host " c:\fciftp\ftpout.log
if not errorlevel 1 goto ERROROUT
echo "Check ftp log for <Invalid command.> errors ...."
findstr /l "Invalid command." c:\fciftp\ftpout.log
if not errorlevel 1 goto ERROROUT
echo "Outbound FTP Log ====>"
type c:\fciftp\ftpout.log
echo "<===="

cd c:\fciwebnet\USERNAME\out\
copy *.* c:\fciwebnet\USERNAME\outbak
cd c:\fciwebnet\USERNAME\out\
echo Y|del *.*
goto END

:NOOUT
cd c:\fciwebnet\USERNAME\in
FTP -i -s:c:\fciftp\ftpin.ftp edi.fciwebnet.com
if errorlevel 1 goto ERRORIN
copy *.* c:\fciwebnet\USERNAME\inbak


:ERRORIN
Echo ***********************************************************************
Echo An error occurred during the FTP session attempting to access data from
echo FCI. 
Echo ***********************************************************************
goto END
:ERROROUT
Echo ***********************************************************************
Echo An error occurred during the FTP session attempting to transfer data to
echo FCI. 
Echo ***********************************************************************
echo "Outbound FTP Log ====>"
type c:\fciftp\ftpout.log
echo "<===="
:End