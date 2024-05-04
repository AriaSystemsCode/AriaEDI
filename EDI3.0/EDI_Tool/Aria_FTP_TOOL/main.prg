PARAMETERS lcR_S_ALL
_screen.WindowState = 1 
IF TYPE('lcR_S_ALL')<> 'C'
lcR_S_ALL = 'ALL'
ENDIF 
LOCAL lcPath
lcPath = FULLPATH('')
lcPath = ADDBS(lcPath)
SET CLASSLIB TO MAIN
*CD ..
*debug
*susp

ln=ADIR(arr15,'FTP_*.XML')

LOCAL I 
IF LN > 0 THEN 
  FOR I = 1 TO ALEN(ARR15,1)
   oObj = CREATEOBJECT('MAIN')  
   *oObj.Do(lcPath+ARR(I,1),lcR_S_ALL)
   oObj.Do(ARR15(I,1),lcR_S_ALL)   
   RELEASE oObj
  ENDFOR
ENDIF        


