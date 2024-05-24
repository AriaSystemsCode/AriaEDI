****************************************************************
*Modifications:
*B605568,1 HIA 2/15/2002 Adjust the lfread function to read in
*B605568,1 HIA           segment other than the picked one.
*N127567,1 AAH           Read the subfield at segment when EDI type is EDI-FACT.
*E040124,1 HIA Enhance The Used Method To Write Carton Sequence From Fixed Method At The Code;
*              To Method Depend On 'UCC # Structure' Setup Which Added To Al By E040123 By HBG.
*E302434,1 WLD Increase the  MEMOWIDTH to be 85  08/29/2007
*E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007/11/14
*E302532,1 WLD Increase the  MEMOWIDTH to be 200  06/01/2008
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
*B608815,1 WLD Get mapped drive path by API
*E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [Begin]
*B609151,1 WAM 02/02/2010 Add sequence number for cartons if not found in EDICRTSQ [T20100122.0004]
*B609349,1 HES 07/15/2010 -Get Ordline note info for Temporary SO [T20100709.0047]
*N000649,1 WLD Open SQL File 08/02/2010
*E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [T20110620.0017]
*E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [T20110620.0017]
*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [T20120529.0052]
*E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [P20120101.0002]
*E303226,1 RAS 2012-09-02 add function that seek PO1 data depended on PO1 Qualifiers [T20120207.0024]
*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [T20121224.0009]
*E303362,1 RAS 2013-03-04 modi prg to not retrieve last line in case of no data at lfskudesc function[T20130301.0015]
*E303469,1 RAS 2014-04-27 modi prg to modify the search performace at edicrtsq when setup of UCC# is [T20131219.0020]
*!* E303478,1 HES 06/11/2014 Add functions to help to open DBF tables to use it when needed in SYCEDIXP or any other places [T20140523.0006]
*B611092,1 AEG 2015-12-14 Two Diffrent packing list have the same UCC9 [T20151111.0001]
*E303856,1 DERBY 2017-07-08 Create Indexs for a specific table based on SYDINDX [P20170806.0001]
*B611631,1 BYM 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()
*E304069 ,1 BYM JCP 753 issue with unit of measures, supporting cubic feet,inch, and cm [T20180831.0028]
*E612287 ,1 Sara.N Modify LFREAD to Read the partner 850 version not the Outgoing transaction version [T20201015.0004]
*B612325 ,1 Sara.N seek for full 6 digit of partcode [T20210105.0018]
*B612352,1 HIA, restore quialifier option in lfread [T20210212.0001]
*B612649,1 HIA, Call lfread using 860-POC if 860-PO1 failed [T20220907.0001]
***************************************************************
***************************************************************

***************************************************************
**
** FUNCTION TO CHANGE THE DATE FROM YYMMDD TO MM/DD/YY FORMAT
**                                  YYMMDD TO DD/MM/YY FORMAT
**
****************************************************************
Function EDATE
Parameter MDATE

If Alltrim(oAriaApplication.DefaultCountry) = 'CANADA' Or ;
    ALLTRIM(oAriaApplication.DefaultCountry) = 'USA'
  Return(Ctod(Substr(MDATE,3,2)+'/'+Substr(MDATE,5,2)+'/'+;
    IIF(Val(Substr(MDATE,1,2))<50,'20','19')+Substr(MDATE,1,2)))
Else
  Return(Ctod(Substr(MDATE,5,2)+'/'+Substr(MDATE,3,2)+'/'+Padl(Year(Date()),2)+Substr(MDATE,1,2)))
Endif

***************************************************************
**
** FUNCTION TO CHANGE THE DATE FROM YYYYMMDD TO MM/DD/YYYY FORMAT
**                                  YYYYMMDD TO DD/MM/YYYY FORMAT
*C101100,1 Add new function to Read Date with century
****************************************************************
Function CENDATE
Parameter MDATE

If Alltrim(oAriaApplication.DefaultCountry) = 'CANADA' Or ;
    ALLTRIM(oAriaApplication.DefaultCountry) = 'USA'
  Return(Ctod(Substr(MDATE,5,2)+'/'+Substr(MDATE,7,2)+'/'+Substr(MDATE,1,4)))
Else
  Return(Ctod(Substr(MDATE,7,2)+'/'+Substr(MDATE,5,2)+'/'+Substr(MDATE,1,4)))
Endif

*!*************************************************************************
*! Proc : lfSkuDesc
*! Auth : Wael Aly Mohamed
*! Date : 01/13/98
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*! Synopsis : Restore PO SKU information
*!C101190,1 WAM 06/07/98 Initialize SKU information.
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function lfSkuDesc
Parameters lcOrder,lcLineNo,lcSKU,lcType
Private lcNotes,lcLine

*E303362,1 RAS 2013-03-04 define variable hold flag decide if we found the line related to send SKU or not [begin]
Store .F. To llfound
*E303362,1 RAS 2013-03-04 define variable hold flag decide if we found the line related to send SKU or not [end]

*N129597,1 WLD increase the  MEMOWIDTH to be 65 (not use the default 50) [Begin]
*E302434,1 WLD Increase the  MEMOWIDTH to be 85  08/29/2007 [Begin]
*Set MEMOWIDTH To 65
*E302532,1 WLD Increase the  MEMOWIDTH to be 200  06/01/2008 [Begin]
*Set MEMOWIDTH To 85
Set Memowidth To 200
*E302532,1 WLD Increase the  MEMOWIDTH to be 200  06/01/2008 [End]
*E302434,1 WLD Increase the  MEMOWIDTH to be 85  08/29/2007 [End]
*N129597,1 WLD increase the  MEMOWIDTH to be 65 (not use the default 50) [End]

*B609349,1 HES 07/15/2010 -Get Ordline note info for Temporary SO [Start]
*!*	  =SEEK('O'+lcOrder+STR(lcLineNo,6),'ORDLINE','ORDLINE')
=Seek('O'+lcOrder+Str(lcLineNo,6),'ORDLINE','ORDLINE') Or Seek('T'+lcOrder+Str(lcLineNo,6),'ORDLINE','ORDLINE')
*B609349,1 HES 07/15/2010 -Get Ordline note info for Temporary SO [End  ]

lcNotes = ORDLINE.NOTE_MEM

*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [begin]
Alines(LANoteLines,lcNotes)
For lnx= 1 To Alen(LANoteLines,1)
  lcLine = LANoteLines(lnx)
  If Alltrim(lcSKU) $ lcLine
    *E303362,1 RAS 2013-03-04 assign true to the variable that hold flag decide if we found the line related to send SKU or not [begin]
    llfound= .T.
    *E303362,1 RAS 2013-03-04 assign true to the variable that hold flag decide if we found the line related to send SKU or not [end]
    Exit
  Endif
Endfor
*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [end]

lcReturn = ''

*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [begin]
*!*	  IF ATCLINE(ALLTRIM(lcSKU),lcNotes) > 0
*!*	    lcLine=MLINE(lcNotes,ATCLINE(ALLTRIM(lcSKU),lcNotes))
*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [end]

*E303362,1 RAS 2013-03-04 modi prg to not retrieve last line in case of no data at lfskudesc function[begin]
*!*	    IF AT(lcType+'|',lcLine) > 0
If At(lcType+'|',lcLine) > 0 And llfound
  *E303362,1 RAS 2013-03-04 modi prg to not retrieve last line in case of no data at lfskudesc function[end]

  lcLine=Substr(lcLine,At(lcType+'|',lcLine)+Len(lcType)+1)
  lcReturn = Substr(lcLine,1,At('|',lcLine)-1)
Endif

*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [begin]
*!*	  ENDIF
*E303351,1 RAS 2013-02-11 get line at lfskudesc independed on memo width [end]

Return(lcReturn)

************************************************
**
** FUNCTION GETCENT Return Date Century
**
*C101100,1 WAM 03/08/98 Add new function to get date century
************************************************
Function GETCENT
Parameters MDATE

Return Left(Str(Year(MDATE),4),2)

************************************************
**
** FUNCTION XDATE GIVE THE DATE IN YYMMDD FORMAT
**
*C101100,1 WAM 03/09/98 Use Date functions in EDI100
************************************************
Function XDATE
Parameters MDATE

Return(Right(Str(Year(MDATE),4),2)+Padl(Month(MDATE),2,'0')+Padl(Day(MDATE),2,'0'))

************************************************
**
** FUNCTION CENTDATE GIVE THE DATE IN CCYYMMDD FORMAT
**
************************************************
Function CENTDATE
Parameters MDATE
Return(Str(Year(MDATE),4)+Padl(Month(MDATE),2,'0')+Padl(Day(MDATE),2,'0'))

**********************************************
**
** FUNCTION XTIME GIVE THE TIME IN HHMM FORMAT
**
**********************************************
Function XTIME
Return(Substr(Time(),1,2)+Substr(Time(),4,2))

*!*************************************************************************
*! Proc : lfPOLine
*! Auth : Wael Aly Mohamed
*! Date : 01/13/98
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*! Synopsis : Restore PO line information
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function lfPOLine
Parameters lcType
Private lcLine

lcLine=Substr(ORDLINE.Desc1,At(lcType+'|',ORDLINE.Desc1)+3)
Return(Substr(lcLine,1,At('|',lcLine)-1))

