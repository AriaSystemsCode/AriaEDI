   �   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              �DRIVER=winspool
DEVICE=Microsoft Print to PDF (redirected 99)
OUTPUT=TS002
ORIENTATION=0
PAPERSIZE=259
COPIES=1
DEFAULTSOURCE=256
PRINTQUALITY=300
COLOR=1
YRESOLUTION=300
         Q  :  winspool  Microsoft Print to PDF (redirected 99)  TS002                                                              �Microsoft Print to PDF (redire  � @/   �
od   ,  ,  Letter                                                        ����GIS4            DINU" � $ ?]{~                                 	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       �   SMTJ     � { 0 8 4 F 0 1 F A - E 6 3 4 - 4 D 7 7 - 8 3 E E - 0 7 4 8 1 7 C 0 3 5 8 1 }   RESDLL UniresDLL PaperSize LETTER Orientation PORTRAIT Resolution ResOption1 ColorMode Color                 V4DM                                                     Courier New                                                   SUBSTR(ALLTRIM(VND_NAME),1,20)                                Arial                                                         GSUBSTR(ALLTRIM(VND_ADDR1),1,20) + ' ' + SUBSTR(ALLTRIM(VND_ADDR2),1,20)                                                       Arial                                                         KSUBSTR(ALLTRIM(VND_CITY),1,10)+','+ALLTRIM(VND_STATE)+'  '+ALLTRIM(VND_ZIP)                                                   Arial                                                         SUBSTR(ALLTRIM(SHP_NAME),1,26)                                                                                              Arial                                                         ALLT(CUSTPO)                                                  Arial                                                         HSUBSTR(ALLTRIM(SHP_ADDR1),1,26) + ' '  + SUBSTR(ALLTRIM(SHP_ADDR2),1,26)                                                      Arial                                                         MSUBSTR(ALLTRIM(SHP_CITY),1,14)+' , '+ALLTRIM(SHP_STATE) +' '+ALLTRIM(SHP_ZIP)                                                 Arial                                                         1IIF(CSIZEDESC='MIXED','','AC '+ALLTRIM(CSTSTORE))             Arial                                                         ('420 ('+SUBSTR(alltrim(shp_zip),1,5)+')'                                                                                    Times New Roman                                               "(420) SHIP TO POSTAL CODE:"                                  "@J"                                                          Arial                                                         BOL_NO                                                                                                                      Times New Roman                                               ALLT(carrier)                                                 Arial                                                         +'(00) 0 '+MANUF_ID+'  '+UCC9+'  '+UCC_CHECK                   Times New Roman                                               'IIF(CSIZEDESC='MIXED','',ALLTRIM(CSKU))                       Arial                                                         "ITEM:"                                                       Arial                                                         "PRO NUMBER:"                                                 "@I"                                                          Times New Roman                                               SUBSTR(ALLTRIM(Cpro_No),1,10)                                 Times New Roman                                               8IIF(EMPTY(ALLTRIM(Style)),'MIXED PALLET',ALLTRIM(Style))      Courier New                                                   "PART:"                                                       Arial                                                         "B/L NUMBER:"                                                 "@I"                                                          Times New Roman                                               
"CARRIER:"                                                    "@I"                                                          Times New Roman                                               "FROM:"                                                       "@J"                                                          Times New Roman                                               "TO:"                                                         "@J"                                                          Times New Roman                                               "P.O. NUMBER:"                                                "@I"                                                          Arial                                                         
"AUTOZONE"                                                    Arial                                                         %"(00) SERIAL SHIPPING CONTAINER CODE"                         "@J"                                                          Arial                                                         	ucc128fnt                                                                                                                   	ShpZipFnt                                                                                                                   Courier New                                                   Arial                                                         Arial                                                         Arial                                                         Times New Roman                                               Arial                                                         Times New Roman                                               Arial                                                         Courier New                                                   Times New Roman                                               Arial                                                         dataenvironment                                               `Top = 32
Left = 492
Width = 237
Height = 402
DataSource = .NULL.
Name = "Dataenvironment"
                              �PROCEDURE Init
lcx= oAriaApplication.WorkDir+loFrom.Parent.TmpOutH
SET DELETED ON 
USE &lcx SHARED IN 0
SELECT (loFrom.Parent.TmpOutH)

ENDPROC
                                      0���                              �   %   �       �      �           �  U  K  T�  �� � � � � �� G � USE &lcx SHARED IN 0
 F�� � � �� U  LCX OARIAAPPLICATION WORKDIR LOFROM PARENT TMPOUTH Init,     ��1 �a �2                       �       )                                   �DRIVER=winspool
DEVICE=Microsoft Print to PDF (redirected 99)
OUTPUT=TS002
ORIENTATION=0
PAPERSIZE=259
COPIES=1
DEFAULTSOURCE=256
PRINTQUALITY=300
COLOR=1
YRESOLUTION=300
         Q  :  winspool  Microsoft Print to PDF (redirected 99)  TS002                                                              �Microsoft Print to PDF (redire  � @/   �
od   ,  ,  Letter                                                        ����GIS4            DINU" � $ ?]{~                                 	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       �   SMTJ     � { 0 8 4 F 0 1 F A - E 6 3 4 - 4 D 7 7 - 8 3 E E - 0 7 4 8 1 7 C 0 3 5 8 1 }   RESDLL UniresDLL PaperSize LETTER Orientation PORTRAIT Resolution ResOption1 ColorMode Color                 V4DM                                                     Courier New                                                   SUBSTR(ALLTRIM(VND_NAME),1,20)                                Arial                                                         GSUBSTR(ALLTRIM(VND_ADDR1),1,20) + ' ' + SUBSTR(ALLTRIM(VND_ADDR2),1,20)                                                       Arial                                                         KSUBSTR(ALLTRIM(VND_CITY),1,10)+','+ALLTRIM(VND_STATE)+'  '+ALLTRIM(VND_ZIP)                                                   Arial                                                         SUBSTR(ALLTRIM(SHP_NAME),1,26)                                                                                              Arial                                                         ALLT(CUSTPO)                                                  Arial                                                         HSUBSTR(ALLTRIM(SHP_ADDR1),1,26) + ' '  + SUBSTR(ALLTRIM(SHP_ADDR2),1,26)                                                      Arial                                                         MSUBSTR(ALLTRIM(SHP_CITY),1,14)+' , '+ALLTRIM(SHP_STATE) +' '+ALLTRIM(SHP_ZIP)                                                 Arial                                                         1IIF(CSIZEDESC='MIXED','','AC '+ALLTRIM(CSTSTORE))             Arial                                                         ('420 ('+SUBSTR(alltrim(shp_zip),1,5)+')'                                                                                    Times New Roman                                               "(420) SHIP TO POSTAL CODE:"                                  "@J"                                                          Arial                                                         BOL_NO                                                                                                                      Times New Roman                                               ALLT(carrier)                                                 Arial                                                         +'(00) 0 '+MANUF_ID+'  '+UCC9+'  '+UCC_CHECK                   Times New Roman                                               'IIF(CSIZEDESC='MIXED','',ALLTRIM(CSKU))                       Arial                                                         "ITEM:"                                                       Arial                                                         "PRO NUMBER:"                                                 "@I"                                                          Times New Roman                                               SUBSTR(ALLTRIM(Cpro_No),1,10)                                 Times New Roman                                               8IIF(EMPTY(ALLTRIM(Style)),'MIXED PALLET',ALLTRIM(Style))      Courier New                                                   "PART:"                                                       Arial                                                         "B/L NUMBER:"                                                 "@I"                                                          Times New Roman                                               
"CARRIER:"                                                    "@I"                                                          Times New Roman                                               "FROM:"                                                       "@J"                                                          Times New Roman                                               "TO:"                                                         "@J"                                                          Times New Roman                                               "P.O. NUMBER:"                                                "@I"                                                          Arial                                                         
"AUTOZONE"                                                    Arial                                                         %"(00) SERIAL SHIPPING CONTAINER CODE"                         "@J"                                                          Arial                                                         	ucc128fnt                                                                                                                   	ShpZipFnt                                                                                                                   Courier New                                                   Arial                                                         Arial                                                         Arial                                                         Times New Roman                                               Arial                                                         Times New Roman                                               Arial                                                         Courier New                                                   Times New Roman                                               Arial                                                         dataenvironment                                               `Top = 32
Left = 492
Width = 237
Height = 402
DataSource = .NULL.
Name = "Dataenvironment"
                              �PROCEDURE Init
lcx= oAriaApplication.WorkDir+loFrom.Parent.TmpOutH
SET DELETED ON 
USE &lcx SHARED IN 0
SELECT (loFrom.Parent.TmpOutH)

ENDPROC
                                      0���                              �   %   �       �      �           �  U  K  T�  �� � � � � �� G � USE &lcx SHARED IN 0
 F�� � � �� U  LCX OARIAAPPLICATION WORKDIR LOFROM PARENT TMPOUTH Init,     ��1 �a �2                       �       )                             