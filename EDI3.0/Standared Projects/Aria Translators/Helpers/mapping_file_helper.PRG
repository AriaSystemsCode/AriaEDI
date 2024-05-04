*!*	cTest = "Record Type,Parent Code,Code,Name,Language,Email Address,Phone1 Type,Phone1 Code,Phone1 Number,Phone1 Ext.,Phone2 Type,Phone2 Code,"+;
*!*	  "Phone2 Number,Phone2 Ext.,Phone3 Type,Phone3 Code,Phone3 Number,Phone3 Ext.,First Name,Last Name,Title,Trade Name,Account Type,About us,Currency,"+;
*!*	  "Website,Business Classification 1,Business Classification 2,Business Classification 3,Department 1,Department 2,Department 3,Address1 Type,Address1 Code,"+;
*!*	  "Address1 Name,Address1 Line1,Address1 Line2,Address1 City,Address1 State,Address1 Postal Code,Address1 Country,Address2 Type,Address2 Code,Address2 Name,"+;
*!*	  "Address2 Line1,Address2 Line2,Address2 City,Address2 State,Address2 Postal Code,Address2 Country,Address3 Type,Address3 Code,Address3 Name,Address3 Line1,"+;
*!*	  "Address3 Line2,Address3 City,Address3 State,Address3 Postal Code,Address3 Country,Address4 Type,Address4 Code,Address4 Name,Address4 Line1,Address4 Line2,"+;
*!*	  "Address4 City,Address4 State,Address4 Postal Code,Address4 Country,Image1 Type,Image1 File Name,Image2 Type,Image2 File Name,Image3 Type,Image3 File Name,"+;
*!*	  "Image4 Type,Image4 File Name,Image5 Type,Image5 File Name"

*!*	N= Alines(arr, Strtran(cTest,",",Chr(13)))
*!*	tablename="Header"
*!*	Loop="03"

*!*	Set Step On
*!*	String=""
*!*	For i = 1 To N
*!*	  lcvar = Strtran(arr(i)," ","")

*!*	  If Len(lcvar+"03") > 21
*!*	    lcvar = Strtran(arr(i)," ","")
*!*	    lcvar = Strtran(lcvar,"Business","")
*!*	  Endif
*!*	  If Len(lcvar+"03") > 21
*!*	    Wait Window lcvar
*!*	  Endif
*!*	  String=String + "	<Map>"  + Chr(10)

*!*	  String=String + "		<Variable>"  + lcvar+Loop+"</Variable>"+Chr(10)
*!*	  String=String + "		<Table>"  +"</Table>"+Chr(10)
*!*	  String=String + "		<Column>" +"</Column>"+Chr(10)
*!*	  String=String + "		<Loop>"  + Loop+"</Loop>"+Chr(10)
*!*	  String=String + "		<Fixed>"  + arr(i) +"</Fixed>"+Chr(10)
*!*	  String=String + "		<Condition>"  +"" +"</Condition>"+Chr(10)
*!*	  String=String + "		<relatedtypevalue>"  +"" +"</relatedtypevalue>"+Chr(10)
*!*	  String=String + "		<relatedtype>"  + ""+"</relatedtype>"+Chr(10)
*!*	  String=String + "	</Map>"  + Chr(10)

*!*	Endfor

********************************************************************
If Not Used("CUSTOMER")
  Use x:\aria4xp\dbfs\01\CUSTOMER Share In 0
Endif
Loop="03"
tablename="CUSTOMER"
Select CUSTOMER
N=Afields(arr)

String=""
For i = 1 To n

  String=String + "	<Map>"  + Chr(10)

  String=String + "		<Variable>"  + arr(i,1)+"_"+tablename+"_"+Loop+"</Variable>"+Chr(10)
  String=String + "		<Table>"  + tablename+"</Table>"+Chr(10)
  String=String + "		<Column>"  + arr(i,1)+"</Column>"+Chr(10)
  String=String + "		<Loop>"  + Loop+"</Loop>"+Chr(10)
  String=String + "		<Fixed>"  + "" +"</Fixed>"+Chr(10)
  String=String + "		<Condition>"  +"" +"</Condition>"+Chr(10)
  String=String + "		<relatedtypevalue>"  +"" +"</relatedtypevalue>"+Chr(10)
  String=String + "		<relatedtype>"  + ""+"</relatedtype>"+Chr(10)
  String=String + "	</Map>"  + Chr(10)

ENDFOR
*********************************************************************
_Cliptext = String
Wait Window "done"
