*E301175,1 HS  12/30/1998 Add the capability to call the sales order Save
*E301175,1                and Delete functions from the EDI
*E301175,1                - from EDIProcessPO Class -
*B602496,1 WAM 02/18/1999 Update the order record in the uncmsess file
*B602555,1 WAM 02/19/1999 Check if any POs/C/Ts have been assigned to the
*B602555,1                bulk order. If any, Release allocation from the
*B602555,1                bulk order and allocate them to the newly received
*B602555,1                distribution order.
*E301077,5 WAM 02/28/1999 Inhance openning files to speed up transaction
*B602674,1 HS  03/17/1999 fix the bug "Variable llFromEDI not found"
*E301182,1 WAM 03/23/1999 Update CT/PO line number in the CUTPICK file.
*B602753,1 HDM 04/07/1999 Stop Calling NotePad Program In lpSavScr as the global save
*B602753,1 HDM 04/07/1999        Will Call it
*B602826,1 TAK 04/26/1999 Fixed wrong check on piktkt in canceling order.
*B802131,1 TAK 05/12/1999 Fix the program does not update the dates in Ordline.
*B602952,1 TAK 05/12/1999 Fix the wrong updating of Order Qty in Style and StyDye
*B602952,1                files if the style code was changed in the order line.
*C101557,1 TAK 06/08/1999 Added a new code for Order Category in summary folder.
*C200081,1 Reham On 06/29/1999
*C200081,1 1- Add an event for the save function for the entire order process.
*C200081,1 2- Add an event to restore the allocation amount from the order header
*C200081,1    into its row in the user defined fields array.
*E301288,1 Reham On 07/20/1999
*E301288,1 1- Validate filling the style positions for all the lines.
*E301288,1 2- Save the style positions in the BOMVAR file.
*C200089,1 Reham On 07/22/1999
*C200089,1 1- Add an event if status changed to "Open"
*C200089,1 2- Add an event if status changed to "On Hold"
*C200089,1 3- Add an event if there is modifications in the sales order info.
*B802366,1 AMM 08/18/1999 Adjust the ship via POPUP in case of multi store orders
*E301305,1 AMM 08/25/1999 Make the complete date per order line due to a system setting
*E500309,1 AMM 01/23/2000 Deduct bulk order quantity from the booked quantity due to a system setting
*C200556,1 SSH Addt Trigger for GMA to Assign Sales Order # the same web order number.
*B607436,1 TMI 07/30/2003 Overcome the error "Numeric overflow"
*E037853,1 HBG 16/02/2004 Change the width of Key field in EDITRANS to 40 char
*E038729,1 WAM 11/11/2004 Maintain SQL tables
*E038463,1 WAM 11/15/2004 Update configuration WIP & WO
*E302709,1 HES 07/20/2010 Add new 850 record for (Customer\Factor) AND new 865 in EDI transaction file [T20100503.0026]
*E302931,1 RAS 07/07/2011 prevent add row for 865 in editrans table as it already has been added from edipo class[T20110407.0041]
*E302953,1 RAS 08/08/2011 make 860 cancel the order if it delete the only order line[T20110803.0033]
*E303199,1 RAS 07-17-2012 modi prg to consider existing of start date for each line [T20120626.0212]
*B610083,1 RAS 09/16/2012 solve bug of canceling the order on no changes [T20120626.0212]
*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017]
*E303266,1 RAS 10/01/2012 show 860 cancel message depend on Setup at partner screen [T20120830.0030]
*E303278,1 RAS 10/17/2012 show descriptive message in case of invalid period before get out [T20121002.0018]
*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [T20121025.0002]
*E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [T20121101.0008]
*E303340,1 RAS 11/22/2012 store the Cancel line releated to release order not Bulk order [T20121205.0009]
*E303411,1 RAS 08/28/2013 make the same effect on open and book quantity at bulk orders on receving release orders [T20121226.0001]
*B610606,1 RAS 11/27/2013 solve bug set deleted on before apply effect on all deleted lines [T20131106.0014]
*B610606,2 RAS 12/2/2013 solve bug not update bulk order header by add -ve values [T20121226.0001]
*B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [T20131226.0026]
*E303469,1 RAS 2014-04-27 modi prg to handle delete all order items then add an item[T20131219.0020]
*B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[T20140922.0059]
*B611034,1 AEG 2015-07-29 overide ordline style description only if empty when updating 860 [T20150630.0004]
*B611136,1 Ras 2016-04-04 solve bug not saving lines due to new line no [T20160229.0008]
*E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [T20160316.0004]
*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [T20160429.0008]
*E303788,1 Sara.N 2017-06-04 "CA" quaifier Doesn't change the Store and lines are duplicated  T20170222.0021
*E303813,1 Foda 05/11/2017 add option to make the EDI orders get another sequence of ERP orders [P20170425.0001]
*B611389,1 AEG 08/17/2017 reverse fix E303788 in order to not delete store in 860 [T20170810.0027]
*B611392,1 AEG 08/20/2017 change line number type to open when adding new order line [T20170810.0027]
*E303886,1 Derby 26/11/2017 - SALES ORDER APPROVAL/ORDER STATUS [T20171027.0002]
*E303887,1 FODA 12/07/2017 05 replace qualifier in BCH01 is not supported in 860 [T20170824.0050]
*B612293,1 HIA 12/16/2020 add silent mode feature
*!*************************************************************
*! Name      : lfSavScr
*! Developer : WAM
*! Date      : 07/01/1996
*! Purpose   : Save new or modified order
*!*************************************************************
*! Calls     : None
*!*************************************************************
*! Passed Parameters  :  None
*!*************************************************************
*! Returns            :  None
*!*************************************************************
*! Example            :  =lfSavScr()
*!*************************************************************
Function lfSavScr

*E301175,1 Add this line to add a new parameter to know if the function was
*          called from EDI - from EDI transaction 860
*          (Purchase Order Modify) -. [Begin]
*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*PARAMETERS llFromEDI
Parameters llFromEDI, llSilent
*B612293,1 HIA 12/16/2020 add silent mode feature [End]

*B611389,1 AEG 08/17/2017 reverse fix E303788 in order to not delete store in 860 [BEGIN]
*!*	*E303788,1 Sara.N "CA" quaifier Doesn't change the Store and lines are duplicated  T20170222.0021 [Start]
*!*	IF SEEK('T'+EDILIBDT.cEDITranNo,'ORDHDR','ORDHDR') and EDILIBDT.cEDITrnTyp = '860'
*!*	  laData[3] = ordhdr.store && Change ordhdr store for 860 if Single Store and "CA" qualifer Come
*!*	ENDIF
*!*	*E303788,1 Sara.N "CA" quaifier Doesn't change the Store and lines are duplicated  T20170222.0021 [End]
*B611389,1 AEG 08/17/2017 reverse fix E303788 in order to not delete store in 860 [END]

llFromEDI = Iif(Type('llFromEDI') = 'L' , llFromEDI , .F.)

*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
lcLogCont='Entertred lfSavScr function in SOUPDATE PRG '+Chr(13)+Chr(10)
lcLogCont=lcLogCont+'llFromEDI  is# '+Iif(llFromEDI,'TRUE','FALSE')+Chr(13)+Chr(10)
Strtofile(lcLogCont,lcLog,1)
*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

*E301175,1 Add this line to add a new parameter to know if the function [End]

Private lnCanBulk,lnCancel,lnCancelAmt,lnLineCount,lcHdrAlo,lcDetAlo,;
  lcBulkYear,lcBulkPrd

*B610083,1 RAS 09/16/2012 initalize lcHdrStatus variable to solve bug of canceling the order on no changes [begin]
*!*	  STORE ' ' TO lcBulkYear,lcBulkPrd
Store ' ' To lcBulkYear,lcBulkPrd,lcHdrStatus
*B610083,1 RAS 09/16/2012 initalize lcHdrStatus variable to solve bug of canceling the order on no changes [end]

*jica
*IF !SEEK(lcOrdType,lcOrdLine) .OR. laData[41] = 0
*E303887,1 FODA 12/07/2017 05 replace qualifier in BCH01 is not supported in 860 [BEGIN]
*IF !INLIST(&lcOrdHdr..Mon_Flg,'G','L') AND (!SEEK(lcOrdType,lcOrdLine) .OR. laData[41] = 0)
If !Inlist(&lcOrdHdr..Mon_Flg,'G','L' , 'R') And (!Seek(lcOrdType,lcOrdLine) .Or. laData[41] = 0)
  *E303887,1 FODA 12/07/2017 05 replace qualifier in BCH01 is not supported in 860 [END]
  *E300420,1 Message : 32044
  *E300420,1 No lines entered! No updates performed.
  *E300420,1 Button : 00000
  *E300420,1 Ok

  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *=gfModalGen('TRM32044B00000','DIALOG')
  If !llSilent
    =gfModalGen('TRM32044B00000','DIALOG')
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  llcSave = .F.
  Select (Iif(lnActFolder=2,lcOrdLine,lcOrdHdr))
  Return
Endif
If laData[34] <=0
  *E300420,1 Message : 32028
  *E300420,1 The exchange rate must be greater than zero
  *E300420,1 Button : 00000
  *E300420,1 Ok

  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *=gfModalGen('TRM32028B00000','ALERT')
  If !llSilent
    =gfModalGen('TRM32028B00000','ALERT')
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  llcSave = .F.
  Select (Iif(lnActFolder=2,lcOrdLine,lcOrdHdr))
  Return
Endif
*B607436,1  TMI [Start] Overcome the error "Numeric overflow"
If lfDivByZr()
  llcSave = .F.
  Return
Endif
*B607436,1  TMI [End  ]
If lcOrdType='O' .And. laData[5]<>'B' .And. !CHECKPRD(laData[8],'lcGlYear','lcGlPeriod','',.T.)
  Store Space(4) To lcGlYear
  Store Space(2) To lcGlPeriod
Endif
If lcOrdType='O' .And. laData[5]<>'B' .And. laScrMode[4] .And. Seek(lcOrdType+&lcOrdHdr..cFromOrder,'OrdHdr')
  =CHECKPRD(OrdHdr.Entered,'lcBulkYear','lcBulkPrd','',.T.)
Endif
Set Order To Tag 'ORDHDR' In 'ORDHDR'
Set Order To Tag 'ORDLINE' In 'ORDLINE'

*E301288,1 Reham On 07/20/1999   *** Begin ***
If llBomVarnt .And. !lfStyPos()
  *** You have to fill the missing fields for the styles positions ***
  *** before saving, or you have to delete the related order line. ***
  *** <  OK  > ***


  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *=gfModalGen('TRM32072B00000','DIALOG')
  If !llSilent
    =gfModalGen('TRM32072B00000','DIALOG')
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  llcSave = .F.
  Return .F.
Endif
*E301288,1 Reham On 07/20/1999   *** End   ***

*C200081,1 Reham On 06/29/1999  *** Begin ***
*C200081,1 If there are user fields for this order, Call process Id to
*C200081,1 execute function before saving the entire order.
If Ascan(laEvntTrig , Padr('ORD_SAV',10)) <> 0
  llReturn = gfDoTriger('SOORD',Padr('ORD_SAV',10))
  If !llReturn
    llcSave = .F.
    Return .F.
  Endif
Endif
*C200081,1 Reham On 06/29/1999  *** End   ***

*C200081,1 Reham On 06/29/1999  *** Begin ***
*C200081,1 If there are user fields for this order, Call process Id to
*C200081,1 execute function before saving the entire order.
If Ascan(laEvntTrig , Padr('ALO_RES',10)) <> 0
  llReturn = gfDoTriger('SOORD',Padr('ALO_RES',10))
Endif
*C200081,1 Reham On 06/29/1999  *** End   ***

*C200089,1 Reham On 07/22/1999  *** Begin ***
If laScrMode[3]
  Do Case
    *C200089,1 If the order status changed to "Open"
  Case laData[5] <> OrdHdr.Status .And. laData[5] = "O" .And. Ascan(laEvntTrig , Padr('CHG_OPN',10)) <> 0
    llReturn = gfDoTriger('SOORD',Padr('CHG_OPN',10))
    *C200089,1 If the order status changed to "On Hold"
  Case laData[5] <> OrdHdr.Status .And. laData[5] = "H" .And. Ascan(laEvntTrig , Padr('CHG_HLD',10)) <> 0
    llReturn = gfDoTriger('SOORD',Padr('CHG_HLD',10))
    *C200089,1 If there is any modification happened on the current order header.
  Otherwise
    *C200089,1 Get all the order info in a temp array.
    Declare laOrdInfo[1]
    =gfSubStr(Alltrim(lcScFields) , @laOrdInfo , ',')
    *C200089,1 Flag to know that there is modifications in the current sales order.
    llModOrd = .F.
    *C200089,1 Slect the order header file.
    Select OrdHdr
    *C200089,1 Loop in all the order header fields to find if there is
    *C200089,1 any modifications happened on the sales order or not.
    For lnOrdCnt = 1 To Alen(laOrdInfo)
      *C200089,1 If there is difference between the field & the array to be saved.
      If Evaluate(laOrdInfo[lnOrdCnt]) <> laData[lnOrdCnt]
        llModOrd = .T.
        Exit
      Endif
    Endfor
    If llModOrd .And. Ascan(laEvntTrig , Padr('MOD_ORD',10)) <> 0
      llReturn = gfDoTriger('SOORD',Padr('MOD_ORD',10))
    Endif
  Endcase
Endif
*C200089,1 Reham On 07/22/1999  *** End   ***

*E500377,1 Generate numbers automatically for EDI orders
*laData[1] = IIF((llContinue AND !EMPTY(laData[1])) OR laScrMode[3],laData[1],;
IIF(laSetups[6,2]='Y',lfGtOrder(),gfSequence('ORDER','','',laData[15])))

*C124452,1 WAM Use the same web order number
*laData[1] = IIF((llContinue AND !EMPTY(laData[1])) OR laScrMode[3],laData[1],;
IIF(laSetups[6,2]='Y' AND !llFromEDI,lfGtOrder(),gfSequence('ORDER','','',laData[15])))

*E303813,1 Foda 05/11/2017 add option to make the EDI orders get another sequence of ERP orders [Begin]
*laData[1] = IIF( (llContinue AND !EMPTY(laData[1])) OR laScrMode[3] OR (llFromEDI AND &lcOrdHdr..lFromWeb),laData[1],;
IIF(laSetups[6,2]='Y' AND !llFromEDI,lfGtOrder(),gfSequence('ORDER','','',laData[15])))
laData[1] = Iif( (llContinue And !Empty(laData[1])) Or laScrMode[3] Or (llFromEDI And &lcOrdHdr..lFromWeb),laData[1],;
  IIF(laSetups[6,2]='Y' And !llFromEDI,lfGtOrder(),Iif(laSetups[15,2] = 'Y',gfSequence('EDI_SORD','','',laData[15]),gfSequence('ORDER','','',laData[15]))))
*E303813,1 Foda 05/11/2017 add option to make the EDI orders get another sequence of ERP orders [END]

*C124452,1 WAM (End)

*E500377,1 (End)

*C200556,1 SSH Trigger for GMA to Assign Sales Order # the same web order number. [Begin]
*=gfDoTriger('SOORD',PADR('ASSGNORD',10))
*C200556,1 [End]

lcCurrOrd = laData[1]
*E301288,1 Reham On 07/20/1999   *** Begin ***
*E301288,1 Replace the order # in all the adornment order lines.
If llBomVarnt .And. laScrMode[4]
  Select (lcT_BomVar)
  Replace All cCost_Id With laData[1]
Endif
*E301288,1 Reham On 07/20/1999   *** End   ***

*E301175,1 Add this line to add the capability to call this function from
*          the EDI - from EDIProcessPO Class - [Begin]

*-- If the function was not called from EDI
If !llFromEDI
  *E301175,1 Add this line to add the capability to call this function [End]

  =gfSavSess('SOORD', lcFiles, @laVariables,lcSession)
  Select UnCmSess
  *B602496,1 Update the order record in the uncmsess file
  =Seek('O'+Padr('SOORD',10)+gcUser_id+lcSession)
  *B602496,1 (End)

  Replace cCurrObj With 'pbSav'

  *E301175,1 Add this line to add the capability to call this function from
  *          the EDI - from EDIProcessPO Class - [Begin]
Endif    && End of IF !llFromEDI
*E301175,1 Add this line to add the capability to call this function [End]

*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
Use (oAriaApplication.DataDir+"ORDCANLN") In 0 Shared Again Alias BlkORDCnl Order ORDCANLN   && CORDTYPE+ORDER+STR(LINENO,6)
Store .F. To lHasBulkmsg, llCancelBulk
Store '' To lcBulkKey
*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End  ]

Select (lcOrdHdr)
lcEdiOrd = Order
=Rlock()