*!*************************************************************************
*! Proc : lfInvoice
*! Auth : Ahmed Mohamed Ibrahim
*! Date : 10/31/2000
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*! Synopsis : Get invoice number
*! Ref      : B803788
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Function lfInvoice
Parameters lcAccount,lcOrderNo,lcStoreNo

lnAlias=Select()
Select INVHDR
Set Order To Tag INVHDRA Desc
=Seek(lcAccount)
Locate Rest While ACCOUNT+INVOICE = lcAccount ;
  FOR  Order=lcOrderNo .And. ;
  IIF(MCONSOL='Y',Seek(INVOICE+lcStoreNo,'CONSINVH'),Store=lcStoreNo)
Select (lnAlias)
Return(INVHDR.INVOICE)

*!*************************************************************************
*! Proc : GetChkDgt
*! Auth : Wael Ali Mohamed
*! Date : 08/06/2001
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*! Synopsis : Calculate Check digit
*! ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function GetChkDgt
Lparameter lcUccNo
Private lnChkDigit,lnSumOdd,lnSumEven,lnCount,lnLength
Store 0 To lnSumOdd,lnSumEven,lnChkDigit

lnLength = Len(lcUccNo)
For lnCount = 1 To Int(lnLength/2)
  lnSumOdd  = lnSumOdd + Val(Substr(lcUccNo,lnCount*2-1,1))
  lnSumEven = lnSumEven+ Val(Substr(lcUccNo,lnCount*2,1))
Endfor
If Mod(lnLength,2) = 1
  lnSumOdd   = lnSumOdd + Val(Substr(lcUccNo,lnLength,1))
  lnChkDigit = Mod(lnSumOdd*3+lnSumEven,10)
Else
  lnChkDigit = Mod(lnSumOdd+lnSumEven*3,10)
Endif
Return(Iif(lnChkDigit=0,'0',Str(Int(10-lnChkDigit),1)))

**B612649,1 HIA, Call lfread using 860-POC if 860-PO1 failed [T20220907.0001] [Begin]
*!**************************************************************************
*! Name      : lfRead
*! Developer : Hassan Ali
*! Date      : 06/08/2001
*! Purpose   : Read EDI file seg. or Specified Field value From "edisv" Table
*!             AND RETURN THE FIELD VALUE OR THE SEG VALUES ALL
*!**************************************************************************
*! Call From : The Mapping tables
*!**************************************************************************
*! Param(s)  :  nFld_no    :The field number(N) or (.F.) for Whole SEG.
*!              cKey_Value :The key value to detect the value
*!     		   	LEVEL      :THE lcPROCESSLEVEL (detail, header)
*!     	        cTran_type :THE TRANSACTION (WE NEED TO GET FROM ) TYPE (850, 860)
*!     	        lcSegId    :THE Segment  (WE NEED TO GET FROM ) TYPE (PO1, POC)
*!     	        cKey_Value1:THE TRANSACTION (WE NEED TO GET FROM ) TYPE 
*!              lLastTransaction: If True search latest 860 POC then 850 PO1
*!**************************************************************************
*! Returns   : The field value (OR THE FIRST FIELD VALUE IN CASE OF ALL SEG)
*!**************************************************************************
*! Example   : = lfRead(nFld_no,cKey_Value,PROCESSLEVEL,cTran_type)
*!**************************************************************************
*:->
 Function lfREAD

Lparameters nFld_No        ,;
  cKey_Value     ,;
  lcProcessLevel ,;
  cTran_Type     ,;
  lcSegId ,;
  cKey_Value1,;
  lLastTransaction

&& lLastTransaction

ret = ""
If Type("lLastTransaction")=="L" And lLastTransaction == .T.
  If (cTran_Type = '850' And lcSegId = 'PO1') Or (cTran_Type = '860' And lcSegId = 'POC')
    ret = lpfread(nFld_No, cKey_Value, lcProcessLevel, '860', 'POC', cKey_Value1)
    If Empty(Alltrim(ret))
      ret = lpfread(nFld_No, cKey_Value, lcProcessLevel, '850', 'PO1', cKey_Value1)
    Endif
  Else
    && as normal
    ret = lpfread(nFld_No, cKey_Value, lcProcessLevel, cTran_Type, lcSegId, cKey_Value1)
  Endif
Else
  && as normal
  ret = lpfread(nFld_No, cKey_Value, lcProcessLevel, cTran_Type, lcSegId, cKey_Value1)
Endif
Return ret
**B612649,1 HIA, Call lfread using 860-POC if 860-PO1 failed [T20220907.0001] [End]  
**********************************************************************************
*!**************************************************************************
*! Name      : lpfRead
*! Developer : Hassan Ali
*! Date      : 06/08/2001
*! Purpose   : Read EDI file seg. or Specified Field value From "edisv" Table
*!             AND RETURN THE FIELD VALUE OR THE SEG VALUES ALL
*!**************************************************************************
*! Call From : The Mapping tables
*!**************************************************************************
*! Param(s)  :  nFld_no    :The field number(N) or (.F.) for Whole SEG.
*!              cKey_Value :The key value to detect the value
*!     		   	LEVEL      :THE lcPROCESSLEVEL
*!     	       cTran_type :THE TRANSACTION (WE NEED TO GET FROM ) TYPE
*!**************************************************************************
*! Returns   : The field value (OR THE FIRST FIELD VALUE IN CASE OF ALL SEG)
*!**************************************************************************
*! Example   : = lfRead(nFld_no,cKey_Value,PROCESSLEVEL,cTran_type)
*!**************************************************************************
*:->
Function lpfREAD
*B605568,1 HIA 2/15/2002 Read in segment other than the picked one [Begin].
*!*	LPARAM nFld_no     ,;
*!*	       cKey_Value     ,;
*!*	       lcPROCESSLEVEL ,;
*!*	       cTran_type
*E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007-11-14 [BEGIN]
*LPARAMETERS nFld_No        ,;
*  cKey_Value     ,;
*  lcProcessLevel ,;
*  cTran_Type     ,;
*  lcSegId


Lparameters nFld_No        ,;
  cKey_Value     ,;
  lcProcessLevel ,;
  cTran_Type     ,;
  lcSegId ,;
  cKey_Value1

*E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007-11-14 [END]
Set Step On
lcSegId = Iif(Type('lcSegId')="C",lcSegId,mSegId)
*B605568,1 HIA 2/15/2002 Read in segment other than the picked one [End].
*!**********Save Work Area**************************************************
Local lnArea ,;
  lnInc  ,;
  cRet

cRet   = ""
lnArea = Select()
*!*	*!**********Main***********************************************************
Set Step On
cField_Sep = Iif(Eof('EdiPh'),'',Eval(Alltrim(EdiPh.cFieldSep)))
cLine_Sep  = Iif(Eof('EdiPh'),'',Eval(Alltrim(EdiPh.cLineSep)))
*E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [Begin]
*E612287 ,1 Sara.N Modify LFREAD to Read the partner 850 version not the Outgoing transaction version [Start]
Select edipd
lcCurCursorKey = Evaluate(Key())

*B612325 ,1 Sara.N seek for full 6 digit of partcode [Start]
*=SEEK(Alltrim(EdiAcPrt.cPartCode)+ALLTRIM(cTran_Type),'EDIPD','PARTTRANS')
=Seek(Padr(Alltrim(EdiAcPrt.cPartCode),6)+Alltrim(cTran_Type),'EDIPD','PARTTRANS')
*E612287 ,1 Sara.N Modify LFREAD to Read the partner 850 version not the Outgoing transaction version [End]

*B612325 ,1 Sara.N seek for full 6 digit of partcode [End]
lcTrnVer   = Substr(Alltrim(edipd.cVersion),1,6) + "VICS  "
lcTrnVer_1 = Padr(Strtran(edipd.cVersion,'VICS',''),12)
*E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [End]

*B612325 ,1 Sara.N seek for full 6 digit of partcode [Start]
*E612287 ,1 Sara.N Modify LFREAD to Read the partner 850 version not the Outgoing transaction version [Start]
*=SEEK(Alltrim(lcCurCursorKey) ,'EDIPD')
=Seek(lcCurCursorKey,'EDIPD')
*E612287 ,1 Sara.N Modify LFREAD to Read the partner 850 version not the Outgoing transaction version [End]
*B612325 ,1 Sara.N seek for full 6 digit of partcode [End]
Select EdiSv
Do Case
  *!*	***************CASE Type(nFld_no) = "L"************************************
