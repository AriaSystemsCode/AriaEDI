lcServer='ARIASQL\ARIASQLSERVER'
lcTmpDataBase='System.Master'
lcUsrNam='sa'
lcPasword='aria_123'
lcTemp=''
lcQuery=' cversion =  CASE '
lcfnames=''
If !Used('fnametable')
  Use C:\Users\aria.aria\Desktop\Compare\fnametable
  Scan
    lcfnames=lcfnames+'|'+Alltrim(e)
  Endscan
Endif
*Create Table lcComRes(Mapset c(20), Tran_no c(6), cversion c(10), Client_ID c(10), F_name c(20), LoopId c(20),SegId c(20), F_order c(10), Aria_Exp c(200), Client_Exp c(200),Aria_Val c(200),Client_Val c(200), Aria_Cond c(100), Client_Con c(100), Aria_Usg c(10), Client_Usg c(10), ctype c(50),Aria_typ c(50),Client_typ c(50),Aria_des c(50),Client_des c(50),Aria_det c(50),Client_det c(50),AriaCrep c(50),ClientCrep c(50))
*Create Table lcComRes1(Mapset c(20), Tran_no c(6), cversion c(10), Client_ID c(10), F_name c(20), LoopId c(20),SegId c(20), F_order c(10), Aria_Exp c(200), Client_Exp c(200),Aria_Val c(200),Client_Val c(200), Aria_Cond c(100), Client_Con c(100), Aria_Usg c(10), Client_Usg c(10), ctype c(50),Aria_typ c(50),Client_typ c(50),Aria_des c(50),Client_des c(50),Aria_det c(50),Client_det c(50),AriaCrep c(50),ClientCrep c(50))

Create Table lcComRes(Mapset C(20), Tran_no C(6), cversion C(10), Client_ID C(10), F_name C(20), LoopId C(20),SegId C(20), F_order C(10), Aria_Exp C(200), Client_Exp C(200),Aria_Val C(200),Client_Val C(200), Aria_Cond C(100), Client_Con C(100), Aria_Usg C(10), Client_Usg C(10), ctype C(50),Aria_typ C(50),Client_typ C(50),Aria_des C(50),Client_des C(50),Aria_det C(50),Client_det C(50),AriaCrep C(50),ClientCrep C(50),Aria_nwid C(10),Clien_nwid C(10),Aria_NXD C(10),Clien_NXD C(10),Aria_SMB C(10),Clien_SMB C(10),Aria_NST C(10),Clien_NST C(10),Aria_NBH C(10),Clien_NBH C(10),Aria_NLH C(10),Clien_NLH C(10),Aria_NLW C(10),Clien_NLW C(10),Aria_NLM C(10),Clien_NLM C(10),Aria_NTM C(10),Clien_NTM C(10),Aria_NW2 C(10),Clien_NW2 C(10))
Create Table lcComRes1(Mapset C(20), Tran_no C(6), cversion C(10), Client_ID C(10), F_name C(20), LoopId C(20),SegId C(20), F_order C(10), Aria_Exp C(200), Client_Exp C(200),Aria_Val C(200),Client_Val C(200), Aria_Cond C(100), Client_Con C(100), Aria_Usg C(10), Client_Usg C(10), ctype C(50),Aria_typ C(50),Client_typ C(50),Aria_des C(50),Client_des C(50),Aria_det C(50),Client_det C(50),AriaCrep C(50),ClientCrep C(50),Aria_nwid C(10),Clien_nwid C(10),Aria_NXD C(10),Clien_NXD C(10),Aria_SMB C(10),Clien_SMB C(10),Aria_NST C(10),Clien_NST C(10),Aria_NBH C(10),Clien_NBH C(10),Aria_NLH C(10),Clien_NLH C(10),Aria_NLW C(10),Clien_NLW C(10),Aria_NLM C(10),Clien_NLM C(10),Aria_NTM C(10),Clien_NTM C(10),Aria_NW2 C(10),Clien_NW2 C(10))


*Create Table lcComRes(Mapset c(20), Tran_no c(6), cversion c(10), Client_ID c(10), F_name c(20), LoopId c(20),SegId c(20), F_order c(10), Aria_Exp c(200), Client_Exp c(200),Aria_Val c(200),Client_Val c(200), Aria_Cond c(100), Client_Con c(100), Aria_Usg c(10), Client_Usg c(10), ctype c(50))
*Create Table lcComRes1(Mapset c(20), Tran_no c(6), cversion c(10), Client_ID c(10), F_name c(20), LoopId c(20),SegId c(20), F_order c(10), Aria_Exp c(200), Client_Exp c(200),Aria_Val c(200),Client_Val c(200), Aria_Cond c(100), Client_Con c(100), Aria_Usg c(10), Client_Usg c(10), ctype c(50))
lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim(lcTmpDataBase)+;
  ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
If !Used('SqlTables')
  *Use C:\Users\aria.ARIA\Desktop\Comp\SQLTables
  Use C:\Users\aria.aria\Desktop\Compare\SQLTables
Endif
******************Client To Aria********************
lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim(lcTmpDataBase)+;
  ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