Replace Order With laData[1]
Unlock
Show Get laData[1] Disable
llAria4xp = .T.
If lcOrdType='O' .And. laData[5]<>'B' .And. laScrMode[3] .And. Used(lcAlocated)
  Select (lcAlocated)
  Set Order To Tag 'CUTPKORD' In (lcAlocated)
  Go Top
  If !Eof()
    *E038729,1 WAM 11/11/2004 Maintain SQL tables
    If oAriaApplication.isRemoteComp
      lcSetClass = Set('CLASSLIB')
      Set Classlib To (oAriaApplication.lcAria4Class+"MAIN.VCX"),(oAriaApplication.lcAria4Class+"UTILITY.VCX")
      lcTranCode = oAriaApplication.RemoteCompanyData.BeginTran(oAriaApplication.ActiveCompanyConStr,3,'',.T.)
      Set Classlib To &lcSetClass.
      If Type('lcTranCode') = 'N'
        =oAriaApplication.RemoteCompanyData.CheckRetResult("BEGINTRAN",lcTranCode,.T.)
      Else

        *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
        *WAIT 'Updating alocated quantity...' WINDOW NOWAIT
        If !llSilent
          Wait 'Updating alocated quantity...' Window Nowait
        Endif
        *B612293,1 HIA 12/16/2020 add silent mode feature [End]
        Select (lcAlocated)
        Do While !Eof()
          lcTranCd = TRANCD
          lcTktNo  = CTKTNO
          lnOrdQty = 0
          lnBudQty = 0
          Scan Rest While TRANCD+CTKTNO+CTKTLINENO+Order+Style+CORDLINE = lcTranCd+lcTktNo
            Scatter Memvar
            *-- Get original allocated quantity
            =Seek(m.TRANCD+m.CTKTNO+m.CTKTLINENO+m.ORDER+m.STYLE+m.CORDLINE,'CUTPICK','Cutpkord')
            lnOrdQty = lnOrdQty + m.TotQty-CUTPICK.TotQty
            If !Empty(m.cUpdSizes)
              If Seek(OrdHdr.cOrdType+m.ORDER+Padl(Alltrim(m.CORDLINE),6),lcOrdLine,'OrdLine')
                *-- Update style WIP & WO
                If Seek(m.STYLE,'Style')
                  =Rlock('Style')
                  For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                    lcSize = Substr(m.cUpdSizes,lnSize,1)
                    lnBudQty = lnBudQty - CUTPICK.Qty&lcSize + m.Qty&lcSize
                    Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In Style
                  Endfor
                  Unlock In Style
                Endif
                *-- Update Warehouse WIP & WO
                If Seek(m.STYLE + &lcOrdLine..cWareCode+Space(10) ,'StyDye')
                  =Rlock('StyDye')
                  For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                    lcSize = Substr(m.cUpdSizes,lnSize,1)
                    Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In StyDye
                  Endfor
                  Unlock In StyDye
                Endif
                *E038463,1 WAM 11/15/2004 Update configuration WIP & WO
                If !Empty(&lcOrdLine..Dyelot) And Seek(m.STYLE + &lcOrdLine..cWareCode+&lcOrdLine..Dyelot,'StyDye')
                  =Rlock('StyDye')
                  For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                    lcSize = Substr(m.cUpdSizes,lnSize,1)
                    Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                      NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In StyDye
                  Endfor
                  Unlock In StyDye
                Endif
                *E038463,1 WAM 11/15/2004 (End)
              Endif
            Endif
            *-- Update ticket lines Ordered quantity
            lcSelString="UPDATE PosLn SET Ord1=Ord1+"+Alltrim(Str(m.Qty1-CUTPICK.Qty1))+",Ord2=Ord2+"+Alltrim(Str(m.Qty2-CUTPICK.Qty2))+;
              ",Ord3=Ord3+"+Alltrim(Str(m.Qty3-CUTPICK.Qty3))+",Ord4=Ord4+"+Alltrim(Str(m.Qty4-CUTPICK.Qty4))+;
              ",Ord5=Ord5+"+Alltrim(Str(m.Qty5-CUTPICK.Qty5))+",Ord6=Ord6+"+Alltrim(Str(m.Qty6-CUTPICK.Qty6))+;
              ",Ord7=Ord7+"+Alltrim(Str(m.Qty7-CUTPICK.Qty7))+",Ord8=Ord8+"+Alltrim(Str(m.Qty8-CUTPICK.Qty8))+;
              ",TotOrd=TotOrd+"+Alltrim(Str(m.TotQty-CUTPICK.TotQty))
            *-- Update ticket lines budget quantities
            If !Empty(m.cUpdSizes)
              lcSelString=lcSelString+Iif('1' $ m.cUpdSizes,",Qty1=Qty1+"+Alltrim(Str(m.Qty1-CUTPICK.Qty1)),'')+;
                IIF('2' $ m.cUpdSizes,",Qty2=Qty2+"+Alltrim(Str(m.Qty2-CUTPICK.Qty2)),'')+;
                IIF('3' $ m.cUpdSizes,",Qty3=Qty3+"+Alltrim(Str(m.Qty3-CUTPICK.Qty3)),'')+;
                IIF('4' $ m.cUpdSizes,",Qty4=Qty4+"+Alltrim(Str(m.Qty4-CUTPICK.Qty4)),'')+;
                IIF('5' $ m.cUpdSizes,",Qty5=Qty5+"+Alltrim(Str(m.Qty5-CUTPICK.Qty5)),'')+;
                IIF('6' $ m.cUpdSizes,",Qty6=Qty6+"+Alltrim(Str(m.Qty6-CUTPICK.Qty6)),'')+;
                IIF('7' $ m.cUpdSizes,",Qty7=Qty7+"+Alltrim(Str(m.Qty7-CUTPICK.Qty7)),'')+;
                IIF('8' $ m.cUpdSizes,",Qty8=Qty8+"+Alltrim(Str(m.Qty8-CUTPICK.Qty8)),'')+;
                ",TotQty=TotQty+"+Alltrim(Str(m.TotQty-CUTPICK.TotQty))
            Endif
            If m.TRANCD = '1'
              lcSelString=lcSelString+" WHERE cBusDocu+cstytype+po+cInvType+style+STR([lineno],6)+trancd='PU"+m.CTKTNO+'0001'+m.STYLE+m.CTKTLINENO+"1'"
            Else
              lcSelString=lcSelString+" WHERE cBusDocu+cstytype+po+cInvType+style+STR([lineno],6)+trancd='PP"+m.CTKTNO+'0001'+m.STYLE+m.CTKTLINENO+"1'"
            Endif
            lnResult = oAriaApplication.RemoteCompanyData.Execute(lcSelString,'',"SAVEFILE","",lcTranCode,4,'',Set("DATASESSION"))
            Select CUTPICK
            If m.TotQty = 0
              Delete
            Else
              Gather Memvar
            Endif
          Endscan
          *-- Update ticket total Ordered & budget quantity
          If lcTranCd = '1'
            *-- Change Cutting quantity if order allocated quantity has been changed
            lcSelString = "UPDATE PosHdr SET TotOrd=TotOrd+"+Alltrim(Str(lnOrdQty))+",nStyOrder = nStyOrder + "+Alltrim(Str(lnBudQty))+" ,[Open] = [Open] + "+Alltrim(Str(lnBudQty))+" WHERE cBusDocu+cstytype+po='PU"+lcTktNo+"'"
          Else
            *-- Change Purchased quantity if order allocated quantity has been changed
            lcSelString = "UPDATE PosHdr SET TotOrd=TotOrd+"+Alltrim(Str(lnOrdQty))+",nStyOrder = nStyOrder + "+Alltrim(Str(lnBudQty))+" ,[Open] = [Open] + "+Alltrim(Str(lnBudQty))+" WHERE cBusDocu+cstytype+po='PP"+lcTktNo+"'"
          Endif
          lnResult = oAriaApplication.RemoteCompanyData.Execute(lcSelString,'',"SAVEFILE","",lcTranCode,4,'',Set("DATASESSION"))
          Select (lcAlocated)
        Enddo
        lnResult = lfSqlUpdate('CUTPICK',lcTranCode, Set("DATASESSION"),'trancd,ctktno,ctktlineno,order,style,cordline')
        If lnResult <=0
          =oAriaApplication.RemoteCompanyData.CheckRetResult("SQLUPDATE",lnResult,.T.)
          =oAriaApplication.RemoteCompanyData.RollBackTran(lcTranCode)
        Else
          If oAriaApplication.RemoteCompanyData.CommitTran(lcTranCode,.T.) = 1
          Else
            =oAriaApplication.RemoteCompanyData.CheckRetResult("COMMITTRAN",lnResult,.T.)
          Endif
        Endif

        *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
        *WAIT CLEAR
        If !llSilent
          Wait Clear
        Endif
        *B612293,1 HIA 12/16/2020 add silent mode feature [End]
      Endif
      *E038729,1 WAM 11/11/2004 (End)
    Else

      *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
      *WAIT 'Updating alocated quantity...' WINDOW NOWAIT
      If !llSilent
        Wait 'Updating alocated quantity...' Window Nowait
      Endif
      *B612293,1 HIA 12/16/2020 add silent mode feature [End]
      If 'PO' $ gcCmpModules
        =gfOpenFile(gcDataDir+'POSHDR',gcDataDir+'POSHDR','SH')
        =gfOpenFile(gcDataDir+'POSLN',gcDataDir+'POSLN','SH')
      Endif
      If 'MF' $ gcCmpModules
        =gfOpenFile(gcDataDir+'CUTTKTH',gcDataDir+'CUTTKTH','SH')
        =gfOpenFile(gcDataDir+'CUTTKTL',gcDataDir+'CUTLIN','SH')
      Endif
      =gfOpenFile(gcDataDir+'CUTPICK',gcDataDir+'CUTPKORD','SH')
      Select (lcAlocated)
      Do While !Eof()
        lcTranCd = TRANCD
        lcTktNo  = CTKTNO
        lnOrdQty = 0
        lnBudQty = 0
        Scan Rest While TRANCD+CTKTNO+CTKTLINENO+Order+Style+CORDLINE = lcTranCd+lcTktNo
          Scatter Memvar
          *-- Get original allocated quantity
          =Seek(m.TRANCD+m.CTKTNO+m.CTKTLINENO+m.ORDER+m.STYLE+m.CORDLINE,'CUTPICK','Cutpkord')
          lnOrdQty = lnOrdQty + m.TotQty-CUTPICK.TotQty
          If !Empty(m.cUpdSizes)
            If Seek(OrdHdr.cOrdType+m.ORDER+Padl(Alltrim(m.CORDLINE),6),lcOrdLine,'OrdLine')
              *-- Update style WIP & WO
              If Seek(m.STYLE,'Style')
                =Rlock('Style')
                For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                  lcSize = Substr(m.cUpdSizes,lnSize,1)
                  lnBudQty = lnBudQty - CUTPICK.Qty&lcSize + m.Qty&lcSize
                  Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In Style
                Endfor
                Unlock In Style
              Endif
              *-- Update Warehouse WIP & WO
              If Seek(m.STYLE + &lcOrdLine..cWareCode+Space(10) ,'StyDye')
                =Rlock('StyDye')
                For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                  lcSize = Substr(m.cUpdSizes,lnSize,1)
                  Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In StyDye
                Endfor
                Unlock In StyDye
              Endif
              *E038463,1 WAM 11/15/2004 Update configuration WIP & WO
              If !Empty(&lcOrdLine..Dyelot) And Seek(m.STYLE + &lcOrdLine..cWareCode+&lcOrdLine..Dyelot,'StyDye')
                =Rlock('StyDye')
                For lnSize = 1 To Len(Alltrim(m.cUpdSizes))
                  lcSize = Substr(m.cUpdSizes,lnSize,1)
                  Replace WIP&lcSize With WIP&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    TOTWIP     With TOTWIP     - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NWO&lcSize With NWO&lcSize - CUTPICK.Qty&lcSize + m.Qty&lcSize , ;
                    NTOTWO     With NTOTWO     - CUTPICK.Qty&lcSize + m.Qty&lcSize In StyDye
                Endfor
                Unlock In StyDye
              Endif
              *E038463,1 WAM 11/15/2004 (End)
            Endif
          Endif
          Select (lcDetAlo)
          *E301182,1 Update CT/PO line number in the CUTPICK file.
          *=SEEK(IIF(m.TranCd='1',m.CTKTNO+m.Style,'P'+m.CTKTNO+m.Style))
          =Seek(Iif(m.TRANCD='2','P','')+m.CTKTNO+m.STYLE+m.CTKTLINENO+'1')
          *E301182,1 (End)
          =Rlock()
          Replace ORD1   With ORD1   - CUTPICK.Qty1   + m.Qty1 ,;
            ORD2   With ORD2   - CUTPICK.Qty2   + m.Qty2 ,;
            ORD3   With ORD3   - CUTPICK.Qty3   + m.Qty3 ,;
            ORD4   With ORD4   - CUTPICK.Qty4   + m.Qty4 ,;
            ORD5   With ORD5   - CUTPICK.Qty5   + m.Qty5 ,;
            ORD6   With ORD6   - CUTPICK.Qty6   + m.Qty6 ,;
            ORD7   With ORD7   - CUTPICK.Qty7   + m.Qty7 ,;
            ORD8   With ORD8   - CUTPICK.Qty8   + m.Qty8 ,;
            TOTORD With TOTORD - CUTPICK.TotQty + m.TotQty
          If !Empty(&lcAlocated..cUpdSizes)
            Replace Qty1   With Iif('1' $ &lcAlocated..cUpdSizes,Qty1-CUTPICK.Qty1+m.Qty1,Qty1) ,;
              Qty2   With Iif('2' $ &lcAlocated..cUpdSizes,Qty2-CUTPICK.Qty2+m.Qty2,Qty2) ,;
              Qty3   With Iif('3' $ &lcAlocated..cUpdSizes,Qty3-CUTPICK.Qty3+m.Qty3,Qty3) ,;
              Qty4   With Iif('4' $ &lcAlocated..cUpdSizes,Qty4-CUTPICK.Qty4+m.Qty4,Qty4) ,;
              Qty5   With Iif('5' $ &lcAlocated..cUpdSizes,Qty5-CUTPICK.Qty5+m.Qty5,Qty5) ,;
              Qty6   With Iif('6' $ &lcAlocated..cUpdSizes,Qty6-CUTPICK.Qty6+m.Qty6,Qty6) ,;
              Qty7   With Iif('7' $ &lcAlocated..cUpdSizes,Qty7-CUTPICK.Qty7+m.Qty7,Qty7) ,;
              Qty8   With Iif('8' $ &lcAlocated..cUpdSizes,Qty8-CUTPICK.Qty8+m.Qty8,Qty8) ,;
              TotQty With TotQty - CUTPICK.TotQty + m.TotQty
          Endif
          Unlock
          Select CUTPICK
          =Rlock()
          If m.TotQty = 0
            Delete
          Else
            =Rlock()
            Gather Memvar
            Unlock
          Endif
          Unlock
        Endscan
        lcHdrAlo = Iif(TRANCD='1','CutTktH','PosHdr')
        lcDetAlo = Iif(TRANCD='1','CutTktL','PosLn')
        Select (lcHdrAlo)
        =Seek(Iif(lcTranCd='1',lcTktNo,'P'+lcTktNo))
        =Rlock()
        Replace TOTORD With TOTORD + lnOrdQty
        If m.TRANCD = '1'
          Replace Pcs_Bud With Pcs_Bud + lnBudQty ,;
            Pcs_Opn With Pcs_Opn + lnBudQty
        Else
          Replace nStyOrder With nStyOrder + lnBudQty ,;
            OPEN      With Open  + lnBudQty
        Endif
        Unlock
      Enddo
      *E301077,5 Inhance openning files to speed up transaction
      =Iif('PO' $ gcCmpModules,gfCloseFile('POSHDR')  And gfCloseFile('POSLN'),.T.)
      =Iif('MF' $ gcCmpModules,gfCloseFile('CUTTKTH') And gfCloseFile('CUTTKTL'),.T.)
      =gfCloseFile('CUTPICK')
      *E301077,5 (End)
    Endif
  Endif
Endif
*E301077,5 Inhance openning files to speed up transaction
=gfOpenFile(gcDataDir+'icStyHst',gcDataDir+'Styhst','SH')
=Iif('AL' $ gcCmpModules,gfOpenFile(gcDataDir+'PikTkt',gcDataDir+'PikTkt','SH'),.T.)
=gfOpenFile(gcDataDir+'ORDCANLN',gcDataDir+'ORDCANLN','SH')
*E301077,5 (End)

*E038729,1 WAM 11/11/2004 Maintain SQL tables
If oAriaApplication.isRemoteComp
  llBlkAloTrn = .F.
  Select Dist cFromOrder From (lcOrdLine) Where !Empty(cFromOrder) Into Array laFromOrder
  If _Tally > 0
    Local lcSetClass
    lcSetClass = Set('CLASSLIB')
    Set Classlib To (oAriaApplication.lcAria4Class+"MAIN.VCX"),(oAriaApplication.lcAria4Class+"UTILITY.VCX")
    lcTranCode = oAriaApplication.RemoteCompanyData.BeginTran(oAriaApplication.ActiveCompanyConStr,3,'',.T.)
    Set Classlib To &lcSetClass.
    If Type('lcTranCode') = 'N'
      =oAriaApplication.RemoteCompanyData.CheckRetResult("BEGINTRAN",lcTranCode,.T.)
    Else
      lcFromOrder = ''
      For lnFromOrder = 1 To Alen(laFromOrder)
        lcFromOrder = lcFromOrder + "'" + laFromOrder[lnFromOrder] + "',"
      Endfor
      lcFromOrder = Left(lcFromOrder,Len(lcFromOrder)-1)
      lcSelString = "SELECT * FROM cutpick WHERE [Order] IN (" + lcFromOrder + ")"
      If oAriaApplication.RemoteCompanyData.Execute(lcSelString ,'',"CutPick","CutPick",lcTranCode,4,'',Set("DATASESSION")) = 1
        lnCurBuff = CursorGetProp("Buffering")
        =CursorSetProp("Buffering" ,3,"CutPick")
        Index On TRANCD+Order+CORDLINE Tag 'CUTORD'
        Index On TRANCD+CTKTNO+CTKTLINENO+Order+Style+CORDLINE Tag 'CUTPKORD' Additive
        =CursorSetProp("Buffering" ,lnCurBuff ,"CutPick")
        Set Order To Tag 'CUTORD'
        llBlkAloTrn = .T.
      Endif
    Endif
  Endif
Else
  llBlkAloTrn = .T.
  =gfOpenFile(gcDataDir+'CUTPICK',gcDataDir+'CUTORD','SH')
Endif
*E038729,1 WAM 11/11/2004 (End)

Select ORDLINE
Set Relation To
Select (lcOrdLine)
Set Delete Off
Set Order To Tag 0
Go Top

*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*WAIT 'Updating order lines...' WINDOW NOWAIT
If !llSilent
  Wait 'Updating order lines...' Window Nowait
Endif
*B612293,1 HIA 12/16/2020 add silent mode feature [End]

*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
lcLogCont='Updating order lines... '+Chr(13)+Chr(10)
Strtofile(lcLogCont,lcLog,1)
*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

lcUntSin = ''
lcExRSin = gfGetExSin(@lcUntSin, laData[33])

Store 0 To lnCancel,lnCancelAmt,lnCanBulk
lnLineCount=Iif(Seek(lcOrdType+laData[1],'ORDHDR'),OrdHdr.LastLine,0)
*B802131,1 Check if the dates was changed in this session and set the flag.
*E301305,1 AMM update the complete date due to the system setting (per line or order)
*llUpdDates = IIF(laData[9]<>ORDHDR.Start OR laData[10]<>ORDHDR.Complete,.T.,.F.)
llUpdDates = Iif(laData[9]<>OrdHdr.Start Or (!llCDPerL .And. laData[10]<>OrdHdr.Complete) ,.T.,.F.)
*E301305,1 AMM end
*B802131,1 End.