Case Type('nFld_No') = "L"
  *E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007-11-14 [BEGIN]
  *IF SEEK( EdiAcPrt.cPartCode           +;
  EdiPd.cVersion               +;
  cTran_Type                   +;
  lcSegId                      +;
  PADR(lcProcessLevel, 50, " ")+;
  PADR(cKey_Value    , 60, " "))

  *E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [Begin]
  *IF SEEK( EdiAcPrt.cPartCode + EdiPd.cVersion + cTran_Type+lcSegId +;
  PADR(lcProcessLevel, 50, " ")+ PADR(cKey_Value    , 60, " ")) ;
  OR (TYPE('cKey_Value1')='C' AND SEEK( EdiAcPrt.cPartCode + EdiPd.cVersion + cTran_Type+lcSegId +;
  PADR(lcProcessLevel, 50, " ")+ PADR(cKey_Value1    , 60, " ")))
  If (Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type+lcSegId +;
      PADR(lcProcessLevel, 50, " ")+ Padr(cKey_Value    , 60, " ")) ;
      OR (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type+lcSegId +;
      PADR(lcProcessLevel, 50, " ")+ Padr(cKey_Value1 , 60, " ")))) ;
      OR ;
      (Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type+lcSegId +;
      PADR(lcProcessLevel, 50, " ")+ Padr(cKey_Value    , 60, " ")) ;
      OR (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type+lcSegId +;
      PADR(lcProcessLevel, 50, " ")+ Padr(cKey_Value1    , 60, " "))))
    *E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [End]
    *E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007-11-14 [END]

    cRet  = Allt(cValue)

    *!*    		For lnInc = 1 to mFl_Cnt - 1
    *!*    			xField(lnInc)  = SubStr( cRet                               ,;
    *!*    			                         At(cField_Sep,cRet,lnInc     ) +1  ,;
    *!*    			                         At(cField_Sep,cRet,lnInc + 1 ) - At(cField_Sep,cRet,lnInc) -1)

    *!*    		EndFor
    *!*    		xField(lnInc)  = SubStr( cRet ,At(cFIELD_SEP,cRet,lnINc    ) +1)
    *!*    		cRet           = xField(1)
  Else
  Endif
  ****************CASE Type(nFld_no) = "N"************************************
Case Type('nFld_No') = "N"

  *N128528, AHH HAS PROBLEM WITH SGEID OF TWO CHAR LENGTH,06/23/2005	[BEGIN]
  *!*		If Seek( EdiAcPrt.cPartCode            +;
  *!*		         EdiPd.cVersion                +;
  *!*		         cTran_Type                    +;
  *!*		         lcSegId			           +;
  *!*		         Padr(lcProcessLevel, 50, " ") +;
  *!*		         Padr(cKey_Value    , 60, " ") )
  *!*	        *B119185,1 WAM Get Fields Separator
  *!*			cField_Sep = SUBSTR(cValue,LEN(lcSegId)+1,1)
  *!*	        *B119185,1 WAM (End)
  *E302467,1 HIA Modify LFREAD fn to use 2 parameters 2007-11-14 [BEGIN]
  *IF SEEK( EdiAcPrt.cPartCode            +;
  EdiPd.cVersion                +;
  cTran_Type                    +;
  PADR(lcSegId,3,SPACE(1))            +;
  PADR(lcProcessLevel, 50, " ") +;
  PADR(cKey_Value    , 60, " ") )


  *E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [Begin]
  *IF SEEK( EdiAcPrt.cPartCode + EdiPd.cVersion + cTran_Type + PADR(lcSegId,3,SPACE(1))+;
  PADR(lcProcessLevel, 50, " ") +PADR(cKey_Value    , 60, " ") ) OR;
  (TYPE('cKey_Value1')='C' AND SEEK( EdiAcPrt.cPartCode + EdiPd.cVersion + cTran_Type + PADR(lcSegId,3,SPACE(1))+;
  PADR(lcProcessLevel, 50, " ") +PADR(cKey_Value1    , 60, " ") ))
  If (Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value    , 60, " ") ) Or;
      (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value1    , 60, " ") ))) ;
      OR ;
      (Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value    , 60, " ") ) Or;
      (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value1    , 60, " ") )))
    *E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [End]

    cField_Sep = Substr(cValue,Len(Alltrim(lcSegId))+1,1)

    *N128528, AHH HAS PROBLEM WITH SGEID OF TWO CHAR LENGTH,06/23/2005	[END]
    cRet  = Allt(cValue)
    nOcur = Occur(cField_Sep, cRet)
    nLOC1 = At(cField_Sep, cRet, nFld_No  )
    nLOC2 = At(cField_Sep, cRet, nFld_No+1)
    Do Case
    Case nLOC1 <> 0 And nLOC2 <> 0
      cRet = Substr(cRet, nLOC1 + 1, nLOC2 - nLOC1 -1 )
    Case nLOC1 <> 0 And nLOC2 = 0
      cRet = Substr(cRet, nLOC1+1)
      *B119185,1 WAM Get Fields Separator
    Otherwise
      cRet = ''
      *B119185,1 WAM (End)
    Endcase
  Else
  Endif
  ****************CASE Type(nFld_no) = "C"************************************
  *B612352,1 HIA, restore quialifier option in lfread [T20210212.0001] [Begin]
Case Type('nFld_No') = "C"

  If (Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value    , 60, " ") ) Or;
      (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value1    , 60, " ") ))) ;
      OR ;
      (Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value    , 60, " ") ) Or;
      (Type('cKey_Value1')='C' And Seek( EdiAcPrt.cPartCode + lcTrnVer_1 + cTran_Type + Padr(lcSegId,3,Space(1))+;
      PADR(lcProcessLevel, 50, " ") +Padr(cKey_Value1    , 60, " ") )))
    *E302604,1 WLD Get the saved data in EDISV not depending on VICS version   05/13/2009 [End]

    cField_Sep = Substr(cValue,Len(Alltrim(lcSegId))+1,1)

    *N128528, AHH HAS PROBLEM WITH SGEID OF TWO CHAR LENGTH,06/23/2005	[END]
    cRet  = Allt(cValue)
    If At(cField_Sep +nFld_No+cField_Sep , cRet ) > 0 And !Empty(nFld_No)
      cRet = Substr(cRet , At(cField_Sep+nFld_No+cField_Sep , cRet)+Len(nFld_No)+2)
      cRet = Substr(cRet , 1 , Iif(Occurs(cField_Sep , cRet)> 0 , At(cField_Sep , cRet)-1, Len(cRet)))
    Else
      cRet = ''
    Endif

  Else
  Endif
Otherwise
  cRet = ''
  *B612352,1 HIA, restore quialifier option in lfread [T20210212.0001][End]
Endcase
**********Restore Work Area*************************************************
Select (lnArea)
Return cRet
*!**************************************************************************
Endfun
*!****************END PROCEDURE*********************************************
*!*	***************************************************************************
*E039066 AAH  save edi raw files into aria data base 02/28/2005	[Begin]
*!*	This function will retrive data of stored raw files from aria data base
*!*	aria read edi rawfile and store it into two files one for header segment and
*!*	second for detail loop segement
*!*	IF we need header segment data we pass line no parameter with 0 ELSE if we
*!*	need detail segment we pass line no and size or pack which we need
*!*	***************************************************************************
Function ReadFld
Parameters ;
  lcAccount,;
  lcOrder,;
  lnOrdline,;
  lcSeg_id,;
  lnFieldno,;
  lcQualifier,;
  lcsz_pack

Local lcRetAlias

lcFldValue = ""
lcRetAlias = Alias()

If lnOrdline = 0	&&Read HEADER segment
  If !Used("EDISOHD")
    Select 0
    Use EDISOHD
    Set Order To ACC_ORD
  Else
    Select EDISOHD
  Endif
  If Seek(lcAccount+lcOrder)
    lcFieldSep=Substr(Edi_lines,Len(Alltrim(Seg_id))+1,1)
    lcQualifier=lcFieldSep+lcQualifier+lcFieldSep
    Scan While ACCOUNT+Order = lcAccount+lcOrder
      If Seg_id = lcSeg_id  And  lcQualifier$Edi_lines
        *------------------------
        mFielsNo = Occurs(lcFieldSep,Edi_lines)
        *-- Put the data elements into array
        If mFielsNo > 0
          For X = 1 To  mFielsNo
            Strt_Pos = At(lcFieldSep,Edi_lines , X) + 1
            End_Pos  = Iif(X < mFielsNo , At(lcFieldSep , Edi_lines , X + 1),Len(Edi_lines) + 1)
            If End_Pos => Strt_Pos And X = lnFieldno
              lcFldValue = Substr(Edi_lines  , Strt_Pos , End_Pos - Strt_Pos)
              lcFldValue = Trim(lcFldValue)
            Endif
          Endfor
        Endif
        *------------------------
        Exit
      Endif
    Endscan
  Endif
Else 				&&Read DETAIL Segment
  If !Used("EDISODT")
    Select 0
    Use EDISODT
    Set Order To ACC_ORD
  Else
    Select EDISODT
  Endif

  If Seek(lcAccount+lcOrder+Str(lnOrdline,6))
    lcFieldSep=Substr(Edi_lines,Len(Alltrim(Seg_id))+1,1)
    lcQualifier=lcFieldSep+lcQualifier+lcFieldSep
    Scan While ACCOUNT+Order+Str(line_no,6) = lcAccount+lcOrder+Str(lnOrdline,6)
      If Seg_id = lcSeg_id  And  lcQualifier$Edi_lines And Alltrim(csz_pack)==Alltrim(lcsz_pack)
        *------------------------
        mFielsNo = Occurs(lcFieldSep,Edi_lines)
        *-- Put the data elements into array
        If mFielsNo > 0
          For X = 1 To  mFielsNo
            Strt_Pos = At(lcFieldSep,Edi_lines , X) + 1
            End_Pos  = Iif(X < mFielsNo , At(lcFieldSep , Edi_lines , X + 1),Len(Edi_lines) + 1)
            If End_Pos => Strt_Pos And X = lnFieldno
              lcFldValue = Substr(Edi_lines  , Strt_Pos , End_Pos - Strt_Pos)
              lcFldValue = Trim(lcFldValue)
            Endif
          Endfor
        Endif
        *------------------------
        Exit
      Endif
    Endscan
  Endif