If lnConnHandler>0
  llret=SQLExec(lnConnHandler , 'SELECT CCLIENTID,ARIA40SYS FROM CLIENTS', 'clients')
  If llret>0 And Reccount('clients')>0
    SQLDisconnect(lnConnHandler)
    Select clients
    Go Top
    Scan
      lcClient=clients.CCLIENTID
      lcSysfiles=clients.ARIA40SYS
      Wait Wind 'Comparing Client:'+lcClient Nowait
      Select SQLTables
      Set Deleted On
      Go Top
      Scan
        lcSqlTable=Alltrim(SQLTables.Table)
        lcTrn_no=Alltrim(SQLTables.Trnnum)
        lcTrn_Typ=Alltrim(SQLTables.Trntyp)
        If (!Used(Allt(lcSqlTable))) And (File(Allt(lcSysfiles)+'\'+Allt(lcSqlTable)+'.dbf'))
          Use Allt(lcSysfiles)+'\'+Allt(lcSqlTable)+'.dbf' Shar In 0

          Select 0
          Select * From &lcSqlTable Into Cursor ClientFile Readwrite
          Use In Allt(lcSqlTable)

          Wait Wind 'Comparing Client: '+lcClient+'---Table: '+lcSqlTable Nowait
          lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim('EDIMAPPINGS')+;
            ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
          If lnConnHandler>0
            If  lcTrn_Typ='XP'
              llret=SQLExec(lnConnHandler , 'SELECT * FROM '+lcSqlTable +" Where ccustomer='" +lcClient+"'", 'AriaSqlTable')
            Else
              llret=SQLExec(lnConnHandler , 'SELECT * FROM '+lcSqlTable, 'AriaSqlTable')
            Endif

            SQLDisconnect(lnConnHandler)

            lcValue = ""
            lnOccur = 0
            lcCompDesRecNos  = ""

            ***Set Index of Send and XP
            If lcTrn_Typ=='S' Or lcTrn_Typ='XP'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of Recevice
            If lcTrn_Typ=='R'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif


            ***Set Index of SG
            If lcTrn_Typ=='SG'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif


            ***Set Index of SV
            If lcTrn_Typ=='SV'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cpartcode+cversion+ceditrntyp+SegId+Level  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cpartcode+cversion+ceditrntyp+SegId+Level Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of ASNHD
            If lcTrn_Typ=='ASNHD' Or lcTrn_Typ=='UPCHD'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cver Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cver Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of ASNDT
            If lcTrn_Typ=='ASNDT' Or  lcTrn_Typ=='UPCDT'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                *Index On cver+Alltrim(zone)+Str(F_order,2)  Tag Network1
                Index On cver  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                *Index On cver+Alltrim(zone)+Str(F_order,2) Tag Network1
                Index On cver  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif




            Select ClientFile

            *Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
            Go Top
            lcSourceKeyVal = ""
            Scan
              **Handle Send & XP[Start]
              If lcTrn_Typ=='S' Or lcTrn_Typ='XP'
                * Hes
                Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cmapset+cversion+loop_id+Str(F_order,2)+F_name=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry

                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(F_value) = Alltrim(ClientSourceTemp.F_value)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(ClientSourceTemp.F_cond) == Alltrim(F_cond) And Alltrim(ClientSourceTemp.cusage)==Alltrim(cusage))
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,ClientSourceTemp.loop_id,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,AriaSqlTable.F_cond,ClientSourceTemp.F_cond,AriaSqlTable.cusage,ClientSourceTemp.cusage,'Change')
                        Endif

                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,ClientSourceTemp.loop_id,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,AriaSqlTable.F_cond,ClientSourceTemp.F_cond,AriaSqlTable.cusage,ClientSourceTemp.cusage,'Expression Change')
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,ClientSourceTemp.loop_id,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'',ClientSourceTemp.F_cond,'',ClientSourceTemp.cusage,'Missing from Aria')
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,ClientSourceTemp.loop_id,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'',ClientSourceTemp.F_cond,'',ClientSourceTemp.cusage,'Missing from Aria')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle Send & XP[End]

              **Handle receive[Start]
              If lcTrn_Typ=='R'
                * Hes
                *Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                Lckey='cmapset+cversion+segid+STR(f_order,2)'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cmapset+cversion+SegId+Str(F_order,2)=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp

                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    *!*	                    If cmapset='ACE' And clients.CCLIENTID='BBC10' And SegId='PO1'
                    *!*	                      Messagebox('ss')
                    *!*	                    Endif
                    Lckey='cmapset+cversion+segid+STR(f_order,2)'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')

                      Scan Rest While &Lckey= LckeyValu For Iif((At(Alltrim(Upper(F_name)),lcfnames)>0),Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name) And Alltrim(F_cond)=Alltrim(ClientSourceTemp.F_cond),Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name))
                        *Scan Rest While &Lckey= LckeyValu For Iif(SEEK(UPPER(f_name),'fnametable','key'),F_name = ClientSourceTemp.F_name And F_cond=ClientSourceTemp.F_cond,F_name = ClientSourceTemp.F_name)
                        *Select AriaSqlTable
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(ClientSourceTemp.F_cond) == Alltrim(F_cond) And Alltrim(ClientSourceTemp.F_value)==Alltrim(F_value) And Alltrim(ClientSourceTemp.f_type)==Alltrim(f_type))
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,'',ClientSourceTemp.SegId,Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,AriaSqlTable.F_cond,ClientSourceTemp.F_cond,AriaSqlTable.f_type,ClientSourceTemp.f_type,'Change')
                        Endif

                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion+segid+STR(f_order,2)'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,'',ClientSourceTemp.SegId,Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,AriaSqlTable.F_cond,ClientSourceTemp.F_cond,AriaSqlTable.f_type,ClientSourceTemp.f_type,'Variable Change')
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,'',ClientSourceTemp.SegId,Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'',ClientSourceTemp.F_cond,'','','Missing from Aria')
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,ClientSourceTemp.F_name,'',ClientSourceTemp.SegId,Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'',ClientSourceTemp.F_cond,'','','Missing from Aria')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
              Endif
              **Handle receive[End]

              **Handle SG[Start]
              If lcTrn_Typ='SG'
                Lckey='cmapset+cversion'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cmapset+cversion=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp

                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cmapset+cversion'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')

                      Scan Rest While &Lckey= LckeyValu For Alltrim(SegId)=Alltrim(ClientSourceTemp.SegId) And Alltrim(loop_id)=Alltrim(ClientSourceTemp.loop_id)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'
                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'',ClientSourceTemp.loop_id+'-'+AriaSqlTable.loop_id,ClientSourceTemp.SegId,'','','','','','','','','','Loop Change')
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'',ClientSourceTemp.loop_id,ClientSourceTemp.SegId,'','','','','','','','','','Missing from Aria')
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cmapset,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'',ClientSourceTemp.loop_id,ClientSourceTemp.SegId,'','','','','','','','','','Missing from Aria')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif

              **Handle SG[End]

              **Handle SV [Start]
              If lcTrn_Typ=='SV'

                Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cpartcode+cversion+ceditrntyp+SegId+Level=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp

                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cpartcode+cversion+ceditrntyp+SegId+Level  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')

                      Scan Rest While &Lckey= LckeyValu For Alltrim(key_exp)=Alltrim(ClientSourceTemp.key_exp) And Alltrim(ccond)=Alltrim(ClientSourceTemp.ccond)
                        *Scan Rest While &Lckey= LckeyValu For Iif(SEEK(UPPER(f_name),'fnametable','key'),F_name = ClientSourceTemp.F_name And F_cond=ClientSourceTemp.F_cond,F_name = ClientSourceTemp.F_name)
                        *Select AriaSqlTable
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'
                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cpartcode,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'','',ClientSourceTemp.SegId,'',AriaSqlTable.key_exp,ClientSourceTemp.key_exp,'','',AriaSqlTable.ccond,ClientSourceTemp.ccond,'','','Expression Change')
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cpartcode,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'','',ClientSourceTemp.SegId,'','',ClientSourceTemp.key_exp,'','','',ClientSourceTemp.ccond,'','','Missing from Aria')
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cpartcode,lcTrn_Typ,ClientSourceTemp.cversion,lcClient,'','',ClientSourceTemp.SegId,'','',ClientSourceTemp.key_exp,'','','',ClientSourceTemp.ccond,'','','Missing from Aria')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
              Endif
              **Handle SV[End]

              **Handle ASNHD [Start]
              If lcTrn_Typ=='ASNHD'
                * Hes
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cver=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry

                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(crep_name) = Alltrim(ClientSourceTemp.crep_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(ClientSourceTemp.desc1) == Alltrim(desc1) And Alltrim(ClientSourceTemp.ctype)==Alltrim(ctype) And ClientSourceTemp.ldetlabel==ldetlabel)
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,Iif(AriaSqlTable.ldetlabel,"TRUE","FALSE"),Iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"),AriaSqlTable.crep_name,ClientSourceTemp.crep_name)
                        Endif

                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Crep_Name Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,Iif(AriaSqlTable.ldetlabel,"TRUE","FALSE"),Iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"),AriaSqlTable.crep_name,ClientSourceTemp.crep_name)
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Aria','',ClientSourceTemp.ctype,'',ClientSourceTemp.desc1,'',Iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"),'',ClientSourceTemp.crep_name)
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Aria','',ClientSourceTemp.ctype,'',ClientSourceTemp.desc1,'',Iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"),'',ClientSourceTemp.crep_name)
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle ASNHD[End]


              **Handle ASNDT[Start]
              If lcTrn_Typ=='ASNDT'
                * HesIndex On cver+f_name  Tag Network1
                *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cver=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    *Index On cver+Alltrim(zone)+Str(F_order,2) Tag Network1
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry

                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      *Scan Rest While &Lckey= LckeyValu For Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name)
                      Scan Rest While &Lckey= LckeyValu For Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        *If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Str(ClientSourceTemp.Nwidth)==Str(Nwidth))
                        *If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Str(ClientSourceTemp.Nwidth)==Str(Nwidth) And Str(ClientSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(ClientSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(ClientSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(ClientSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(ClientSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(ClientSourceTemp.nTopMargn)==Str(nTopMargn) And Str(ClientSourceTemp.NWID2NRW)==Str(NWID2NRW))
                        If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Alltrim(Str(ClientSourceTemp.F_order,2)) == Alltrim(Str(F_order,2))And Alltrim(ClientSourceTemp.zone) == Alltrim(zone) And Str(ClientSourceTemp.Nwidth)==Str(Nwidth) And Str(ClientSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(ClientSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(ClientSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(ClientSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(ClientSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(ClientSourceTemp.nTopMargn)==Str(nTopMargn) And Str(ClientSourceTemp.NWID2NRW)==Str(NWID2NRW))
                          *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone+'-'+AriaSqlTable.zone,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,'','',Str(AriaSqlTable.Nwidth),Str(ClientSourceTemp.Nwidth),'Change')
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone)+'-'+Alltrim(AriaSqlTable.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,AriaSqlTable.F_value,'','',Str(ClientSourceTemp.Nwidth),Str(AriaSqlTable.Nwidth),'Change','','','','','','','','',Str(ClientSourceTemp.Nwidth),Str(AriaSqlTable.Nwidth),Str(ClientSourceTemp.NXDIMLBL),Str(AriaSqlTable.NXDIMLBL),Str(ClientSourceTemp.NSYMBOLOGY),Str(AriaSqlTable.NSYMBOLOGY),Str(ClientSourceTemp.NSHOWTEXT),Str(AriaSqlTable.NSHOWTEXT),Str(ClientSourceTemp.NBARHEIGHT),Str(AriaSqlTable.NBARHEIGHT),Str(ClientSourceTemp.NLBLHEIGHT),Str(AriaSqlTable.NLBLHEIGHT),Str(ClientSourceTemp.NLBLWIDTH),Str(AriaSqlTable.NLBLWIDTH),Str(ClientSourceTemp.NLEFTMARGN),Str(AriaSqlTable.NLEFTMARGN),Str(ClientSourceTemp.nTopMargn),Str(AriaSqlTable.nTopMargn),Str(ClientSourceTemp.NWID2NRW),Str(AriaSqlTable.NWID2NRW))
                        Endif
                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone+'-'+AriaSqlTable.zone,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,'','',Str(AriaSqlTable.Nwidth),Str(ClientSourceTemp.Nwidth),'F_name Change')
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone)+'-'+Alltrim(AriaSqlTable.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,AriaSqlTable.F_value,'','',Str(ClientSourceTemp.Nwidth),Str(AriaSqlTable.Nwidth),;
                        'F_name Change','','','','','','','','',Str(ClientSourceTemp.nwidth),Str(AriaSqlTable.nwidth),Str(ClientSourceTemp.NXDIMLBL),Str(AriaSqlTable.NXDIMLBL),Str(ClientSourceTemp.NSYMBOLOGY),Str(AriaSqlTable.NSYMBOLOGY),Str(ClientSourceTemp.NSHOWTEXT),Str(AriaSqlTable.NSHOWTEXT),Str(ClientSourceTemp.NBARHEIGHT),Str(AriaSqlTable.NBARHEIGHT),Str(ClientSourceTemp.NLBLHEIGHT),Str(AriaSqlTable.NLBLHEIGHT),Str(ClientSourceTemp.NLBLWIDTH),Str(AriaSqlTable.NLBLWIDTH),Str(ClientSourceTemp.NLEFTMARGN),Str(AriaSqlTable.NLEFTMARGN),Str(ClientSourceTemp.nTopMargn),Str(AriaSqlTable.nTopMargn),Str(ClientSourceTemp.NWID2NRW),Str(AriaSqlTable.NWID2NRW))
                      Else
                        *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'Missing from Aria')
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'',;
                        'Missing from Aria','','','','','','','','',Str(ClientSourceTemp.nwidth),'',Str(ClientSourceTemp.NXDIMLBL),'',Str(ClientSourceTemp.NSYMBOLOGY),'',Str(ClientSourceTemp.NSHOWTEXT),'',Str(ClientSourceTemp.NBARHEIGHT),'',Str(ClientSourceTemp.NLBLHEIGHT),'',Str(ClientSourceTemp.NLBLWIDTH),'',Str(ClientSourceTemp.NLEFTMARGN),'',Str(ClientSourceTemp.nTopMargn),'',Str(ClientSourceTemp.NWID2NRW),'')
                      Endif
                    Else
                      *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'Missing from Aria')
                                              Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'',;
                        'Missing from Aria','','','','','','','','',Str(ClientSourceTemp.nwidth),'',Str(ClientSourceTemp.NXDIMLBL),'',Str(ClientSourceTemp.NSYMBOLOGY),'',Str(ClientSourceTemp.NSHOWTEXT),'',Str(ClientSourceTemp.NBARHEIGHT),'',Str(ClientSourceTemp.NLBLHEIGHT),'',Str(ClientSourceTemp.NLBLWIDTH),'',Str(ClientSourceTemp.NLEFTMARGN),'',Str(ClientSourceTemp.nTopMargn),'',Str(ClientSourceTemp.NWID2NRW),'')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle ASNDT[End]



              **Handle UPCHD[Start]
              If lcTrn_Typ=='UPCHD'
                * Hes
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cver=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry

                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(crep_name) = Alltrim(ClientSourceTemp.crep_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) AND Alltrim(ClientSourceTemp.desc1) == Alltrim(desc1) And Alltrim(ClientSourceTemp.ctype)==Alltrim(ctype) And STR(ClientSourceTemp.NWIDTH)==STR(NWIDTH))
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,AriaSqlTable.F_value,ClientSourceTemp.F_value,AriaSqlTable.crep_name,ClientSourceTemp.crep_name)
                        Endif

                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Crep_Name Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,AriaSqlTable.f_value,ClientSourceTemp.f_value,AriaSqlTable.crep_name,ClientSourceTemp.crep_name)
                      Else
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Aria','',ClientSourceTemp.ctype,'',ClientSourceTemp.desc1,'',ClientSourceTemp.f_value,'',ClientSourceTemp.crep_name)
                      Endif
                    Else
                      Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Aria','',ClientSourceTemp.ctype,'',ClientSourceTemp.desc1,'',ClientSourceTemp.f_value,'',ClientSourceTemp.crep_name)
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle UPCHD[End]

              **Handle UPCDT[Start]
              If lcTrn_Typ=='UPCDT'
                * HesIndex On cver+f_name  Tag Network1
                *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('ClientSourceTemp ')
                    Select ClientSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From ClientFile Where cver=LckeyValu Into Cursor ClientSourceTemp Readwrite

                  Select ClientSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    *Index On cver+Alltrim(zone)+Str(F_order,2) Tag Network1
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry

                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      *Scan Rest While &Lckey= LckeyValu For Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name)
                      Scan Rest While &Lckey= LckeyValu For Alltrim(F_name) = Alltrim(ClientSourceTemp.F_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        *If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Str(ClientSourceTemp.Nwidth)==Str(Nwidth))
                        *If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Str(ClientSourceTemp.Nwidth)==Str(Nwidth) And Str(ClientSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(ClientSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(ClientSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(ClientSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(ClientSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(ClientSourceTemp.nTopMargn)==Str(nTopMargn) And Str(ClientSourceTemp.NWID2NRW)==Str(NWID2NRW))
                        If !(Alltrim(ClientSourceTemp.F_value) == Alltrim(F_value) And Alltrim(Str(ClientSourceTemp.F_order,2)) == Alltrim(Str(F_order,2))And Alltrim(ClientSourceTemp.zone) == Alltrim(zone) And  Str(ClientSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(ClientSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(ClientSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(ClientSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(ClientSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(ClientSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(ClientSourceTemp.nTopMargn)==Str(nTopMargn))
                          *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone+'-'+AriaSqlTable.zone,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,'','',Str(AriaSqlTable.Nwidth),Str(ClientSourceTemp.Nwidth),'Change')
                          Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone)+'-'+Alltrim(AriaSqlTable.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,AriaSqlTable.F_value,'','','','','Change','','','','','','','','','','',Str(ClientSourceTemp.NXDIMLBL),Str(AriaSqlTable.NXDIMLBL),Str(ClientSourceTemp.NSYMBOLOGY),Str(AriaSqlTable.NSYMBOLOGY),Str(ClientSourceTemp.NSHOWTEXT),Str(AriaSqlTable.NSHOWTEXT),Str(ClientSourceTemp.NBARHEIGHT),Str(AriaSqlTable.NBARHEIGHT),Str(ClientSourceTemp.NLBLHEIGHT),Str(AriaSqlTable.NLBLHEIGHT),Str(ClientSourceTemp.NLBLWIDTH),Str(AriaSqlTable.NLBLWIDTH),Str(ClientSourceTemp.NLEFTMARGN),Str(AriaSqlTable.NLEFTMARGN),Str(ClientSourceTemp.nTopMargn),Str(AriaSqlTable.nTopMargn),'','')
                        Endif
                      Endscan
                    Endif
                  Endscan

                  Select ClientSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select AriaSqlTable

                    Go Top
                    If Seek(LckeyValu,'AriaSqlTable','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test
                      If llExist
                        *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone+'-'+AriaSqlTable.zone,'',Str(ClientSourceTemp.F_order),'','',AriaSqlTable.F_value,ClientSourceTemp.F_value,'','',Str(AriaSqlTable.Nwidth),Str(ClientSourceTemp.Nwidth),'F_name Change')
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone)+'-'+Alltrim(AriaSqlTable.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,AriaSqlTable.F_value,'','','','',;
                        'F_name Change','','','','','','','','','','',Str(ClientSourceTemp.NXDIMLBL),Str(AriaSqlTable.NXDIMLBL),Str(ClientSourceTemp.NSYMBOLOGY),Str(AriaSqlTable.NSYMBOLOGY),Str(ClientSourceTemp.NSHOWTEXT),Str(AriaSqlTable.NSHOWTEXT),Str(ClientSourceTemp.NBARHEIGHT),Str(AriaSqlTable.NBARHEIGHT),Str(ClientSourceTemp.NLBLHEIGHT),Str(AriaSqlTable.NLBLHEIGHT),Str(ClientSourceTemp.NLBLWIDTH),Str(AriaSqlTable.NLBLWIDTH),Str(ClientSourceTemp.NLEFTMARGN),Str(AriaSqlTable.NLEFTMARGN),Str(ClientSourceTemp.nTopMargn),Str(AriaSqlTable.nTopMargn),'','')
                      Else
                        *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'Missing from Aria')
                        Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,'','','','','',;
                        'Missing from Aria','','','','','','','','','','',Str(ClientSourceTemp.NXDIMLBL),'',Str(ClientSourceTemp.NSYMBOLOGY),'',Str(ClientSourceTemp.NSHOWTEXT),'',Str(ClientSourceTemp.NBARHEIGHT),'',Str(ClientSourceTemp.NLBLHEIGHT),'',Str(ClientSourceTemp.NLBLWIDTH),'',Str(ClientSourceTemp.NLEFTMARGN),'',Str(ClientSourceTemp.nTopMargn),'','','')
                      Endif
                    Else
                      *Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,ClientSourceTemp.zone,'',Str(ClientSourceTemp.F_order),'','','',ClientSourceTemp.F_value,'','','',Str(ClientSourceTemp.Nwidth),'Missing from Aria')
                                              Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,ClientSourceTemp.F_name,Alltrim(ClientSourceTemp.zone),'',Str(ClientSourceTemp.F_order),'','',ClientSourceTemp.F_value,'','','','','',;
                        'Missing from Aria','','','','','','','','','','',Str(ClientSourceTemp.NXDIMLBL),'',Str(ClientSourceTemp.NSYMBOLOGY),'',Str(ClientSourceTemp.NSHOWTEXT),'',Str(ClientSourceTemp.NBARHEIGHT),'',Str(ClientSourceTemp.NLBLHEIGHT),'',Str(ClientSourceTemp.NLBLWIDTH),'',Str(ClientSourceTemp.NLEFTMARGN),'',Str(ClientSourceTemp.nTopMargn),'','','')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle UPCDT[End]


            Endscan
            If Used(Allt(lcSqlTable))
              Use In Allt(lcSqlTable)
            Endif
            If Used(Allt('fnametable'))
              Use In Allt('fnametable')
            Endif
          Else
            Messagebox("could not connect to EDIMAPPINGS")
          Endif
        Else
          *Messagebox(lcSqlTable+"Not Exist")
        Endif
      Endscan
      If Used('AriaSqlTable')
        Use In AriaSqlTable
      Endif
    Endscan
    Select lcComRes1
    Export To C:\Users\aria.aria\Desktop\Compare\ClientsVsAria.Xls Type Xls
    Messagebox('Completed')
  Else
    Messagebox("could not get clients from client table")
  Endif
Else
  Messagebox("could not connect to system.master")
Endif




******************Aria to Client*********************
lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim(lcTmpDataBase)+;
  ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
If lnConnHandler>0
  llret=SQLExec(lnConnHandler , 'SELECT CCLIENTID,ARIA40SYS FROM CLIENTS', 'clients')
  If llret>0 And Reccount('clients')>0
    SQLDisconnect(lnConnHandler)
    Select clients
    Go Top
    Scan
      lcClient=clients.CCLIENTID
      lcSysfiles=clients.ARIA40SYS
      Wait Wind 'Comparing Client:'+lcClient Nowait
      Select SQLTables
      Set Deleted On
      Go Top
      Scan
        lcSqlTable=Alltrim(SQLTables.Table)
        lcTrn_no=Alltrim(SQLTables.Trnnum)
        lcTrn_Typ=Alltrim(SQLTables.Trntyp)

        lcQuery=''
        If !Used('sycedipd') And File(Allt(lcSysfiles)+'\sycedipd.dbf')
          Use Allt(lcSysfiles)+'\sycedipd.dbf' Shar In 0
          Select sycedipd

          If lcTrn_Typ=='R'
            Select Dist cmapset,cversion From sycedipd Where ctrantype=lcTrn_Typ Into Cursor temp
          Endif

          If lcTrn_Typ=='SV'
            *Select Dist cpartcode,cversion From sycedipd Where ctrantype='R' Into Cursor temp
            Select Dist cmapset,cversion From sycedipd Where ctrantype='R' Into Cursor temp
          Endif

          If lcTrn_Typ=='SG'
            Select Dist cmapset,cversion From sycedipd Where ctrantype='R' Into Cursor temp
          Endif

          If lcTrn_Typ=='S'
            Select Dist cmapset,cversion From sycedipd Where ceditrntyp=lcTrn_no And ctrantype=lcTrn_Typ Into Cursor temp
          Endif

          If lcTrn_Typ=='XP'
            lcQuery="ccustomer='" +lcClient+"'"
          Endif




          If lcTrn_Typ=='ASNHD' Or lcTrn_Typ=='ASNDT'
            If !Used('sycasnhd') And File(Allt(lcSysfiles)+'\sycasnhd.dbf')
              Use Allt(lcSysfiles)+'\sycasnhd.dbf' Shar In 0
            Endif
            Select Dist cver From sycasnhd Into Cursor temp
          ENDIF

           If lcTrn_Typ=='UPCHD' Or lcTrn_Typ=='UPCDT'
            If !Used('SYCUPCHD') And File(Allt(lcSysfiles)+'\sycUPCDT.dbf')
              Use Allt(lcSysfiles)+'\SYCUPCHD.dbf' Shar In 0
            Endif
            Select Dist cver From SYCUPCHD Into Cursor temp
          Endif


          If Used ('temp') And !Eof('temp')
            Select temp
            Go Top
            Scan

              If lcTrn_Typ=='ASNHD' Or lcTrn_Typ=='ASNDT'
                If !Empty(temp.cver)
                  lcQuery= lcQuery+ " cver='"+ temp.cver + "' OR"
                Endif

              ELSE

            	  IF lcTrn_Typ=='UPCHD' Or lcTrn_Typ=='UPCDT'
            		  If !Empty(temp.cver)
                 	  lcQuery= lcQuery+ " cver='"+ temp.cver + "' OR"
                 	  ENDIF

                  ELSE
                		If !Empty(temp.cmapset) And !Empty(temp.cversion)
	                    lcQuery= lcQuery + "When Cmapset='"+ temp.cmapset+"' "+ "Then '" +temp.cversion+"' "
	                    ENDIF
                  Endif
              ENDIF
              *ENDIF
            ENDSCAN

            If lcTrn_Typ=='ASNHD' Or lcTrn_Typ=='ASNDT' OR lcTrn_Typ=='UPCHD' Or lcTrn_Typ=='UPCDT'
              lcQuery=Substr(lcQuery ,1,Len(lcQuery)-2)
            Endif
          Endif
        Endif
        If Used('temp')
          Use In temp
        Endif
        If Used('sycedipd')
          Use In sycedipd
        ENDIF

        If Used('sycasnhd')
          Use In sycasnhd
        ENDIF

        If Used('SYCUPCHD')
          Use In SYCUPCHD
        Endif
        If Empty(lcQuery)
          Loop
        Endif
        If (!Used(Allt(lcSqlTable))) And (File(Allt(lcSysfiles)+'\'+Allt(lcSqlTable)+'.dbf'))
          Use Allt(lcSysfiles)+'\'+Allt(lcSqlTable)+'.dbf' Shar In 0

          Select 0
          Select * From &lcSqlTable Into Cursor ClientFile Readwrite
          Use In Allt(lcSqlTable)



          Wait Wind 'Comparing Client: '+lcClient+'---Table: '+lcSqlTable Nowait
          *!*	          lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim('EDIMAPPINGS')+;
          *!*	            ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
          *!*	          If lnConnHandler>0
          *!*	          If lcTrn_Typ='SV'
          *!*	              llret=SQLExec(lnConnHandler , 'SELECT * FROM SYCEDIPD Where cversion =  CASE ' +lcQuery+' END', 'TempPd')
          *!*	              SQLDisconnect(lnConnHandler)
          *!*	              lcQuery=''
          *!*	              Select TempPd
          *!*	              Scan
          *!*	                lcQuery= lcQuery + "When Cpartcode='"+ TempPd.cpartcode+"' "+ "Then '" +TempPd.cversion+"' "
          *!*	              Endscan
          *!*	              If Used('TempPd')
          *!*	                Use In TempPd
          *!*	              Endif
          *!*	            Endif
          *!*	            lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim('EDIMAPPINGS')+;
          *!*	            ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
          *!*	            llret=SQLExec(lnConnHandler , 'SELECT * FROM '+lcSqlTable +' Where cversion =  CASE ' +lcQuery+' END', 'AriaSqlTable')
          *!*	            SQLDisconnect(lnConnHandler)
          lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim('EDIMAPPINGS')+;
            ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
          If lcTrn_Typ='SV'
            llret=SQLExec(lnConnHandler , 'SELECT * FROM SYCEDIPD Where cversion =  CASE ' +lcQuery+' END', 'TempPd')
            SQLDisconnect(lnConnHandler)
            lcQuery=''
            Select TempPd
            Scan
              lcQuery= lcQuery + "When Cpartcode='"+ TempPd.cpartcode+"' "+ "Then '" +TempPd.cversion+"' "
            Endscan
            If Used('TempPd')
              Use In TempPd
            Endif
          Endif


          lnConnHandler = Sqlstringconnect( "Driver={SQL Server};server="+Alltrim(lcServer)+";DATABASE="+Alltrim('EDIMAPPINGS')+;
            ";uid="+Alltrim(lcUsrNam)+";pwd="+Alltrim(lcPasword))
          If lnConnHandler>0
            If lcTrn_Typ=='ASNHD' Or lcTrn_Typ=='ASNDT' Or lcTrn_Typ=='XP' OR lcTrn_Typ=='UPCHD' Or lcTrn_Typ=='UPCDT'
              llret=SQLExec(lnConnHandler , 'SELECT * FROM '+lcSqlTable +' Where '+lcQuery, 'AriaSqlTable')
            Else
              llret=SQLExec(lnConnHandler , 'SELECT * FROM '+lcSqlTable +' Where cversion =  CASE ' +lcQuery+' END', 'AriaSqlTable')
            Endif

            SQLDisconnect(lnConnHandler)
            If llret=-1
              Messagebox('Error, Table:' +lcSqlTable +' Client:'+lcClient )
            Endif

            lcValue = ""
            lnOccur = 0
            lcCompDesRecNos  = ""

            ***Set Index of Send & XP
            If lcTrn_Typ=='S' Or lcTrn_Typ='XP'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of Recevie
            If lcTrn_Typ=='R'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif



            ***Set Index of SG
            If lcTrn_Typ=='SG'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cmapset+cversion+SegId Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif


            ***Set Index of SV
            If lcTrn_Typ=='SV'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cpartcode+cversion+ceditrntyp+SegId+Level  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cpartcode+cversion+ceditrntyp+SegId+Level  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of ASNHD
            If lcTrn_Typ=='ASNHD' OR  lcTrn_Typ=='UPCHD'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                Index On cver Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                Index On cver Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            ***Set Index of ASNDT
            If lcTrn_Typ=='ASNDT' OR lcTrn_Typ=='UPCDT'
              Select ClientFile
              Try
                Set Order To Network1
              Catch To oErr
                *Index On cver+Alltrim(zone)+Str(F_order,2)  Tag Network1
                Index On cver  Tag Network1
                Set Order To Network1
              Finally
              Endtry

              Select AriaSqlTable
              Try
                Set Order To Network1
              Catch To oErr
                *Index On cver+Alltrim(zone)+Str(F_order,2) Tag Network1
				Index On cver  Tag Network1
                Set Order To Network1
              Finally
              Endtry
            Endif

            Select AriaSqlTable
            Go Top
            lcSourceKeyVal = ""
            Scan

              **Handle Send & XP[Start]
              If lcTrn_Typ=='S' Or lcTrn_Typ='XP'
                * Hes
                Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cmapset+cversion+loop_id+Str(F_order,2)+F_name=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion+loop_id+Str(F_order,2)+F_name +F_value  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  *!*	                  lnTempOccur = 0
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(F_value) = Alltrim(AriaSourceTemp.F_value)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(AriaSourceTemp.F_cond) == Alltrim(F_cond) And Alltrim(AriaSourceTemp.cusage)==Alltrim(cusage))
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.cusage,ClientFile.cusage,'Change')
                        Endif
                      Endscan
                    Endif
                    **Handle Send & XP[End]
                    ** Old Code End
                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.cusage,ClientFile.cusage,'Expression Change')
                      Else
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                      Endif
                    Else
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle Send & XP[End]

              **Handle receive[Start]
              If lcTrn_Typ=='R'
                * Hes
                *Lckey='cmapset+cversion+loop_id+STR(f_order,2)+F_name'
                Lckey='cmapset+cversion+segid+STR(f_order,2)'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp ')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cmapset+cversion+SegId+Str(F_order,2)=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp

                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion+SegId+Str(F_order,2)+F_name+F_cond  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    *!*	                    If cmapset='ACE' And clients.CCLIENTID='BBC10' And SegId='PO1'
                    *!*	                      Messagebox('ss')
                    *!*	                    Endif
                    Lckey='cmapset+cversion+segid+STR(f_order,2)'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')

                      Scan Rest While &Lckey= LckeyValu For Iif((At(Alltrim(Upper(F_name)),lcfnames)>0),Alltrim(F_name) = Alltrim(AriaSourceTemp.F_name) And Alltrim(F_cond)=Alltrim(AriaSourceTemp.F_cond),Alltrim(F_name) = Alltrim(AriaSourceTemp.F_name))
                        *Scan Rest While &Lckey= LckeyValu For Iif(SEEK(UPPER(f_name),'fnametable','key'),F_name = AriaSourceTemp.F_name And F_cond=AriaSourceTemp.F_cond,F_name = AriaSourceTemp.F_name)
                        *Select ClientFile
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        If !(Alltrim(AriaSourceTemp.F_cond) == Alltrim(F_cond) And Alltrim(AriaSourceTemp.F_value)==Alltrim(F_value) And Alltrim(AriaSourceTemp.f_type)==Alltrim(f_type))
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,'',AriaSourceTemp.SegId,Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.f_type,ClientFile.f_type,'Change')
                        Endif

                      Endscan
                    Endif
                  Endscan

                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion+segid+STR(f_order,2)'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,'',AriaSourceTemp.SegId,Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.f_type,AriaSourceTemp.f_type,'Variable Change')
                      Else
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,'',AriaSourceTemp.SegId,Str(AriaSourceTemp.F_order),'','','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'','','Missing from Client')
                      Endif
                    Else
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,'',AriaSourceTemp.SegId,Str(AriaSourceTemp.F_order),'','','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'','','Missing from Client')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
              Endif
              **Handle receive[End]


              **Handle SG[Start]
              If lcTrn_Typ=='SG'
                Lckey='cmapset+cversion'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp ')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cmapset+cversion=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp

                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cmapset+cversion Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    Lckey='cmapset+cversion'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')

                      Scan Rest While &Lckey= LckeyValu For Alltrim(SegId) = Alltrim(AriaSourceTemp.SegId) And Alltrim(loop_id)= Alltrim(AriaSourceTemp.loop_id)

                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'
                      Endscan
                    Endif
                  Endscan

                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cmapset+cversion'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'',AriaSourceTemp.loop_id+'-'+ClientFile.loop_id,AriaSourceTemp.SegId,'','','','','','','','','','Loop Change')
                      Else
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'',AriaSourceTemp.loop_id,AriaSourceTemp.SegId,'','','','','','','','','','Missing from Client')
                      Endif
                    Else
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'',AriaSourceTemp.loop_id,AriaSourceTemp.SegId,'','','','','','','','','','Missing from Client')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan
                Endif
              Endif
              **Handle SG [End]

              **Handle SV[Start]
              If lcTrn_Typ=='SV'
                * Hes
                Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cpartcode+cversion+ceditrntyp+SegId+Level=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cpartcode+cversion+ceditrntyp+SegId+Level  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())

                    If cpartcode='KMRTSR' And SegId='N1'
                      Messagebox('sdsd')
                    Endif


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(key_exp) = Alltrim(AriaSourceTemp.key_exp) And Alltrim(ccond)=Alltrim(AriaSourceTemp.ccond)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'
                      Endscan
                    Endif
                    ** Old Code End
                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cpartcode+cversion+ceditrntyp+segid+level'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cpartcode,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'','',AriaSourceTemp.SegId,'',AriaSqlTable.key_exp,ClientFile.key_exp,'','',AriaSqlTable.ccond,ClientFile.ccond,'','','Expression Change')
                      Else
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cpartcode,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'','',AriaSourceTemp.SegId,'',AriaSourceTemp.key_exp,'','','',AriaSourceTemp.ccond,'','','','Missing from Client')
                      Endif
                    Else
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cpartcode,lcTrn_Typ,AriaSourceTemp.cversion,lcClient,'','',AriaSourceTemp.SegId,'',AriaSourceTemp.key_exp,'','','',AriaSourceTemp.ccond,'','','','Missing from Client')
                    Endif
                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle SV[End]



              **Handle ASNHD[Start]
              If lcTrn_Typ=='ASNHD'
                * Hes
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cver=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  *!*	                  lnTempOccur = 0
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(crep_name) = Alltrim(AriaSourceTemp.crep_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        *                        If !(Alltrim(ClientSourceTemp.desc1) == Alltrim(desc1) And Alltrim(ClientSourceTemp.ctype)==Alltrim(ctype) And ClientSourceTemp.ldetlabel==ldetlabel)

                        If !(Alltrim(AriaSourceTemp.desc1) == Alltrim(desc1) And Alltrim(AriaSourceTemp.ctype)==Alltrim(ctype) And AriaSourceTemp.ldetlabel==ldetlabel)
                          * Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,iif(AriaSqlTable.ldetlabel,"TRUE","FALSE"),iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"))**,AriaSourceTemp.crep_name,Clientfile.crep_name
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,Clientfile.ctype,AriaSourceTemp.desc1,Clientfile.desc1,iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),iif(Clientfile.ldetlabel,"TRUE","FALSE"))
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,Clientfile.ctype,AriaSourceTemp.desc1,Clientfile.desc1,iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),iif(Clientfile.ldetlabel,"TRUE","FALSE"),AriaSourceTemp.crep_name,Clientfile.crep_name)
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,ClientFile.ctype,AriaSourceTemp.desc1,ClientFile.desc1,Iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),Iif(ClientFile.ldetlabel,"TRUE","FALSE"),AriaSourceTemp.crep_name,ClientFile.crep_name)
                        Endif
                      Endscan
                    Endif

                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.cusage,ClientFile.cusage,'Expression Change')
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Crep_Name Change',AriaSourceTemp.ctype,ClientFile.ctype,AriaSourceTemp.desc1,ClientFile.desc1,Iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),Iif(ClientFile.ldetlabel,"TRUE","FALSE"),AriaSourceTemp.crep_name,ClientFile.crep_name)
                      Else
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing From Client',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',Iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                      Endif
                    Else
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',Iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle ASNHD[End]


              **Handle ASNDT[Start]
              If lcTrn_Typ=='ASNDT'
                * Hes
                *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  *Select * From AriaSqlTable Where cver+Alltrim(zone)+Str(F_order,2)=LckeyValu Into Cursor AriaSourceTemp Readwrite
				  Select * From AriaSqlTable Where cver=LckeyValu Into Cursor AriaSourceTemp Readwrite
                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  *!*	                  lnTempOccur = 0
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(f_name) = Alltrim(AriaSourceTemp.f_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'


                        If !(Alltrim(AriaSourceTemp.f_value) == Alltrim(f_value) AND Alltrim(str(AriaSourceTemp.f_order,2)) == Alltrim(STR(f_order,2)) AND Alltrim(AriaSourceTemp.zone) == Alltrim(zone) And Str(AriaSourceTemp.Nwidth)==Str(Nwidth) And Str(AriaSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(AriaSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(AriaSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(AriaSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(AriaSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(AriaSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(AriaSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(AriaSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(AriaSourceTemp.nTopMargn)==Str(nTopMargn) And Str(AriaSourceTemp.NWID2NRW)==Str(NWID2NRW))
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',STR(AriaSourceTemp.nwidth),STR(ClientFile.nwidth),'Change')
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,Alltrim(AriaSourceTemp.zone)+'-'+Alltrim(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',Str(AriaSourceTemp.Nwidth),Str(ClientFile.Nwidth),'Change','','','','','','','','',Str(AriaSourceTemp.nwidth),Str(ClientFile.nwidth),Str(AriaSourceTemp.NXDIMLBL),Str(ClientFile.NXDIMLBL),Str(AriaSourceTemp.NSYMBOLOGY),Str(ClientFile.NSYMBOLOGY),Str(AriaSourceTemp.NSHOWTEXT),Str(ClientFile.NSHOWTEXT),Str(AriaSourceTemp.NBARHEIGHT),Str(ClientFile.NBARHEIGHT),Str(AriaSourceTemp.NLBLHEIGHT),Str(ClientFile.NLBLHEIGHT),Str(AriaSourceTemp.NLBLWIDTH),Str(ClientFile.NLBLWIDTH),Str(AriaSourceTemp.NLEFTMARGN),Str(ClientFile.NLEFTMARGN),Str(AriaSourceTemp.nTopMargn),Str(ClientFile.nTopMargn),Str(AriaSourceTemp.NWID2NRW),Str(ClientFile.NWID2NRW))
                        Endif
                      Endscan
                    Endif

                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,ALLTRIM(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',STR(AriaSourceTemp.nwidth),STR(ClientFile.nwidth),'F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',STR(AriaSourceTemp.nwidth),STR(ClientFile.nwidth),;
						'F_name Change','','','','','','','','',Str(AriaSourceTemp.nwidth),Str(ClientFile.nwidth),STR(AriaSourceTemp.NXDIMLBL),STR(ClientFile.NXDIMLBL),STR(AriaSourceTemp.NSYMBOLOGY),STR(ClientFile.NSYMBOLOGY),STR(AriaSourceTemp.NSHOWTEXT),STR(ClientFile.NSHOWTEXT),STR(AriaSourceTemp.NBARHEIGHT),STR(ClientFile.NBARHEIGHT),STR(AriaSourceTemp.NLBLHEIGHT),STR(ClientFile.NLBLHEIGHT),STR(AriaSourceTemp.NLBLWIDTH),STR(ClientFile.NLBLWIDTH),STR(AriaSourceTemp.NLEFTMARGN),STR(ClientFile.NLEFTMARGN),STR(AriaSourceTemp.nTopMargn),STR(ClientFile.nTopMargn),STR(AriaSourceTemp.NWID2NRW),STR(ClientFile.NWID2NRW))
                      Else
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,AriaSourceTemp.zone,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'','F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'' ,;
						'Missing from Client','','','','','','','','',Str(AriaSourceTemp.nwidth),'',STR(AriaSourceTemp.NXDIMLBL),'',STR(AriaSourceTemp.NSYMBOLOGY),'',STR(AriaSourceTemp.NSHOWTEXT),'',STR(AriaSourceTemp.NBARHEIGHT),'',STR(AriaSourceTemp.NLBLHEIGHT),'',STR(AriaSourceTemp.NLBLWIDTH),'',STR(AriaSourceTemp.NLEFTMARGN),'',STR(AriaSourceTemp.nTopMargn),'',STR(AriaSourceTemp.NWID2NRW),'')
                      Endif
                    Else
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,AriaSourceTemp.zone,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'','F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'' ,;
						'Missing from Client','','','','','','','','',Str(AriaSourceTemp.nwidth),'',STR(AriaSourceTemp.NXDIMLBL),'',STR(AriaSourceTemp.NSYMBOLOGY),'',STR(AriaSourceTemp.NSHOWTEXT),'',STR(AriaSourceTemp.NBARHEIGHT),'',STR(AriaSourceTemp.NLBLHEIGHT),'',STR(AriaSourceTemp.NLBLWIDTH),'',STR(AriaSourceTemp.NLEFTMARGN),'',STR(AriaSourceTemp.nTopMargn),'',STR(AriaSourceTemp.NWID2NRW),'')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle ASNDT[END]



              **Handle UPCHD[Start]
              If lcTrn_Typ=='UPCHD'
                * Hes
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  Select * From AriaSqlTable Where cver=LckeyValu Into Cursor AriaSourceTemp Readwrite

                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver  Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  *!*	                  lnTempOccur = 0
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(crep_name) = Alltrim(AriaSourceTemp.crep_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'

                        *                        If !(Alltrim(ClientSourceTemp.desc1) == Alltrim(desc1) And Alltrim(ClientSourceTemp.ctype)==Alltrim(ctype) And ClientSourceTemp.ldetlabel==ldetlabel)

                        If !(Alltrim(AriaSourceTemp.F_value) == Alltrim(F_value) and Alltrim(AriaSourceTemp.desc1) == Alltrim(desc1) And Alltrim(AriaSourceTemp.ctype)==Alltrim(ctype) And STR(AriaSourceTemp.NWIDTH)==STR(NWIDTH))
                          * Insert Into lcComRes1(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det) Values (ClientSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSqlTable.ctype,ClientSourceTemp.ctype,AriaSqlTable.desc1,ClientSourceTemp.desc1,iif(AriaSqlTable.ldetlabel,"TRUE","FALSE"),iif(ClientSourceTemp.ldetlabel,"TRUE","FALSE"))**,AriaSourceTemp.crep_name,Clientfile.crep_name
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,Clientfile.ctype,AriaSourceTemp.desc1,Clientfile.desc1,iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),iif(Clientfile.ldetlabel,"TRUE","FALSE"))
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,Clientfile.ctype,AriaSourceTemp.desc1,Clientfile.desc1,iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),iif(Clientfile.ldetlabel,"TRUE","FALSE"),AriaSourceTemp.crep_name,Clientfile.crep_name)
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Change',AriaSourceTemp.ctype,ClientFile.ctype,AriaSourceTemp.desc1,ClientFile.desc1,AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.crep_name,ClientFile.crep_name)
                        Endif
                      Endscan
                    Endif

                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.F_cond,ClientFile.F_cond,AriaSourceTemp.cusage,ClientFile.cusage,'Expression Change')
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Crep_Name Change',AriaSourceTemp.ctype,ClientFile.ctype,AriaSourceTemp.desc1,ClientFile.desc1,AriaSourceTemp.F_value,ClientFile.F_value,AriaSourceTemp.crep_name,ClientFile.crep_name)
                      Else
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing From Client',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                        Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',AriaSourceTemp.F_value,'',AriaSourceTemp.crep_name,'')
                      Endif
                    Else
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cmapset,Iif(lcTrn_Typ='XP',lcTrn_Typ,lcTrn_no),AriaSourceTemp.cversion,lcClient,AriaSourceTemp.F_name,AriaSourceTemp.loop_id,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'',AriaSourceTemp.F_cond,'',AriaSourceTemp.cusage,'','Missing from Client')
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',iif(AriaSourceTemp.ldetlabel,"TRUE","FALSE"),'',AriaSourceTemp.crep_name,'')
                      Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,'','','','','','','','','','','','','Missing from Clinet',AriaSourceTemp.ctype,'',AriaSourceTemp.desc1,'',AriaSourceTemp.F_value,'',AriaSourceTemp.crep_name,'')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle UPCHD[End]


              **Handle UPCDT[Start]
              If lcTrn_Typ=='UPCDT'
                * Hes
                *Lckey='cver+ALLTRIM(zone)+Str(F_order,2)'
                Lckey='cver'
                LckeyValu=&Lckey

                If !(lcValue == LckeyValu)
                  lcCompDesRecNos  = ""
                Endif
                lcValue =LckeyValu

                If !(LckeyValu == lcSourceKeyVal)
                  If Used('AriaSourceTemp')
                    Select AriaSourceTemp
                    Set Safety Off
                    Zap
                    Set Safety On
                  Endif
                  lcSourceKeyVal=LckeyValu
                  *Select * From AriaSqlTable Where cver+Alltrim(zone)+Str(F_order,2)=LckeyValu Into Cursor AriaSourceTemp Readwrite
				  Select * From AriaSqlTable Where cver=LckeyValu Into Cursor AriaSourceTemp Readwrite
                  Select AriaSourceTemp
                  Try
                    Set Order To Network1
                  Catch To oErr
                    Index On cver Tag Network1
                    Set Order To Network1
                  Finally
                  Endtry
                  *!*	                  lnTempOccur = 0
                  lcOccurSourceRecID = ""
                  lcOccurSourceRecIDs = ""
                  Go Top
                  Scan
                    ** Old Code Start
                    Lckey='cver'
                    LckeyValu=&Lckey
                    lcOccurSourceRecID = Str(Recno())


                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      Scan Rest While &Lckey= LckeyValu For Alltrim(f_name) = Alltrim(AriaSourceTemp.f_name)
                        lnOccurDesRecNo = Recno()
                        lcCompDesRecNos='('+lcCompDesRecNos+')('+Str(lnOccurDesRecNo)+')'
                        lcOccurSourceRecIDs = Iif(Empty(lcOccurSourceRecIDs),'(',+lcOccurSourceRecIDs +'(')+ lcOccurSourceRecID +')'


                        If !(Alltrim(AriaSourceTemp.f_value) == Alltrim(f_value) AND Alltrim(str(AriaSourceTemp.f_order,2)) == Alltrim(STR(f_order,2)) AND Alltrim(AriaSourceTemp.zone) == Alltrim(zone) And Str(AriaSourceTemp.NXDIMLBL)==Str(NXDIMLBL) And Str(AriaSourceTemp.NSYMBOLOGY)==Str(NSYMBOLOGY) And Str(AriaSourceTemp.NSHOWTEXT)==Str(NSHOWTEXT) And Str(AriaSourceTemp.NBARHEIGHT)==Str(NBARHEIGHT) And Str(AriaSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(AriaSourceTemp.NLBLHEIGHT)==Str(NLBLHEIGHT) And Str(AriaSourceTemp.NLBLWIDTH)==Str(NLBLWIDTH) And Str(AriaSourceTemp.NLEFTMARGN)==Str(NLEFTMARGN) And Str(AriaSourceTemp.nTopMargn)==Str(nTopMargn))
                          *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',STR(AriaSourceTemp.nwidth),STR(ClientFile.nwidth),'Change')
                          Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2)Values(AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,Alltrim(AriaSourceTemp.zone)+'-'+Alltrim(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','','','','Change','','','','','','','','','','',Str(AriaSourceTemp.NXDIMLBL),Str(ClientFile.NXDIMLBL),Str(AriaSourceTemp.NSYMBOLOGY),Str(ClientFile.NSYMBOLOGY),Str(AriaSourceTemp.NSHOWTEXT),Str(ClientFile.NSHOWTEXT),Str(AriaSourceTemp.NBARHEIGHT),Str(ClientFile.NBARHEIGHT),Str(AriaSourceTemp.NLBLHEIGHT),Str(ClientFile.NLBLHEIGHT),Str(AriaSourceTemp.NLBLWIDTH),Str(ClientFile.NLBLWIDTH),Str(AriaSourceTemp.NLEFTMARGN),Str(ClientFile.NLEFTMARGN),Str(AriaSourceTemp.nTopMargn),Str(ClientFile.nTopMargn),'','')
                        Endif
                      Endscan
                    Endif

                  Endscan

                  * Code 3
                  Select AriaSourceTemp
                  lnTempCounter = 0
                  Scan For At('('+Str(Recno())+')',lcOccurSourceRecIDs)==0
                    Lckey='cver'
                    LckeyValu=&Lckey

                    Select ClientFile

                    Go Top
                    If Seek(LckeyValu,'ClientFile','NETWORK1')
                      lnClientRecNo = Recno()
                      llExist = .F.
                      Skip lnTempCounter
                      If &Lckey= LckeyValu And At('('+Str(Recno())+')',lcCompDesRecNos)==0
                        lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                        llExist = .T.
                      Else
                        Goto lnClientRecNo
                        Scan Rest While &Lckey= LckeyValu For At('('+Str(Recno())+')',lcCompDesRecNos)==0
                          lcCompDesRecNos= '('+lcCompDesRecNos+')('+Str(Recno())+')'
                          llExist = .T.
                          Exit
                        Endscan
                      Endif
                      * Test

                      If llExist
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,ALLTRIM(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','',STR(AriaSourceTemp.nwidth),STR(ClientFile.nwidth),'F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone)+'-'+ALLTRIM(ClientFile.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,ClientFile.F_value,'','','','',;
						'F_name Change','','','','','','','','',Str(AriaSourceTemp.nwidth),Str(ClientFile.nwidth),STR(AriaSourceTemp.NXDIMLBL),STR(ClientFile.NXDIMLBL),STR(AriaSourceTemp.NSYMBOLOGY),STR(ClientFile.NSYMBOLOGY),STR(AriaSourceTemp.NSHOWTEXT),STR(ClientFile.NSHOWTEXT),STR(AriaSourceTemp.NBARHEIGHT),STR(ClientFile.NBARHEIGHT),STR(AriaSourceTemp.NLBLHEIGHT),STR(ClientFile.NLBLHEIGHT),STR(AriaSourceTemp.NLBLWIDTH),STR(ClientFile.NLBLWIDTH),STR(AriaSourceTemp.NLEFTMARGN),STR(ClientFile.NLEFTMARGN),STR(AriaSourceTemp.nTopMargn),STR(ClientFile.nTopMargn),'','')
                      Else
                        *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,AriaSourceTemp.zone,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'','F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','','','' ,;
						'Missing from Client','','','','','','','','','','',STR(AriaSourceTemp.NXDIMLBL),'',STR(AriaSourceTemp.NSYMBOLOGY),'',STR(AriaSourceTemp.NSHOWTEXT),'',STR(AriaSourceTemp.NBARHEIGHT),'',STR(AriaSourceTemp.NLBLHEIGHT),'',STR(AriaSourceTemp.NLBLWIDTH),'',STR(AriaSourceTemp.NLEFTMARGN),'',STR(AriaSourceTemp.nTopMargn),'','','')
                      Endif
                    Else
                      *Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,AriaSourceTemp.zone,'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','',STR(AriaSourceTemp.nwidth),'','F_name Change')
						Insert Into lcComRes(Mapset, Tran_no, cversion, Client_ID, F_name, LoopId,SegId , F_order, Aria_Exp, Client_Exp,Aria_Val ,Client_Val, Aria_Cond, Client_Con, Aria_Usg, Client_Usg, ctype,Aria_typ,Client_typ ,Aria_des,Client_des,Aria_det,Client_det,AriaCrep,ClientCrep,Aria_nwid ,Clien_nwid ,Aria_NXD ,Clien_NXD ,Aria_SMB ,Clien_SMB ,Aria_NST ,Clien_NST ,Aria_NBH ,Clien_NBH ,Aria_NLH ,Clien_NLH ,Aria_NLW ,Clien_NLW ,Aria_NLM ,Clien_NLM ,Aria_NTM ,Clien_NTM ,Aria_NW2 ,Clien_NW2) Values (AriaSourceTemp.cver,lcTrn_Typ,'',lcClient,AriaSourceTemp.F_name,alltrim(AriaSourceTemp.zone),'',Str(AriaSourceTemp.F_order),'','',AriaSourceTemp.F_value,'','','','','' ,;
						'Missing from Client','','','','','','','','','','',STR(AriaSourceTemp.NXDIMLBL),'',STR(AriaSourceTemp.NSYMBOLOGY),'',STR(AriaSourceTemp.NSHOWTEXT),'',STR(AriaSourceTemp.NBARHEIGHT),'',STR(AriaSourceTemp.NLBLHEIGHT),'',STR(AriaSourceTemp.NLBLWIDTH),'',STR(AriaSourceTemp.NLEFTMARGN),'',STR(AriaSourceTemp.nTopMargn),'','','')
                    Endif

                    lnTempCounter = lnTempCounter + 1
                  Endscan

                Endif
                * HES
              Endif
              **Handle UPCDT[END]


            Endscan
          Else
            Messagebox("could not connect to EDIMAPPINGS")
          Endif
        Endif
        If Used(Allt(lcSqlTable))
          Use In Allt(lcSqlTable)
        Endif
      Endscan
    Endscan
    Select lcComRes
    Export To C:\Users\aria.ARIA\Desktop\Compare\AriaVsClients.Xls Type Xls

    Messagebox('Completed')
  Else
    Messagebox("could not get clients from client table")
  Endif
Else
  Messagebox("could not connect to system.master")
Endif