Scan For Iif(OrdHdr.Status='B',.T.,Flag='M' .Or. (Flag='N' .And. !Deleted() .And. TotQty > 0))

  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
  lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
  lcLogCont='Line Number# '+Alltrim(Str(Lineno))+Chr(13)+Chr(10)
  lcLogCont=lcLogCont+'Style# '+Style+Chr(13)+Chr(10)
  Strtofile(lcLogCont,lcLog,1)
  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]


  If lcOrdType='O' .And. laData[5] <> 'B' .And. !Deleted() .And. ;
      (laScrMode[4] .Or. OrdHdr.Status='B') .And. nSteps < 1 .And. ;
      SEEK(lcOrdType+cFromOrder+Str(BulkLineNo,6),'OrdLine')

    *-- Decrease ordered quantity of the warehouse originaly assigned to the bulk
    *-- order being depleted
    =Seek(ORDLINE.Style+ORDLINE.cWareCode+Space(10),'StyDye')
    Select StyDye
    =Rlock('StyDye')
    Replace ORD1 With ORD1 - Min(ORDLINE.Qty1,&lcOrdLine..Qty1),;
      ORD2 With ORD2 - Min(ORDLINE.Qty2,&lcOrdLine..Qty2),;
      ORD3 With ORD3 - Min(ORDLINE.Qty3,&lcOrdLine..Qty3),;
      ORD4 With ORD4 - Min(ORDLINE.Qty4,&lcOrdLine..Qty4),;
      ORD5 With ORD5 - Min(ORDLINE.Qty5,&lcOrdLine..Qty5),;
      ORD6 With ORD6 - Min(ORDLINE.Qty6,&lcOrdLine..Qty6),;
      ORD7 With ORD7 - Min(ORDLINE.Qty7,&lcOrdLine..Qty7),;
      ORD8 With ORD8 - Min(ORDLINE.Qty8,&lcOrdLine..Qty8),;
      TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
    Unlock In 'StyDye'
    *E038463,1 WAM 11/09/2004 Update ordered quantity at the Configuration level
    If !Empty(ORDLINE.Dyelot) And Seek(ORDLINE.Style+ORDLINE.cWareCode+ORDLINE.Dyelot,'StyDye')
      =Rlock('StyDye')
      Replace ORD1 With ORD1 - Min(ORDLINE.Qty1,&lcOrdLine..Qty1),;
        ORD2 With ORD2 - Min(ORDLINE.Qty2,&lcOrdLine..Qty2),;
        ORD3 With ORD3 - Min(ORDLINE.Qty3,&lcOrdLine..Qty3),;
        ORD4 With ORD4 - Min(ORDLINE.Qty4,&lcOrdLine..Qty4),;
        ORD5 With ORD5 - Min(ORDLINE.Qty5,&lcOrdLine..Qty5),;
        ORD6 With ORD6 - Min(ORDLINE.Qty6,&lcOrdLine..Qty6),;
        ORD7 With ORD7 - Min(ORDLINE.Qty7,&lcOrdLine..Qty7),;
        ORD8 With ORD8 - Min(ORDLINE.Qty8,&lcOrdLine..Qty8),;
        TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8 In StyDye
      Unlock In 'StyDye'
    Endif
    *E038463,1 WAM 11/09/2004 (End)
    Select Style
    =Seek(ORDLINE.Style)
    Rlock('Style')
    Replace ORD1   With ORD1 - Min(ORDLINE.Qty1,&lcOrdLine..Qty1),;
      ORD2   With ORD2 - Min(ORDLINE.Qty2,&lcOrdLine..Qty2),;
      ORD3   With ORD3 - Min(ORDLINE.Qty3,&lcOrdLine..Qty3),;
      ORD4   With ORD4 - Min(ORDLINE.Qty4,&lcOrdLine..Qty4),;
      ORD5   With ORD5 - Min(ORDLINE.Qty5,&lcOrdLine..Qty5),;
      ORD6   With ORD6 - Min(ORDLINE.Qty6,&lcOrdLine..Qty6),;
      ORD7   With ORD7 - Min(ORDLINE.Qty7,&lcOrdLine..Qty7),;
      ORD8   With ORD8 - Min(ORDLINE.Qty8,&lcOrdLine..Qty8),;
      TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
    Unlock In 'Style'

    Select (lcOrdLine)
    =Rlock()
    Replace nSteps With 1
    Unlock
  Endif

  If lcOrdType='O' .And. laData[5]<>'B' .And. nSteps < 2
    If OrdHdr.Status <> 'B' .And. Seek(lcOrdType+Order+Str(Lineno,6),'OrdLine')
      Select StyDye
      =Seek(ORDLINE.Style+ORDLINE.cWareCode+Space(10))
      =Rlock('StyDye')
      Replace ORD1   With ORD1   - ORDLINE.Qty1 ,;
        ORD2   With ORD2   - ORDLINE.Qty2 ,;
        ORD3   With ORD3   - ORDLINE.Qty3 ,;
        ORD4   With ORD4   - ORDLINE.Qty4 ,;
        ORD5   With ORD5   - ORDLINE.Qty5 ,;
        ORD6   With ORD6   - ORDLINE.Qty6 ,;
        ORD7   With ORD7   - ORDLINE.Qty7 ,;
        ORD8   With ORD8   - ORDLINE.Qty8 ,;
        TOTORD With TOTORD - ORDLINE.TotQty
      Unlock In 'StyDye'
      *E038463,1 WAM 11/09/2004 Update ordered quantity at the Configuration level
      If !Empty(ORDLINE.Dyelot) And Seek(ORDLINE.Style+ORDLINE.cWareCode+ORDLINE.Dyelot)
        =Rlock('StyDye')
        Replace ORD1   With ORD1   - ORDLINE.Qty1 ,;
          ORD2   With ORD2   - ORDLINE.Qty2 ,;
          ORD3   With ORD3   - ORDLINE.Qty3 ,;
          ORD4   With ORD4   - ORDLINE.Qty4 ,;
          ORD5   With ORD5   - ORDLINE.Qty5 ,;
          ORD6   With ORD6   - ORDLINE.Qty6 ,;
          ORD7   With ORD7   - ORDLINE.Qty7 ,;
          ORD8   With ORD8   - ORDLINE.Qty8 ,;
          TOTORD With TOTORD - ORDLINE.TotQty
        Unlock In 'StyDye'
      Endif
      *E038463,1 WAM 11/09/2004 (End)
      Select Style
      =Seek(ORDLINE.Style)
      =Rlock('Style')
      Replace ORD1   With ORD1   - ORDLINE.Qty1 ,;
        ORD2   With ORD2   - ORDLINE.Qty2 ,;
        ORD3   With ORD3   - ORDLINE.Qty3 ,;
        ORD4   With ORD4   - ORDLINE.Qty4 ,;
        ORD5   With ORD5   - ORDLINE.Qty5 ,;
        ORD6   With ORD6   - ORDLINE.Qty6 ,;
        ORD7   With ORD7   - ORDLINE.Qty7 ,;
        ORD8   With ORD8   - ORDLINE.Qty8 ,;
        TOTORD With TOTORD - ORDLINE.TotQty
      Unlock In 'Style'
    Endif
    If !Deleted(lcOrdLine)
      Select StyDye
      =Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+Space(10))
      =Rlock('StyDye')
      Replace ORD1   With ORD1   + &lcOrdLine..Qty1 ,;
        ORD2   With ORD2   + &lcOrdLine..Qty2 ,;
        ORD3   With ORD3   + &lcOrdLine..Qty3 ,;
        ORD4   With ORD4   + &lcOrdLine..Qty4 ,;
        ORD5   With ORD5   + &lcOrdLine..Qty5 ,;
        ORD6   With ORD6   + &lcOrdLine..Qty6 ,;
        ORD7   With ORD7   + &lcOrdLine..Qty7 ,;
        ORD8   With ORD8   + &lcOrdLine..Qty8 ,;
        TOTORD With TOTORD + &lcOrdLine..TotQty
      Unlock In 'StyDye'
      *E038463,1 WAM 11/09/2004 Update ordered quantity at the Configuration level
      Select StyDye
      If !Empty(&lcOrdLine..Dyelot) And Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+&lcOrdLine..Dyelot)
        =Rlock('StyDye')
        Replace ORD1   With ORD1   + &lcOrdLine..Qty1 ,;
          ORD2   With ORD2   + &lcOrdLine..Qty2 ,;
          ORD3   With ORD3   + &lcOrdLine..Qty3 ,;
          ORD4   With ORD4   + &lcOrdLine..Qty4 ,;
          ORD5   With ORD5   + &lcOrdLine..Qty5 ,;
          ORD6   With ORD6   + &lcOrdLine..Qty6 ,;
          ORD7   With ORD7   + &lcOrdLine..Qty7 ,;
          ORD8   With ORD8   + &lcOrdLine..Qty8 ,;
          TOTORD With TOTORD + &lcOrdLine..TotQty
        Unlock In 'StyDye'
      Endif
      *E038463,1 WAM 11/09/2004 (End)
      Select Style
      =Seek(&lcOrdLine..Style)
      =Rlock('Style')
      Replace ORD1   With ORD1   + &lcOrdLine..Qty1 ,;
        ORD2   With ORD2   + &lcOrdLine..Qty2 ,;
        ORD3   With ORD3   + &lcOrdLine..Qty3 ,;
        ORD4   With ORD4   + &lcOrdLine..Qty4 ,;
        ORD5   With ORD5   + &lcOrdLine..Qty5 ,;
        ORD6   With ORD6   + &lcOrdLine..Qty6 ,;
        ORD7   With ORD7   + &lcOrdLine..Qty7 ,;
        ORD8   With ORD8   + &lcOrdLine..Qty8 ,;
        TOTORD With TOTORD + &lcOrdLine..TotQty
      Unlock In 'Style'
    Endif
    Select (lcOrdLine)
    =Rlock()
    Replace nSteps With 2
    Unlock
  Endif

  lnCanBulk = 0
  If lcOrdType='O' .And. laData[5]<>'B' .And. ;
      (laScrMode[4] .Or. OrdHdr.Status='B') .And. !Deleted() .And. Seek(lcOrdType+cFromOrder,'OrdHdr') And ;
      SEEK(lcOrdType+cFromOrder+Str(BulkLineNo,6),'OrdLine')

    =CHECKPRD(OrdHdr.Entered,'lcBulkYear','lcBulkPrd','',.T.)

    lnCanBulk = Min(ORDLINE.Qty1,Qty1)+Min(ORDLINE.Qty2,Qty2)+;
      MIN(ORDLINE.Qty3,Qty3)+Min(ORDLINE.Qty4,Qty4)+;
      MIN(ORDLINE.Qty5,Qty5)+Min(ORDLINE.Qty6,Qty6)+;
      MIN(ORDLINE.Qty7,Qty7)+Min(ORDLINE.Qty8,Qty8)
    lnCancel    = lnCancel    + lnCanBulk
    lnCancelAmt = lnCancelAmt + lnCanBulk*ORDLINE.Price
    lnOpmAmnt = lnCanBulk*ORDLINE.Price &lcExRSin laData[34] &lcUntSin laData[50]
    If Seek(Style+lcBulkYear,'icStyHst') .And. &lcOrdLine..nSteps < 5
      lnOrdAmt = lnOpmAmnt &lcExRSin laData[34] &lcUntSin laData[50]
      Select icStyHst
      =Rlock()
      Replace nOrdQty&lcBulkPrd With nOrdQty&lcBulkPrd - lnCanBulk ,;
        nOrdQty           With nOrdQty           - lnCanBulk ,;
        nOrdAmt&lcBulkPrd With nOrdAmt&lcBulkPrd - lnOrdAmt  ,;
        nOrdAmt           With nOrdAmt           - lnOrdAmt
      Unlock
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 5
      Unlock
    Endif
    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
    *IF nSteps < 6
    *  =RLOCK('ORDLINE')
    *  SELECT ORDLINE
    *  =RLOCK()
    *  REPLACE Qty1   WITH MAX(Qty1-&lcOrdLine..Qty1,0),;
    *    Qty2   WITH MAX(Qty2-&lcOrdLine..Qty2,0),;
    *    Qty3   WITH MAX(Qty3-&lcOrdLine..Qty3,0),;
    *    Qty4   WITH MAX(Qty4-&lcOrdLine..Qty4,0),;
    *    Qty5   WITH MAX(Qty5-&lcOrdLine..Qty5,0),;
    *    Qty6   WITH MAX(Qty6-&lcOrdLine..Qty6,0),;
    *    Qty7   WITH MAX(Qty7-&lcOrdLine..Qty7,0),;
    *    Qty8   WITH MAX(Qty8-&lcOrdLine..Qty8,0),;
    *    TotQty WITH Qty1+Qty2+Qty3+Qty4+Qty5+Qty6+Qty7+Qty8
    *  *E500309,1 AMM update the booked quantity in bulk order
    *  REPLACE Book1   WITH MAX(Book1-&lcOrdLine..Book1,0),;
    *    Book2   WITH MAX(Book2-&lcOrdLine..Book2,0),;
    *    Book3   WITH MAX(Book3-&lcOrdLine..Book3,0),;
    *    Book4   WITH MAX(Book4-&lcOrdLine..Book4,0),;
    *    Book5   WITH MAX(Book5-&lcOrdLine..Book5,0),;
    *    Book6   WITH MAX(Book6-&lcOrdLine..Book6,0),;
    *    Book7   WITH MAX(Book7-&lcOrdLine..Book7,0),;
    *    Book8   WITH MAX(Book8-&lcOrdLine..Book8,0),;
    *    TotBook WITH Book1+Book2+Book3+Book4+Book5+Book6+Book7+Book8
    *  *E500309,1 AMM end
    *
    *  UNLOCK IN 'ORDLINE'
    *  SELECT (lcOrdLine)
    *  =RLOCK()
    *  REPLACE nSteps WITH 6
    *  UNLOCK
    *ENDIF
    **E500309,1 AMM If bulk order , deduct from booked else add to canceled quantity
    *SELECT OrdHdr
    *=SEEK(lcOrdType+&lcOrdLine..cFromOrder)
    *=RLOCK()
    *REPLACE Book      WITH Book    - lnCanBulk  ,;
    *  BookAmt   WITH BookAmt - lnCanBulk*ORDLINE.Price ,;
    *  OPEN      WITH OPEN    - lnCanBulk  ,;
    *  Openamt   WITH Openamt - lnCanBulk*ORDLINE.Price ,;
    *  STATUS    WITH IIF(OPEN = 0 ,'X',STATUS)
    *UNLOCK
    *SELECT (lcOrdLine)
    **E500309,1 (End)

    lcBulkKey = lcOrdType+cFromOrder
    If (&lcOrdLine..Qty1<0 Or &lcOrdLine..Qty2<0 Or &lcOrdLine..Qty3<0 Or &lcOrdLine..Qty4<0 Or &lcOrdLine..Qty5<0 Or &lcOrdLine..Qty6<0 Or &lcOrdLine..Qty7<0 Or &lcOrdLine..Qty8<0)
      If !lHasBulkmsg  And (gfModalGen('QRM54038B32000','DIALOG',OrdHdr.cFromOrder) =1)
        lHasBulkmsg = .T.
        llCancelBulk = .T.
      Endif
    Endif
    = lfBulkActions(lcOrdLine,'OrdHdr','OrdLine','BlkORDCnl',-1)

    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End]


  Endif
  If lcOrdType='O' .And. laData[5]<>'B' .And. laScrMode[3] .And. ;
      Picked .And. Seek(PikTkt,'PikTkt')
    Select PikTkt
    =Rlock()
    Replace Store With &lcOrdLine..Store
    Unlock
    Select (lcOrdLine)
  Endif
  =Seek(lcOrdType+Order+Str(Lineno,6),'OrdLine')
  If lcOrdType='O' .And. laData[5]<>'B' .And. Seek(Style+lcGlYear,'icStyHst') .And. ;
      &lcOrdLine..nSteps < 7
    lnOrdAmt = ;
      IIF(Deleted(lcOrdLine),0,&lcOrdLine..TotQty*&lcOrdLine..Price &lcExRSin laData[34] &lcUntSin laData[50]) - ;
      IIF(laScrMode[4] Or OrdHdr.Status='B',0,ORDLINE.TotQty*ORDLINE.Price &lcExRSin OrdHdr.nExRate &lcUntSin OrdHdr.nCurrUnit)
    Select icStyHst
    =Rlock()
    Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod - ;
      IIF(laScrMode[4] Or OrdHdr.Status='B',0,ORDLINE.TotQty) + ;
      IIF(Deleted(lcOrdLine),0,&lcOrdLine..TotQty) ,;
      nOrdQty            With nOrdQty- Iif(laScrMode[4] Or OrdHdr.Status='B',0,ORDLINE.TotQty) + ;
      IIF(Deleted(lcOrdLine),0,&lcOrdLine..TotQty) ,;
      nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod + lnOrdAmt ,;
      nOrdAmt            With nOrdAmt + lnOrdAmt
    Unlock
    Select (lcOrdLine)
    =Rlock()
    Replace nSteps With 7
    Unlock
  Endif
  *E300956,1 Update Order lines canceled quantity
  If laScrMode[3] And &lcOrdLine..nSteps < 8 And Seek(lcOrdType+Order+Str(Lineno,6),lcOrdCanLn)
    Select (lcOrdCanLn)
    Scatter To laCanRec
    Insert Into ORDCANLN From Array laCanRec
    Select (lcOrdLine)
    =Rlock()
    Replace nSteps With 8
    Unlock
  Endif
  *E300956,1 (End)

  *B602555,1 Check if any C/Ts have been assigned to the bulk order.
  *B602555,1 If any, Release allocation from the bulk order and allocate them
  *B602555,1 to the newly received distribution order.
  Select (lcOrdLine)
  If lcOrdType='O' And laScrMode[4] And !Empty(&lcOrdLine..cFromOrder) .And. Seek('O'+&lcOrdLine..cFromOrder,'ORDHDR','ORDHDR') And ;
      OrdHdr.TotCut> 0 And &lcOrdLine..nSteps < 9
    Scatter Fields ;
      Qty1,Qty2,Qty3,Qty4,Qty5,Qty6,Qty7,Qty8,TotQty To laDistQty
    *E038729,1 WAM 11/11/2004 Maintain SQL tables
    If llBlkAloTrn And (Seek('1'+&lcOrdLine..cFromOrder+Str(&lcOrdLine..BulkLineNo,6),'CUTPICK','CUTORD') Or ;
        SEEK('2'+&lcOrdLine..cFromOrder+Str(&lcOrdLine..BulkLineNo,6),'CUTPICK','CUTORD'))
      lcTranCd = CUTPICK.TRANCD
      Select CUTPICK
      Scan Rest ;
          WHILE TRANCD+Order+CORDLINE = lcTranCd+&lcOrdLine..cFromOrder+Str(&lcOrdLine..BulkLineNo,6) ;
          AND laDistQty[1]+laDistQty[2]+laDistQty[3]+laDistQty[4]+;
          laDistQty[5]+laDistQty[6]+laDistQty[7]+laDistQty[8] >0
        m.CTKTNO = CTKTNO
        m.CTKTLINENO = CTKTLINENO
        m.Cut1 = Qty1
        m.Cut2 = Qty2
        m.Cut3 = Qty3
        m.Cut4 = Qty4
        m.Cut5 = Qty5
        m.Cut6 = Qty6
        m.Cut7 = Qty7
        m.Cut8 = Qty8
        =Rlock()
        Replace Qty1   With Max(Qty1-laDistQty[1],0) ,;
          Qty2   With Max(Qty2-laDistQty[2],0) ,;
          Qty3   With Max(Qty3-laDistQty[3],0) ,;
          Qty4   With Max(Qty4-laDistQty[4],0) ,;
          Qty5   With Max(Qty5-laDistQty[5],0) ,;
          Qty6   With Max(Qty6-laDistQty[6],0) ,;
          Qty7   With Max(Qty7-laDistQty[7],0) ,;
          Qty8   With Max(Qty8-laDistQty[8],0) ,;
          TotQty With Qty1+Qty2+Qty3+Qty4+Qty5+Qty6+Qty7+Qty8
        Unlock
        If TotQty = 0
          Delete
        Endif
        m.Cut1 = Min(m.Cut1,laDistQty[1])
        m.Cut2 = Min(m.Cut2,laDistQty[2])
        m.Cut3 = Min(m.Cut3,laDistQty[3])
        m.Cut4 = Min(m.Cut4,laDistQty[4])
        m.Cut5 = Min(m.Cut5,laDistQty[5])
        m.Cut6 = Min(m.Cut6,laDistQty[6])
        m.Cut7 = Min(m.Cut7,laDistQty[7])
        m.Cut8 = Min(m.Cut8,laDistQty[8])
        m.TotCut = m.Cut1+m.Cut2+m.Cut3+m.Cut4+m.Cut5+m.Cut6+m.Cut7+m.Cut8
        If m.TotCut > 0
          lnRecNo  = Recno('CUTPICK')
          Select CUTPICK
          If !Seek(lcTranCd+m.CTKTNO+m.CTKTLINENO+laData[1]+&lcOrdLine..Style+Str(&lcOrdLine..Lineno,6),'CUTPICK','CUTPKORD')
            Insert Into 'CUTPICK' ;
              (CTKTNO,CTKTLINENO,TRANCD,Order,CORDLINE,Style) Values ;
              (m.CTKTNO,m.CTKTLINENO,lcTranCd,laData[1],Str(&lcOrdLine..Lineno,6),&lcOrdLine..Style)
          Endif
          Replace Qty1   With Qty1   + m.Cut1 ,;
            Qty2   With Qty2   + m.Cut2 ,;
            Qty3   With Qty3   + m.Cut3 ,;
            Qty4   With Qty4   + m.Cut4 ,;
            Qty5   With Qty5   + m.Cut5 ,;
            Qty6   With Qty6   + m.Cut6 ,;
            Qty7   With Qty7   + m.Cut7 ,;
            Qty8   With Qty8   + m.Cut8 ,;
            TotQty With TotQty + m.TotCut
          Goto lnRecNo
          Select (lcOrdLine)
          =Rlock()
          Replace Cut1   With Cut1+m.Cut1 ,;
            Cut2   With Cut2+m.Cut2 ,;
            Cut3   With Cut3+m.Cut3 ,;
            Cut4   With Cut4+m.Cut4 ,;
            Cut5   With Cut5+m.Cut5 ,;
            Cut6   With Cut6+m.Cut6 ,;
            Cut7   With Cut7+m.Cut7 ,;
            Cut8   With Cut8+m.Cut8 ,;
            TotCut With Cut1+Cut2+Cut3+Cut4+Cut5+Cut6+Cut7+Cut8
          Unlock
          Select (lcOrdHdr)
          =Rlock()
          Replace TotCut With TotCut + m.TotCut
          Unlock
          If Seek('O'+&lcOrdLine..cFromOrder+Str(&lcOrdLine..BulkLineNo,6),'ORDLINE')
            Select ORDLINE
            =Rlock()
            Replace Cut1   With Max(Cut1-m.Cut1,0) ,;
              Cut2   With Max(Cut2-m.Cut2,0) ,;
              Cut3   With Max(Cut3-m.Cut3,0) ,;
              Cut4   With Max(Cut4-m.Cut4,0) ,;
              Cut5   With Max(Cut5-m.Cut5,0) ,;
              Cut6   With Max(Cut6-m.Cut6,0) ,;
              Cut7   With Max(Cut7-m.Cut7,0) ,;
              Cut8   With Max(Cut8-m.Cut8,0) ,;
              TotCut With Cut1+Cut2+Cut3+Cut4+Cut5+Cut6+Cut7+Cut8
            Unlock
            Select OrdHdr
            =Rlock()
            Replace TotCut With Max(TotCut - m.TotCut,0)
            Unlock
          Endif
          laDistQty[1] = laDistQty[1] - m.Cut1
          laDistQty[2] = laDistQty[2] - m.Cut2
          laDistQty[3] = laDistQty[3] - m.Cut3
          laDistQty[4] = laDistQty[4] - m.Cut4
          laDistQty[5] = laDistQty[5] - m.Cut5
          laDistQty[6] = laDistQty[6] - m.Cut6
          laDistQty[7] = laDistQty[7] - m.Cut7
          laDistQty[8] = laDistQty[8] - m.Cut8
        Endif
      Endscan
    Endif
    Select (lcOrdLine)
    =Rlock()
    Replace nSteps With 9
    Unlock
  Endif
  *E303199,1 RAS 07-17-2012 update start date with line date first and if empty with header date [begin]

  *!*	    SCATTER MEMVAR MEMO
  *!*	  	    m.Start    = laData[9]
  *!*	   *E301305,1 AMM if complete date isn't per line or empty complete date, get it from header
  *!*	    *m.Complete = laData[10]
  *!*	    m.Complete = IIF(!llCDPerL .OR. EMPTY(m.Complete),laData[10],m.Complete )
  *!*	    *E301305,1 AMM end
  Scatter Memvar Memo
  m.Start    = Iif(!llCDPerL .Or. Empty(m.Start),laData[9],m.Start)
  m.Complete = Iif(!llCDPerL .Or. Empty(m.Complete),laData[10],m.Complete )

  *E303199,1 RAS 07-17-2012 update start date with line date first and if empty with header date[end]


  m.Flag     = Space(1)
  *B802131,1 If the dates allready updated by the program ,no need to update them again.
  llUpdDates = .F.
  *B802131,1 End.
  m.ORDER    = laData[1]
  *E302953,1 RAS 08/08/2011 define variable that hold x if this order has no other line after do 860[begin]
  lcHdrStatus=''
  *E302953,1 RAS 08/08/2011 define variable that hold x if this order has no other line after do 860[end]
  Do Case

    *B611136,1 Ras 2016-04-04 solve bug not saving lines due to new line no [begin]
    *!*  CASE !llFromEDI AND !DELETED() .AND. !SEEK(lcOrdType+laData[1]+STR(LINENO,6),'OrdLine')
  Case !Deleted() .And. !Seek(lcOrdType+laData[1]+Str(Lineno,6),'OrdLine')
    *B611136,1 Ras 2016-04-04 solve bug not saving lines due to new line no [end]

    *B611392,1 AEG 08/20/2017 change line number type to open when adding new order line [T20170810.0027]
    m.cOrdType  = Iif(llFromEDI,'O',m.cOrdType)
    *B611392,1 AEG 08/20/2017 change line number type to open when adding new order line [T20170810.0027]
    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
    lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
    lcLogCont='Entered Case# 1'+Chr(13)+Chr(10)
    Strtofile(lcLogCont,lcLog,1)
    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

    lnLineCount=lnLineCount+1
    m.LineNo = lnLineCount
    Insert Into ORDLINE From Memvar
    If Seek(lcOrdType+laData[1],'ORDHDR')
      Select OrdHdr
      Replace LastLine With lnLineCount
    Endif
  Case (llFromEDI .And. Seek('T'+Order+Str(Lineno,6),'OrdLine') ) .Or. ;
      (!Deleted() .And. Seek(lcOrdType+Order+Str(Lineno,6),'OrdLine'))
    m.cOrdType  = Iif(llFromEDI,'O',m.cOrdType)


    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
    lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
    lcLogCont='Entered Case# 2'+Chr(13)+Chr(10)
    Strtofile(lcLogCont,lcLog,1)
    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

    If llFromEDI And ORDLINE.cOrdType='T'
      lnLineCount=lnLineCount+1
      m.LineNo = lnLineCount
    Endif
    Select ORDLINE
    *B611034,1 AEG 2015/07/29 overide style description only if empty[begin]
    m.DESC1=Iif(Empty(ORDLINE.DESC1), M.DESC1 ,ORDLINE.DESC1 )
    *B611034,1 AEG 2015/07/29 overide style description only if empty[begin]
    Gather Memvar Memo
    If Deleted()
      Recall
    Endif
  Case Deleted() .And. Seek(lcOrdType+Order+Str(Lineno,6),'OrdLine')


    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
    lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
    lcLogCont='Entered Case# 3'+Chr(13)+Chr(10)
    Strtofile(lcLogCont,lcLog,1)
    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

    Select ORDLINE
    *E302953,1 RAS 08/08/2011 get set deleted status and ordline recNo[begin]
    lcDeletedStatus=Set("Deleted")
    Set Deleted Off
    lcOrdLRecNo=Recno()
    *E302953,1 RAS 08/08/2011 get set deleted status and ordline recNo[end]
    Delete
    *E302953,1 RAS 08/08/2011 make 860 cancel the order if it delete the only order line[begin]
    Set Deleted On

    *E303469,1 RAS 2014-04-27 modi prg to handle delete all order items then add an item[begin]
    *ADD check to be sure that there is more items to be added on this order
    *!*	    IF !SEEK(lcOrdType+laData[1],'ORDLINE')
    If !Seek(lcOrdType+laData[1],'ORDLINE') And Recno(lcOrdLine)= Reccount(lcOrdLine)
      *E303469,1 RAS 2014-04-27 modi prg to handle delete all order items then add an item[end]

      If Seek('O'+laData[1],'OrdHdr','OrdHdr')
        lcHdrStatus='X'
      Endif
      Set Deleted Off
      Goto lcOrdLRecNo
      Recall
      *B610606,1 RAS 11/27/2013 solve bug set deleted on before apply effect on all deleted lines [begin]
      *!*	      SET DELETED &lcDeletedStatus
      *B610606,1 RAS 11/27/2013 solve bug set deleted on before apply effect on all deleted lines [end]
    Endif
    *B610606,1 RAS 11/27/2013 solve bug set deleted on before apply effect on all deleted lines [begin]
    Set Deleted &lcDeletedStatus
    *B610606,1 RAS 11/27/2013 solve bug set deleted on before apply effect on all deleted lines [end]
    *E302953,1 RAS 08/08/2011 make 860 cancel the order if it delete the only order line[end]
  Otherwise


    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
    lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
    lcLogCont='Entered OTHERWISE '+Chr(13)+Chr(10)
    Strtofile(lcLogCont,lcLog,1)
    *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]


    llcSave = .F.
    Return
  Endcase
  Select (lcOrdLine)

  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
  lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
  lcLogCont='before replace order number: ' + Order +' & line number: '+ Alltrim(Str(Lineno))+Chr(13)+Chr(10)
  Strtofile(lcLogCont,lcLog,1)
  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

  =Rlock()
  Replace Order  With laData[1] ,;
    LINENO With m.LineNo
  Unlock


  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
  lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
  lcLogCont='after replace order number: ' + Order + ' & line number: '+ Alltrim(Str(Lineno))+Chr(13)+Chr(10)
  Strtofile(lcLogCont,lcLog,1)
  *E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]

Endscan
*E038729,1 WAM 11/11/2004 Maintain SQL tables

If oAriaApplication.isRemoteComp And llBlkAloTrn
  lnResult = lfSqlUpdate('CUTPICK',lcTranCode, Set("DATASESSION"),'trancd,ctktno,ctktlineno,order,style,cordline')
  If lnResult <=0
    =oAriaApplication.RemoteCompanyData.CheckRetResult("SQLUPDATE",lnResult,.T.)
    =oAriaApplication.RemoteCompanyData.RollBackTran(lcTranCode)
  Else
    If oAriaApplication.RemoteCompanyData.CommitTran(lcTranCode,.T.) = 1
    Else
      =oAriaApplication.RemoteCompanyData.CheckRetResult("COMMITTRAN",lnResult,.T.)
    Endif
  Endif
  Use In CUTPICK
Endif
*E038729,1 WAM 11/11/2004 (End)

*B802131,1 If the date does not updated and its need to update.
If llUpdDates
  Select ORDLINE
  If Seek(lcOrdType+laData[1])
    *E301305,1 AMM Update complete date with suitable date due to the system setting
    *REPLACE REST Start WITH laData[9],Complete WITH laData[10] ;
    WHILE cOrdType+Order=lcOrdType+laData[1]

    *E303199,1 RAS 07-17-2012 update update start date with line date first and if empty with header date [begin]
    *!*	      REPLACE REST START WITH laData[9] , COMPLETE WITH IIF(llCDPerL,COMPLETE,laData[10]) ;
    *!*	        WHILE cOrdType+ORDER=lcOrdType+laData[1]
    Replace Rest Start With Iif(!llCDPerL Or Empty(Start),laData[9],Start) , Complete With Iif(llCDPerL,Complete,laData[10]) ;
      WHILE cOrdType+Order=lcOrdType+laData[1]
    *E303199,1 RAS 07-17-2012 update update start date with line date first and if empty with header date [end]
    *E301305,1 AMM end
  Endif
Endif
*B802131,1 End.

*E301288,1 Reham On 07/20/1999   *** Begin ***
*E301288,1 Call global function to update the bomvar file.
If llBomVarnt
  =gfTmp2Mast('BOMVAR' , lcT_BomVar , 'Update the style positions for the order lines...')
Endif
*E301288,1 Reham On 07/20/1999   *** End   ***

*E301077,5 Inhance openning files to speed up transaction
=gfCloseFile('icStyHst')
=gfCloseFile('ORDCANLN')
=Iif('AL' $ gcCmpModules,gfCloseFile('PikTkt'),.T.)
If lcOrdType='O' And laScrMode[4] And Used('CUTPICK')
  =gfCloseFile('CUTPICK')
Endif
*E301077,5 (End)

Set Delete On

*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*WAIT 'Updating order header...' WINDOW NOWAIT
If !llSilent
  Wait 'Updating order header...' Window Nowait
Endif
*B612293,1 HIA 12/16/2020 add silent mode feature [End]

*E301077,5 Inhance openning files to speed up transaction
=gfOpenFile(gcDataDir+'arCusHst',gcDataDir+'Acthst','SH')
*E301077,5 (End)
Select OrdHdr
If llFromEDI .And. Seek('T'+lcEdiOrd)
  Replace cOrdType With 'O' ,;
    ORDER    With laData[1]
Else
  If !Seek(lcOrdType+laData[1])
    Insert Into OrdHdr (cOrdType,Order) Values (lcOrdType,laData[1])
  Endif
Endif
If lcOrdType='O' .And. laData[5]<>'B' .And. Seek(laData[2]+lcGlYear,'arCusHst') .And. ;
    &lcOrdHdr..nSteps < 1
  lnOrdAmt = laData[42] &lcExRSin laData[34] &lcUntSin laData[50] - ;
    IIF(laScrMode[4] Or OrdHdr.Status='B',0,OrdHdr.Openamt &lcExRSin OrdHdr.nExRate &lcUntSin OrdHdr.nCurrUnit)
  Select arCusHst
  =Rlock()
  Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod -;
    IIF(laScrMode[4] Or OrdHdr.Status='B',0,OrdHdr.Open) + laData[41],;
    nOrdQty With nOrdQty -;
    IIF(laScrMode[4] Or OrdHdr.Status='B',0,OrdHdr.Open) + laData[41],;
    nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod + lnOrdAmt ,;
    nOrdAmt With nOrdAmt + lnOrdAmt
  Unlock
  Select (lcOrdHdr)
  =Rlock()
  Replace nSteps With 1
  Unlock
