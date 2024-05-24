LOCAL lcRequestServer
lcRequestServer = ALLTRIM(SUBSTR(SYS(0), 1, AT('#', SYS(0))-1))
loActivator = CREATEOBJECT("Aria.Utilities.RemoteCall.AriaActivator")
loA5ariaEnvironment = loActivator.GetRemoteObject("Aria.Environment.AriaEnviromentVariables" , lcRequestServer, 1500)
lcclients = 'Clients'
lcOutclients = 'Out_Clients'
=SQLSETPROP(0,"DispLogin",3)
lcsysflconnect = loA5ariaEnvironment.aria50SystemFilesConnectionStringOdbc
lnconnecthandle = SQLSTRINGCONNECT(lcsysflconnect)
IF lnconnecthandle <= 0
  MESSAGEBOX("Connection Level Error",16+512,'Connection Error!')
  RETURN .F.
ELSE
  y = SQLEXEC(lnconnecthandle,'Select * From Clients',lcclients)
   IF y > 0
    SELECT(lcclients)
    LOCATE
    IF EOF()
      MESSAGEBOX("Clients Table is empty",16+512,'Empty Table!')
      RETURN .F.
    ENDIF
    
    SELECT (lcclients)
    SCAN 
      lcClient = ADDBS(ALLTRIM(cClientName))
      lcAria27Sys = ADDBS(ALLTRIM(Aria27Sys))
      lcAbsDataPath = ADDBS(ALLTRIM(cDataPath))
      USE ADDBS(Aria27Sys)+"SYCCOMP.DBF" SHARED IN 0 
      SELECT SYCCOMP
      SCAN for !DELETED()
        WAIT WINDOW "Updating Client# "+lcClient + " - Company# "+ ALLTRIM(cComp_id) NOWAIT 
        lcDBFPath = ADDBS(ALLTRIM(cCom_dDir))
        TRY
          USE STRTRAN(lcDBFPath,"X:\",lcAbsDataPath)+"ASN_SHIP.DBF" IN 0 EXCLUSIVE
          SELECT ASN_SHIP
          PACK 
          REINDEX 
        CATCH 
          MESSAGEBOX("Couldn't open file ASN_SHIP exclusive for Client# "+lcClient + " - Company# "+ ALLTRIM(cComp_id),16+512,"Exclusive open failed!")
        ENDTRY 
        IF USED('ASN_SHIP')
          USE IN ASN_SHIP
        ENDIF 
      ENDSCAN 
      IF USED('SYCCOMP')
        USE IN SYCCOMP
      endif
    ENDSCAN 
    MESSAGEBOX("All clients updated sucessfully.",64+512,"Updating completed.")
  ELSE
    MESSAGEBOX("Connection Level Error",16+512,'Connection Error!')
  ENDIF
ENDIF
