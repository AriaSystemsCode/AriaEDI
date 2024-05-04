Lparameters lcSys

Close All
Set Deleted On
***********************************************************************
If Type('lcSys')<>'C'
  lcSys=Getdir("","Select Aria27 System Files Folder")
Endif

If !Isnull(lcSys)

  lcSys  = Upper(Addbs(lcSys))
  *lcAria = Strtran(lcSys,'SYSFILES\','')
  lcAria = lcSys
  lcFile = ADDBS(lcAria)+'fxordrep.txt'
  
  If !File(lcFile )
  
    ln = FCREATE(lcFile,1)
    =FCLOSE(ln)
    
    Cd (lcSys)
    Use (lcSys+'SYCCOMP.DBF') Shared
    Use SYCCOMP
    Scan
      Wait Window 'Process Company: '+SYCCOMP.ccomp_id Nowait

      Use (Addbs(CCOM_DDIR)+'ORDREPLN.DBF') In 0 Shared
      Select ORDREPLN
      Try
        Scan
          Wait Window "Process Company: "+SYCCOMP.ccomp_id +" Order: "+ ORDREPLN.cordrepno Nowait
          If Empty(CACKCODE)
            Replace CACKCODE With reason
          Endif
        Endscan
      Catch
      Endtry
      Use In ORDREPLN
      Select SYCCOMP
    Endscan
  Endif
Endif