Endif
*E500309,1 AMM If bulk order , deduct from booked else add to canceled quantity
*IF lcOrdType='O' .AND. laData[5]<>'B' .AND. (laScrMode[4] .OR. OrdHdr.Status='B') .AND. ;
*   SEEK(lcOrdType+&lcOrdHdr..cFromOrder,'OrdHdr')
*
*  IF &lcOrdHdr..nSteps < 2 .AND. SEEK(laData[2]+lcBulkYear,'arCusHst')
*    lnOrdAmt = lnCancelAmt &lcExRSin laData[34] &lcUntSin laData[50]
*    SELECT arCusHst
*    =RLOCK()
*    REPLACE nOrdQty&lcBulkPrd WITH nOrdQty&lcBulkPrd - lnCancel ,;
*            nOrdQty           WITH nOrdQty           - lnCancel ,;
*            nOrdAmt&lcBulkPrd WITH nOrdAmt&lcBulkPrd - lnOrdAmt ,;
*            nOrdAmt           WITH nOrdAmt           - lnOrdAmt
*    UNLOCK
*    SELECT (lcOrdHdr)
*    =RLOCK()
*    REPLACE nSteps WITH 2
*    UNLOCK
*  ENDIF
*  IF &lcOrdHdr..nSteps < 3
*    SELECT ORDHDR
*    =RLOCK('ORDHDR')
*    REPLACE Cancel    WITH Cancel    + lnCancel   ,;
*            Cancelamt WITH Cancelamt + lnCancelAmt,;
*            Open      WITH Book      - Cancel     ,;
*            Openamt   WITH Bookamt   - Cancelamt  ,;
*            Status    WITH IIF(OrdHdr.Open = 0 ,'X',OrdHdr.Status)
*    UNLOCK IN 'ORDHDR'
*    SELECT (lcOrdHdr)
*    =RLOCK()
*    REPLACE nSteps WITH 3
*    UNLOCK
*  ENDIF
*  IF OrdHdr.Status='X' .AND. &lcOrdHdr..nSteps < 4 .AND. ;
*    SEEK('M'+OrdHdr.Account,'Customer')
*    SELECT Customer
*    =RLOCK('Customer')
*    REPLACE nBulk WITH nBulk - 1
*    UNLOCK IN 'Customer'
*    SELECT (lcOrdHdr)
*    =RLOCK()
*    REPLACE nSteps WITH 4
*    UNLOCK
*  ENDIF
*ENDIF

If lcOrdType='O' .And. laData[5]<>'B' .And. (laScrMode[4] .Or. OrdHdr.Status='B')
  If &lcOrdHdr..nSteps < 2 .And. Seek(laData[2]+lcBulkYear,'arCusHst')
    lnOrdAmt = lnCancelAmt &lcExRSin laData[34] &lcUntSin laData[50]
    Select arCusHst
    =Rlock()
    Replace nOrdQty&lcBulkPrd With nOrdQty&lcBulkPrd - lnCancel ,;
      nOrdQty           With nOrdQty           - lnCancel ,;
      nOrdAmt&lcBulkPrd With nOrdAmt&lcBulkPrd - lnOrdAmt ,;
      nOrdAmt           With nOrdAmt           - lnOrdAmt
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 2
    Unlock
  Endif
  If OrdHdr.Status='X' .And. &lcOrdHdr..nSteps < 4 .And. ;
      SEEK('M'+laData[2],'Customer')

    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    LcAl=Alias()
    Select OrdHdr
    lcORD = Order()
    Set Order To ORDBULK
    =Seek(laData[2]+'O'+'Y'+'O','ORDHDR','ORDBULK')
    lnBulkCntO=0
    lnBulkCntH=0
    Count To lnBulkCntO  While account+Status+bulk+cOrdType+Order = laData[2]+'O'+'Y'+'O'
    =Seek(laData[2]+'H'+'Y'+'O','ORDHDR','ORDBULK')
    Count To lnBulkCntH  While account+Status+bulk+cOrdType+Order = laData[2]+'H'+'Y'+'O'
    lnBulkCntO=lnBulkCntO+lnBulkCntH
    Set Order To (lcORD)
    Select (LcAl)
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]

    Select Customer
    =Rlock('Customer')
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    *!*REPLACE nBulk WITH nBulk - 1
    Replace nBulk With lnBulkCntO
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
    Unlock In 'Customer'
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 4
    Unlock
  Endif
Endif
*E500309,1 AMM end
*E301077,5 Inhance openning files to speed up transaction
=gfCloseFile('arCusHst')
*E301077,5 (End)

If lcOrdType='O' And laData[5]<>'B' And (laScrMode[4] Or OrdHdr.Status='B') And ;
    &lcOrdHdr..bulk='Y' And &lcOrdHdr..nSteps < 5 And Seek('M'+laData[2],'Customer')

  *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
  LcAl=Alias()
  Select OrdHdr
  lcORD = Order()
  Set Order To ORDBULK
  =Seek(laData[2]+'O'+'Y'+'O','ORDHDR','ORDBULK')
  lnBulkCntO=0
  lnBulkCntH=0
  Count To lnBulkCntO  While account+Status+bulk+cOrdType+Order = laData[2]+'O'+'Y'+'O'
  =Seek(laData[2]+'H'+'Y'+'O','ORDHDR','ORDBULK')
  Count To lnBulkCntH  While account+Status+bulk+cOrdType+Order = laData[2]+'H'+'Y'+'O'
  lnBulkCntO=lnBulkCntO+lnBulkCntH
  Set Order To (lcORD)
  Select (LcAl)
  *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]

  Select Customer
  =Rlock()
  *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
  *!*REPLACE nBulk WITH nBulk + 1
  Replace nBulk With lnBulkCntO
  *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
  Unlock
  Select (lcOrdHdr)
  =Rlock()
  Replace nSteps With 5
  Unlock
Endif
Select OrdHdr
=Seek(lcOrdType+laData[1])
=Rlock()
Gather From laData Fields &lcScFields
*E303886,1 Derby 26/11/2017 - SALES ORDER APPROVAL/ORDER STATUS [Start]
*REPLACE cOrdType   WITH lcOrdType ,;
LastLine   WITH lnLineCount  ,;
cFromOrder WITH &lcOrdHdr..cFromOrder ,;
StName     WITH IIF(laData[51],lcShipName,SPACE(30)) ,;
cAddress1  WITH IIF(laData[51],lcShipAdd1,SPACE(30)) ,;
cAddress2  WITH IIF(laData[51],lcShipAdd2,SPACE(30)) ,;
cAddress3  WITH IIF(laData[51],lcShipAdd3,SPACE(30)) ,;
cAddress4  WITH IIF(laData[51],lcShipAdd4,SPACE(30)) ,;
cAddress5  WITH IIF(laData[51],lcShipAdd5,SPACE(30)) ,;
TotCut     WITH &lcOrdHdr..TotCut

Replace cOrdType   With lcOrdType ,;
  Status     With &lcOrdHdr..Status  ,;
  Approval   With &lcOrdHdr..Approval  ,;
  LastLine   With lnLineCount  ,;
  cFromOrder With &lcOrdHdr..cFromOrder ,;
  StName     With Iif(laData[51],lcShipName,Space(30)) ,;
  cAddress1  With Iif(laData[51],lcShipAdd1,Space(30)) ,;
  cAddress2  With Iif(laData[51],lcShipAdd2,Space(30)) ,;
  cAddress3  With Iif(laData[51],lcShipAdd3,Space(30)) ,;
  cAddress4  With Iif(laData[51],lcShipAdd4,Space(30)) ,;
  cAddress5  With Iif(laData[51],lcShipAdd5,Space(30)) ,;
  TotCut     With &lcOrdHdr..TotCut
*E303886,1 Derby 26/11/2017 - SALES ORDER APPROVAL/ORDER STATUS [End]
*E302953,1 RAS 08/08/2011 make 860 cancel the order if it delete the only order line[begin]
If lcHdrStatus=='X'
  Replace Status With 'X' In OrdHdr
Endif
*E302953,1 RAS 08/08/2011 make 860 cancel the order if it delete the only order line[end]
Unlock

*E301175,1 Add this line to add the capability to call this function from
*          the EDI - from EDIProcessPO Class - [Begin]

*-- If the function was not called from EDI
If !llFromEDI
  *E301175,1 Add this line to add the capability to call this function [End]

  Select UnCmSess
  *B602496,1 Update the order record in the uncmsess file
  =Seek('O'+Padr('SOORD',10)+gcUser_id+lcSession)
  *B602496,1 (End)

  Replace Status With 'C'
  Unlock
  llContinue = .F.
  Unlock

  *E301175,1 Add this line to add the capability to call this function from
  *          the EDI - from EDIProcessPO Class - [Begin]
Endif    && End of IF !llFromEDI
*E301175,1 Add this line to add the capability to call this function [End]

*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*WAIT CLEAR
If !llSilent
  Wait Clear
Endif
*B612293,1 HIA 12/16/2020 add silent mode feature [End]

If laScrMode[4] And !llFromEDI
  *E300420,1 Message : 32045
  *E300420,1 Order has been saved as xxxxxx
  *E300420,1 Button : 00000
  *E300420,1 Ok

  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *=gfModalGen('INM32045B00000','DIALOG',Iif(lcOrdType='C','Contract','Order')+'|'+laData[1])
  If !llSilent
    =gfModalGen('INM32045B00000','DIALOG',Iif(lcOrdType='C','Contract','Order')+'|'+laData[1])
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  *--B602753,1 HDM 04/07/1999[Start] Stop Calling NotePad Program In lpSavScr as the global save
  *--B602753,1 HDM 04/07/1999        Will Call it
  *= IIF(gfModalGen("QRM00271B00006") = 1, NotePad('B',laData[1]), .T.)
  *--B602753,1 HDM 04/07/1999[End]
Endif
Set Order To Tag 'ORDLINE' In (lcOrdLine)

*E301086,1 Add new record in the EDI transaction file to be send
If !llFromEDI And lcOrdType='O' And 'EB' $ gcCmpModules
  *E301077,5 Inhance openning files to speed up transaction
  =gfOpenFile(gcDataDir+'EDIACPRT',gcDataDir+'ACCFACT','SH')
  =gfOpenFile(gcDataDir+'EDIPD',gcDataDir+'PARTTRANS','SH')
  =gfOpenFile(gcDataDir+'EDITRANS',gcDataDir+'TYPEKEY','SH')
  *E301077,5 (End)

  If Seek('A'+laData[2],'EDIACPRT') And Seek(EDIACPRT.cPartCode+'855','EDIPD')
    Select EDITRANS
    *E037853,1 HBG 16/02/2004 Change the width of Key field in EDITRANS to 40 char [Begin]
    *IF !SEEK('855'+PADR(laData[1],20)+'A'+laData[2])
    If !Seek('855'+Padr(laData[1],40)+'A'+laData[2])
      *E037853,1 HBG 16/02/2004 Change the width of Key field in EDITRANS to 40 char [End]
      Insert Into 'EDITRANS' (cEdiTrnTyp,Key,Type,cPartner) Values ;
        ('855',laData[1],'A',laData[2])
    Endif
    Replace cStatus With 'N'
    =gfAdd_Info('EDITRANS')
  Endif

  *E302709,1 HES 07/20/2010 Add new 850 record for (Customer\Factor) AND new 865 in EDI transaction file [Begin]
  *-- Add new 850 record in the EDI transaction file to be sent to the customer
  If Seek('A'+&lcOrdHdr..account,'EDIACPRT') And Seek(EDIACPRT.cPartCode+'850','EDIPD') And EDIPD.cTranType = "S"
    If !Seek('850'+Padr(lcOrderNo,40)+'A'+&lcOrdHdr..account,'EDITRANS')
      Insert Into 'EDITRANS' (cEdiTrnTyp,Key,Type,cPartner) Values ;
        ('850',lcOrderNo,'A',&lcOrdHdr..account)
    Endif
    Replace cStatus With 'N' In EDITRANS
    =gfAdd_Info('EDITRANS')
  Endif
  *-- Add new 850 record in the EDI transaction file to be sent to the factor
  If Seek('F'+&lcOrdHdr..cFacCode,'EDIACPRT') And Seek(EDIACPRT.cPartCode+'850','EDIPD') And EDIPD.cTranType = "S"
    If !Seek('850'+Padr(lcOrderNo,40)+'F'+&lcOrdHdr..cFacCode,'EDITRANS')
      Insert Into 'EDITRANS' (cEdiTrnTyp,Key,Type,cPartner) Values ;
        ('850',lcOrderNo,'F',&lcOrdHdr..cFacCode)
    Endif
    Replace cStatus With 'N' In EDITRANS
    =gfAdd_Info('EDITRANS')
  Endif
  *-- Add new 865 record in the EDI transaction file to be sent
  If Seek('A'+&lcOrdHdr..account,'EDIACPRT') And Seek(EDIACPRT.cPartCode+'865','EDIPD')
    If !Seek('865'+Padr(&lcOrdHdr..Order,40)+'A'+&lcOrdHdr..account,'EDITRANS')
      Insert Into 'EDITRANS' (cEdiTrnTyp,Key,Type,cPartner) Values ;
        ('865',&lcOrdHdr..Order,'A',&lcOrdHdr..account)
    Endif
    Replace cStatus With 'N' In EDITRANS
    =gfAdd_Info('EDITRANS')
  Endif
  *E302709,1 HES 07/20/2010 Add new 850 record for (Customer\Factor) AND new 865 in EDI transaction file [End  ]

  *E301077,5 Inhance openning files to speed up transaction
  =gfCloseFile('EDIACPRT')
  =gfCloseFile('EDIPD')
  =gfCloseFile('EDITRANS')
  *E301077,5 (End)
Endif
*E301086,1 (End)

*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
If Used("BlkORDCnl")
  *E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
  Use In BlkORDCnl
  *E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
Endif
*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]

*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End  ]

llcSave = Seek(lcOrdType+laData[1],'ORDLINE')

*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [BEGIN]
lcLog=oAriaApplication.syspath+Strtran(Dtoc(Date()),'/','')+'.txt'
lcLogCont='llcSave# '+Iif(llcSave,'TRUE','FALSE')+Chr(13)+Chr(10)
Strtofile(lcLogCont,lcLog,1)
*E303687,1 AEG 2016-27-06 adding log when appdating 850 transaction [END]


Select OrdHdr
Return

*!*************************************************************
*! Name      : lfDelScr
*! Developer : Wael Aly Mohamed
*! Date      : 01/01/1996
*! Purpose   : Cancel/Uncancel order
*!*************************************************************
*! Calls     : gfModalGen,lfGetInfo
*!*************************************************************
*! Parameters: None
*!*************************************************************
*! Returns   :  None.
*!*************************************************************
*! Example   :  =lfDelScr()
*!*************************************************************
*!Modifications
*!
*!B801945,1 WAM 02/09/1999 Check if allocation module is installed before
*!B801945,1                use piktkt file.
*!*************************************************************
Function lfDelScr

*E301175,1 Add this line to add a new parameter to know if the function was
*          called from EDI - from EDI transaction 860
*          (Purchase Order Modify) -. [Begin]
*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*PARAMETERS llFromEDI
Parameters llFromEDI, llSilent
*B612293,1 HIA 12/16/2020 add silent mode feature [End]
*E301175,1 Add this line to add a new parameter to know if the function [End]


*B602674,1 Add this line to fix the bug "Variable llFromEDI not found" [Begin]
llFromEDI = Iif(Type('llFromEDI') = 'L' , llFromEDI , .F.)
*B602674,1 Add this line to fix the bug "Variable llFromEDI not found" [End]

*E303266,1 RAS 10/01/2012 get showing 860 cancel message setup value from partner screen [begin]
lc860CMValue=Iif(Empty(EDIACPRT.batchcm),'I',EDIACPRT.batchcm)
*E303266,1 RAS 10/01/2012 get showing 860 cancel message setup value from partner screen [end]

*E302709,1 HES 07/20/2010 Add new 865 in EDI transaction file [Begin]
If llFromEDI And OrdHdr.cOrdType='O' And 'EB' $ oAriaApplication.CompanyInstalledModules
  =gfOpenFile(oAriaApplication.DataDir+'EDIACPRT',oAriaApplication.DataDir+'ACCFACT'  ,'SH')
  =gfOpenFile(oAriaApplication.DataDir+'EDIPD'   ,oAriaApplication.DataDir+'PARTTRANS','SH')
  =gfOpenFile(oAriaApplication.DataDir+'EDITRANS',oAriaApplication.DataDir+'TYPEKEY'  ,'SH')

  * E302931,1 RAS 07/07/2011 prevent add row for 865 in editrans table as it already has been added from edipo class[begin]
  If !Inlist(EDIPD.CMAPSET,'GFS')
    * E302931,1 RAS 07/07/2011 prevent add row for 865 in editrans table as it already has been added from edipo class[END  ]

    *-- Add new 865 record in the EDI transaction file to be sent
    If Seek('A'+OrdHdr.account,'EDIACPRT') And Seek(EDIACPRT.cPartCode+'865','EDIPD')
      If !Seek('865'+Padr(OrdHdr.Order,40)+'A'+OrdHdr.account,'EDITRANS')
        Insert Into 'EDITRANS' (cEdiTrnTyp,Key,Type,cPartner) Values ;
          ('865',OrdHdr.Order,'A',OrdHdr.account)
      Endif
      Replace cStatus With 'N' In EDITRANS
      =gfAdd_Info('EDITRANS')
    Endif

    * E302931,1 RAS 07/07/2011 prevent add row for 865 in editrans table as it already has been added from edipo class[begin]
  Endif
  * E302931,1 RAS 07/07/2011 prevent add row for 865 in editrans table as it already has been added from edipo class[end  ]

Endif
*E302709,1 HES 07/20/2010 Add new 865 in EDI transaction file [End  ]

Private lnTktCnt

If lcOrdType='O' .And. !CHECKPRD(OrdHdr.Entered,'lcGlYear','lcGlPeriod ','',.T.)
  *E303278,1 RAS 10/17/2012 show descriptive message in case of invalid period before get out [begin]

  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *MESSAGEBOX("Invalid Period !       ",16+512,_screen.caption)
  If !llSilent
    Messagebox("Invalid Period !       ",16+512,_Screen.Caption)
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  *E303278,1 RAS 10/17/2012 show descriptive message in case of invalid period before get out [end]
  Return
Endif
lcUntSin = ''
lcExRSin = gfGetExSin(@lcUntSin, laData[33])

If OrdHdr.Status='X'
  If lcOrdType='O' .And. !Seek(lcOrdType+laData[1],'ORDLINE')
    *E300420,1 Message : 32000
    *E300420,1 The lines for this order are missing! Cannot update cut & sold.
    *E300420,1 Button : 00000
    *E300420,1 Ok

    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    *=gfModalGen('TRM32000B00000','ALERT')
    If !llSilent
      =gfModalGen('TRM32000B00000','ALERT')
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]

    Return
  Endif
  Set Order To Tag ORDLINE In ORDLINE
  Set Order To Tag OrdHdr  In OrdHdr
  If !llContinue
    *E300420,1 Message : 32002
    *E300420,1 Order is canceled. Uncancel?
    *E300420,1 Button : 32000
    *E300420,1 Yes/No
    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    If !llSilent
        *B612293,1 HIA 12/16/2020 add silent mode feature [End]
      If gfModalGen('QRM32002B32000','ALERT',Iif(lcOrdType='C','Contract','Order')) =2
        Return
      ENDIF
    
      *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]    
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]
              
    
    If OrdHdr.Cancel = 0 And OrdHdr.bulk <> 'Y'
      Select OrdHdr
      =Rlock()
      Replace Status     With 'B' ,;
        cCancReson With Space(6) ,;
        Cancelled  With {} ,;
        FLAG       With Space(1)
      Unlock
      Scatter Fields &lcScFields To laData
      =lfGetInfo()
      Return
    Endif
    *E301077,5 Inhance openning files to speed up transaction
    *SELECT (lcOrdHdr)
    *DELETE
    *SELECT ORDHDR
    *=SEEK(lcOrdType+laData[1])
    *SCATTER MEMVAR
    *INSERT INTO (lcOrdHdr) FROM MEMVAR
    *SELECT (lcOrdLine)
    *DELETE ALL
    *SELECT ORDLINE
    *=SEEK(lcOrdType+laData[1])
    *SCAN REST WHILE cordtype+order+STR(lineno,6) = lcOrdType+laData[1]
    *  SCATTER MEMVAR
    *  INSERT INTO (lcOrdLine) FROM MEMVAR
    *ENDSCAN

    *B608442,1 optimize the code to enhance the speed when update 860 HIA 02/19/2008 [Begin]
    *SELECT *, 00 AS nSteps FROM ORDHDR WHERE cordtype+order=lcOrdType+laData[1];
    *INTO DBF (gcWorkDir+lcOrdHdr)
    *SELECT *, 00 AS nSteps FROM ORDLINE WHERE cordtype+order+STR(lineno,6)=;
    *lcOrdType+laData[1] INTO DBF (gcWorkDir+lcOrdLine)

    Select OrdHdr
    Copy Structure To (gcWorkDir+lcOrdHdr)

    Use (gcWorkDir+lcOrdHdr)  In 0 Exclusive
    Select (lcOrdHdr)
    Alter Table (lcOrdHdr) Add Column nSteps  N(2,0)

    Use In (lcOrdHdr)
    Use (gcWorkDir+lcOrdHdr)  In 0 Shared

    Select OrdHdr
    =Seek(lcOrdType+laData[1])
    Scan Rest While cOrdType+Order=lcOrdType+laData[1]
      Scatter Memvar Memo
      m.nSteps = 0
      Select (lcOrdHdr)
      Append Blank
      Gather Memvar Memo
      Select OrdHdr
    Endscan
    Select OrdHdr
    =Seek(lcOrdType+laData[1])

    Select ORDLINE
    Copy Structure To (gcWorkDir+lcOrdLine)

    Use (gcWorkDir+lcOrdLine)  In 0 Exclusive
    Select (lcOrdLine)
    Alter Table (lcOrdLine) Add Column nSteps  N(2,0)

    Use In (lcOrdLine)
    Use (gcWorkDir+lcOrdLine)  In 0 Shared

    Select ORDLINE
    =Seek(lcOrdType+laData[1])
    Scan Rest While cOrdType+Order+Str(Lineno,6)=lcOrdType+laData[1]
      Scatter Memvar Memo
      m.nSteps = 0
      Select (lcOrdLine)
      Append Blank
      Gather Memvar Memo
      Select ORDLINE
    Endscan
    Select ORDLINE
    =Seek(lcOrdType+laData[1])
    Select (lcOrdLine)

    *B608442,1 optimize the code to enhance the speed when update 860 HIA 02/19/2008 [End]
    *E301077,5 (End)

    If !llFromEDI
      Select 'UNCMSESS'
      If Seek('I')
        Blank
      Else
        Append Blank
      Endif
      Replace Status     With 'O'       ,;
        cUTranType With 'SOORD'   ,;
        cUserId    With gcUser_id ,;
        cSession   With lcSession ,;
        cProgram   With 'SOORD'   ,;
        cCurrScr   With 'SOORD'   ,;
        cCurrObj   With 'PBDLT'   ,;
        dTranDate  With gdSysDate ,;
        cTranTime  With Time()
      =Rlock()
      lcCurrOrd = laData[1]
      lcFiles = 'lcOrdHdr,'+lcOrdHdr+','+lcOrdHdr+';'+;
        'lcOrdLine,'+lcOrdLine+',lcOrdLine;'
      =gfSavSess('SOORD', lcFiles, @laVariables,lcSession)
    Endif
  Endif
  If lcOrdType='O'

    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    *WAIT 'Uncancelling and updating Cut & Sold...' WINDOW NOWAIT
    If !llSilent
      Wait 'Uncancelling and updating Cut & Sold...' Window Nowait
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  Endif
  Store 0 To lnNewOpen,lnNewOAmt
  *E301077,5 Inhance openning files to speed up transaction
  =gfOpenFile(gcDataDir+'icStyHst',gcDataDir+'Styhst','SH')
  *E301077,5 (End)
  Select (lcOrdLine)
  Scan
    If lcOrdType='O' .And. nSteps < 1
      Select StyDye
      =Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+Space(10),'StyDye')
      =Rlock()
      Replace ORD1   With ORD1 + &lcOrdLine..Qty1 ,;
        ORD2   With ORD2 + &lcOrdLine..Qty2 ,;
        ORD3   With ORD3 + &lcOrdLine..Qty3 ,;
        ORD4   With ORD4 + &lcOrdLine..Qty4 ,;
        ORD5   With ORD5 + &lcOrdLine..Qty5 ,;
        ORD6   With ORD6 + &lcOrdLine..Qty6 ,;
        ORD7   With ORD7 + &lcOrdLine..Qty7 ,;
        ORD8   With ORD8 + &lcOrdLine..Qty8 ,;
        TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
      Unlock
      *E038463,1 WAM 11/09/2004 Update the Qty on the Configuration level
      If !Empty(&lcOrdLine..Dyelot) And Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+&lcOrdLine..Dyelot)
        =Rlock()
        Replace ORD1   With ORD1 + &lcOrdLine..Qty1 ,;
          ORD2   With ORD2 + &lcOrdLine..Qty2 ,;
          ORD3   With ORD3 + &lcOrdLine..Qty3 ,;
          ORD4   With ORD4 + &lcOrdLine..Qty4 ,;
          ORD5   With ORD5 + &lcOrdLine..Qty5 ,;
          ORD6   With ORD6 + &lcOrdLine..Qty6 ,;
          ORD7   With ORD7 + &lcOrdLine..Qty7 ,;
          ORD8   With ORD8 + &lcOrdLine..Qty8 ,;
          TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8 In StyDye
      Endif
      *E038463,1 WAM 11/09/2004 (End)
      Unlock In StyDye
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 1
      Unlock
    Endif
    If lcOrdType='O' .And. nSteps < 2 .And. Seek(Style,'Style')
      Select Style
      =Rlock()
      Replace ORD1   With ORD1 + &lcOrdLine..Qty1 ,;
        ORD2   With ORD2 + &lcOrdLine..Qty2 ,;
        ORD3   With ORD3 + &lcOrdLine..Qty3 ,;
        ORD4   With ORD4 + &lcOrdLine..Qty4 ,;
        ORD5   With ORD5 + &lcOrdLine..Qty5 ,;
        ORD6   With ORD6 + &lcOrdLine..Qty6 ,;
        ORD7   With ORD7 + &lcOrdLine..Qty7 ,;
        ORD8   With ORD8 + &lcOrdLine..Qty8 ,;
        TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
      Unlock
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 2
      Unlock
    Endif
    If lcOrdType='O' .And. nSteps < 3 .And. Seek(Style+lcGlYear,'icStyHst')
      lnOrdAmt = &lcOrdLine..TotQty*&lcOrdLine..Price &lcExRSin laData[34] &lcUntSin laData[50]
      Select icStyHst
      =Rlock()
      Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod + &lcOrdLine..TotQty ,;
        nOrdQty            With nOrdQty            + &lcOrdLine..TotQty ,;
        nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod + lnOrdAmt ,;
        nOrdAmt            With nOrdAmt            + lnOrdAmt
      Unlock
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 3
      Unlock
    Endif
    lnNewOpen = lnNewOpen+ TotQty
    lnNewOAmt = lnNewOAmt+ TotQty*Price
  Endscan
  *E301077,5 Inhance openning files to speed up transaction
  =gfCloseFile('icStyHst')
  *E301077,5 (End)
  If laData[23]='Y' .And. &lcOrdHdr..nSteps < 1 .And. Seek('M'+laData[2],'Customer')

    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    LcAl=Alias()
    Select OrdHdr
    lcORD = Order()
    Set Order To ORDBULK
    =Seek(laData[2]+'O'+'Y'+'O','ORDHDR','ORDBULK')
    lnBulkCntO=0
    lnBulkCntH=0
    Count To lnBulkCntO  While account+Status+bulk+cOrdType+Order = laData[2]+'O'+'Y'+'O'
    =Seek(laData[2]+'H'+'Y'+'O','ORDHDR','ORDBULK')
    Count To lnBulkCntH  While account+Status+bulk+cOrdType+Order = laData[2]+'H'+'Y'+'O'
    lnBulkCntO=lnBulkCntO+lnBulkCntH
    Set Order To (lcORD)
    Select (LcAl)
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]

    Select Customer
    =Rlock()
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    *!*REPLACE nBulk WITH nBulk + 1
    Replace nBulk With lnBulkCntO
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 1
    Unlock
  Endif
  If &lcOrdHdr..nSteps < 2
    Select OrdHdr
    =Rlock()
    Replace Status     With 'O'      ,;
      cCancReson With Space(6) ,;
      Cancelled  With {} ,;
      CANCEL     With Iif(bulk='Y',Cancel,Cancel-lnNewOpen) ,;
      CancelAmt  With Iif(bulk='Y',CancelAmt,CancelAmt-lnNewOAmt) ,;
      OPEN       With lnNewOpen ,;
      Openamt    With lnNewOAmt ,;
      FLAG       With Space(1)
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 2
    Unlock
  Endif

  If lcOrdType='O' .And. &lcOrdHdr..nSteps < 3
    *E301077,5 Inhance openning files to speed up transaction
    =gfOpenFile(gcDataDir+'arCusHst',gcDataDir+'Acthst','SH')
    *E301077,5 (End)
    =Seek(laData[2]+lcGlYear,'arCusHst')
    lnOrdAmt = lnNewOAmt &lcExRSin laData[34] &lcUntSin laData[50]
    Select arCusHst
    =Rlock()
    Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod + lnNewOpen ,;
      nOrdQty            With nOrdQty            + lnNewOpen ,;
      nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod + lnOrdAmt  ,;
      nOrdAmt            With nOrdAmt            + lnOrdAmt
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 3
    Unlock
  Endif