Endif
Return lcFldValue
*!****************END PROCEDURE*********************************************
*******************************************************************
**
** FUNCTION lfCOMPFLD used to get subfiled from segment at EDI-FACT
**
**
******************************************************************
Function lfCOMPFLD
Lparameters lcData,lcSeprator ,lnFieldno
If Empty(lcSeprator)
  lcSeprator =":"
Endif

Do Case
  *handel case of no subfield and need to return fld #1
Case Occurs(lcSeprator,lcData) = 0 And lnFieldno = 1
  Return(Alltrim(lcData))
  *handel case of no subfield
Case Occurs(lcSeprator,lcData) = 0
  Return('')
  *handel case of requested subfld not exist at the segment
Case Occurs(lcSeprator,lcData) +1 < lnFieldno
  Return('')

Endcase

*!*	IF OCCURS(lcSeprator,lcData) +1 < lnFieldNo
*!*	  *=MESSAGEBOX("Invalid Field # ")
*!*	  RETURN('')
*!*	ENDIF

Do Case
Case lnFieldno  = 1
  lnStartpos 	= 1
  lnStrlen	 	= At(lcSeprator,lcData,lnFieldno)-1
Case lnFieldno  = Occurs(lcSeprator,lcData) +1
  lnStartpos 	= At(lcSeprator,lcData,lnFieldno-1)+1
  lnStrlen	 	= Len(lcData)- lnStartpos +1
Other
  lnStartpos 	= At(lcSeprator,lcData,lnFieldno-1)+1
  lnStrlen	 	= At(lcSeprator,lcData,lnFieldno)-At(lcSeprator,lcData,lnFieldno-1)-1

Endcase
Return(Substr(lcData,lnStartpos,lnStrlen))
**************************************************************************************
*:****************************************************************************************
*! Name      : GetUccNO
*! Developer : Hassan Ibrahim Ali [HIA]
*! Date      : 03/19/2006
*! Purpose   : Eet the UCC9 # from the new file EDICRTSQ
*:****************************************************************************************
*! Called from : EDI.SENDUCCLABELS CLASS, EDISH.SEND856 CLASS
*! Called Like : lfGetUccNO (lnCRTSEQ_SETUP, lcPACKNO, lcBOX_SER)
*:****************************************************************************************
*E040124,1 HIA Enhance The Used Method To Write Carton Sequence From Fixed Method At The Code;
*              To Method Depend On 'UCC # Structure' Setup Which Added To Al By E040123 By HBG [BEGIN]
*B609151,1 WAM Add sequence number for cartons if not found in EDICRTSQ [T20100122.0004]

Function lfGetUccNO

*E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
*! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
** => -add the new parameter to do either (normal -generate and Add- OR retrieve -in case of 856- [BEGIN]
*!*	  LPARAMETERS lnCRTSEQ_SETUP,; && THE 'UCC # Structure ' SETUP FROM AL MODULE
*!*	  lcPACKNO,;       && Packing List #
*!*	  lcBOX_SER        && Carton # Within The Packing List
*!*	  LPARAMETERS lnCRTSEQ_SETUP,; && THE 'UCC # Structure ' SETUP FROM AL MODULE
*!*	  lcPACKNO,;       && Packing List #
*!*	  lcBOX_SER,;        && Carton # Within The Packing List
*!*	  llAdd

*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
*!*	  LPARAMETERS lnCRTSEQ_SETUP,; && THE 'UCC # Structure ' SETUP FROM AL MODULE
*!*	  lcPACKNO,;       && Packing List #
*!*	  lcBOX_SER        && Carton # Within The Packing List
*E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
*!*	  LPARAMETERS lnCRTSEQ_SETUP,; && THE 'UCC # Structure ' SETUP FROM AL MODULE
*!*	  lcPACKNO,;       && Packing List #
*!*	  lcBOX_SER,;      && Carton # Within The Packing List
*!*	  llFrmShp         && From Ship BOL flag
Lparameters lnCRTSEQ_SETUP,; && THE 'UCC # Structure ' SETUP FROM AL MODULE
lcPACKNO,;       && Packing List #
lcBOX_SER,;      && Carton # Within The Packing List
llFrmShp,;       && From Ship BOL flag
lnUCCMNFLEN      && UCC Manufacture length
*E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [EBD  ]



*E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]

*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [Begin]
lcDel = Set("Deleted")
*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

lcAccount = Pack_Hdr.ACCOUNT
If !Used('EDICRTSQ')
  Use (oAriaApplication.DataDir+'EDICRTSQ') Order Tag PCKCRTSQ In 0
Endif
*! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]
** => -add the new parameter to do either (normal -generate and Add- OR retrieve -in case of 856- [END  ]

Local oGetMemVar_SETUP,lcUCC9

* Verified The 'UCC # Structure ' Setup From AL Module Passed Or Not [START]
If Type('lnCRTSEQ_SETUP') <> 'C'

  lnCRTSEQ_SETUP   = '0'
  oGetMemVar_SETUP = Createobject('GetMemVar')
  lnCRTSEQ_SETUP   = Alltrim(oGetMemVar_SETUP.Do('M_UCCBSDON',oAriaApplication.ActiveCompanyId))
  Release oGetMemVar_SETUP
  If lnCRTSEQ_SETUP   = '0'
    *=Messagebox('UCC # Structure Setup [AL Module Setup] Has Not Accepted Value [Accept 5,6,9], Carton Sequence Can Not Be Generated !!',0+16,_Screen.Caption)
    = Messagebox('Please setup the UCC # structure code from the Allocation Module setup screen in order to using the Bill Of Lading screen.',0+16,_Screen.Caption)
  Endif
Endif
* Verified The 'UCC # Structure ' Setup From AL Module Passed Or Not [END]

Do Case
Case lnCRTSEQ_SETUP = '5'
  * UCC9 Format: Right 5 Digits of Packing list + 4 Digits From Carton Sequence Pad Left With '0'

  *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [BEGIN]
  lcAlias = Alias()
  Select EDICRTSQ

  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
  Set Deleted On
  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

  *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
  *!*	      IF llAdd AND !SEEK(lcPACKNO+STR(lcBOX_SER,6))
  If !Seek(lcPACKNO+Str(lcBOX_SER,6))
    *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]
    *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [END  ]

    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
    If !llFrmShp
      Set Deleted Off
      If !Seek(lcPACKNO+Str(lcBOX_SER,6))
        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]


        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
        *!*	     lcUCC9 = RIGHT(PADL(ALLTRIM(lcPACKNO),6,'0'),5)             +PADL(lcBOX_SER,4,'0')
        lcUCC9 = Right(Padl(Alltrim(lcPACKNO),6,'0'),Iif(lnUCCMNFLEN = 7,12,11)-lnUCCMNFLEN)+Padl(lcBOX_SER,4,'0')
        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]

        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [BEGIN]
        Insert Into 'EDICRTSQ' (Pack_No,ACCOUNT,cart_no,Ucc9);
          VALUES (lcPACKNO,lcAccount,lcBOX_SER,lcUCC9)

        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
      Endif
    Else
      Messagebox("Pack# "+Alltrim(lcPACKNO)+" - Carton# "+Alltrim(Str(lcBOX_SER))+", not found in the carton sequence file, please refer to Aria with these information.",16+512,"Fatal Error!")
      lcUCC9 = ''
      Set Deleted &lcDel
      Return lcUCC9
    Endif
    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

    *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
    *!*	      ELSE
    *!*	        IF !SEEK(lcPACKNO+STR(lcBOX_SER,6))
    *!*	          lcUCC9 = ""
    *!*	          = MESSAGEBOX('Packing list # '+ lcPACKNO + ", Carton # (" + ALLTRIM(STR(lcBOX_SER)) + ") hasn't a record in EDICRTSQ file, please refer to Aria.",16,_SCREEN.CAPTION)
    *!*	        ENDIF
    *!*	        lcUCC9 = EDICRTSQ.Ucc9
    *!*	      ENDIF
  Endif

  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
  Select EDICRTSQ
  If Deleted()
    Recall
  Endif
  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

  lcUCC9 = EDICRTSQ.Ucc9
  *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]

  Select (lcAlias)
  *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [END  ]

