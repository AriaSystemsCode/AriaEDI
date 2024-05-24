lcServer='EDISQL\EDISQL'
lcTmpDataBase='EDIMappings'
lcUsrNam='sa'
lcPasword='aria_123'

Create Table Final(cpartcode C(20)null, cpartname C(50)null, ceditrntyp C(50)null, cversion C(50) null, cmapset C(20)null, Cgdlnlnk C(200)null,cgdweb C(200)null, GLRevDate C(200)null)

lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim(lcTmpDataBase)+;
  ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
  If lnConnHandler>0
    llret=SQLExec(lnConnHandler ,'SELECT * FROM sycediph', 'sycediph')
    SELECT 'sycediph'
    INDEX on  cpartcode+cversion TAG indx1
    llret=SQLExec(lnConnHandler ,'SELECT cpartcode,ceditrntyp,cversion,cmapset,Cgdlnlnk,cgdweb,GLRevDate,ctranactv FROM sycedipd', 'sycedipd')
    IF llret > 0
    SELECT 'sycedipd'
    INDEX on  cmapset TAG indx1
    GO top
    	SCAN
    	SCATTER MEMVAR memo 
    	IF SEEK(cpartcode+cversion,'sycediph','indx1')
    		m.cpartname =sycediph.cpartname
        ENDIF
    		SELECT 'Final'
    		APPEND BLANK
    		GATHER MEMVAR memo
    	
    	ENDSCAN
    ENDIF
  llret=SQLExec(lnConnHandler ,  'SELECT * FROM SYCASNHD', 'SYCASNHD')
  llret=SQLExec(lnConnHandler ,  'SELECT * FROM SYCASNHD', 'SYCASNDT')
  
  SELECT SYCASNHD
  GO TOP 
  SCAN FOR ctype='Y'
  IF SEEK(parent_ver,'sycedipd','indx1') AND SEEK(sycedipd.cpartcode,'sycediph','indx1') AND SEEK(sycediph.cparentcode,'sycediph','indx1')
  	INSERT INTO Final (cpartcode ,cpartname ,ceditrntyp ,cversion ,cmapset) Values (sycediph.cpartcode,sycediph.cpartname,'LBL',sycediph.cversion,SYCASNHD.Cver)
  ENDIF
  ENDSCAN
  
  SQLDisconnect(lnConnHandler)
  ENDIF
  