Else
  If OrdHdr.Status='C'
    *E300420,1 Message : 32003
    *E300420,1 Order has been shipped complete! Cannot cancel.
    *E300420,1 Button : 00000
    *E300420,1 Ok

    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    *=gfModalGen('TRM32003B00000','ALERT')
    If !llSilent
      =gfModalGen('TRM32003B00000','ALERT')
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]
    Return
  Endif
  If !Seek(lcOrdType+laData[1],'ORDLINE')
    *E300420,1 Message : 32000
    *E300420,1 The lines for this order are missing! Cannot update cut & sold.
    *E300420,1 Button : 00000
    *E300420,1 Ok

    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    *=gfModalGen('TRM32000B00000','ALERT')
    If !llSilent
      =gfModalGen('TRM32000B00000','ALERT')
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]
    Return
  Endif
  Set Order To Tag ORDLINE In ORDLINE
  Set Order To Tag OrdHdr  In OrdHdr
  If !llContinue
    If OrdHdr.TotCut > 0
      *E300420,1 Message : 32054
      *E300420,1 This order has quantity allocated.
      *E300420,1 Canceling this order will release this allocation.
      *E300420,1 Would you like to continue ?
      *E300420,1 Button : 32000
      *E300420,1 Yes  No
      If gfModalGen('QRM32054B32000','ALERT')=2
        Return
      Endif
      *E301077,5 Inhance openning files to speed up transaction
      If !oAriaApplication.isRemoteComp
        If 'PO' $ gcCmpModules
          =gfOpenFile(gcDataDir+'POSHDR',gcDataDir+'POSHDR','SH')
          =gfOpenFile(gcDataDir+'POSLN',gcDataDir+'POSLN','SH')
        Endif
        If 'MF' $ gcCmpModules
          =gfOpenFile(gcDataDir+'CUTTKTH',gcDataDir+'CUTTKTH','SH')
          *E301182,1 Update CT/PO line number in the CUTPICK file.
          *=gfOpenFile(gcDataDir+'CUTTKTL',gcDataDir+'CUTTKTL','SH')
          =gfOpenFile(gcDataDir+'CUTTKTL',gcDataDir+'CUTLIN','SH')
          *E301182,1 (End)
        Endif
        =gfOpenFile(gcDataDir+'CUTPICK',gcDataDir+'CUTORD','SH')
      Endif
      *E301077,5 (End)
    Endif

    *B801945,1 Check if allocation module is installed.
    If 'AL' $ gcCmpModules
      *E301077,5 Inhance openning files to speed up transaction
      =gfOpenFile(gcDataDir+'PIKTKT',gcDataDir+'ORDPIK','SH')
      *E301077,5 (End)

      If Seek(OrdHdr.Order,'PikTkt')
        *B602826,1 Added to check on Piktkt status for picked lines mesg.
        Select PikTkt
        Locate Rest While Order = OrdHdr.Order For Status $ 'OH'
        If Found()
          *B602826,1 End.
          *E300420,1 Message : 32004
          *E300420,1 Some order lines hve been picked.
          *E300420,1 Button : 00000
          *E300420,1 Ok

          *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
          *=gfModalGen('INM32004B00000','ALERT')
          If !llSilent
            =gfModalGen('INM32004B00000','ALERT')
          Endif
          *B612293,1 HIA 12/16/2020 add silent mode feature [End]
        Endif
      Endif
      *E301077,5 Inhance openning files to speed up transaction
      =gfOpenFile(gcDataDir+'PIKLINE',gcDataDir+'PIKLINE','SH')
      Set Order To Tag 'PIKTKT' In 'PIKTKT'
      *E301077,5 (End)
    Endif

    *E300420,1 Message : 32005
    *E300420,1 Cancel all open items on this order?
    *E300420,1 Button : 320000
    *E300420,1 Yes/No

    *E303266,1 RAS 10/01/2012 show 860 cancel message incase value of its setup per each 860 or per batch and this is
    ** the first time  [begin]

    If (lc860CMValue=='I' Or lnFCTransaction=0) And lc860CMValue<>'N'
      lnFCTransaction=1
      *E303266,1 RAS 10/01/2012 show 860 cancel message incase value of its setup per each 860 or per batch and this is
      **the first time  [end]

      If gfModalGen('QRM32005B32000','ALERT',Iif(lcOrdType='C','contract','order')) = 2
        *E303266,1 RAS 10/01/2012 store 860 cancel message response from customer to use it for next 860 in case
        ** that 860 cancel message setup value is once per batch[begin]
        lcCanMsgCho='N'
        *E303266,1 RAS 10/01/2012 store 860 cancel message response from customer to use it for next 860 in case
        ** that 860 cancel message setup value is once per batch[end]
        Return
        *E303266,1 RAS 10/01/2012 store 860 cancel message response from customer to use it for next 860 in case
        **that 860 cancel message setup value is once per batch[begin]
      Else
        lcCanMsgCho='Y'
        *E303266,1 RAS 10/01/2012 store 860 cancel message response from customer to use it for next 860 in case
        **that 860 cancel message setup value is once per batch[end]

      Endif

      *E303266,1 RAS 10/01/2012 check if customer choose to not "cancel all items" before and 860 cancel message setup
      **value is once per batch then return to not cancel the order[begin]
    Endif
    If lcCanMsgCho<>'Y'
      Return
    Endif
    *E303266,1 RAS 10/01/2012 check if customer choose to not "cancel all items" before and 860 cancel message setup
    **value is once per batch then return to not cancel the order[end]


    If OrdHdr.Status='B'
      Select OrdHdr
      =Rlock()
      Replace Status     With 'X' ,;
        cCancReson With lfCanReason() ,;
        Cancelled  With gdSysDate ,;
        FLAG       With Space(1)
      Unlock
      Scatter Fields &lcScFields To laData
      =lfGetInfo()
      Return
    Endif
    lnTktCnt = 0
    Dimension laTickets[1,2]
    *E301077,5 Inhance openning files to speed up transaction
    *IF 'PO' $ gcCmpModules
    *  SET ORDER TO TAG POSLN IN POSLN
    *ENDIF
    *IF 'MF' $ gcCmpModules
    *  SET ORDER TO TAG CUTTKTL IN CUTTKTL
    *ENDIF
    *SELECT (lcOrdHdr)
    *DELETE
    *SELECT ORDHDR
    *=SEEK(lcOrdType+laData[1])
    *SCATTER MEMVAR
    *m.cCancReson = lfCanReason()
    *INSERT INTO (lcOrdHdr) FROM MEMVAR
    *SELECT (lcOrdLine)
    *DELETE ALL
    *SELECT ORDLINE
    *=SEEK(lcOrdType+laData[1])
    *SCAN REST WHILE cordtype+order+STR(lineno,6) = lcOrdType+laData[1]
    *  SCATTER MEMVAR
    *  INSERT INTO (lcOrdLine) FROM MEMVAR
    *ENDSCAN

    *B608442,1 optimize the code to enhance the speed when update 860 HIA 02/19/2008 [Begin]
    *SELECT *, 00 AS nSteps FROM ORDHDR WHERE cordtype+order=lcOrdType+laData[1];
    *INTO DBF (gcWorkDir+lcOrdHdr)
    *m.cCancReson = lfCanReason()
    *REPLACE cCancReson WITH m.cCancReson
    *SELECT *, 00 AS nSteps FROM ORDLINE WHERE cordtype+order+STR(lineno,6)=;
    lcOrdType+laData[1] INTO DBF (gcWorkDir+lcOrdLine)
    Select OrdHdr
    Copy Structure To (gcWorkDir+lcOrdHdr)

    Use (gcWorkDir+lcOrdHdr)  In 0 Exclusive
    Select (lcOrdHdr)
    Alter Table (lcOrdHdr) Add Column nSteps  N(2,0)

    Use In (lcOrdHdr)
    Use (gcWorkDir+lcOrdHdr)  In 0 Shared

    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]

    *B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[begin]
    If Used("BlkOrdHd")
      Use In BlkOrdHd
    Endif
    If Used("BlkOrdLn")
      Use In BlkOrdLn
    Endif
    If Used("BlkORDCnl")
      Use In BlkORDCnl
    Endif
    *B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[end]

    Use (oAriaApplication.DataDir+"OrdHDR")   In 0 Shared Again Alias BlkOrdHd  Order OrdHdr   && CORDTYPE+ORDER
    Use (oAriaApplication.DataDir+"ORDLINE")  In 0 Shared Again Alias BlkOrdLn  Order ORDLINE   && CORDTYPE+ORDER+STR(LINENO,6)
    Use (oAriaApplication.DataDir+"ORDCANLN") In 0 Shared Again Alias BlkORDCnl Order ORDCANLN   && CORDTYPE+ORDER+STR(LINENO,6)
    Store .F. To lHasBulk, llCancelBulk
    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End  ]

    Select OrdHdr
    =Seek(lcOrdType+laData[1])
    Scan Rest While cOrdType+Order=lcOrdType+laData[1]
      *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
      lHasBulk = !Empty(Alltrim(OrdHdr.cFromOrder))
      *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End]
      Scatter Memvar Memo
      m.nSteps = 0
      Select (lcOrdHdr)
      Append Blank
      Gather Memvar Memo
      Select OrdHdr
    Endscan
    Select OrdHdr
    =Seek(lcOrdType+laData[1])
    Select (lcOrdHdr)

    m.cCancReson = lfCanReason()
    Replace cCancReson With m.cCancReson

    Select ORDLINE
    Copy Structure To (gcWorkDir+lcOrdLine)

    Use (gcWorkDir+lcOrdLine)  In 0 Exclusive
    Select (lcOrdLine)
    Alter Table (lcOrdLine) Add Column nSteps  N(2,0)

    Use In (lcOrdLine)
    Use (gcWorkDir+lcOrdLine)  In 0 Shared

    Select ORDLINE
    =Seek(lcOrdType+laData[1])
    Scan Rest While cOrdType+Order+Str(Lineno,6)=lcOrdType+laData[1]
      *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
      lHasBulk = lHasBulk Or !Empty(Alltrim(ORDLINE.cFromOrder)) Or !Empty(ORDLINE.BulkLineNo)
      *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End]
      Scatter Memvar Memo
      m.nSteps = 0
      Select (lcOrdLine)
      Append Blank
      Gather Memvar Memo
      Select ORDLINE
    Endscan
    Select ORDLINE
    =Seek(lcOrdType+laData[1])
    Select (lcOrdLine)

    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
    If lHasBulk  And (gfModalGen('QRM54038B32000','DIALOG',OrdHdr.cFromOrder) =1)
      llCancelBulk = .T.
    Endif
    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End]

    *B608442,1 optimize the code to enhance the speed when update 860 HIA 02/19/2008 [Begin]
    *E301077,5 (End)

    If !llFromEDI
      Select 'UNCMSESS'
      If Seek('I')
        Blank
      Else
        Append Blank
      Endif
      Replace Status     With 'O'       ,;
        cUTranType With 'SOORD'   ,;
        cUserId    With gcUser_id ,;
        cSession   With lcSession ,;
        cProgram   With 'SOORD'   ,;
        cCurrScr   With 'SOORD'   ,;
        cCurrObj   With 'PBDLT'   ,;
        dTranDate  With gdSysDate ,;
        cTranTime  With Time()
      =Rlock()
      lcCurrOrd = laData[1]
      lcFiles = 'lcOrdHdr,'+lcOrdHdr+','+lcOrdHdr+';'+;
        'lcOrdLine,'+lcOrdLine+',lcOrdLine;'
      =gfSavSess('SOORD', lcFiles, @laVariables,lcSession)
    Endif
  Endif

  *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
  *WAIT 'Cancelling and updating Cut & Sold...' WINDOW NOWAIT
  If !llSilent
    Wait 'Cancelling and updating Cut & Sold...' Window Nowait
  Endif
  *B612293,1 HIA 12/16/2020 add silent mode feature [End]

  *E301077,5 Inhance openning files to speed up transaction
  =gfOpenFile(gcDataDir+'icStyHst',gcDataDir+'Styhst','SH')
  *E301077,5 (End)
  Select (lcOrdLine)
  Store 0 To lnOpen,lnOpenAmt,lnBook,lnBookAmt
  Scan
    If lcOrdType='O' .And. &lcOrdLine..nSteps < 1
      If Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+Space(10),'StyDye')
        Select StyDye
        =Rlock()
        Replace ORD1   With Max(ORD1-&lcOrdLine..Qty1,0) ,;
          ORD2   With Max(ORD2-&lcOrdLine..Qty2,0) ,;
          ORD3   With Max(ORD3-&lcOrdLine..Qty3,0) ,;
          ORD4   With Max(ORD4-&lcOrdLine..Qty4,0) ,;
          ORD5   With Max(ORD5-&lcOrdLine..Qty5,0) ,;
          ORD6   With Max(ORD6-&lcOrdLine..Qty6,0) ,;
          ORD7   With Max(ORD7-&lcOrdLine..Qty7,0) ,;
          ORD8   With Max(ORD8-&lcOrdLine..Qty8,0) ,;
          TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
        If &lcOrdLine..Picked
          Replace Alo1   With Max(Alo1-&lcOrdLine..Pik1,0) ,;
            Alo2   With Max(Alo2-&lcOrdLine..Pik2,0) ,;
            Alo3   With Max(Alo3-&lcOrdLine..Pik3,0) ,;
            Alo4   With Max(Alo4-&lcOrdLine..Pik4,0) ,;
            Alo5   With Max(Alo5-&lcOrdLine..Pik5,0) ,;
            Alo6   With Max(Alo6-&lcOrdLine..Pik6,0) ,;
            Alo7   With Max(Alo7-&lcOrdLine..Pik7,0) ,;
            Alo8   With Max(Alo8-&lcOrdLine..Pik8,0) ,;
            TotAlo With Alo1+Alo2+Alo3+Alo4+Alo5+Alo6+Alo7+Alo8
        Endif
        Unlock
        Select (lcOrdLine)
        =Rlock()
        Replace nSteps With 1
        Unlock
      Endif
    Endif
    *E038463,1 WAM 11/09/2004 Update ordered quantity at the Configuration level
    If lcOrdType='O' .And. &lcOrdLine..nSteps < 2
      If !Empty(&lcOrdLine..Dyelot) And Seek(&lcOrdLine..Style+&lcOrdLine..cWareCode+&lcOrdLine..Dyelot,'StyDye')
        Select StyDye
        =Rlock()
        Replace ORD1   With Max(ORD1-&lcOrdLine..Qty1,0) ,;
          ORD2   With Max(ORD2-&lcOrdLine..Qty2,0) ,;
          ORD3   With Max(ORD3-&lcOrdLine..Qty3,0) ,;
          ORD4   With Max(ORD4-&lcOrdLine..Qty4,0) ,;
          ORD5   With Max(ORD5-&lcOrdLine..Qty5,0) ,;
          ORD6   With Max(ORD6-&lcOrdLine..Qty6,0) ,;
          ORD7   With Max(ORD7-&lcOrdLine..Qty7,0) ,;
          ORD8   With Max(ORD8-&lcOrdLine..Qty8,0) ,;
          TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
        If &lcOrdLine..Picked
          Replace Alo1   With Max(Alo1-&lcOrdLine..Pik1,0) ,;
            Alo2   With Max(Alo2-&lcOrdLine..Pik2,0) ,;
            Alo3   With Max(Alo3-&lcOrdLine..Pik3,0) ,;
            Alo4   With Max(Alo4-&lcOrdLine..Pik4,0) ,;
            Alo5   With Max(Alo5-&lcOrdLine..Pik5,0) ,;
            Alo6   With Max(Alo6-&lcOrdLine..Pik6,0) ,;
            Alo7   With Max(Alo7-&lcOrdLine..Pik7,0) ,;
            Alo8   With Max(Alo8-&lcOrdLine..Pik8,0) ,;
            TotAlo With Alo1+Alo2+Alo3+Alo4+Alo5+Alo6+Alo7+Alo8
        Endif
        Unlock
        Select (lcOrdLine)
        =Rlock()
        Replace nSteps With 2
        Unlock
      Endif
    Endif
    *E038463,1 WAM 11/09/2004 (End)

    If lcOrdType='O' .And. Seek(&lcOrdLine..Style,'Style')
      If &lcOrdLine..nSteps < 3
        Select Style
        =Rlock()
        Replace ORD1   With Max(ORD1-&lcOrdLine..Qty1,0) ,;
          ORD2   With Max(ORD2-&lcOrdLine..Qty2,0) ,;
          ORD3   With Max(ORD3-&lcOrdLine..Qty3,0) ,;
          ORD4   With Max(ORD4-&lcOrdLine..Qty4,0) ,;
          ORD5   With Max(ORD5-&lcOrdLine..Qty5,0) ,;
          ORD6   With Max(ORD6-&lcOrdLine..Qty6,0) ,;
          ORD7   With Max(ORD7-&lcOrdLine..Qty7,0) ,;
          ORD8   With Max(ORD8-&lcOrdLine..Qty8,0) ,;
          TOTORD With ORD1+ORD2+ORD3+ORD4+ORD5+ORD6+ORD7+ORD8
        Unlock
        Select (lcOrdLine)
        =Rlock()
        Replace nSteps With 3
        Unlock
      Endif
      If &lcOrdLine..Picked .And. &lcOrdLine..nSteps < 4
        Select Style
        =Rlock()
        Replace Alo1   With Max(Alo1-&lcOrdLine..Pik1,0) ,;
          Alo2   With Max(Alo2-&lcOrdLine..Pik2,0) ,;
          Alo3   With Max(Alo3-&lcOrdLine..Pik3,0) ,;
          Alo4   With Max(Alo4-&lcOrdLine..Pik4,0) ,;
          Alo5   With Max(Alo5-&lcOrdLine..Pik5,0) ,;
          Alo6   With Max(Alo6-&lcOrdLine..Pik6,0) ,;
          Alo7   With Max(Alo7-&lcOrdLine..Pik7,0) ,;
          Alo8   With Max(Alo8-&lcOrdLine..Pik8,0) ,;
          TotAlo With Alo1+Alo2+Alo3+Alo4+Alo5+Alo6+Alo7+Alo8
        Unlock
        Select (lcOrdLine)
        =Rlock()
        Replace nSteps With 4
        Unlock
      Endif
    Endif

    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
    If lHasBulk
      Select BlkOrdLn
      = lfBulkActions(lcOrdLine,'BlkOrdHd','BlkOrdLn','BlkORDCnl',1)
      Select (lcOrdLine)
    Endif
    *B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End]

    *B602418,1 Update dyelot allocated quantity
    If lcOrdType='O' And &lcOrdLine..nSteps < 5 And &lcOrdLine..Picked And !Empty(&lcOrdLine..Dyelot) And ;
        SEEK(&lcOrdLine..Style+&lcOrdLine..cWareCode+&lcOrdLine..Dyelot,'StyDye')
      Select StyDye
      =Rlock()
      Replace Alo1   With Max(Alo1-&lcOrdLine..Pik1,0) ,;
        Alo2   With Max(Alo2-&lcOrdLine..Pik2,0) ,;
        Alo3   With Max(Alo3-&lcOrdLine..Pik3,0) ,;
        Alo4   With Max(Alo4-&lcOrdLine..Pik4,0) ,;
        Alo5   With Max(Alo5-&lcOrdLine..Pik5,0) ,;
        Alo6   With Max(Alo6-&lcOrdLine..Pik6,0) ,;
        Alo7   With Max(Alo7-&lcOrdLine..Pik7,0) ,;
        Alo8   With Max(Alo8-&lcOrdLine..Pik8,0) ,;
        TotAlo With Alo1+Alo2+Alo3+Alo4+Alo5+Alo6+Alo7+Alo8
      Unlock
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 5
      Unlock
    Endif
    *B602418,1 (End)

    If lcOrdType='O' .And. &lcOrdLine..nSteps < 6 .And. Seek(Style+lcGlYear,'icStyHst')
      lnOrdAmt = &lcOrdLine..TotQty*&lcOrdLine..Price &lcExRSin laData[34] &lcUntSin laData[50]
      Select icStyHst
      =Rlock()
      Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod - &lcOrdLine..TotQty ,;
        nOrdQty            With nOrdQty            - &lcOrdLine..TotQty ,;
        nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod - lnOrdAmt ,;
        nOrdAmt            With nOrdAmt            - lnOrdAmt
      Unlock
      Select (lcOrdLine)
      =Rlock()
      Replace nSteps With 6
      Unlock
    Endif
    =Seek(lcOrdType+&lcOrdLine..Order+Str(&lcOrdLine..Lineno,6),'ORDLINE')
    If &lcOrdLine..Picked
      If Seek(&lcOrdLine..PikTkt,'PIKTKT')
        Select PikTkt
        =Rlock()
        Replace Status With 'X'
        Unlock
      Endif
      Select ORDLINE
      If !Seek(PikTkt+Order+Str(Lineno,6),'PIKLINE')
        Scatter To laPikLine
        Insert Into PIKLINE From Array laPikLine
      Endif
      Select ORDLINE
      =Rlock()
      Replace Pik1   With 0 ,;
        Pik2   With 0 ,;
        Pik3   With 0 ,;
        Pik4   With 0 ,;
        Pik5   With 0 ,;
        Pik6   With 0 ,;
        Pik7   With 0 ,;
        Pik8   With 0 ,;
        TOTPIK With 0 ,;
        Picked With .F. ,;
        PikTkt With Space(6) ,;
        PIKDATE With {}
      If Seek(AltStyle,'STYLE') .And. Seek('S'+Style.Scale,'SCALE')
        Replace Style     With AltStyle,;
          AltStyle  With Space(19),;
          SCALE     With Scale.Scale,;
          cWareCode With OrdHdr.cWareCode
        Replace Qty1  With Iif(Scale.Cnt>=1,Qty1,0)  ,;
          Book1 With Iif(Scale.Cnt>=1,Book1,0) ,;
          Qty2  With Iif(Scale.Cnt>=2,Qty2,0)  ,;
          Book2 With Iif(Scale.Cnt>=2,Book2,0) ,;
          Qty3  With Iif(Scale.Cnt>=3,Qty3,0)  ,;
          Book3 With Iif(Scale.Cnt>=3,Book3,0) ,;
          Qty4  With Iif(Scale.Cnt>=4,Qty4,0)  ,;
          Book4 With Iif(Scale.Cnt>=4,Book4,0) ,;
          Qty5  With Iif(Scale.Cnt>=5,Qty5,0)  ,;
          Book5 With Iif(Scale.Cnt>=5,Book5,0) ,;
          Qty6  With Iif(Scale.Cnt>=6,Qty6,0)  ,;
          Book6 With Iif(Scale.Cnt>=6,Book6,0) ,;
          Qty7  With Iif(Scale.Cnt>=7,Qty7,0)  ,;
          Book7 With Iif(Scale.Cnt>=7,Book7,0) ,;
          Qty8  With Iif(Scale.Cnt>=8,Qty8,0)  ,;
          Book8 With Iif(Scale.Cnt>=8,Book8,0) ,;
          TotQty With Qty1+Qty2+Qty3+Qty4+Qty5+Qty6+Qty7+Qty8 ,;
          TotBook With Book1+Book2+Book3+Book4+Book5+Book6+Book7+Book8
      Endif
      Unlock
    Endif
    If OrdHdr.TotCut > 0 And !oAriaApplication.isRemoteComp
      Select CUTPICK
      Do While Seek(Iif(Style.Make,'1','2')+&lcOrdLine..Order+Str(&lcOrdLine..Lineno,6))
        Select Iif(CUTPICK.TRANCD='1','CutTktH','PosHdr')
        =Seek(Iif(CUTPICK.TRANCD='1','','P')+CUTPICK.CTKTNO)
        =Rlock()
        Replace TOTORD With Max(TOTORD-CUTPICK.TotQty,0)
        Unlock
        Select Iif(CUTPICK.TRANCD='1','CutTktL','PosLn')
        *E301182,1 Update CT/PO line number in the CUTPICK file.
        *=SEEK(IIF(CutPick.TranCd='1',CutPick.CTKTNO+CutPick.Style,;
        'P'+CutPick.CTKTNO+CutPick.Style))
        =Seek(Iif(CUTPICK.TRANCD='2','P','')+;
          CUTPICK.CTKTNO+CUTPICK.Style+CUTPICK.CTKTLINENO+'1')
        *E301182,1 (End)
        =Rlock()
        Replace ORD1   With Max(ORD1-CUTPICK.Qty1,0) ,;
          ORD2   With Max(ORD2-CUTPICK.Qty2,0) ,;
          ORD3   With Max(ORD3-CUTPICK.Qty3,0) ,;
          ORD4   With Max(ORD4-CUTPICK.Qty4,0) ,;
          ORD5   With Max(ORD5-CUTPICK.Qty5,0) ,;
          ORD6   With Max(ORD6-CUTPICK.Qty6,0) ,;
          ORD7   With Max(ORD7-CUTPICK.Qty7,0) ,;
          ORD8   With Max(ORD8-CUTPICK.Qty8,0) ,;
          TOTORD With Max(TOTORD-CUTPICK.TotQty,0)
        Unlock
        *E300420,1 Message : 32006
        *E300420,1 Cuttkt# xxxxxx status is HOLD. Do you wish to update the generated
        *E300420,1 cuttkt quantities accordingly?
        *E300420,1 Button : 32000
        *E300420,1 Yes/No

        *E300420,1 Message : 32007
        *E300420,1 Purchase order# xxxxxx status is HOLD. Do you wish to update the generated
        *E300420,1 Purchase order quantities accordingly?
        *E300420,1 Button : 32000
        *E300420,1 Yes/No

        *E300420,1 Message : 32008
        *E300420,1 Do you wish to update Purchase order# 999999 quantities accordingly?
        *E300420,1 Button : 32000
        *E300420,1 Yes/No
        lnTicket=Ascan(laTickets,CUTPICK.CTKTNO)
        If lnTicket = 0
          *llUpdate= (CutPick.TranCd='1' .AND. CUTTKTH.Status='H' .AND. ;
          gfModalGen('QRM32006B32000','ALERT',CutPick.CTKTNO)=1) .OR. ;
          (CutPick.TranCd='2' .AND. ( ( POSHDR.Status='H' .AND. ;
          gfModalGen('QRM32007B32000','ALERT',CutPick.CTKTNO)=1) .OR. ;
          ( POSHDR.Status $ 'OA' .AND. !laSetups[13,2] .AND. ;
          gfModalGen('QRM32008B32000','ALERT',CutPick.CTKTNO)=1) ))
          llUpdate= (CUTPICK.TRANCD='1' .And. CUTTKTH.Status='H' .And. ;
            gfModalGen('QRM32006B32000','ALERT',CUTPICK.CTKTNO)=1) .Or. ;
            (CUTPICK.TRANCD='2' .And. POSHDR.Status='H'  .And. ;
            gfModalGen('QRM32007B32000','ALERT',CUTPICK.CTKTNO)=1)

          lnTktCnt=lnTktCnt+1
          Dimension laTickets[lnTktCnt,2]
          laTickets[lnTktCnt,1]=CUTPICK.CTKTNO
          laTickets[lnTktCnt,2]=Iif(llUpdate,'Y','N')
        Else
          llUpdate = (laTickets[lnTicket+1]='Y')
        Endif
        If llUpdate
          Select Iif(CUTPICK.TRANCD='1','CutTktH','PosHdr')
          =Rlock()
          If CUTPICK.TRANCD = '1'
            Replace Pcs_Bud With Pcs_Bud - CUTPICK.TotQty ,;
              Pcs_Opn With Pcs_Opn - CUTPICK.TotQty
          Else
            Replace nStyOrder With nStyOrder - CUTPICK.TotQty ,;
              OPEN      With Open  - CUTPICK.TotQty
          Endif
          Unlock
          Select Iif(CUTPICK.TRANCD='1','CutTktL','PosLn')
          =Rlock()
          Replace Qty1   With Qty1-CUTPICK.Qty1 ,;
            Qty2   With Qty2-CUTPICK.Qty2 ,;
            Qty3   With Qty3-CUTPICK.Qty3 ,;
            Qty4   With Qty4-CUTPICK.Qty4 ,;
            Qty5   With Qty5-CUTPICK.Qty5 ,;
            Qty6   With Qty6-CUTPICK.Qty6 ,;
            Qty7   With Qty7-CUTPICK.Qty7 ,;
            Qty8   With Qty8-CUTPICK.Qty8 ,;
            TotQty With TotQty - CUTPICK.TotQty
          Unlock
        Endif
        Select CUTPICK
        Delete
      Enddo
    Endif
    Select ORDLINE
    =Rlock()
    Replace Cut1   With 0 ,;
      Cut2   With 0 ,;
      Cut3   With 0 ,;
      Cut4   With 0 ,;
      Cut5   With 0 ,;
      Cut6   With 0 ,;
      Cut7   With 0 ,;
      Cut8   With 0 ,;
      TotCut With 0
    Unlock
    lnOpen    = lnOpen    + ORDLINE.TotQty
    lnOpenAmt = lnOpenAmt + ORDLINE.TotQty*ORDLINE.Price
    lnBook    = lnBook    + ORDLINE.TotBook
    lnBookAmt = lnBookAmt + ORDLINE.TotBook*ORDLINE.Price
  Endscan
  *E038729,1 WAM 11/15/2004  Release order allocated quantity to any cutting ticket order style purchae order
  llUpdate = .F.
  If oAriaApplication.isRemoteComp And OrdHdr.TotCut > 0
    lcSetClass = Set('CLASSLIB')
    Set Classlib To (oAriaApplication.lcAria4Class+"MAIN.VCX"),(oAriaApplication.lcAria4Class+"UTILITY.VCX")
    lcTranCode = oAriaApplication.RemoteCompanyData.BeginTran(oAriaApplication.ActiveCompanyConStr,3,'',.T.)
    Set Classlib To &lcSetClass.
    If Type('lcTranCode') = 'N'
      =oAriaApplication.RemoteCompanyData.CheckRetResult("BEGINTRAN",lcTranCode,.T.)
    Else
      lcSelString =               "SELECT CutPick.*,PosHdr.Status FROM CutPick INNER JOIN PosHdr On PosHdr.cBusDocu+PosHdr.cStyType+PosHdr.Po = 'PU'+CutPick.cTktNo WHERE CutPick.TranCd+CutPick.[Order]+CutPick.cOrdLine LIKE '1" + OrdHdr.Order + "%' UNION "
      lcSelString = lcSelString + "SELECT CutPick.*,PosHdr.Status FROM CutPick INNER JOIN PosHdr ON PosHdr.cBusDocu+PosHdr.cStyType+PosHdr.Po = 'PP'+CutPick.cTktNo WHERE CutPick.TranCd+CutPick.[Order]+CutPick.cOrdLine LIKE '2" + OrdHdr.Order + "%' ORDER BY trancd,ctktno,cTKtLineNo"
      If oAriaApplication.RemoteCompanyData.Execute(lcSelString,'',"CutPick","CutPick ",lcTranCode,4,'',Set("DATASESSION")) = 1
        Select CUTPICK
        Go Top
        Do While !Eof()
          lcTranCd = TRANCD
          lcTktNo  = CTKTNO
          lnTotOrd = 0
          *-- Message : 32006
          *-- Cuttkt# xxxxxx status is HOLD. Do you wish to update the generated
          *-- cuttkt quantities accordingly?
          *-- Button : 32000
          *-- Yes/No
          *-- Message : 32007
          *-- Purchase order# xxxxxx status is HOLD. Do you wish to update the generated
          *-- Purchase order quantities accordingly?
          *-- Button : 32000
          *-- Yes/No
          llUpdate= Status='H' .And. ((TRANCD='1' .And. gfModalGen('QRM32006B32000','ALERT',CTKTNO)=1) .Or. ;
            (TRANCD='2' .And. gfModalGen('QRM32007B32000','ALERT',CTKTNO)=1) )

          Scan Rest While TRANCD+CTKTNO+CTKTLINENO = lcTranCd+lcTktNo

            =Seek('O'+Order+CORDLINE,'OrdLine','OrdLine')

            *-- Update ticket lines Ordered quantity
            lcSelString="UPDATE PosLn SET Ord1=Ord1-"+Alltrim(Str(CUTPICK.Qty1))+",Ord2=Ord2-"+Alltrim(Str(CUTPICK.Qty2))+;
              ",Ord3=Ord3-"+Alltrim(Str(CUTPICK.Qty3))+",Ord4=Ord4-"+Alltrim(Str(CUTPICK.Qty4))+;
              ",Ord5=Ord5-"+Alltrim(Str(CUTPICK.Qty5))+",Ord6=Ord6-"+Alltrim(Str(CUTPICK.Qty6))+;
              ",Ord7=Ord7-"+Alltrim(Str(CUTPICK.Qty7))+",Ord8=Ord8-"+Alltrim(Str(CUTPICK.Qty8))+;
              ",TotOrd=TotOrd-"+Alltrim(Str(CUTPICK.TotQty))
            *-- Update ticket lines budget quantities
            If llUpdate
              lcSelString=lcSelString+;
                ",Qty1=Qty1-"+Alltrim(Str(CUTPICK.Qty1))+",Qty2=Qty2-"+Alltrim(Str(CUTPICK.Qty2))+;
                ",Qty3=Qty3-"+Alltrim(Str(CUTPICK.Qty3))+",Qty4=Qty4-"+Alltrim(Str(CUTPICK.Qty4))+;
                ",Qty5=Qty5-"+Alltrim(Str(CUTPICK.Qty5))+",Qty6=Qty6-"+Alltrim(Str(CUTPICK.Qty6))+;
                ",Qty7=Qty7-"+Alltrim(Str(CUTPICK.Qty7))+",Qty8=Qty8-"+Alltrim(Str(CUTPICK.Qty8))+;
                ",TotQty=TotQty-"+Alltrim(Str(CUTPICK.TotQty))
            Endif
            If lcTranCd = '1'
              lcSelString=lcSelString+" WHERE cBusDocu+cstytype+po+cInvType+style+STR([lineno],6)+trancd='PU"+CUTPICK.CTKTNO+'0001'+CUTPICK.Style+CUTPICK.CTKTLINENO+"1'"
            Else
              lcSelString=lcSelString+" WHERE cBusDocu+cstytype+po+cInvType+style+STR([lineno],6)+trancd='PP"+CUTPICK.CTKTNO+'0001'+CUTPICK.Style+CUTPICK.CTKTLINENO+"1'"
            Endif
            lnResult = oAriaApplication.RemoteCompanyData.Execute(lcSelString,'',"SAVEFILE","",lcTranCode,4,'',Set("DATASESSION"))

            If Seek(ORDLINE.Style+ORDLINE.cWareCode+Space(10),'StyDye')
              =Rlock("StyDye")
              Replace WIP1   With Max(WIP1-ORDLINE.Qty1,0) ,;
                WIP2   With Max(WIP2-ORDLINE.Qty2,0) ,;
                WIP3   With Max(WIP3-ORDLINE.Qty3,0) ,;
                WIP4   With Max(WIP4-ORDLINE.Qty4,0) ,;
                WIP5   With Max(WIP5-ORDLINE.Qty5,0) ,;
                WIP6   With Max(WIP6-ORDLINE.Qty6,0) ,;
                WIP7   With Max(WIP7-ORDLINE.Qty7,0) ,;
                WIP8   With Max(WIP8-ORDLINE.Qty8,0) ,;
                TOTWIP With WIP1+WIP2+WIP3+WIP4+WIP5+WIP6+WIP7+WIP8 In StyDye
              Replace NWO1   With Max(NWO1-ORDLINE.Qty1,0) ,;
                NWO2   With Max(NWO2-ORDLINE.Qty2,0) ,;
                NWO3   With Max(NWO3-ORDLINE.Qty3,0) ,;
                NWO4   With Max(NWO4-ORDLINE.Qty4,0) ,;
                NWO5   With Max(NWO5-ORDLINE.Qty5,0) ,;
                NWO6   With Max(NWO6-ORDLINE.Qty6,0) ,;
                NWO7   With Max(NWO7-ORDLINE.Qty7,0) ,;
                NWO8   With Max(NWO8-ORDLINE.Qty8,0) ,;
                NTOTWO With NWO1+NWO2+NWO3+NWO4+NWO5+NWO6+NWO7+NWO8 In StyDye
              Unlock In StyDye
            Endif
            If !Empty(ORDLINE.Dyelot) And Seek(ORDLINE.Style+ORDLINE.cWareCode+ORDLINE.Dyelot,'StyDye')
              =Rlock("StyDye")
              Replace WIP1   With Max(WIP1-ORDLINE.Qty1,0) ,;
                WIP2   With Max(WIP2-ORDLINE.Qty2,0) ,;
                WIP3   With Max(WIP3-ORDLINE.Qty3,0) ,;
                WIP4   With Max(WIP4-ORDLINE.Qty4,0) ,;
                WIP5   With Max(WIP5-ORDLINE.Qty5,0) ,;
                WIP6   With Max(WIP6-ORDLINE.Qty6,0) ,;
                WIP7   With Max(WIP7-ORDLINE.Qty7,0) ,;
                WIP8   With Max(WIP8-ORDLINE.Qty8,0) ,;
                TOTWIP With WIP1+WIP2+WIP3+WIP4+WIP5+WIP6+WIP7+WIP8 In StyDye
              Replace NWO1   With Max(NWO1-ORDLINE.Qty1,0) ,;
                NWO2   With Max(NWO2-ORDLINE.Qty2,0) ,;
                NWO3   With Max(NWO3-ORDLINE.Qty3,0) ,;
                NWO4   With Max(NWO4-ORDLINE.Qty4,0) ,;
                NWO5   With Max(NWO5-ORDLINE.Qty5,0) ,;
                NWO6   With Max(NWO6-ORDLINE.Qty6,0) ,;
                NWO7   With Max(NWO7-ORDLINE.Qty7,0) ,;
                NWO8   With Max(NWO8-ORDLINE.Qty8,0) ,;
                NTOTWO With NWO1+NWO2+NWO3+NWO4+NWO5+NWO6+NWO7+NWO8 In StyDye
              Unlock In StyDye
            Endif
            *-- Decrease style ordered quantity with order open quantity
            If Seek(ORDLINE.Style,'Style')
              =Rlock("Style")
              Replace WIP1   With Max(WIP1-ORDLINE.Qty1,0) ,;
                WIP2   With Max(WIP2-ORDLINE.Qty2,0) ,;
                WIP3   With Max(WIP3-ORDLINE.Qty3,0) ,;
                WIP4   With Max(WIP4-ORDLINE.Qty4,0) ,;
                WIP5   With Max(WIP5-ORDLINE.Qty5,0) ,;
                WIP6   With Max(WIP6-ORDLINE.Qty6,0) ,;
                WIP7   With Max(WIP7-ORDLINE.Qty7,0) ,;
                WIP8   With Max(WIP8-ORDLINE.Qty8,0) ,;
                TOTWIP With WIP1+WIP2+WIP3+WIP4+WIP5+WIP6+WIP7+WIP8 In Style
              Replace NWO1   With Max(NWO1-ORDLINE.Qty1,0) ,;
                NWO2   With Max(NWO2-ORDLINE.Qty2,0) ,;
                NWO3   With Max(NWO3-ORDLINE.Qty3,0) ,;
                NWO4   With Max(NWO4-ORDLINE.Qty4,0) ,;
                NWO5   With Max(NWO5-ORDLINE.Qty5,0) ,;
                NWO6   With Max(NWO6-ORDLINE.Qty6,0) ,;
                NWO7   With Max(NWO7-ORDLINE.Qty7,0) ,;
                NWO8   With Max(NWO8-ORDLINE.Qty8,0) ,;
                NTOTWO With NWO1+NWO2+NWO3+NWO4+NWO5+NWO6+NWO7+NWO8 In Style
              Unlock In Style
            Endif
            lnTotOrd = lnTotOrd + CUTPICK.TotQty
          Endscan
          *-- Update ticket total Ordered & budget quantity
          If lcTranCd = '1'
            *-- Change Cutting quantity if order allocated quantity has been changed
            lcSelString = "UPDATE PosHdr SET TotOrd=TotOrd-"+Alltrim(Str(lnTotOrd))+;
              IIF(llUpdate,",nStyOrder = nStyOrder-"+Alltrim(Str(lnTotOrd))+",[Open]=[Open]-"+Alltrim(Str(lnTotOrd)),'')+;
              " WHERE cBusDocu+cstytype+po='PU"+lcTktNo+"'"
          Else
            *-- Change Purchased quantity if order allocated quantity has been changed
            lcSelString = "UPDATE PosHdr SET TotOrd=TotOrd-"+Alltrim(Str(lnTotOrd))+;
              IIF(llUpdate,",nStyOrder = nStyOrder-"+Alltrim(Str(lnTotOrd))+",[Open]=[Open]-"+Alltrim(Str(lnTotOrd)),'')+;
              " WHERE cBusDocu+cstytype+po='PP"+lcTktNo+"'"
          Endif
          lnResult = oAriaApplication.RemoteCompanyData.Execute(lcSelString,'',"SAVEFILE","",lcTranCode,4,'',Set("DATASESSION"))
          Select CUTPICK
        Enddo
        Select CUTPICK
        Delete All
        lnResult = lfSqlUpdate('CUTPICK',lcTranCode, Set("DATASESSION"),'trancd,ctktno,ctktlineno,order,style,cordline')
        If lnResult <=0
          =oAriaApplication.RemoteCompanyData.CheckRetResult("SQLUPDATE",lnResult,.T.)
          =oAriaApplication.RemoteCompanyData.RollBackTran(lcTranCode)
        Else
          If oAriaApplication.RemoteCompanyData.CommitTran(lcTranCode,.T.) = 1
          Else
            =oAriaApplication.RemoteCompanyData.CheckRetResult("COMMITTRAN",lnResult,.T.)
          Endif
        Endif
        Use In CUTPICK
      Endif
    Endif
  Endif
  *E038729,1 WAM 11/15/2004 (End)

  *E301077,5 Inhance openning files to speed up transaction
  =gfCloseFile('icStyHst')
  *E301077,5 (End)
  If laData[23]='Y' .And. &lcOrdHdr..nSteps < 1 .And. Seek('M'+laData[2],'Customer')

    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    LcAl=Alias()
    Select OrdHdr
    lcORD = Order()
    Set Order To ORDBULK
    =Seek(laData[2]+'O'+'Y'+'O','ORDHDR','ORDBULK')
    lnBulkCntO=0
    lnBulkCntH=0
    Count To lnBulkCntO  While account+Status+bulk+cOrdType+Order = laData[2]+'O'+'Y'+'O'
    =Seek(laData[2]+'H'+'Y'+'O','ORDHDR','ORDBULK')
    Count To lnBulkCntH  While account+Status+bulk+cOrdType+Order = laData[2]+'H'+'Y'+'O'
    lnBulkCntO=lnBulkCntO+lnBulkCntH
    Set Order To (lcORD)
    Select (LcAl)
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]

    Select Customer
    =Rlock()
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
    *!*REPLACE nBulk WITH nBulk - 1
    Replace nBulk With lnBulkCntO
    *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 1
    Unlock
  Endif
  If lcOrdType='O' .And. &lcOrdHdr..nSteps < 2
    *E301077,5 Inhance openning files to speed up transaction
    =gfOpenFile(gcDataDir+'arCusHst',gcDataDir+'Acthst','SH')
    *E301077,5 (End)
    =Seek(laData[2]+lcGlYear,'arCusHst')
    lnOrdAmt = OrdHdr.Openamt &lcExRSin laData[34] &lcUntSin laData[50]
    Select arCusHst
    =Rlock()
    Replace nOrdQty&lcGlPeriod With nOrdQty&lcGlPeriod - OrdHdr.Open ,;
      nOrdQty            With nOrdQty            - OrdHdr.Open ,;
      nOrdAmt&lcGlPeriod With nOrdAmt&lcGlPeriod - lnOrdAmt    ,;
      nOrdAmt            With nOrdAmt            - lnOrdAmt
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 2
    Unlock
  Endif
  *E301077,5 Inhance openning files to speed up transaction
  =Iif('AL' $ gcCmpModules,gfCloseFile('PIKLINE') And gfCloseFile('PIKTKT'),.T.)
  If OrdHdr.TotCut > 0 And !oAriaApplication.isRemoteComp
    =Iif('PO' $ gcCmpModules,gfCloseFile('POSHDR')  And gfCloseFile('POSLN'),.T.)
    =Iif('MF' $ gcCmpModules,gfCloseFile('CUTTKTH') And gfCloseFile('CUTTKTL'),.T.)
    =gfCloseFile('CUTPICK')
  Endif
  *E301077,5 (End)

  If &lcOrdHdr..nSteps < 3
    Select OrdHdr
    =Rlock()
    *B602410,1 Update canceled date with system date.
    Replace Status     With Iif(Ship > 0,'C','X') ,;
      cCancReson With &lcOrdHdr..cCancReson ,;
      Cancelled  With gdSysDate ,;
      CANCEL     With Iif(laData[23]='Y',Cancel ,Cancel+lnOpen),;
      CancelAmt  With Iif(laData[23]='Y',CancelAmt ,CancelAmt+lnOpenAmt),;
      OPEN       With 0,;
      Openamt    With 0,;
      TotCut     With 0,;
      Book       With lnBook,;
      BookAmt    With lnBookAmt ,;
      FLAG       With Space(1)
    Unlock
    Select (lcOrdHdr)
    =Rlock()
    Replace nSteps With 3
    Unlock
  Endif