Case lnCRTSEQ_SETUP = '6'
  * UCC9 Format: Right 6 Digits of Packing list + 3 Digits From Carton Sequence Pad Left With '0'

  *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [BEGIN]
  lcAlias = Alias()
  Select EDICRTSQ

  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
  Set Deleted On
  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

  *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
  *!*	      IF llAdd AND !SEEK(lcPACKNO+STR(lcBOX_SER,6))
  If !Seek(lcPACKNO+Str(lcBOX_SER,6))
    *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]
    *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [END  ]

    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
    If !llFrmShp
      Set Deleted Off
      If !Seek(lcPACKNO+Str(lcBOX_SER,6))
        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]



        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
        *!*	        lcUCC9 = RIGHT(PADL(ALLTRIM(lcPACKNO),6,'0'),6)+PADL(lcBOX_SER,3,'0')
        lcUCC9 = Right(Padl(Alltrim(lcPACKNO),6,'0'),Iif(lnUCCMNFLEN = 7,13,12)-lnUCCMNFLEN)+Padl(lcBOX_SER,3,'0')
        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]

        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [BEGIN]
        Insert Into 'EDICRTSQ' (Pack_No,ACCOUNT,cart_no,Ucc9);
          VALUES (lcPACKNO,lcAccount,lcBOX_SER,lcUCC9)

        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
      Endif
    Else
      Messagebox("Pack# "+Alltrim(lcPACKNO)+" - Carton# "+Alltrim(Str(lcBOX_SER))+", not found in the carton sequence file, please refer to Aria with these information.",16+512,"Fatal Error!")
      lcUCC9 = ''
      Set Deleted &lcDel
      Return lcUCC9
    Endif
    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

    *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
    *!*	      ELSE
    *!*	        IF !SEEK(lcPACKNO+STR(lcBOX_SER,6))
    *!*	          lcUCC9 = ""
    *!*	          = MESSAGEBOX('Packing list # '+ lcPACKNO + ", Carton # (" + ALLTRIM(STR(lcBOX_SER)) + ") hasn't a record in EDICRTSQ file, please refer to Aria.",16,_SCREEN.CAPTION)
    *!*	        ENDIF
    *!*	        lcUCC9 = EDICRTSQ.Ucc9
    *!*	      ENDIF
  Endif

  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
  Select EDICRTSQ
  If Deleted()
    Recall
  Endif
  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

  lcUCC9 = EDICRTSQ.Ucc9
  *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]

  Select (lcAlias)
  *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L -Add these info within the EDICRTSQ also if doesn't exist- [END  ]

