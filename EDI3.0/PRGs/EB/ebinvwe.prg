**************************************************************************************************
** develop Program to put lines in editrans tabel for wells fargo. for each invoice at the system 
*E303298,1 RAS 11/11/2012 modi program to get wells fargo. account instead of make it fixed at the program[T20121010.0035]
**************************************************************************************************
*get Program Path
*!*	lcPath = STRTRAN(SYS(16),UPPER('updateinvoice.EXE'),'')
* get data(DBF) folder path from user
*lcDataPath=GETDIR(lcPath, 'Please Select Data (DBFS) Folder:', 'Assign invoices to Wells Fargo',1)
lcDataPath=oAriaApplication.DataDir
 
*E303298,1 RAS 11/11/2012 modi program to get wells fargo. account instead of make it fixed at the program[begin]
STORE 0 TO lnAccNo
store '' to lcPartcode1,lcPartcode2
IF !USED('ediacprt')
    USE (lcDataPath+'ediacprt') SHARED IN 0
ENDIF
SELECT ediacprt
SET ORDER TO PARTNER
IF SEEK('WFCPFN','ediacprt')
 lcPartcode=ediacprt.cpartner
 lcPartcode1=ediacprt.cpartner
 lnAccNo=lnAccNo+1
ENDIF
IF SEEK('WFCPNF','ediacprt')
 lcPartcode=ediacprt.cpartner
 lcPartcode2=ediacprt.cpartner
 lnAccNo=lnAccNo+1
ENDIF
IF lnAccNo=0
 RETURN
ENDIF
IF lnAccNo=2
  IF !USED('CUSTOMER')
    USE (lcDataPath+'CUSTOMER') SHARED IN 0
  ENDIF
  Select Customer
  Set order to CUSTOMER
  LCBROWSEFIELDS = "account:H= 'Account Code' , stname:H= 'Account Name'    "
  LCBROWSEFILE   = 'Customer'
  LCBROWSETITLE  = 'Please,Select Wells Fargo. Account'
  LLSTCLSELECTED = GFBROWSE(LCBROWSEFIELDS,LCBROWSETITLE,LCBROWSEFILE ,'"M"','INLIST(account,LEFT(lcPartcode1,5),LEFT(lcPartcode2,5))',,.T.)

  IF LLSTCLSELECTED
    lcPartcode=Customer.account
  ELSE
    RETURN   
  ENDIF
  
ENDIF
*E303298,1 RAS 11/11/2012 modi program to get wells fargo. account instead of make it fixed at the program[end]

* save the account code for wells fargo at Krazy Kat
*E303298,1 RAS 11/11/2012 modi program to get wells fargo. account instead of make it fixed at the program[begin]
*!*	lcPartcode='NAT10'
*E303298,1 RAS 11/11/2012 modi program to get wells fargo. account instead of make it fixed at the program[end]
* check is the path enter by user valid or show message for user that it is invalid path
InvoiceCounter=0
IF FILE(lcDataPath+'Invhdr.dbf') AND  FILE(lcDataPath+'editrans.dbf')
  IF !USED('Invhdr')
    USE (lcDataPath+'Invhdr') SHARED IN 0
  ENDIF
  IF !USED('editrans')
    USE (lcDataPath+'editrans') SHARED IN 0
  ENDIF
  SELECT editrans
  Set Deleted on
  SET ORDER TO TYPEKEY
  SELECT Invhdr
  Set Deleted on
  * loop on invhdr and check if this line exist at editrans for wells fargo or add it
  SCAN
    IF !SEEK('810'+PADR(Invhdr.invoice,40)+'F'+PADR(lcPartcode,8),'editrans')
      SELECT editrans
      APPEND BLANK
      REPLACE Ceditrntyp WITH '810',;
        KEY WITH Invhdr.invoice,;
        Cpartner WITH  lcPartcode , ;
        TYPE WITH 'F', ;
        Cstatus WITH 'N', ;
        Cadd_user WITH 'UIPrg',;
        Dadd_date WITH DATE()
      InvoiceCounter=InvoiceCounter+1  
    ENDIF
  ENDSCAN
  *close the open tables
  SELECT Invhdr
  USE
  SELECT editrans
  USE
  MESSAGEBOX(ALLT(STR(InvoiceCounter))+" Invoices have been added, Update Done.          ",64,'Aria Systems')
*!*	ELSE
*!*	  IF MESSAGEBOX("Invalid Path! Please Press OK to Select your Data Folder Path Again..",1+16+512,'Wrong Path!') = 1
*!*	    DO SYS(16)
*!*	  ENDIF
ENDIF