Endif
*E301077,5 Inhance openning files to speed up transaction
=gfCloseFile('arCusHst')
*E301077,5 (End)

*E301175,1 Add this line to add the capability to call this function from
*          the EDI - from EDIProcessPO Class - [Begin]

*-- If the function was not called from EDI
If !llFromEDI
  *E301175,1 Add this line to add the capability to call this function [End]

  Select UnCmSess
  *B602496,1 Update the order record in the uncmsess file
  =Seek('O'+Padr('SOORD',10)+gcUser_id+lcSession)
  *B602496,1 (End)

  Replace Status With 'C'
  Unlock

  *E301175,1 Add this line to add the capability to call this function from
  *          the EDI - from EDIProcessPO Class - [Begin]
Endif    && End of IF !llFromEDI
*E301175,1 Add this line to add the capability to call this function [End]

llContinue = .F.

*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*WAIT CLEAR
If !llSilent
  Wait Clear
Endif
*B612293,1 HIA 12/16/2020 add silent mode feature [End]

Select OrdHdr
Scatter Fields &lcScFields To laData
If !llFromEDI
  =lfGetInfo()
Endif

*B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[begin]
If Used("BlkOrdHd")
  Use In BlkOrdHd
Endif
If Used("BlkOrdLn")
  Use In BlkOrdLn