Case lnCRTSEQ_SETUP = '9'
  * UCC9 Format: No format, It Is Picked From EDICRTSQ.UCC9 Which Filled By A27 Packing Screens;
  *              Which Catched From EDIACPRT.UCC9 Sequence In Case Of The Account Is EDI Trading Partner;
  *              OTHERWISE Catched From Sequence At Allocation Module For EDI Carton Sequence.

  lcAlias = Alias()
  If !Used('EDICRTSQ')
    Use (oAriaApplication.DataDir+'EDICRTSQ') Order Tag PCKCRTSQ In 0
  Endif

  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
  Set Deleted On
  *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]



  If Seek(lcPACKNO+Str(lcBOX_SER,6),'EDICRTSQ')
    Select EDICRTSQ
    *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
    *!*	        lcUCC9 = PADL(ALLTRIM(EDICRTSQ.Ucc9),9,'0')
    lcUCC9 = Padr(Alltrim(EDICRTSQ.Ucc9),Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
    *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
    *B609151,1 WAM Add sequence number for this carton
  Else

    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
    If !llFrmShp
      Set Deleted Off
      If Seek(lcPACKNO+Str(lcBOX_SER,6),'EDICRTSQ')
        Select EDICRTSQ
        Recall
        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
        *!*	            lcUCC9 = PADL(ALLTRIM(EDICRTSQ.Ucc9),9,'0')
        lcUCC9 = Padr(Alltrim(EDICRTSQ.Ucc9),Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
        *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
      Else
        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
        *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
        *!*	        IF llAdd
        *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]
        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]

        If !Used('EDIACPRT')
          Use (oAriaApplication.DataDir+'EDIACPRT') Order Tag ACCFACT In 0
        Endif

        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
        *!*	        lcAccount = Pack_Hdr.ACCOUNT
        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]

        *-- If this customer is a partner , get the last Ucc # from EDIACPRT file,
        If Seek('A'+lcAccount,'EDIACPRT','ACCFACT')


          *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [begin]
          Do While !Rlock('EDIACPRT')
          Enddo
          *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [End]

          lnUcc9  = Iif(Empty(EdiAcPrt.Ucc9),0,Eval(EdiAcPrt.Ucc9)) + 1
          *B611631,1  BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[Begin]
          If lnUcc9 > 999999999
            lnUcc9  = 0
          Endif
          *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]


          *B611631,1  BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[Begin]
          **llFound = SEEK(lcAccount+PADL(lnUcc9,9,'0'),'EDICRTSQ','EDICRTSQ')
          llfound = Seek(Padl(lnUcc9,9,'0'),'EDICRTSQ','EDIUCCSQ')
          *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
          Do While llfound
            lnUcc9  = lnUcc9  + 1
            *E303469,1 RAS 2014-04-27 modi prg to modify the search performace at edicrtsq when setup of UCC# is [begin]
            *!*	          llFound = SEEK(lcAccount+PADL(lnUcc9,9,'0'),'EDICRTSQ')

            *B611631,1  BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[Begin]
            *!*llFound = SEEK(lcAccount+PADL(lnUcc9,9,'0'),'EDICRTSQ','EDICRTSQ')
            llfound = Seek(Padl(lnUcc9,9,'0'),'EDICRTSQ','EDIUCCSQ')
            *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]

            *E303469,1 RAS 2014-04-27 modi prg to modify the search performace at edicrtsq when setup of UCC# is [end]
          Enddo

          *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
          *!*	            INSERT INTO 'EDICRTSQ' (Pack_No,ACCOUNT,cart_no,Ucc9);
          *!*	              VALUES (lcPACKNO,lcAccount,lcBOX_SER,PADL(lnUcc9,9,'0'))
          *!*	            REPLACE Ucc9 WITH PADL(lnUcc9,9,"0") IN   'EDIACPRT'
          *!*	            lcUCC9 = PADL(lnUcc9,9,"0")
          *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
          *!*	        lnUCC9 = PADR(lnUCC9,IIF(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
          lnUcc9 = Padl(lnUcc9,Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
          *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
          Insert Into 'EDICRTSQ' (Pack_No,ACCOUNT,cart_no,Ucc9);
            VALUES (lcPACKNO,lcAccount,lcBOX_SER,Alltrim(lnUcc9))
          Replace Ucc9 With Alltrim(lnUcc9) In 'EDIACPRT'
          lcUCC9 = Alltrim(lnUcc9)
          *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]


          *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [begin]
          Unlock In('EDIACPRT')
          *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [End]



        Else    && Get the last Ucc # from EDICRTSQ file.
          *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
          *!*	            SELECT MAX(EDICRTSQ.Ucc9) FROM EDICRTSQ WHERE EDICRTSQ.ACCOUNT = lcAccount INTO CURSOR lcMaxUcc
          *!*	            SELECT lcMaxUcc
          *!*	            LOCATE

          Select EDICRTSQ
          lcOrd = Order()
          Set Order To EDICRTSQ Descending
          Locate For EDICRTSQ.ACCOUNT = lcAccount




          *!*	            IF EOF() OR ISNULL(lcMaxUcc.MAX_UCC9)
          If Eof()
            *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]
            *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
            *!*	              lcUCC9 = '000000001'
            *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
            *!*							lcUCC9 = Padr('000000001',Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
            lcUCC9 = Padl('000000001',Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
            *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
            *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
            *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
            Set Order To &lcOrd
            *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]
          Else


            *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [Begin]
            Do While!Rlock('EDICRTSQ')
            Enddo
            *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [End]
            *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
            *!*	              lcUCC9 = PADL(VAL(lcMaxUcc.MAX_UCC9)+1,9,'0')
            *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
            *!*	              lcUCC9 = PADL(ALLTRIM(STR(VAL(EDICRTSQ.UCC9)+1,9,0)),9,'0')
            *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
            *!*							lcUCC9 = Padr(Alltrim(Str(Val(EDICRTSQ.Ucc9)+1,9,0)),Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
            lcUCC9 = Padl(Alltrim(Str(Val(EDICRTSQ.Ucc9)+1,9,0)),Iif(lnUCCMNFLEN = 7,16,15)-lnUCCMNFLEN,'0')
            *B611631,1  , BYM, 2018-07-31 Modify Seeking in edicrtnsq to seek with UCC9 only not with account+UCC9 and change PadR() to PadL()[End]
            *E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
            Set Order To &lcOrd
            *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]
            *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [Begin]
            Unlock In('EDICRTSQ')
            *B611092,1 AEG 2015-12-14 Two diffrent packing lst have the same UCC9 [End]
          Endif
          Insert Into 'EDICRTSQ' (Pack_No,ACCOUNT,cart_no,Ucc9);
            VALUES (lcPACKNO,lcAccount,lcBOX_SER,lcUCC9)
        Endif




        *B609151,1 WAM (End)

        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [BEGIN]
        *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [BEGIN]
        *!*	        ELSE
        *!*	          lcUCC9 = ""
        *!*	          = MESSAGEBOX('Packing list # '+ lcPACKNO + ", Carton # (" + ALLTRIM(STR(lcBOX_SER)) + ") hasn't a record in EDICRTSQ file, please refer to Aria.",16,_SCREEN.CAPTION)
        *!*	        ENDIF
        *E302998,2 HES 27/11/2011 Make the lfGetUCC9 function works without the lADD new parameter [END  ]
        *! E302998,1 HES 27/11/2011 Change the way of getting the UCC9 while saving the P\L [END  ]

        *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
      Endif
    Else
      Messagebox("Pack# "+Alltrim(lcPACKNO)+" - Carton# "+Alltrim(Str(lcBOX_SER))+", not found in the carton sequence file, please refer to Aria with these information.",16+512,"Fatal Error!")
      lcUCC9 = ''
      Set Deleted &lcDel
      Return lcUCC9
    Endif
    *B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

  Endif
  Select (lcAlias)

Otherwise
  lcUCC9 = ''
  *=MESSAGEBOX('UCC # Structure Setup [AL Module Setup] Has Not Accepted Value [Accept 5,6,9], Carton Sequence Can Not Be Generated !!',0+16,_SCREEN.CAPTION)
  = Messagebox('Please setup the UCC # structure code from the Allocation Module setup screen in order to using the Bill Of Lading screen.',0+16,_Screen.Caption)
Endcase

*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [BEGIN]
Set Deleted &lcDel
*B609965,1 HES 06/18/2012 Fix bugs happened in scenario of creating the same P\L with the same ID [END  ]

*E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [BEGIN]
*!*	  RETURN(lcUCC9)
Return(Alltrim(lcUCC9))
*E303191,1 HES Make the UCC manf IF to be more flexiable regarding its length from 6 to 9 [END  ]
Endfunc

*:****************************************************************************************
*! Name      : EPCHEX
*! Developer : Walid Hamed [WLD]
*! Date      : 08/26/2008
*! Purpose   : Calculate and convert EPC code to HEX
*:****************************************************************************************
*! Called from : EDI.Prnlabel CLASS
*:****************************************************************************************
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
Function EPCHEX
Lparameters DataToEncode

Private EPCDataToEncode
EPCDataToEncode = DataToEncode
*--------------------------- Example of DataToEncode  ------------------------------------------------------------------
*DataToEncode = "~b00800110000~n0033~n0035~n0240400024~n020192243~n038*1"
* b00800110000 : 8 bit  Binary using 96 bit
* n0033        : Filter value 3 with Numeric length 3 digits
* n0035        : Partition value 5 with Numeric length 3 digits
* n0240400024  : Company Prefix value 0400024 with Numeric length 24 digits
* n020192243   : Item Ref value 192243 with Numeric length 20 digits
* n03801       : Serial value 01 with Numeric length 38 digits

* SGTIN              : 10400024922437 (1 Item Indicator ,04000 Comp Prefix,2492243 Item ,7 Chk Dgt)
* Filter             : 3
* Comp Prefix length : 7
* No. o bits Tag     : 96
* Serial             : 01

*Table 1. Electronic Product Code Headers
*10        64 SGTIN-64 where 10is header value in binary and 64 id bits
*0000 1000 64 SSCC-64
*0000 1001 64 GLN-64
*0011 0000 96 SGTIN-96
*0011 0001 96 SSCC-96
*0011 0010 96 GLN-96

*We use SGTIN-96

*Table 5. SGTIN Filter Values
*Type Binary Value
*All Others                           000
*Retail Consumer Trade Item           001
*Standard Trade Item Grouping         010
*Single Shipping/ Consumer Trade Item 011
*We will use Single Shipping/ Consumer Trade Item Filter= 3 so value will be = 011

*row 0  1 2 3 4 5 6 : partition
*col1 Partition
*col2 cmpPrfx  M Bits
*col3 cmpPrfx  L length digits
*col4 item ref N Bits
*col5 item ref   digits

**Table 7. SGTIN-96 Partitions.
*!*	Partition Value      Company Prefix           Item Reference and Indicator Digit
*!*	    (P)            Bits (M)  Digits (L)              Bits (N)      Digits
*!*		0 				40 		12 				   4 			 1
*!*		1 				37 		11 				   7 			 2
*!*		2 				34 		10 				   10 			3
*!*		3 				30 		9 			 	   14 			4
*!*		4 				27 		8 			 	   17 			5
*!*		5 				24 		7 					20 			6
*!*		6 				20 		6 					24 			7
*----------------------------------------------------------------------------------------------------------------------
*Main Program for Endcoding Data
Store "" To Builder
Private Length As Integer
Length  = Len(EPCDataToEncode)
Dimension chArray(Length)
For i =1 To Length
  Store  Substrc(EPCDataToEncode,i,1) To chArray[i]
Endfor

For i = 1 To Length

  Private num3,num4 As Integer
  num3 = Asc(chArray[i])
  num4=0
  If ((i + 1) < Length)
    num4 = Asc(chArray[i+1])
  Endif

  If (((num3 == 126) And  (i < (Length - 5))) And  ((((((((((num4 == 98) Or  (num4 == 100)) Or  (num4 == 110)) Or  (num4 == 120)) Or  (num4 == 116)) Or  (num4 == 66)) Or  (num4 == 68)) Or (num4 == 78)) Or (num4 == 84)) Or  (num4 == 88)))
    Private desiredLength As Integer
    desiredLength = Val(Substr(EPCDataToEncode,i+2,3))
    If ((desiredLength < 1000) And  (desiredLength > 0))
      Do Case
      Case (num4=98 Or num4=66)
        Private index1 As Integer
        index1=i+5
        Do While ((index1 < Length) And  ((chArray[index1] == '0') Or  (chArray[index1] == '1')))
          index1=index1+1
        Enddo
        Private inString As String
        inString = Substr(EPCDataToEncode,i + 5,index1 - (i + 5))
        inString = Padl(inString, desiredLength,'0')
        Builder=Builder+inString
        i = index1 - 1
      Endcase
      If ((num4 == 100) Or (num4 == 68))
        i =i+5
      Endif
      If ((num4 == 110) Or (num4 == 78))
        Private num7 As Integer
        num7 = i + 5
        Do While (((num7 <= Length) And  (chArray[num7] > '/')) And  (chArray[num7] < ':'))
          num7=num7+1
        Enddo
        Private decInput,str3 As String
        decInput = Substr(EPCDataToEncode , i + 5 , num7 - (i + 5))
        Store "" To lcBin
        str3 = ConvertDecStringToBinString(decInput)
        decInput = Padl(str3, desiredLength,'0')&& CheckStringLength(str3, desiredLength)
        Builder=Builder+decInput
        i = num7 - 1
      Endif
      If ((num4 == 120) Or (num4 == 84))
        Private num8 As Integer
        num8 = 0
        If ((desiredLength % 4) == 0)
          num8 = desiredLength / 4
        Else
          num8 = 1 + (desiredLength / 4)
        Endif
        Private hexInput As String
        hexInput = Substr(EPCDataToEncode,i + 5, num8)
        hexInput = ConvertHexStringToBinString(hexInput)
        hexInput = Padl(hexInput, desiredLength,'0') && CheckStringLength(hexInput, desiredLength)
        Builder=Builder + hexInput
        If ((desiredLength % 4) == 0)
          i = i +  4 + (desiredLength / 4)
        Else
          i = i +  5 + (desiredLength / 4)
        Endif
      Endif
      If ((num4 == 116) Or (num4 == 84))
        Private num9 As Integer
        num9 = i + 5
        Do While (((num9 < Length) And  (chArray[num9] != '~')) And ((chArray[num9] > '\x0001') And (chArray[num9] < '\x00ff')))
          num9=num9+1
        Enddo
        Private str5,str6 As String
        str5 = Substr(EPCDataToEncode,i + 5, num9 - (i + 5))
        str6 = ConvertHexStringToBinString(ConvertTextStringToHex(str5))
        str5 = Padl(str6, desiredLength,'0') && CheckStringLength(str6, desiredLength)
        Builder= Builder+str5
        i = num9 - 1
      Endif
    Else
      If ((num4 == 48) Or  (num4 == 49))
        Builder=Builder + chArray[i]
      Endif
    Endif

  Else
    If ((num3 == 48) Or  (num3 == 49))
      Builder= Builder+chArray[i]
    Endif
  Endif
Endfor

lcEPCHEX=  ConvertBinStringToHexString(Builder)
Return(lcEPCHEX)
Endfunc
*:****************************************************************************************
*Convert Decimal String to binary main function
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
Function ConvertDecStringToBinString
Parameters chartoconvert
Store 0 To X,N
If(Vartype(chartoconvert )== 'C')
  X=Val(chartoconvert)
Else
  X=chartoconvert
Endif
If (X/2 == 0)
  Return lcBin && returns the last digit in the binary number
Else
  N = X%2 && converting
  lcBin = Alltrim(Str(N)) +lcBin
  X = Int(X/2) && continue converting
  Return ConvertDecStringToBinString(@X) && recursive step
Endif
Endfunc
*******************************************************************************************************************
*Main function to convert binary string to hex string
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
Function  ConvertBinStringToHexString
Parameters binInput
Store "" To  cstr,builder1
Store Len(binInput) To  length1
If ((length1 % 4) != 0)
  Padl(binInput,4 - (length1 % 4),'0')
Endif
For i=Len(binInput) To 0 Step -1
  If (i >= 3)
    Store Substr(binInput,i - 3, 4) To str3
    builder1 = Dec2BasX(Bin2Dec(str3), 16)  + builder1
    i = i - 3
  Endif
Endfor
Return builder1
Endfunc
*******************************************************************************************************************
*..............................................................................
*   Function: DEC2BASX
*    Purpose:  Convert whole number 0-?, to base 2-16
*
* Parameters: nTempNum - number to convert (0-9007199254740992)
*             base    - base to convert to i.e., 2 4 8 16...
*    returns: string
*      Usage:  cresult=Dec2BasX(nParm1, nParm2)
*              STORE Dec2BasX(255, 16) TO cMyString  &&... cMyString contains 'ff'
*..............................................................................
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
Function Dec2BasX
Parameters nTempNum, nNewBase

Store 0 To nWorkVal,remainder,dividend,nextnum,digit

nWorkVal = nTempNum
ret_str = ''

Do While .T.
  digit = Mod(nWorkVal, nNewBase)
  dividend = nWorkVal / nNewBase
  nWorkVal = Int(dividend)

  Do Case
  Case digit = 10
    ret_str = 'a' + ret_str
  Case digit = 11
    ret_str = 'b' + ret_str
  Case digit = 12
    ret_str = 'c' + ret_str
  Case digit = 13
    ret_str = 'd' + ret_str
  Case digit = 14
    ret_str = 'e' + ret_str
  Case digit = 15
    ret_str = 'f' + ret_str
  Otherwise
    ret_str = Ltrim(Str(digit)) + ret_str
  Endcase
  If nWorkVal = 0
    Exit
  Endif
Enddo
Return ret_str
Endfunc
*******************************************************************************************************************
*   Function: bin2dec
*    Purpose: convert binary string to decimal number
* Parameters: pbinnum - string to convert i.e.,
*   '0' - '11111111111111111111111111111111111111111111111111111'
*   '0' - (53 1's)
*    returns: integer data type
*      Usage: nresult = Bin2Dec(cParm1)
*             STORE Bin2Dec('11111111') TO nMyNum &&... nMyNum contains 255
*..................................................................
*E302545,1 WLD Calculate and convert EPC code to HEX (RFID) 08/27/2008
Function Bin2Dec
Parameters pbinnum
Private retval, bindex

Store 0 To retval
pbinnum = Alltrim(pbinnum)
Store Len(pbinnum) To nDigits
For bindex = 0 To nDigits
  If Substr(pbinnum, nDigits - bindex, 1) = '1'
    retval = retval + 2^bindex
  Endif
Next
Return Int(retval)
Endfunc
*!**************************************************************************
*! Name      : GetPathMapDrv
*! Developer : Walid Hamed
*! Date      : 03/08/2009
*! Purpose   : Wrapper to the API call that converts a mapped drive path to the UNC path
*!**************************************************************************
*! Call From : EBReceive.EDI SendTransaction.EDI
*!**************************************************************************
*! Param(s)  :  tcMappedPath : Mapped drive
*!**************************************************************************
*! Returns   : Mapped Drive path
*!**************************************************************************
*! Example   : = GetPathMapDrv(H:)
*!**************************************************************************

Function GetPathMapDrv
Lparameters tcMappedPath, tnBufferSize

* from winnetwk.h
#Define UNIVERSAL_NAME_INFO_LEVEL 0x00000001
#Define REMOTE_NAME_INFO_LEVEL 0x00000002

* from winerror.h
#Define NO_ERROR 0
#Define ERROR_BAD_DEVICE 1200
#Define ERROR_CONNECTION_UNAVAIL 1201
#Define ERROR_EXTENDED_ERROR 1208
#Define ERROR_MORE_DATA 234
#Define ERROR_NOT_SUPPORTED 50
#Define ERROR_NO_NET_OR_BAD_PATH 1203
#Define ERROR_NO_NETWORK 1222
#Define ERROR_NOT_CONNECTED 2250

* local decision - paths are not likely to be longer than this - if they are, this function calls itself
* recursively with the appropriate buffer size as the second parameter
#Define MAX_BUFFER_SIZE 500

* string length at the beginning of the structure returned before the UNC path ACC changed to 0 before - Now using
* WnetGetConnection which uses a string rather than a struct
#Define STRUCTURE_HEADER 0

Local lcReturnValue

If Type('tcMappedPath') = "C" And ! Isnull(tcMappedPath)
  * split up the passed path to get just the drive
  Local lcDrive, lcPath
  * just take the first two characters - we'll put it all back together later. If the first two
  * characters are not a valid drive, that's OK. The error value returned from the function call will handle it.

  * case statement ensures we don't get the "cannot
  * access beyond end of string" error
  Do Case
  Case Len(tcMappedPath) > 2
    lcDrive = Left(tcMappedPath, 2)
    lcPath = Substr(tcMappedPath, 3)
  Case Len(tcMappedPath) <= 2
    lcDrive = tcMappedPath
    lcPath = ""
  Endcase

  Declare Integer WNetGetConnection In WIN32API ;
    STRING @lpLocalPath, ;
    STRING @lpBuffer, ;
    INTEGER @lpBufferSize

  * set up some variables so the appropriate call can
  * be made
  Local lcLocalPath, lcBuffer, lnBufferSize, ;
    lnResult, lcStructureString

  * set to +1 to allow for the null terminator
  lnBufferSize = Iif(Pcount() = 1 Or Type('tnBufferSize') # "N" Or Isnull(tnBufferSize), ;
    MAX_BUFFER_SIZE, ;
    tnBufferSize) + 1

  lcLocalPath = lcDrive
  lcBuffer = Space(lnBufferSize)

  * now call the dll function
  lnResult = WNetGetConnection(@lcLocalPath, @lcBuffer, @lnBufferSize)

  Do Case
    * string translated sucessfully
  Case lnResult = NO_ERROR
    * Actually, this structure-stripping is no longer required because WnetGetConnection() returns a
    * string rather than a struct
    lcStructureString = Alltrim(Substr(lcBuffer, STRUCTURE_HEADER + 1))
    lcReturnValue = Left(lcStructureString, ;
      AT(Chr(0), lcStructureString) - 1) + lcPath

    * The string pointed to by lpLocalPath is invalid.
  Case lnResult = ERROR_BAD_DEVICE
    lcReturnValue = tcMappedPath

    * There is no current connection to the remote
    * device, but there is a remembered (persistent)
    * connection to it.
  Case lnResult = ERROR_CONNECTION_UNAVAIL
    lcReturnValue = tcMappedPath

    * A network-specific error occurred. Use the
    * WNetGetLastError function to obtain a description
    * of the error.
  Case lnResult = ERROR_EXTENDED_ERROR
    lcReturnValue = tcMappedPath

    * The buffer pointed to by lpBuffer is too small.
    * The function sets the variable pointed to by
    * lpBufferSize to the required buffer size.
  Case lnResult = ERROR_MORE_DATA
    lcReturnValue = getuncpath(tcMappedPath, lnBufferSize)

    * None of the providers recognized this local name
    * as having a connection. However, the network is
    * not available for at least one provider to whom
    * the connection may belong.
  Case lnResult = ERROR_NO_NET_OR_BAD_PATH
    lcReturnValue = tcMappedPath

    * There is no network present.
  Case lnResult = ERROR_NO_NETWORK
    lcReturnValue = tcMappedPath

    * The device specified by lpLocalPath is not
    * redirected.
  Case lnResult = ERROR_NOT_CONNECTED
    lcReturnValue = tcMappedPath
  Otherwise
    lcReturnValue = tcMappedPath
  Endcase
Else
  lcReturnValue = tcMappedPath
Endif

Return lcReturnValue
Endfunc
*!**************************************************************************
*! Name      : lfOpen_SQL_File
*! Developer : Walid Hamed
*! Date      : 08/02/2010
*! Purpose   : Open SQL file and return file name
*!**************************************************************************
*! Call From :
*!**************************************************************************
*! Param(s)  :  lcSelString  : Select statement
*!              lcFile_name  : File name
*!     		  lcIndex_expr : Index Expr
*!     	      lcTagName    : Index Tag name
*!**************************************************************************
*! Returns   : Return file name
*!**************************************************************************
*! Example   : =lfOpen_SQL_File("SELECT File_Type,Description FROM E_FILES_TYPES_T",'E_FILES_TYPES_T','File_Type','FileType')
*!**************************************************************************
*:->
*N000649,1 WLD Open SQL File 08/02/2010
Function lfOpen_SQL_File
Lparameters lcSelString,lcFile_name,lcIndex_expr,lcTagName

lnConnectionHandlar = 0
If oAriaApplication.isRemoteComp  And !Empty(lcSelString)
  lcSetClass = Set('CLASSLIB')
  Set Classlib To (oAriaApplication.lcAria4Class+"MAIN.VCX"),(oAriaApplication.lcAria4Class+"UTILITY.VCX")
  lnConnectionHandlar = oAriaApplication.RemoteCompanyData.sqlrun(lcSelString ,lcFile_name,lcFile_name,;
    oAriaApplication.ActiveCompanyConStr,3,'BROWSE',Set("DATASESSION"))

  Set Classlib To &lcSetClass.
  If lnConnectionHandlar = 1
    Select (lcFile_name)
    =CursorSetProp("Buffering" ,3,lcFile_name)
    If !Empty(lcIndex_expr)
      If Type('lcTagName') = 'C' And !Empty(lcTagName)
        lcIndex_expr = 'INDEX ON '+lcIndex_expr + ' TAG '+ lcTagName
      Else
        lcIndex_expr = 'INDEX ON '+lcIndex_expr + ' TAG '+lcFile_name
      Endif
      &lcIndex_expr.
    Endif
    =CursorSetProp("Buffering" ,5,lcFile_name)
  Else
    lcResult = oAriaApplication.RemoteCompanyData.CheckRetResult('Execute',lnConnectionHandlar,.F.)
  Endif
Endif
Return Alltrim(Str(lnConnectionHandlar,2))
Endfunc
*******************************************************************************************************************

***************************************************************
** E303226,1 RAS 2012-09-02 Add Function That Seek PO1 Data
** depended on PO1 Qualifiers
**
**
****************************************************************
Function GetPO1Value
Lparameters lcQualifier, laPO1Arrary

lcValue =''
lnPO1Elements = Alen(laPO1Arrary)
For lnCount = 6 To lnPO1Elements Step 2
  If laPO1Arrary[lnCount] = lcQualifier
    lcValue = laPO1Arrary[lnCount+1]
    Exit
  Endif
Endfor

Return lcValue

*!* E303478,1 HES 06/11/2014 Add functions to help to open DBF tables to use it when needed in SYCEDIXP or any other places [START]
*!**************************************************************************
*! Name      : lfRunMacro
*! Developer : Hesham Elmasry
*! Date      : 06/11/2014
*! Purpose   : Run a macro on the passed parameter and return empty string.
*!**************************************************************************
Function lfRunMacro
Lparameters lcString
* This passed parameters should be tested carefully
lcAlias = Alias()
Select 0
&lcString
If !Empty(lcAlias)
  Select (lcAlias)
Endif
Return ""
Endfun

*!***********************************************************************************************
*! Name      : gfOpenFile
*! Developer : Hesham Elmasry (Copied from Aria4XP one)
*! Date      : 06/11/2014
*! Purpose   : To open a DBF file and set its index as required then gives it an alias if needed.
*!***********************************************************************************************
*! Calls     : None
*!*************************************************************************
*! Passed Parameters  : File Name, Index Tag,
*!                          Open Mode "EX" ----> "EXCLUSIVE"
*!                                    "SH" ----> "SHARED"
*!*************************************************************************
*! Returns            :  True  ----> If passed file is open by this function
*!                       False ----> If passed file is already open.
*!*************************************************************************
*! Example            : =gfOpenFile(QDD+'ORDHDR',QDD+'ORDHDR','SH')
*!*************************************************************************
Function GFOPENFILE
Parameters NFILE,LCINDEX,MODE,LCALIASNAM,LLFORCEOP
Private MODE,LCFILENAME,lcPath,LLRETURNVAL,LCMSG,LCSETEXACT

Private LCMACROSUB
LCMACROSUB=""
LCFILENAME = Iif(Atc('\',NFILE)<>0,Substr(NFILE,Rat('\',NFILE)+1),NFILE)
LCOPENMODE = Iif(Type('MODE')='C' And MODE='EX', "EXCLUSIVE", "SHARED")
LCORDERTAG = Iif(Type('lcIndex')='C',Substr(LCINDEX,Iif('\' $ LCINDEX,Atc('\',LCINDEX,Occurs('\',LCINDEX)),0) +1),'')

Private LLOPEN
LLOPEN = .F.

LCALIASNAM = Iif(Type('lcAliasNam')#'C' Or Empty(LCALIASNAM),Alltrim(Strtran(Upper(LCFILENAME),".DBF")),LCALIASNAM)

LCMSG = 'Opening '+NFILE+Iif(Empty(LCINDEX),'', ' Index Tag '+LCORDERTAG)+'....'
LCMSG = Proper(LCMSG)
If 'SCREEN' $ Sys(101)
  Set Message To LCMSG
Endif
LLRETURNVAL = .T.
LCFPATHST   = Set('FULLPATH')
Set Fullpath On
If Used(LCALIASNAM)
  LCOPENMODE = "SHARED"
  *-- if the file is used and it is from the same data directory
  If Dbf(LCALIASNAM) == Alltrim(Strtran(Upper(NFILE), ".DBF") + ".DBF")
    *-- if forced open is desired
    If LLFORCEOP
      LCALIASNAM  = GFTEMPNAME()
      LCMACROSUB="USE (NFILE) ALIAS (lcAliasNam) AGAIN IN 0 &lcOpenMode"
      &LCMACROSUB
      LLOPEN = .T.
      If !Empty(LCORDERTAG)
        Set Order To Tag LCORDERTAG In (LCALIASNAM)
      Endif    &&IF !EMPTY(lcOrderTag)
    Else
      *-- if forced open is not desired
      LLRETURNVAL = .F.
      *-- if there is no tag is desired to set order to
      If Empty(LCORDERTAG)
        Set Order To 0 In (LCALIASNAM)
      Else
        Set Order To Tag LCORDERTAG In (LCALIASNAM)
      Endif   &&IF EMPTY(lcOrderTag)
    Endif     &&IF llForceOp
  Else
    *-- if the file is used but not from the same data directory
    LCALIASNAM  = GFTEMPNAME()
    LCMACROSUB="USE (NFILE) ALIAS (lcAliasNam) AGAIN IN 0 &lcOpenMode"
    &LCMACROSUB
    LLOPEN = .T.
    If !Empty(LCORDERTAG)
      Set Order To Tag LCORDERTAG In (LCALIASNAM)
    Endif  &&IF !EMPTY(lcOrderTag)
  Endif   &&IF DBF(lcFilename) == .......
Else
  *-- if the file is not used

  LCMACROSUB = "USE (NFILE) ALIAS (lcAliasNam) AGAIN IN 0 &lcOpenMode"
  &LCMACROSUB
  LLOPEN = .T.
  If !Empty(LCORDERTAG)
    Set Order To Tag LCORDERTAG In (LCALIASNAM)
  Endif    &&IF !EMPTY(lcOrderTag)
Endif    &&IF IF USED(lcFilename)
Select (LCALIASNAM)
Set Fullpath &LCFPATHST
If 'SCREEN' $ Sys(101)
  Set Message To ""
Endif
Return LLRETURNVAL
*!* E303478,1 HES 06/11/2014 Add functions to help to open DBF tables to use it when needed in SYCEDIXP or any other places [END  ]

*!***********************************************************************************************
*! Name           : GFSETINDEX
*! Developer      : Mahmoud Elderby
*! Date           : 08/07/2017
*! Purpose        : Create Indexs for a specific table based on SYDINDX .
*! Tracking Entry : E303856
*! Project Number : P20170806.0001
*!***********************************************************************************************
*! Calls     : None
*!*************************************************************************
*! Passed Parameters  : File Name
*!
*!*****************************************************************************
*! Returns            :  -1  ----> Given TableName is not used.
*!                        0  ----> Given table has no index found on SYDINDEX
*!                        n  ----> Given table has number of index set to table
*!*****************************************************************************
*! Example            :   lcIndCount=GFSETINDEX('SYCEDIXP')
*!*****************************************************************************
Function GFSETINDEX
Parameters lcTableName
Local lcTempAlias,lcIndexCount,lcIndexExpression,lcIndexTag
lcTableName = Upper(lcTableName)
If Used(lcTableName)
  lcTempAlias=Alias()
  lcIndexCount=0
  If !Used('SYDINDEX')
    Use (oAriaApplication.SysPath+ 'SYDINDEX') In 0 Shared
  Endif
  Select SYDINDEX
  Set Order To CFILE
  =Seek(lcTableName,'SYDINDEX','CFILE')

  Scan Rest While cfile_nam=Alltrim(lcTableName)
    Select (lcTableName)
    lcIndexExpression = Alltrim(SYDINDEX.Cindx_exp)
    lcIndexTag = Alltrim(SYDINDEX.Cfile_tag)
    Index On &lcIndexExpression Tag (lcIndexTag)  Additive
    lcIndexCount=lcIndexCount+1
  Endscan
  Select (lcTempAlias)
  Return lcIndexCount
Else
  Return -1
Endif



*!***********************************************************************************************
*! Name           : LFUOMConvert
*! Developer      : Mohamed Baiomy
*! Date           : 03/10/2018
*! Purpose        : Convert UOM from one type to another
*! Tracking Entry : E304069
*! Project Number : T20180831.0028
*!***********************************************************************************************
*! Calls     : None
*!*************************************************************************
*! Passed Parameters  : File Name
*!
*!*****************************************************************************
*! Returns            :  MVOLUME or the converted value
*!*****************************************************************************
*! Example            :     MVOLQIN = LFUOMConvert('IN', MVOLUME, 'QIN')
*!*****************************************************************************
Function LFUOMConvert
Parameters MPKUOM ,MVOLUME, MVOLUOM


Do Case

Case  MPKUOM = 'IN' .And. MVOLUOM = 'QIN'
  Return MVOLUME

Case  MPKUOM = 'FT' .And. MVOLUOM = 'QFT'
  Return MVOLUME

Case  MPKUOM = 'CM' .And. MVOLUOM = 'QCM'
  Return	MVOLUME

Case  MPKUOM = 'IN' .And. MVOLUOM = 'QCM'
  Return MVOLUME * 16.387064

Case  MPKUOM = 'FT' .And. MVOLUOM = 'QIN'
  Return MVOLUME * 1728



Case  MPKUOM = 'FT' .And. MVOLUOM = 'QCM'
  Return MVOLUME * 28316.846


Case  MPKUOM  = 'IN' .And. MVOLUOM = 'QFT'
  Return MVOLUME / 1728

Case  MPKUOM = 'CM' .And. MVOLUOM = 'QIN'
  Return MVOLUME / 16.387064

Case  MPKUOM = 'CM' .And. MVOLUOM = 'QFT'
  Return MVOLUME / 28316.846
Endcase

