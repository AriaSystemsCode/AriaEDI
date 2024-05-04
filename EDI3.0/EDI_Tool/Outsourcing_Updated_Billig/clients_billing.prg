set step on 

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
  y = SQLEXEC(lnconnecthandle,'Select * From CLIENT_OUTSOURCING_PRICE_LIST_T Order by Client_ID',lcOutclients)
  z = SQLEXEC(lnconnecthandle,'Select 0 as lSelect,* From Clients where CClientID IN (Select Client_ID From CLIENT_OUTSOURCING_PRICE_LIST_T) Order by CClientID ',lcclients) 
   IF z > 0 AND y > 0
    SELECT(lcclients)
    LOCATE
    IF EOF()
      MESSAGEBOX("Clients Table is empty",16+512,'Empty Table!')
      RETURN .F.
    ENDIF
    
    SELECT(lcOutclients)
    LOCATE 
    IF EOF()
      MESSAGEBOX("No Outsourcing Clients Founf!",16+512,'Empty Table!')
      RETURN .F.
    ENDIF   
    
    *DO FORM "clients.SCX" WITH lcclients,lcOutclients,lnconnecthandle,STRTRAN(SYS(16),"CLIENTS_BILLING.EXE","")
    DO FORM "C:\Users\edi.d\Desktop\Omar_Updated_Billig\clients.SCX" WITH lcclients,lcOutclients,lnconnecthandle,STRTRAN(SYS(16),"CLIENTS_BILLING.FXP","")
    read events 
  ELSE
    MESSAGEBOX("Connection Level Error",16+512,'Connection Error!')
  ENDIF
ENDIF