Endif
If Used("BlkORDCnl")
  Use In BlkORDCnl
Endif
*B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[end]


Return

*!*************************************************************
*! Name      : lfGet_Info
*! Developer : Wael Aly Mohamed
*! Date      : 01/01/1996
*! Purpose   : Restore invoice information
*!*************************************************************
*! Calls     : gfGetAdr
*!*************************************************************
*! Parameters: None
*!*************************************************************
*! Returns   :  None.
*!*************************************************************
*! Example   :  =lfGet_Info()
*!*************************************************************
Function lfGet_Info

=Seek('M'+laData[2],'Customer')
llConsAcc  = Customer.Consol='Y'
lcPriceLvl = Iif(!Empty(Customer.PriceLvl),Customer.PriceLvl,'A')
=Seek(Iif(Empty(laData[3]),'M'+laData[2],'S'+laData[2]+laData[3]),'Customer')
lnShipAddr = Iif(laData[51],2,1)
Store '' To  lcShipName,lcShipAdd1,lcShipAdd2,lcShipAdd3,lcShipAdd4,lcShipAdd5,;
  lcBillName,lcBillAdd1,lcBillAdd2,lcBillAdd3,lcBillAdd4,lcBillAdd5
llMultiSt = (laData[6]='Y')

If llMultiSt
  Store 'At Store Level' To lcBillName
Else
  lcBillName = Customer.BtName
  =gfGetAdr('Customer','','','',1,'2')
  For lnCount = 1 To Alen(laAddress,1)
    lcCount = Str(laAddress[lnCount,1],1)
    lcBillAdd&lcCount = lcBillAdd&lcCount + Iif(Empty(lcBillAdd&lcCount),'',',')+;
      SUBSTR(laAddress[lnCount,2],1,laAddress[lnCount,3])
  Endfor
Endif
If lnShipAddr = 2
  lcShipName = Iif(laScrMode[2],OrdHdr.StName,&lcOrdHdr..StName)
  lcShipAdd1 = Iif(laScrMode[2],OrdHdr.cAddress1,&lcOrdHdr..cAddress1)
  lcShipAdd2 = Iif(laScrMode[2],OrdHdr.cAddress2,&lcOrdHdr..cAddress2)
  lcShipAdd3 = Iif(laScrMode[2],OrdHdr.cAddress3,&lcOrdHdr..cAddress3)
  lcShipAdd4 = Iif(laScrMode[2],OrdHdr.cAddress4,&lcOrdHdr..cAddress4)
  lcShipAdd5 = Iif(laScrMode[2],OrdHdr.cAddress5,&lcOrdHdr..cAddress5)
  If laScrMode[2]
    Show Get lcShipName Disable
    Show Get lcShipAdd1 Disable
    Show Get lcShipAdd2 Disable
    Show Get lcShipAdd3 Disable
    Show Get lcShipAdd4 Disable
    Show Get lcShipAdd5 Disable
  Else
    Show Get lcShipName Enable
    Show Get lcShipAdd1 Enable
    Show Get lcShipAdd2 Enable
    Show Get lcShipAdd3 Enable
    Show Get lcShipAdd4 Enable
    Show Get lcShipAdd5 Enable
  Endif
Else
  If llMultiSt
    Store 'At Store Level' To lcShipName
  Else
    lcShipName =  Iif(Empty(Customer.Dba),Customer.StName,Customer.Dba)
    =gfGetAdr('CUSTOMER','','','',1,'')
    For lnCount = 1 To Alen(laAddress,1)
      lcCount = Str(laAddress[lnCount,1],1)
      lcShipAdd&lcCount = lcShipAdd&lcCount + Iif(Empty(lcShipAdd&lcCount),'',',')+;
        SUBSTR(laAddress[lnCount,2],1,laAddress[lnCount,3])
    Endfor
  Endif
  Show Get lcShipName Disable
  Show Get lcShipAdd1 Disable
  Show Get lcShipAdd2 Disable
  Show Get lcShipAdd3 Disable
  Show Get lcShipAdd4 Disable
  Show Get lcShipAdd5 Disable
Endif
lcDelMesag = 'cancel'
Do Case
Case laData[5] = 'B'
  lnOrdStatus = 1
  Show Get pbDlt,1 Prompt lcCancel
Case laData[5] = 'O'
  lnOrdStatus = 2
  Show Get pbDlt,1 Prompt lcCancel
Case laData[5] = 'H'
  lnOrdStatus = 3
  Show Get pbDlt,1 Prompt lcCancel
Case laData[5] = 'X'
  lnOrdStatus = 4
  Show Get pbDlt,1 Prompt lcUnCancel
  lcDelMesag    = 'uncancel'
Case laData[5] = 'C'
  lnOrdStatus = 5
  Show Get pbDlt,1 Prompt lcCancel
Endcase
llInsur   = (laData[22]='Y')
llBulk    = (laData[23]='Y')
llReorder = (laData[24]='Y')
=gfwCodePop(@laCodes,'CTERMCODE','T')
=gfwCodePop(@laCodes,'SHIPVIA','T')
*B802366,1 AMM (Start) Display "At Store Level" instead of "ALL" in ship via POPUP
If llMultiSt
  =lfChMSHV()
Endif
*B802366,1 AMM end

=gfwCodePop(@laCodes,'SPCINST','T')
=gfwCodePop(@laCodes,'SEASON','T')
=gfwCodePop(@laCodes,'CDIVISION','T')
*C101557,1 Added to get order category code.
=gfwCodePop(@laCodes,'CORDERCAT','T')
*C101557,1 End.

lnWareHouse = Ascan(laWareHouses,laData[31])
lnWareHouse = Iif(lnWareHouse=0,1,Asubscript(laWareHouses,lnWareHouse,1))
Show Get lnOrdStatus
Show Get lnWareHouse
Show Get lnShipAddr
Show Get llMultiSt
llReBrowse = .T.


*!*************************************************************
*! Name      : lfOrdQUpd                         *B602952,1
*! Developer : Timour A. K.
*! Date      : 05/30/1999
*! Purpose   : Update style orderd quantity in case of order
*!             line style was changed.
*!*************************************************************
*! Calls     : lfSavScr
*!*************************************************************
*! Parameters: lcFlToUpd-> Alias to update (STYLE or STYDYE).
*!*************************************************************
*! Returns   :  None.
*!*************************************************************
Function lfOrdQUpd
Para lcFlToUpd

*--Update New Style.
Select (lcFlToUpd)
=Rlock()
Replace ORD1   With ORD1   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty1),;
  ORD2   With ORD2   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty2),;
  ORD3   With ORD3   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty3),;
  ORD4   With ORD4   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty4),;
  ORD5   With ORD5   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty5),;
  ORD6   With ORD6   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty6),;
  ORD7   With ORD7   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty7),;
  ORD8   With ORD8   + Iif(OrdHdr.Status='B',0,&lcOrdLine..Qty8),;
  TOTORD With TOTORD + Iif(OrdHdr.Status='B',0,&lcOrdLine..TotQty)
Unlock

*--Update Old Style.
=Seek(ORDLINE.Style+Iif(lcFlToUpd='STYLE','',laData[31]+Space(10)),lcFlToUpd)
=Rlock()
Replace ORD1   With ORD1   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty1),;
  ORD2   With ORD2   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty2),;
  ORD3   With ORD3   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty3),;
  ORD4   With ORD4   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty4),;
  ORD5   With ORD5   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty5),;
  ORD6   With ORD6   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty6),;
  ORD7   With ORD7   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty7),;
  ORD8   With ORD8   - Iif(OrdHdr.Status='B',0,ORDLINE.Qty8),;
  TOTORD With TOTORD - Iif(OrdHdr.Status='B',0,ORDLINE.TotQty)
Unlock
Return

*!*************************************************************
*! Name      : lfStyPos
*! Developer : Reham Al-Allamy
*! Date      : 07/20/1999
*! Purpose   : Function to check if there is style position for
*!           : any order line to be sure it has been filled.
*!*************************************************************
*! Calls     : None
*!*************************************************************
*! Parameters: None
*!*************************************************************
*! Returns   : None
*!*************************************************************
*! Example   : =lfStyPos()
*!*************************************************************
*
Function lfStyPos
Private lcCurAlias

*-- Save the current alias.
lcCurAlias = Alias()

*-- Flag to know if valid to save or not.
llSvBomVar = .T.

*-- Open the style positions file to Check if there is positions for the selected style.
=gfOpenFile(gcDataDir+'IcStyPos',gcDataDir+'IcStyPos','SH')

*-- Scan all the order lines to check if there is style position entered for the lines
*-- that have to have records in the BomVar file.
Select (lcOrdLine)
Scan For !Deleted()
  *-- Check if there is positions for the style in the current order line.
  If Seek(&lcOrdLine..Style , "IcStyPos")
    *-- Check if there is style position entered for the current line.
    If Seek("SO" + laData[1] + Str(&lcOrdLine..Lineno,6) , lcT_BomVar)
      *-- Check that at least one of the name drop or the design code has entered for
      *-- all the style positions of the current order line.
      Select (lcT_BomVar)
      Scan Rest While cidtype+cCost_Id+Str(Lineno,6) = "SO"+laData[1] + Str(&lcOrdLine..Lineno,6)
        If Empty(&lcT_BomVar..cNDrpId) .And. Empty(&lcT_BomVar..cDsgnCode)
          *** You cannot leave both name-drop and design code empty for style: {&lcOrdLine..Style}. ***
          *** <  OK  > ***

          *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
          *=gfModalGen("TRM32071B00000" , "DIALOG" , &lcOrdLine..Style)
          If !llSilent
            =gfModalGen("TRM32071B00000" , "DIALOG" , &lcOrdLine..Style)
          Endif
          *B612293,1 HIA 12/16/2020 add silent mode feature [End]
          llSvBomVar = .F.
        Endif
      Endscan
      Select (lcOrdLine)
    Else
      *** You have to enter style position for Style: {&lcOrdLine..Style}. ***
      *** <  OK  > ***

      *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
      *=gfModalGen("TRM32070B00000" , "DIALOG" , &lcOrdLine..Style)
      If !llSilent
        =gfModalGen("TRM32070B00000" , "DIALOG" , &lcOrdLine..Style)
      Endif
      *B612293,1 HIA 12/16/2020 add silent mode feature [End]
      llSvBomVar = .F.
    Endif
  Endif
Endscan

*-- Restore the previous alias.
Select (lcCurAlias)

*-- Return with the returned flag.
Return llSvBomVar

*:**************************************************************************
*:* Name        : lfDivByZr                                      *B607436,1
*:* Developer   : TMI - TAREK MOHAMED IBRAHIM
*:* Date        : 07/30/2003
*:* Purpose     : Overcome the error "Division by 0 when updating the field nOrdAmt
* Note          : this error is difficult to generate so this function is only to be sure
*               : that this type of error will not happen.
*:***************************************************************************
Function lfDivByZr
Private llDivByZro,lnOrdAmt,lcUntSin,lcExRSin,lnSlct
lnSlct = Select()
llDivByZro = .F.
lcUntSin = ''
lcExRSin = gfGetExSin(@lcUntSin, laData[33])

laData[50] = Iif(laData[50] = 0 , 1 , laData[50] )
Select OrdHdr
If OrdHdr.nCurrUnit = 0
  Replace OrdHdr.nCurrUnit With 1
Endif
If OrdHdr.nExRate = 0
  Replace OrdHdr.nExRate With 1
Endif

Select &lcOrdLine
lnRecNo = Recno()
Go Top
Scan
  Store 0 To lnAmt1,lnAmt2
  lnAmt1 = &lcOrdLine..TotQty*&lcOrdLine..Price &lcExRSin laData[34]     &lcUntSin laData[50]
  If !llFromEDI And laScrMode[3]
    lnAmt2 = &lcOrdLine..TotQty*&lcOrdLine..Price &lcExRSin OrdHdr.nExRate &lcUntSin OrdHdr.nCurrUnit
  Endif
  If '*' $ Transform(lnAmt1+lnAmt2,Repl('9',15))


    *B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
    *=gfModalGen('INM32121B00000','ALERT')
    If !llSilent
      =gfModalGen('INM32121B00000','ALERT')
    Endif
    *B612293,1 HIA 12/16/2020 add silent mode feature [End]

    llDivByZro = .T.
    Exit
  Endif
Endscan

If Between(lnRecNo,1,Reccount(lcOrdLine))
  Goto (lnRecNo)
Endif

Select (lnSlct)
Return llDivByZro
*-- end of lfDivByZr.

*!**********************************************************************************
*! Name      : lfSQLUpdate
*! Developer : Timour A. K.
*! Date      : 07/26/2001
*! Purpose   : SQL Update Cursor, Delete and Insert records.
*! Entry no. : N000260
*!**********************************************************************************
*! Parameters: cCursorName : Cursor Name to Update
*!             cTranCode   : Transaction update Code
*!          nDataSessionID : Private Data Session ID number, to create cursor on it.
*!**********************************************************************************
*! Returns : Numeric (Returns the number of result).
*!            1 Finished updating successfully.
*!            2 Nothing Updated.
*!           -1 Error while updating.
*!           -3 No Primary key found for this table, unable to update.
*!           -4 Unable to retrieve updating table information.
*!           -5 Connection Object does not exist
*!           -6 One or more parameter are empty, the parameter are mandatory.
*!           -7 The cursor is not in use.
*!           -8 This Transaction code does not exist (Require begin transaction)
*!           -9 This Cursor is not updateable.
*!**********************************************************************************
*! Modifications :
*! E038142,2 MAH 09/01/2004 Full support for run forms with SQL with high Performance.
*!*****************************************************************************************
*! E038142,2 MAH 09/02/2004 Add addtional parameter lcPKIndex [BEGIN]
*-- LPARAMETERS cCursorName,lcTranCode,nDataSessionID,lcPrimaryKeyList,lcTable
Function lfSqlUpdate

*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*LPARAMETERS cCursorName, lcTranCode, nDataSessionID, lcPrimaryKeyList, lcTable, lcPKIndex
Lparameters cCursorName, lcTranCode, nDataSessionID, lcPrimaryKeyList, lcTable, lcPKIndex, llSilent
*B612293,1 HIA 12/16/2020 add silent mode feature [End]
*! E038142,2 MAH 09/02/2004 [END]


*--Check and validate passed parameters.
cCursorName = Iif(Type('cCursorName')='C' And !Empty(cCursorName),cCursorName,"")
lcTranCode   = Iif(Type('lcTranCode')='C'   And !Empty(lcTranCode)  ,lcTranCode  ,"")
nDataSessionID = Iif(Type('nDataSessionID')='N',nDataSessionID ,Set("DATASESSION"))

*--Check parameters (Both are mandatory and cannot be empty)
If Empty(cCursorName) Or Empty(lcTranCode)
  *--One or more parameter are empty, the parameter are mandatory.
  Return -6
Endif

Local lnOldSession,lnCurrentWorkAria
lnOldSession = Set("Datasession")  && Save current data session.
lnCurrentWorkAria = Select()       && Save current work aria pointer.

*-- Set data session.
If nDataSessionID <> Set("DATASESSION")
  Set DataSession To nDataSessionID
Endif

*--Check for the required cursor is opened (used).
If !Used(cCursorName)
  *--The cursor is not used.
  Return -7
Endif

Local lcUpdTable   && Table to update.
lcUpdTable = Iif(Type('lcTable')='C',lcTable,CursorGetProp("Tables",cCursorName))
If Empty(lcUpdTable)
  *--This Cursor is not updatable
  Return -9
Endif

*--Define local variables.
Local lnHandle,;          && Connection Handle.
lcPrimaryKeyList,;  && Primary key fields list comma delemited.
lcPrimKey,;         && Primary key fields sql expresion.
lcDelSetting,;      && Deletion setting.
lnResult,;          && This method return result.
lnExResult,;        && SQLExecution return result.
lnChange,;          && Changed Record number.
lcUpdString         && Fields to Update list string.


*--Check for existance of connection object.
If Type("oAriaApplication.RemoteCompanyData.oConnectionsClass") <> 'O'
  *--Connection Object does not exist
  Return -5
Endif

*--Check for existance of this transaction and get this transaction handle.
lnHandle = oAriaApplication.RemoteCompanyData.oConnectionsClass.CheckTransaction(lcTranCode)

*! E038142,2 MAH 09/01/2004 Get database engine ID [BEGIN]
Local lcDBEngine
lcDBEngine = Alltrim(oAriaApplication.RemoteCompanyData.mGetConnectionDBEngine(lnHandle))
*! E038142,2 MAH 09/01/2004 [END]

If lnHandle < 1
  *--oAriaApplication.RemoteCompanyData Transaction code does not exist (Require begin transaction)
  Return -8
Endif

*--Get Pimary key fields list.
lcPrimKey = ""

If Empty(lcPrimaryKeyList)
  lcPrimaryKeyList = oAriaApplication.RemoteCompanyData.GetKeyFields(lcUpdTable)
  If Empty(lcPrimaryKeyList)
    *--No Primary key found for this table, unable to update.
    Return -3
  Endif
Endif

*! E038142,2 MAH 09/01/2004 Buid primary key expression based on engine type [BEGIN]
Do Case
Case Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID
  *! E038142,2 MAH 09/01/2004 [END]
  lcPrimaryKeyList =","+lcPrimaryKeyList+","
  lnKeysNo  = Occurs(',',lcPrimaryKeyList)-1
  For lnI=1 To lnKeysNo
    lcFld = Strextract(lcPrimaryKeyList, "," , "," ,lnI )
    *wael
    lcPrimKey = lcPrimKey + "["+lcFld+"]=?m."+lcFld+Iif(lnI<>lnKeysNo," AND ","")
    *  lcPrimKey = lcPrimKey + lcFld+"=?m."+lcFld+IIF(lnI<>lnKeysNo," AND ","")
    *wael
  Endfor

  *! E038142,2 MAH 09/01/2004 Buid primary key expression based on engine type [BEGIN]
Case Alltrim(lcDBEngine) == oAriaApplication.cFOXDBID
  lcPrimKey = lcPrimaryKeyList + ' = '

  *-- Replace fields in the expression to ?m.Field
  Local lnLexemes
  lnLexemes = 1

  Local laLexemes[1]
  laLexemes[1] = ''

  Local lnIndex
  For lnIndex = 1 To Len(lcPrimaryKeyList)
    Local lcChar
    lcChar = Substr(lcPrimaryKeyList, lnIndex, 1)

    If Isalpha(lcChar) .Or. lcChar = '_'
      If Empty(laLexemes[lnLexemes]) .Or. Isalpha(laLexemes[lnLexemes]) .Or. Left(laLexemes[lnLexemes], 1) = '_'
        laLexemes[lnLexemes] = laLexemes[lnLexemes] + lcChar
      Else
        lnLexemes = lnLexemes + 1
        Local laLexemes[lnLexemes]
        laLexemes[lnLexemes] = lcChar
      Endif
    Else
      lnLexemes = lnLexemes + 1
      Local laLexemes[lnLexemes]
      laLexemes[lnLexemes] = lcChar
    Endif
  Endfor

  For lnIndex = 1 To Alen(laLexemes, 1)
    If Isalpha(laLexemes[lnIndex]) .Or. Left(laLexemes[lnIndex], 1) = '_'
      If Upper(Alltrim(laLexemes[lnIndex])) $ 'SUBSTR|PADR|UPPER|DTOS|STR|ALLTRIM|LEFT|LOWER'
        lcPrimKey = lcPrimKey + laLexemes[lnIndex]
      Else
        lcPrimKey = lcPrimKey + '?m.' + Alltrim(laLexemes[lnIndex])
      Endif
    Else
      lcPrimKey = lcPrimKey + laLexemes[lnIndex]
    Endif
  Endfor
Endcase
*! E038142,2 MAH 09/01/2004 [END]

*--Get Table columns in cursor.
oAriaApplication.RemoteCompanyData.GetColumns(lcUpdTable,"TmpTblFld",lcTranCode,4,"FOXPRO",nDataSessionID)
If !Used("TmpTblFld")
  *--Unable to retrive updating table's information.
  Return -4
Endif

