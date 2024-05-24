LOCAL lcRequestServer

set safety off 
set talk off 
x=fullpath('')
cd (x)
_screen.visible = .f.
lcRequestServer = ALLTRIM(SUBSTR(SYS(0), 1, AT('#', SYS(0))-1))
*loActivator = CREATEOBJECT("Aria.Utilities.RemoteCall.AriaActivator")
*loA5ariaEnvironment = loActivator.GetRemoteObject("Aria.Environment.AriaEnviromentVariables" , lcRequestServer, 1500)
lcclients = 'Clients'
lcOutclients = 'Out_Clients'
=SQLSETPROP(0,"DispLogin",3)

*lnconnecthandle = SQLSTRINGCONNECT(lcsysflconnect)
EDIMAPPINGCONNECTION= "Driver={SQL Server};server=ariasql\ariasqlserver;DATABASE=system.master;uid=sa;pwd=aria_123"
lnconnecthandle=SQLSTRINGCONNECT(EDIMAPPINGCONNECTION)

IF lnconnecthandle <= 0
  MESSAGEBOX("Connection Level Error",16+512,'Connection Error!')
  RETURN .F.
ELSE

  clientsCount = SQLEXEC(lnconnecthandle,'Select 0 as lSelect,* From Clients Order by CClientID',lcclients)
  *z = SQLEXEC(lnconnecthandle,'Select 0 as lSelect,* From Clients where CClientID IN (Select Client_ID From CLIENT_OUTSOURCING_PRICE_LIST_T) Order by CClientID ',lcclients) 
   IF  clientsCount > 0
    SELECT(lcclients)
    LOCATE
    IF EOF()
      MESSAGEBOX("Clients Table is empty",16+512,'Empty Table!')
      RETURN .F.
    ENDIF
    x=fullpath('')
    set defa to (x)

    DO FORM "clients.SCX" WITH lcclients,lnconnecthandle,STRTRAN(x,"CLIENTS_PARTNERS.FXP","") 
    read events 
  ELSE
    MESSAGEBOX("Connection Level Error",16+512,'Connection Error!')
  ENDIF
ENDIF