*--Get Native Table columns in cursor.
oAriaApplication.RemoteCompanyData.GetColumns(lcUpdTable,"TmpNTblFld",lcTranCode,4,"NATIVE",nDataSessionID)
If !Used("TmpNTblFld")
  *--Unable to retrive updating table's information.
  Return -4
Endif

*--Default return value is Nothing Changed (Nothing to Update).
Store 2 To lnResult,lnExResult

*--Loop on modified records in cursor.

lcDelSetting = Set("Deleted")
Set Deleted Off
Select (cCursorName)

*! E038142,2 MAH 09/02/2004 In case of SQL, build update view, which will be used in update / delete [BEGIN]
If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
  Local lcUpdView

  *-- Get Temp name
  Local lcTempName
  lcTempName = GFTempName()

  *-- Build update function command
  lcUpdFunctionSQL = 'CREATE FUNCTION ' + lcTempName + ' ('

  Local lcVeiwParam
  lcVeiwParam = ''

  Local lnIndex
  For lnIndex = 1 To Occurs(',', lcPrimaryKeyList) - 1
    Local lcField
    lcField = Strextract(lcPrimaryKeyList, ',', ',', lnIndex)

    lcVeiwParam = lcVeiwParam + '?m.' + Alltrim(lcField)

    lcUpdFunctionSQL = lcUpdFunctionSQL + '@' + Alltrim(lcField) + ' '

    Do Case
    Case Type(lcField) = 'C'
      lcUpdFunctionSQL = lcUpdFunctionSQL + 'CHAR(' + Alltrim(Str(Len(Evaluate(lcField)))) + ')'

    Case Type(lcField) = 'N'
      lcUpdFunctionSQL = lcUpdFunctionSQL + 'NUMERIC'

    Case Type(lcField) = 'L'
      lcUpdFunctionSQL = lcUpdFunctionSQL + 'BIT'

    Case Type(lcField) = 'D' .Or. Type(lcField) = 'T'
      lcUpdFunctionSQL = lcUpdFunctionSQL + 'DATETIME'
    Endcase

    If lnIndex = Occurs(',', lcPrimaryKeyList) - 1
      lcUpdFunctionSQL = lcUpdFunctionSQL + ') '
    Else
      lcVeiwParam = lcVeiwParam + ', '

      lcUpdFunctionSQL = lcUpdFunctionSQL + ', '
    Endif
  Endfor

  lcUpdFunctionSQL = lcUpdFunctionSQL + 'RETURNS TABLE AS RETURN '

  lcUpdFunctionSQL = lcUpdFunctionSQL + ;
    '(SELECT * FROM ' + lcTable + '(INDEX = ' + lcPKIndex + ')' + ' WHERE ' + ;
    STRTRAN(lcPrimKey, '?m.', '@') + ')'

  lcUpdView = lcTempName + '(' + lcVeiwParam + ')'
Endif
*! E038142,2 MAH 09/02/2004 [END]

*! E038142,2 MAH 09/01/2004 Set Exact [BEGIN]
*-- lnChange=GETNEXTMODIFIED(0)
lnResult = 1
If Alltrim(lcDBEngine) == oAriaApplication.cFOXDBID
  lnResult = SQLExec(lnHandle, 'SET ANSI ' + Set('Exact'))
Endif

If lnResult = 1
  lnChange = Getnextmodified(0)
Else
  lnChange = 0
Endif
*! E038142,2 MAH [END]

Do While lnChange <> 0
  *--Go to modified record.
  Goto lnChange

  Scatter Memvar Memo

  Do Case
    *--Update -----------------------------------------------------------------
  Case !Deleted() And Recno()>0
    *! E038142,2 MAH 09/02/2004 Create update function if created [BEGIN]
    If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
      Local llUpdateFuncCreated

      If !llUpdateFuncCreated
        If SQLExec(lnHandle, lcUpdFunctionSQL) # 1
          Set DataSession To lnOldSession
          Select(lnCurrentWorkAria)

          *AMH 2/7/2005 [Start]
          oAriaApplication.RemoteCompanyData.mdebugsqlstr('',lcUpdFunctionSQL)
          *AMH 2/7/2005 [End]

          Return -10 && Error while creating update function
        Endif
      Endif

      llUpdateFuncCreated = .T.
    Endif
    *! E038142,2 MAH 09/02/2004 [END]

    *--Build Update fields SQL string.
    *! E038142,2 MAH 09/01/2004 Get database engine ID [BEGIN]
    *-- lcUpdString = This.buildupdatestring("UPDATE")
    lcUpdString = oAriaApplication.RemoteCompanyData.BuildUpdateString("UPDATE", lcDBEngine)
    *! E038142,2 MAH 09/01/2004 [END]

    If !Empty(lcUpdString)
      *--Execute path throgh command for SQL Update.
      *--Sent as UPDATE TableName SET Column_Name1 = eExpression1 [, Column_Name2 = eExpression2 ...] WHERE FilterCondition1...]
      *! E038142,2 MAH 09/02/2004 Create update function if created [BEGIN]
      *-- lnExResult = SQLEXEC(lnHandle,"UPDATE "+lcUpdTable+" "+lcUpdString+" WHERE "+lcPrimKey)
      If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
        lnExResult = SQLExec(lnHandle,'UPDATE ' +  lcUpdView + ' ' + lcUpdString)

        *AMH 9/26/2004 [Start]
        If lnExResult # 1
          oAriaApplication.RemoteCompanyData.mdebugsqlstr(lcUpdFunctionSQL,'UPDATE ' +  lcUpdView + ' ' + lcUpdString)
        Endif
        *AMH 9/26/2004 [End]

      Else
        lnExResult = SQLExec(lnHandle,"UPDATE "+lcUpdTable+" "+lcUpdString+" WHERE "+lcPrimKey)

        *AMH 9/26/2004 [Start]
        If lnExResult # 1
          oAriaApplication.RemoteCompanyData.mdebugsqlstr('',"UPDATE "+lcUpdTable+" "+lcUpdString+" WHERE "+lcPrimKey)
        Endif
        *AMH 9/26/2004 [End]

      Endif
      *! E038142,2 MAH 09/02/2004 [END]
    Endif

    *--Delete -----------------------------------------------------------------
  Case Deleted() And Recno()>0
    *! E038142,2 MAH 09/02/2004 Create update function if created [BEGIN]
    If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
      Local llUpdateFuncCreated

      If !llUpdateFuncCreated
        If SQLExec(lnHandle, lcUpdFunctionSQL) # 1
          Set DataSession To lnOldSession
          Select(lnCurrentWorkAria)

          *AMH 2/7/2005 [Start]
          oAriaApplication.RemoteCompanyData.mdebugsqlstr('',lcUpdFunctionSQL)
          *AMH 2/7/2005 [End]

          Return -10 && Error while creating update function
        Endif
      Endif

      llUpdateFuncCreated = .T.
    Endif
    *! E038142,2 MAH 09/02/2004 [END]

    *--Execute path throgh command for SQL Delete.

    *! E038142,2 MAH 09/02/2004 Create update function if created [BEGIN]
    *-- lnExResult = SQLEXEC(lnHandle,"DELETE FROM "+ lcUpdTable + " WHERE "+lcPrimKey)
    If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
      lnExResult = SQLExec(lnHandle, 'DELETE FROM ' + lcUpdView)

      *AMH 9/26/2004 [Start]
      If lnExResult # 1
        oAriaApplication.RemoteCompanyData.mdebugsqlstr(lcUpdFunctionSQL,'DELETE FROM ' + lcUpdView)
      Endif
      *AMH 9/26/2004 [End]

    Else
      lnExResult = SQLExec(lnHandle,"DELETE FROM "+ lcUpdTable + " WHERE "+lcPrimKey)

      *AMH 9/26/2004 [Start]
      If lnExResult # 1
        oAriaApplication.RemoteCompanyData.mdebugsqlstr('',"DELETE FROM "+ lcUpdTable + " WHERE "+lcPrimKey)
      Endif
      *AMH 9/26/2004 [End]

    Endif
    *! E038142,2 MAH 09/02/2004 [END]

    *--Insert -----------------------------------------------------------------
  Case !Deleted() And Recno()<0
    *--Build Insert fields SQL string.
    *! E038142,2 MAH 09/01/2004 Get database engine ID [BEGIN]
    *-- lcInsString = This.buildupdatestring("INSERT")
    lcInsString = oAriaApplication.RemoteCompanyData.BuildUpdateString("INSERT", lcDBEngine)
    *! E038142,2 MAH 09/01/2004 [END]

    If !Empty(lcInsString)
      *--Execute path throgh command for SQL Insert.
      *--Sent as INSERT INTO dbf_name [(fname1 [, fname2, ...])] VALUES (eExpression1 [, eExpression2, ...])

      lnExResult = SQLExec(lnHandle,"INSERT INTO "+lcUpdTable+" "+lcInsString)

      *! E038142,2 MAH 09/01/2004 In case of fox the sqlrun returns -1 with insert [BEGIN]
      *-- In case of fox
      If Alltrim(lcDBEngine) = oAriaApplication.cFOXDBID
        lnExResult = 1
      Endif
      *! E038142,2 MAH 09/01/2004 [END]

      *AMH 9/26/2004 [Start]
      If lnExResult # 1
        oAriaApplication.RemoteCompanyData.mdebugsqlstr('',"INSERT INTO "+lcUpdTable+" "+lcInsString)
      Endif
      *AMH 9/26/2004 [End]

    Endif

  Endcase
  lnResult = Min(lnResult,lnExResult)

  *--Next modified record.
  lnChange=Getnextmodified(lnChange)
Enddo

Set Deleted &lcDelSetting
*--Close table fields cursor.
Use In TmpTblFld
Use In TmpNTblFld

*B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[begin]

*!*	*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][Begin]
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
*!*	IF USED("BlkOrdHd")
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
*!*	  USE IN BlkOrdHd
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
*!*	ENDIF
*!*	IF USED("BlkOrdLn")
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
*!*	  USE IN BlkOrdLn
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
*!*	ENDIF
*!*	IF USED("BlkORDCnl")
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
*!*	  USE IN BlkORDCnl
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
*!*	ENDIF
*!*	*E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
*!*	*B610101,1 HIA 09/26/2012 When cancel release order from bulk order, reopen bulk order if user confirmed to reopen it[T20120711.0017][End  ]

*B610905,1 Ras 2014-11-10 solve bug "Alias name is already in use" due to using alias again without close it first[end]

*! E038142,2 MAH 09/02/2004 Drop created view [BEGIN]
If Alltrim(lcDBEngine) == oAriaApplication.cSQLDBID .And. Type('lcPKIndex') = 'C' .And. !Empty(lcPKIndex)
  Local lcDropView
  lcDropView = 'DROP FUNCTION ' + Left(lcUpdView, At('(', lcUpdView) - 1)

  *-- Execute drop function command. No nedd to handle the error if occurs.
  = SQLExec(lnHandle, lcDropView)
Endif
*! E038142,2 MAH 09/02/2004 [END]

*--Back to old work area and return the string.
Set DataSession To lnOldSession
Select(lnCurrentWorkAria)

*--Returns 1 when it has finished executing successfully
*--or -1 if connection level error occurs or 2 if nothing changed.
Return lnResult

Function Strextract
Lparameters lcExpression, cBeginDelim, cEndDelim, lnPos
lcExpression = Substr(lcExpression,At(cBeginDelim,lcExpression,lnPos)+1)
Return Substr(lcExpression,1,At(cEndDelim,lcExpression)-1)

Endfunc

**********************************************************************************************
Function lfBulkActions
*B612293,1 HIA 12/16/2020 add silent mode feature [Begin]
*PARAMETERS lcOrdLine,lcBlkOrdHd,lcBlkOrdLn,lcBlkORDCnl,lnSign
Parameters lcOrdLine,lcBlkOrdHd,lcBlkOrdLn,lcBlkORDCnl,lnSign, llSilent
*B612293,1 HIA 12/16/2020 add silent mode feature [End]


Select (lcOrdLine)
*CurRecOrdLine = ORDLINE.cOrdType+ORDLINE.ORDER+STR(ORDLINE.LINENO,6)
&& Adjust Style And StyDye Record Pointers.
*= SEEK(&lcOrdLine..STYLE,'Style')
*= SEEK(&lcOrdLine..STYLE+&lcOrdLine..cWareCode+SPACE(10),'StyDye')

*!*	FOR innerstr = 1 TO 8
*!*	  cstr = ALLTRIM(STR(innerstr))
*!*	  OldQTY&cstr.  = &lcOrdLine..Qty&cstr.
*!*	  OldBook&cstr. = &lcOrdLine..Book&cstr.
*!*	ENDFOR
Set Step On
Select (lcOrdLine)
lcFromOrder = &lcOrdLine..cFromOrder
lBulkLineNo = &lcOrdLine..BulkLineNo
lcOrdType   = &lcOrdLine..cOrdType
lcDyelot    = &lcOrdLine..Dyelot
lcSTYLE     = &lcOrdLine..Style
lcWareCode  = &lcOrdLine..cWareCode

If !Empty(lcFromOrder) .And. Seek(lcOrdType+lcFromOrder+Str(lBulkLineNo,6),lcBlkOrdLn) .And. Seek(lcOrdType+lcFromOrder,lcBlkOrdHd,'OrdHdr')
  lnOpen      = 0
  lnOpenAmt   = 0
  lnCancel    = 0
  lnCancelAmt = 0
  If llCancelBulk
    *E303340,1 RAS 11/22/2012 store the Cancel line releated to release order not Bulk order [begin]
    *!*	    SELECT (lcBlkOrdLn)
    *E303340,1 RAS 11/22/2012 store the Cancel line releated to release order not Bulk order [end]
    Scatter Memo Memvar
    m.TotQty = 0
    For innerLoopCounter = 1 To 8
      cstr = Alltrim(Str(innerLoopCounter))
      m.Qty&cstr = 0
    Endfor
    m.cCancReson = lfCanReason()
    m.Cancelled  = oAriaApplication.SystemDate
  Endif

  For innerLoopCounter = 1 To 8
    cstr = Alltrim(Str(innerLoopCounter))
    xDiff = (lnSign * (&lcOrdLine..Qty&cstr) )
    If !llCancelBulk
      *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [begin]
      *!*	      REPLACE Qty&cstr  WITH (Qty&cstr. + xDiff ) IN (lcBlkOrdLn)
      *!*	      REPLACE TotQty    WITH (TotQty    + xDiff )    IN (lcBlkOrdLn)
      *!*	      lnOpen    = lnOpen +  xDiff
      *!*	      lnOpenAmt = lnOpenAmt + (xDiff * ORDLINE.Price)

      *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [begin]
      *!*	      lnOpen    = lnOpen +  xDiff
      *!*	      lnOpenAmt = lnOpenAmt + (xDiff * ORDLINE.Price)
      lnOpen    = lnOpen +  Iif (xDiff>0,xDiff,lnSign * Min(&lcBlkOrdLn..Qty&cstr,Abs(xDiff)))
      lnOpenAmt = lnOpenAmt + (Iif (xDiff>0,xDiff,lnSign * Min(&lcBlkOrdLn..Qty&cstr,Abs(xDiff))) * ORDLINE.Price)
      *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [end]


      Replace Qty&cstr  With Max((Qty&cstr. + xDiff ),0) In (lcBlkOrdLn)

      *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [begin]
      *!*	      REPLACE TotQty    WITH MAX((TotQty    + xDiff ),0)    IN (lcBlkOrdLn)
      *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [end]

      *B610606,2 RAS 12/2/2013 solve bug not update bulk order header by add -ve values [begin]
      *!*	      lnOpen    = MAX(lnOpen +  xDiff,0)
      *!*	      lnOpenAmt = MAX(lnOpenAmt + (xDiff * ORDLINE.Price),0)

      *B610606,2 RAS 12/2/2013 solve bug not update bulk order header by add -ve values [end]

      *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [end]
    Else
      m.Qty&cstr = Abs(xDiff)
      m.TotQty = m.TotQty +  Abs(m.Qty&cstr)
    Endif
    *E303411,1 RAS 08/28/2013 make the same effect on open and book quantity at bulk orders on receving release orders [begin]
    *!*	    xDiff = &lcOrdLine..Book&cstr
    *E303411,1 RAS 08/28/2013 make the same effect on open and book quantity at bulk orders on receving release orders [end]
    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [begin]
    *!*	    REPLACE Book&cstr  WITH (Book&cstr. + xDiff) IN (lcBlkOrdLn)
    *!*	    REPLACE TotBook    WITH (TotBook + xDiff)    IN (lcBlkOrdLn)
    *!*	    lnCancel = lnCancel + xDiff
    *!*	    lnCancelAmt = lnCancelAmt + (xDiff * ORDLINE.Price)


    *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [begin]
    *!*	    lnCancel = lnCancel + xDiff
    *!*	    lnCancelAmt = lnCancelAmt + (xDiff * ORDLINE.Price)

    lnCancel = lnCancel +  Iif (xDiff>0,xDiff,lnSign * Min(&lcBlkOrdLn..Book&cstr,Abs(xDiff)))
    lnCancelAmt = lnCancelAmt + (Iif (xDiff>0,xDiff,lnSign * Min(&lcBlkOrdLn..Book&cstr,Abs(xDiff))) * ORDLINE.Price)
    *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [end]

    Replace Book&cstr  With Max((Book&cstr. + xDiff),0) In (lcBlkOrdLn)
    *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [begin]
    *!*	    REPLACE TotBook    WITH MAX((TotBook + xDiff),0)    IN (lcBlkOrdLn)
    *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [end]

    *B610606,2 RAS 12/2/2013 solve bug not update bulk order header by add -ve values [begin]
    *!*	    lnCancel = MAX(lnCancel + xDiff,0)
    *!*	    lnCancelAmt = MAX(lnCancelAmt + (xDiff * ORDLINE.Price),0)



    *B610606,2 RAS 12/2/2013 solve bug not update bulk order header by add -ve values [end]

    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [end]
    *!*	    IF !llCancelBulk
    *!*	      =RLOCK('Style')
    *!*	      REPLACE  Ord&cstr.   WITH Ord&cstr. + xDiff ,;
    *!*	        TotOrd      WITH TotOrd    + xDiff IN STYLE
    *!*	      UNLOCK IN 'Style'

    *!*	      =RLOCK('StyDye')
    *!*	      REPLACE Ord&cstr.  WITH Ord&cstr.  + xDiff  ,;
    *!*	        TotOrd     WITH TotOrd     + xDiff  IN StyDye
    *!*	      UNLOCK IN 'StyDye'
    *!*	      *-- Update the Qty on the Configuration level
    *!*	      IF !EMPTY(lcDyelot) AND SEEK(lcSTYLE+lcWareCode+lcDyelot,'StyDye')
    *!*	        REPLACE Ord&cstr.   WITH Ord&cstr. + xDiff ,;
    *!*	          TotOrd      WITH TotOrd    + xDiff IN StyDye
    *!*	        UNLOCK IN 'StyDye'
    *!*	      ENDIF
    *!*	    ENDIF
  Endfor

  *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [begin]
  Lntotqty=0
  lntotbook=0
  For innerLoopCounter = 1 To 8
    cstr = Alltrim(Str(innerLoopCounter))
    Lntotqty=Lntotqty+&lcBlkOrdLn..Qty&cstr
    lntotbook=lntotbook+&lcBlkOrdLn..Book&cstr
  Endfor
  Replace TotQty    With Lntotqty    In (lcBlkOrdLn)
  Replace TotBook    With lntotbook    In (lcBlkOrdLn)
  *B610606,3 RAS 3/11/2014 solve bug update the total quantiy with total release lines quantity even if it was bigger than bulk lines quantity [end]

  && Modify the Bulk Order Header Totals And Adjust The Status Depend On The Totals values

  If llCancelBulk
    Select ( lcBlkORDCnl)
    Append Blank
    Gather Memo Memvar
    =gfAdd_Info(lcBlkORDCnl)

    Select (lcBlkOrdHd)
    =Rlock(lcBlkOrdHd)
    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders[begin]
    *!*	    REPLACE Book      WITH (Book  + lnCancel)   ,;
    *!*	      BookAmt   WITH (BookAmt + lnCancelAmt)    ,;
    *!*	      STATUS    WITH IIF(OPEN = 0 ,'X',STATUS)  ,;
    *!*	      CANCEL    WITH (CANCEL    + lnCancel)     ,;
    *!*	      CANCELAmt WITH (CANCELAmt + lnCancelAmt)  ,;
    *!*	      APPRAMT   WITH MAX(0,APPRAMT + lnOpenAmt) IN (lcBlkOrdHd)
    Replace Book      With Max((Book  + lnCancel),0)   ,;
      BookAmt   With Max((BookAmt + lnCancelAmt),0)    ,;
      STATUS    With Iif(Open = 0 ,'X',Status)  ,;
      CANCEL    With Max((Cancel    + lnCancel),0)     ,;
      CancelAmt With Max((CancelAmt + lnCancelAmt),0)  ,;
      APPRAMT   With Max(0,APPRAMT + lnOpenAmt) In (lcBlkOrdHd)
    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [end]
  Else

    =Rlock(lcBlkOrdHd)
    Select (lcBlkOrdHd)
    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [begin]
    *!*	    REPLACE Book      WITH (Book  + lnCancel)   ,;
    *!*	      BookAmt   WITH (BookAmt + lnCancelAmt),;
    *!*	      OPEN      WITH (OPEN    + lnOpen)     ,;
    *!*	      OpenAmt   WITH (OpenAmt + lnOpenAmt)  ,;
    *!*	      STATUS    WITH IIF(OPEN = 0 ,'X',STATUS) ,;
    *!*	      APPRAMT   WITH MAX(0,APPRAMT + lnOpenAmt) IN (lcBlkOrdHd)

    Replace Book      With Max((Book  + lnCancel),0)   ,;
      BookAmt   With Max((BookAmt + lnCancelAmt),0),;
      OPEN      With Max((Open    + lnOpen),0)     ,;
      Openamt   With Max((Openamt + lnOpenAmt),0)  ,;
      STATUS    With Iif(Open = 0 ,'X',Status) ,;
      APPRAMT   With Max(0,APPRAMT + lnOpenAmt) In (lcBlkOrdHd)
    *E303304,1 RAS 11/22/2012 prevent store negetive values at bulk orders [end]
    && ASK mmt ABOUT USING llCancelBulk
    *E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [begin]
    *!*	    IF &lcBlkOrdHd..STATUS='X' .AND. &lcBlkOrdHd..OPEN > 0 .AND. SEEK('M'+ BlkOrdHd.Account,'Customer')
    If &lcBlkOrdHd..Status='X' .And. &lcBlkOrdHd..Open > 0 .And. Seek('M'+&lcBlkOrdHd..account,'Customer')
      *E303278,2 RAS 10/17/2012 Solve Bug "blkordhd alias is not found" [end]
      =Rlock(lcBlkOrdHd)
      Replace Status With "O" In (lcBlkOrdHd)
      Unlock In (lcBlkOrdHd)
      *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
      LcAl=Alias()
      Select OrdHdr
      lcORD = Order()
      Set Order To ORDBULK
      =Seek(laData[2]+'O'+'Y'+'O','ORDHDR','ORDBULK')
      lnBulkCntO=0
      lnBulkCntH=0
      Count To lnBulkCntO  While account+Status+bulk+cOrdType+Order = laData[2]+'O'+'Y'+'O'
      =Seek(laData[2]+'H'+'Y'+'O','ORDHDR','ORDBULK')
      Count To lnBulkCntH  While account+Status+bulk+cOrdType+Order = laData[2]+'H'+'Y'+'O'
      lnBulkCntO=lnBulkCntO+lnBulkCntH
      Set Order To (lcORD)
      Select (LcAl)
      *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
      =Rlock('Customer')
      *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [Begin]
      *!*REPLACE nBulk WITH nBulk + 1 IN Customer
      Replace nBulk With lnBulkCntO In Customer
      *E303673,1 AEG 2016-6-09 enhance Nbulk counting after update bulk order [End]
      Unlock In 'Customer'
    Endif

  Endif

  Unlock In (lcBlkOrdHd)

Endif
Select ORDLINE
Return .T.
Endfunc
