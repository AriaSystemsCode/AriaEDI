*:***********************************************************************************************************
*: Program file  : fixsqldic
*: Program desc. : Update SQL Mapppings Dictionary
*:                                       SYCDICDC.DBF
*:										 SYCDICEL.DBF
*:										 SYCDICLP.DBF
*:										 SYCDICPR.DBF
*:										 SYCDICQL.DBF
*:										 SYCDICST.DBF
*:        System : Aria Advantage Series.
*:        Module : (EDI).
*:     Developer : Mostafa Hessin (MOH)
*:          Date : 06/05/2008
*:***********************************************************************************************************
LPARAMETERS lcSysDir

***********************************************************************

* HES NEW
SET STEP ON 
llFirstRun = .F.
IF TYPE('lcSysDir') = 'C' AND !EMPTY(lcSysDir)
  llFirstRun = .T.
ENDIF 

llContinue = .F.
llFromMedia = .F.
llSAAS = .F.
sqlsysfilesconnectionstring = ""
lcClientSysDir = ""
TRY
  loEnvObj = CREATEOBJECT('Aria.Environment.AriaEnviromentVariables')
  IF TYPE('loEnvObj') = 'O'
    sqlsysfilesconnectionstring = loEnvObj.aria50SystemFilesConnectionStringOdbc
    =SQLSETPROP(0,"DispLogin",3)
    IF !EMPTY(sqlsysfilesconnectionstring)
      lnConnHandle =SQLSTRINGCONNECT(sqlsysfilesconnectionstring)
      IF lnConnHandle > 0
        lnRemResult = SQLEXEC(lnConnHandle,"Select * from Clients where 1=2","Clients")
        IF lnRemResult>=1
          TRY
            lnRemResult = SQLEXEC(lnConnHandle,"Select top 1 Aria27sys from Clients ","Clients")
            lcClientSysDir = ALLTRIM(Clients.Aria27sys)
            lnRemResult = SQLEXEC(lnConnHandle,"Select COUNT(*) As ClCount from Clients ","Clients")
            IF Clients.ClCount > 1
              llSAAS = .T.
            ELSE 
              IF Clients.ClCount = 1
                llSAAS = .F.
              ENDIF 
            ENDIF
          CATCH
          ENDTRY
          =SQLDISCONNECT(lnConnHandle)
        ENDIF
      ENDIF
    ENDIF
  ENDIF
CATCH
ENDTRY

IF (TYPE('lcSysDir') <> 'C' AND TYPE('lcClientSysDir') = 'C' AND !llSAAS)
  llFromMedia = .T.
ENDIF 
llContinue = llFromMedia OR llFirstRun 

SET STEP ON 

lcSysDir = IIF(llSAAS and TYPE('lcSysDir') = 'C' AND !EMPTY(lcSysDir),UPPER(ADDBS(lcSysDir)),IIF(!EMPTY(lcClientSysDir),UPPER(ADDBS(lcClientSysDir)),""))
IF EMPTY(lcSysDir)
  = MESSAGEBOX("Please select the System Files Directory.",64,'Update SQL Mapppings Dictionary')
  lcSysDir = GETDIR("","Select Aria27 System Files Folder")  
ENDIF 
* HES NEW

*lcAria   = Strtran(lcSysDir,'SYSFILES\','')
lcAria   = lcSysDir
* HES
*!*	lcFile   = ADDBS(lcAria)+'fxedidic.txt'
lcFile   = ADDBS(lcAria)+'EDIDIC_R12.txt'
* HES
lcLineFeed = CHR(10) + CHR(13)

IF !FILE(lcFile) AND llContinue 
  ln = FCREATE(lcFile,1)
  = FCLOSE(ln)

  IF !FILE(lcSysDir+'SYDFILES.DBF')
    =MESSAGEBOX("This is not the System Files Directory. Cannot proceed.",16,'Update SQL Mapppings Dictionary')
    RETURN
  ENDIF

  * Set The default path to program Path
  lcCurrentProcedure= UPPER(SYS(16,1))
  lnPathStart        = AT(":",lcCurrentProcedure)- 1
  lnLenOfPath        = RAT("\", lcCurrentProcedure) - (lnPathStart)
  lcCurPath          = SUBSTR(lcCurrentProcedure, lnPathStart, lnLenOfPath)
  SET DEFAULT TO (lcCurPath)

  * Array to hold FoxPro DBF files names to insert them into SQL
  DECLARE FileNames[6]
  FileNames[1] = 'SYCDICDC'
  FileNames[2] = 'SYCDICEL'
  FileNames[3] = 'SYCDICLP'
  FileNames[4] = 'SYCDICPR'
  FileNames[5] = 'SYCDICQL'
  FileNames[6] = 'SYCDICST'

  * HES
  SET STEP ON

  LOCAL lcAmzTrnLogScrpt,lcFilesTypesScrpt,lcElctrTrnsScrpt,lcInvHdrScrpt,lcInvDetlScrpt,lcPoAddScrpt,lcPoChrgScrpt,lcPoHeadScrpt,lcPoItmDistScrpt
  LOCAL lcPoItemsScrpt,lcPoMesgScrpt,lcPoSubItmscrpt,lcPoTermsScrpt,lcShpContScrpt,lcShpDetlScrpt,lcShpHeadScrpt,lcShpItmContScrpt,lcShpItemsScrpt,lcShpRoutScrpt
  STORE "" TO lcAmzTrnLogScrpt,lcFilesTypesScrpt,lcElctrTrnsScrpt,lcInvHdrScrpt,lcInvDetlScrpt,lcPoAddScrpt,lcPoChrgScrpt,lcPoHeadScrpt,lcPoItmDistScrpt
  STORE "" TO lcPoItemsScrpt,lcPoMesgScrpt,lcPoSubItmscrpt,lcPoTermsScrpt,lcShpContScrpt,lcShpDetlScrpt,lcShpHeadScrpt,lcShpItmContScrpt,lcShpItemsScrpt,lcShpRoutScrpt

  LOCAL SCRPT
  lcMergeSetting = SET("Textmerge")
  SET TEXTMERGE OFF

  TEXT TO SCRPT NOSHOW
BEGIN TRANSACTION

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[AMAZON_TRANSMISSION_LOG_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[AMAZON_TRANSMISSION_LOG_T] 
END 

IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[AMAZON_TRANSMISSION_LOG_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AMAZON_TRANSMISSION_LOG_T](
	[TRANSMISSION] [int] IDENTITY(1,1) NOT NULL,
	[Downloaded] [int] NULL,
	[DATE] [datetime] NULL,
	[STATUS] [char](20) NULL,
	[InputXML] [varchar](max) NULL,
	[HasNext] [bit] NULL,
	[NextToken] [char](1000) NULL,
	[Progress] [varchar](max) NULL,
	[Error] [varchar](max) NULL,
	[TRANSMISSION_KEY] [uniqueidentifier] NULL)
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[E_FILES_TYPES_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[E_FILES_TYPES_T]
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[E_FILES_TYPES_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[E_FILES_TYPES_T] (
	[E_FILE_TYPES_KEY] [uniqueidentifier] NULL CONSTRAINT [DF_E_FILE_TYPES_T_E_FILE_TYPES_KEY] DEFAULT (newid()),
	[FILE_TYPE] [varchar](20) NULL,
	[DESCRIPTION] [varchar](60) NULL,
	[FILE_FORMAT] [varchar](20) NULL,
	[RECEIVE_CLASS] [text] NULL,
	[SEND_CLASS] [text] NULL)

INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('1565d0e6-3850-4422-bd08-08852881d6e1' AS uniqueidentifier), N'AMZ', N'AMAZON XML FORMAT', N'XML', N'EBRECEIVEAMX', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('7906b900-81b1-4322-a162-e3a41909d8c5' AS uniqueidentifier), N'X12', N'ANSI/X12', N'EDI', N'EBRECEIVE', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('16f334a4-250f-4736-9645-11118ae2e835' AS uniqueidentifier), N'UN', N'UN/EDIFACT', N'EDI', N'EBRECEIVE', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('848307ea-adb2-4043-b0aa-4a59e2279e39' AS uniqueidentifier), N'FXD', N'FIXED EDI', N'EDI', N'EBRECEIVE', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('bbc32a1f-5cdc-47af-bd16-3dfd304716aa' AS uniqueidentifier), N'DLM', N'DELIMITED', N'EDI', N'EBRECEIVE', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('7085c9ec-4739-40d7-a06f-5f932b78e7cf' AS uniqueidentifier), N'TRDCMS', N'TRADACOMS', N'EDI', N'EBRECEIVE', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('7085c9ec-4739-40d7-a06f-5f932b78e7c1' AS uniqueidentifier), N'FREWAY', N'FREEWAY Supported format', N'FREEWAY', N'FREEWAY.ReceiveFile', N'SENDTRANSACTIONS')


INSERT INTO [dbo].[E_FILES_TYPES_T] ([E_FILE_TYPES_KEY], [FILE_TYPE], [DESCRIPTION], [FILE_FORMAT], [RECEIVE_CLASS], [SEND_CLASS])
	VALUES (CAST ('7085c9ec-4739-40d7-a06f-5f988b78e7c1' AS uniqueidentifier), N'CSV', N'Warehouse CSV', N'COMMA', N'CsvTranslator.ReceiveFile', N'SENDTRANSACTIONS')


	 SET ANSI_NULLS ON

	 SET QUOTED_IDENTIFIER ON

	 CREATE NONCLUSTERED INDEX [FILFRMT] ON [dbo].[E_FILES_TYPES_T]  ([FILE_FORMAT])

	CREATE NONCLUSTERED INDEX [FILTYP] ON [dbo].[E_FILES_TYPES_T]  ([FILE_TYPE])
END

IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[ELECTRONIC_TRANSACTIONS_T]') AND type in (N'U'))
BEGIN 
-- *E303596,1 AEG 08/25/2015 upgrade 850 transaction for send  added new field Nccclass_name [Begin]
-- *!*	CREATE TABLE [dbo].[ELECTRONIC_TRANSACTIONS_T] (
-- *!*		[FILE_TYPE] [char](20) NOT NULL,
-- *!*		[DOCUMENT_TYPE] [char](20) NULL,
-- *!*		[DOCUMENT_NAME] [char](50) NULL,
-- *!*		[TRANSACTION_CODE] [char](30) NULL,
-- *!*		[PROCESS_TYPE] [char](1) NULL,
-- *!*		[CLASS_NAME] [text] NULL,
-- *!*		[TRANSLATE_CLASS] [text] NULL,
-- *!*		[MAPPING_FILE] [char](30) NULL,
-- *!*		[addclass_path] [text] NULL,
-- *!*		[ELECTRONIC_TRANSACTIONS_KEY] [uniqueidentifier] NULL CONSTRAINT [DF_ELECTRONIC_TRANSACTIONS_T_ELECTRONIC_TRANSACTIONS_KEY] DEFAULT (newid()))
CREATE TABLE [dbo].[ELECTRONIC_TRANSACTIONS_T] (
    [FILE_TYPE] [char](20) NOT NULL,
	[DOCUMENT_TYPE] [char](20) NULL,
	[DOCUMENT_NAME] [char](50) NULL,
	[TRANSACTION_CODE] [char](30) NULL,
	[PROCESS_TYPE] [char](1) NULL,
	[CLASS_NAME] [text] NULL,
	[TRANSLATE_CLASS] [text] NULL,
	[MAPPING_FILE] [char](30) NULL,
	[addclass_path] [text] NULL,
	[ELECTRONIC_TRANSACTIONS_KEY] [uniqueidentifier] NULL,
	[Ncclass_name] [text] NULL)
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[ELECTRONIC_TRANSACTIONS_T]') AND type in (N'U'))
BEGIN 

-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'204                 ', N'Bill of Lading                                    ', N'SM                            ', N'S', N'SEND204', N'SEND204', N'SYCEDISM                      ', CAST ('3e0465f8-1c09-4a98-8087-21ac512417e2' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'753                 ', N'Request for Routing Instructions                  ', N'RF                            ', N'S', N'SEND753', N'SEND753', N'SYCEDIRF                      ', CAST ('3e0465f8-1c09-4a98-8087-21ac512417e1' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'754                 ', N'Routing Instructions                              ', N'RG                            ', N'R', N'EDIProcessRG', N'EDIProcessRG', NULL, CAST ('113580d7-f20c-443f-93c3-2128c142fd53' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'810                 ', N'Invoice                                           ', N'IN                            ', N'S', N'SEND810', N'SEND810', N'SYCEDIFS                      ', CAST ('16544003-0979-49e0-83c1-5309b8d87c4b' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'811                 ', N'Invoice Batch Summary                             ', N'IN                            ', N'S', N'SEND811', N'SEND811', N'SYCEDIFS                      ', CAST ('91abf9ab-da60-48c4-93a3-00985bffd091' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'812                 ', N'Credit/Debit Adjustment                           ', N'CD                            ', N'R', N'EDIProcessCD', N'EDIProcessCD', NULL, CAST ('3e0465f8-1c09-4a98-8087-21ac512417e2' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'816                 ', N'Organizational Relationship                       ', N'OR                            ', N'R', N'EDIProcessOR', N'EDIProcessOR', NULL, CAST ('3e0465f8-1c09-4a98-8087-21ac512417e4' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'820                 ', N'Payment Order/Remittance Advice                   ', N'RA                            ', N'R', N'EDIProcessRA', N'EDIProcessRA', NULL, CAST ('3e0465f8-1c09-4a98-8087-21ac512417e5' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'824                 ', N'Application Advice                                ', N'AG                            ', N'R', N'EDIProcessAg', N'EDIProcessAg', NULL, CAST ('3e0465f8-1c09-4a98-8087-21ac512417e6' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'830                 ', N'Planning Schedule                                 ', N'PS                            ', N'R', N'EDIProcessPS', N'EDIProcessPS', NULL, CAST ('f97beae9-c10a-483d-829b-486326b69fce' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'832                 ', N'Price & Sales Catalog                             ', N'SC                            ', N'R', N'EDIProcessSC', N'EDIProcessSC', NULL, CAST ('bb0b0121-c1b6-45a9-8c44-74cc328ad84a' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'832                 ', N'Price & Sales Catalog                             ', N'SC                            ', N'S', N'SEND832', N'SEND832', N'SYCEDISC                      ', CAST ('13ebdd42-30d5-4f22-be1b-138d7fe38db9' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'850                 ', N'Purchase Order                                    ', N'PO                            ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, CAST ('b1fedcdb-5044-4e70-a924-d2b464d986a4' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'850                 ', N'Purchase Order                                    ', N'PO                            ', N'S', N'SEND850', N'SEND850', N'SYCEDIPO                      ', CAST ('b8b9c1e7-b31c-417c-a441-813acc7f49ad' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'852                 ', N'Product Activity                                  ', N'PD                            ', N'R', N'EDIProcessPD', N'EDIProcessPD', NULL, CAST ('fd56852e-c85a-4790-a358-ddd53f302701' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'855                 ', N'Reverse Order                                     ', N'PR                            ', N'R', N'EDIProcessCC', N'EDIProcessCC', NULL, CAST ('5f71add2-8c1a-4824-b0eb-c9b8318e18d3' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'855                 ', N'Reverse Order                                     ', N'PR                            ', N'S', N'SEND855', N'SEND855', N'SYCEDIPR                      ', CAST ('d8153ec7-2988-4cc5-a299-07183bffeef8' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'856                 ', N'Advance Ship Notice                               ', N'SH                            ', N'S', N'SEND856', N'SEND856', N'SYCEDISH                      ', CAST ('69c331c1-60fb-4426-b010-6e70ed113d6c' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'860                 ', N'Purchase Order Modify                             ', N'PC                            ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, CAST ('ab277d5b-209b-457f-a3ef-239a8cfa1c8c' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'864                 ', N'Text Message & Location Address                   ', N'TX                            ', N'R', N'EDIProcessTX', N'EDIProcessTX', NULL, CAST ('aa236e7d-5b46-4eeb-8720-e5468dbe2abe' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'864                 ', N'Text Message & Location Address                   ', N'TX                            ', N'S', N'SEND864', N'SEND864', N'SYCEDITX                      ', CAST ('aa236e7d-5b46-4eeb-8720-e5468dbe2abe' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'869                 ', N'Order Status Inquiry                              ', N'RS                            ', N'R', N'EDIProcessRS', N'EDIProcessRS', NULL, CAST ('809ffdb7-c726-4ea8-96b1-6347aefed6ea' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'870                 ', N'Order Status Report                               ', N'RS                            ', N'S', N'SEND870', N'SEND870', N'SYCEDIRS                      ', CAST ('fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'870                 ', N'Order Status Report                               ', N'RS                            ', N'R', N'EDIProcessRs70', N'EDIProcessRs70', NULL, CAST ('fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'997                 ', N'Functional Acknowledgement                        ', N'FA                            ', N'R', N'EDIProcessFA', N'EDIProcessFA', NULL, CAST ('81aebdb1-a74a-495f-9793-8b6f4dc2bc7a' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'846                 ', N'Inventory Inquiry/Advice                          ', N'IB                            ', N'S', N'EDIPD.SEND846', N'EDIPD.SEND846', N'SYCEDIIB                      ', CAST ('8a118804-9175-4677-8f6f-06514e913d05' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'846                 ', N'Inventory Inquiry/Advice                          ', N'IB                            ', N'R', N'EDIProcessPD', N'EDIProcessPD', NULL, CAST ('ef18cbbe-8424-4bb0-8046-b039040f65dc' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'940                 ', N'Warehouse Shipping Order                          ', N'OW                            ', N'S', N'SEND940', N'SEND940', N'SYCEDIOW                      ', CAST ('1c77c0e4-4a2b-4795-9096-b8d57efc09e5' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'211                 ', N'Motor Bill of Lading                              ', N'SM                            ', N'S', N'Send204', N'Send204', N'SYCEDISM                      ', CAST ('388a4d85-601d-435f-bd07-3719f9aecf38' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'945                 ', N'Warehouse Shipping Advice                         ', N'SW                            ', N'R', N'EDIProcessSW', N'EDIProcessSW', NULL, CAST ('04baf2c5-ce5c-4f68-8b8f-d793d1da8969' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'943                 ', N'Stock Transfer Shipment Advice                    ', N'SW                            ', N'S', N'SEND943', N'SEND943', N'SYCEDIST                      ', CAST ('9ab0afad-af97-4dd9-bf93-2e71e5698267' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'944                 ', N'Warehouse Receipt Confirmation                    ', N'SW                            ', N'R', N'EDIProcessRE', N'EDIProcessRE', NULL, CAST ('2087c2ec-dd9f-43cc-9023-9ae33d50d147' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'X12                 ', N'865                 ', N'Supplier PO Change                                ', N'CA                            ', N'S', N'EDICA.SEND865', N'EDICA.SEND865', NULL, CAST ('024d2f79-430e-4894-9ac5-277d48cac9ce' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'997                 ', N'Functional Acknowledgement                        ', N'CONTRL                        ', N'R', N'EDIProcessFA', N'EDIProcessFA', NULL, CAST ('81aebdb1-a74a-495f-9793-8b6f4dc2bc7a' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'830                 ', N'Planning Schedule                                 ', N'DELFOR                        ', N'R', N'EDIProcessPS', N'EDIProcessPS', NULL, CAST ('f97beae9-c10a-483d-829b-486326b69fce' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'856                 ', N'Advance Ship Notice                               ', N'DESADV                        ', N'S', N'SEND856', N'SEND856', N'SYCEDISH                      ', CAST ('69c331c1-60fb-4426-b010-6e70ed113d6c' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'810                 ', N'Invoice                                           ', N'INVOIC                        ', N'S', N'SEND810', N'SEND810', N'SYCEDIFS                      ', CAST ('16544003-0979-49e0-83c1-5309b8d87c4b' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'860                 ', N'Purchase Order Modify                             ', N'ORDCHG                        ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, CAST ('ab277d5b-209b-457f-a3ef-239a8cfa1c8c' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'850                 ', N'Purchase Order                                    ', N'ORDERS                        ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, CAST ('b1fedcdb-5044-4e70-a924-d2b464d986a4' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'850                 ', N'Purchase Order                                    ', N'ORDERS                        ', N'S', N'SEND850', N'SEND850', N'SYCEDIPO                      ', CAST ('b8b9c1e7-b31c-417c-a441-813acc7f49ad' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'870                 ', N'Order Status Report                               ', N'ORDREP                        ', N'S', N'SEND870', N'SEND870', N'SYCEDIRS                      ', CAST ('fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'855                 ', N'Reverse Order                                     ', N'ORDRSP                        ', N'R', N'EDIProcessCC', N'EDIProcessCC', NULL, CAST ('5f71add2-8c1a-4824-b0eb-c9b8318e18d3' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'855                 ', N'Reverse Order                                     ', N'ORDRSP                        ', N'S', N'SEND855', N'SEND855', N'SYCEDIPR                      ', CAST ('5f71add2-8c1a-4824-b0eb-c9b8318e18d3' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'869                 ', N'Order Status Inquiry                              ', N'ORSSTA                        ', N'R', N'EDIProcessRS', N'EDIProcessRS', NULL, CAST ('809ffdb7-c726-4ea8-96b1-6347aefed6ea' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'832                 ', N'Price & Sales Catalog                             ', N'PRICAT                        ', N'R', N'EDIProcessSC', N'EDIProcessSC', NULL, CAST ('bb0b0121-c1b6-45a9-8c44-74cc328ad84a' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'UN                  ', N'832                 ', N'Price & Sales Catalog                             ', N'PRICAT                        ', N'S', N'SEND832', N'SEND832', N'SYCEDISC                      ', CAST ('bb0b0121-c1b6-45a9-8c44-74cc328ad84a' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'850                 ', N'Order Report                                      ', N'OrderReport                   ', N'R', N'XMLPROCESSPO', N'XMLPROCESSPO', N'AMXPO.XML|OrderReport.Xsd     ', CAST ('91b27369-39db-46db-b572-efa410dc0de5' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'856                 ', N'Shipment Confirmation                             ', N'OrderFulfillment              ', N'S', N'SENDXML856', N'SENDXML856', N'AMXSH.XML|OrderFulfillment.XSD', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f58e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'855                 ', N'Order Acknowledgement                             ', N'OrderAcknowledgement          ', N'S', N'SENDXML855', N'SENDXML855', N'AMXPR.XML                     ', CAST ('66e097ca-5e2d-4d80-98e9-f51d6e41f58e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'860                 ', N'Order Adjustment                                  ', N'OrderAdjustment               ', N'R', N'XMLPROCESSPO', N'XMLPROCESSPO', N'AMXPC.XML                     ', CAST ('66e097ca-5e2d-4d80-98e9-f51d6e41f58e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'812                 ', N'Settlement Report                                 ', N'SettlementReport              ', N'R', N'XMLPROCESSCD', N'XMLPROCESSCD', N'AMXCD.XML                     ', CAST ('66e097cb-5e2d-4d80-98e9-f51d6e41f58e' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'AMZ                 ', N'846                 ', N'Inventory Feed                                    ', N'Inventory                     ', N'S', N'SENDXML846', N'SENDXML846', N'AMXPD.XML|Inventory.XSD       ', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f587' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'FREWAY             ', N'850                 ', N'PO                                                ', N'FREEWAY Purchase Order        ', N'R', N'EDIPO.ADPPROCESSPO', N'FREEWAY.RECEIVE850            ', N'                              ', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f588' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'FREWAY             ', N'810                 ', N'IN                                                ', N'FREEWAY Invoice               ', N'S', N'EDIIN.EXTRACT810DATA', N'FREEWAY.SEND810               ', N'                              ', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f589' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'FREWAY             ', N'856                 ', N'SH                                                ', N'FREEWAY Advanced Ship Notice  ', N'S', N'EDISH.EXTRACT856DATA', N'FREEWAY.SEND856               ', N'                              ', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f580' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'CSV             ', N'945                 ', N'Warehouse Shipping Advice                                                ', N'Warehouse Shipping Advice  ', N'R', N'AL.ADPPROCESSSW', N'CsvTranslator.RECEIVE945               ', N'                              ', N 'D:\Shared\ARIA4XP\Classes\AL.VCX', CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f888' AS uniqueidentifier))


-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'CSV             ', N'940                 ', N'Warehouse Shipping Order                                                ', N'Warehouse Shipping Order  ', N'S', N'AL.EXTRACT940DATA', N'CsvTranslator.Send940               ', N'                              ', N 'D:\Shared\ARIA4XP\Classes\AL.VCX' , CAST ('66e097cc-5e2d-4d80-98e9-f51d6e41f889' AS uniqueidentifier))

-- *!*	INSERT INTO [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY])
-- *!*		VALUES (N'CSV             ', N'944                 ', N'Warehouse Stock Transfer Receipt Advice           ', N'Stock Transfer Receipt Advice ', N'R', N'WORKORDERS.ADPPROCESSRE', N'CsvTranslator.RECEIVE944     ', N'                              ', N 'D:\Shared\ARIA4XP\Classes\WORKORDERS.VCX' , CAST ('b1fedcdb-5044-5e70-a924-d2b464d886a5' AS uniqueidentifier))

INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'180                 ', N'Return Authorization                              ', N'AN                            ', N'R', N'EDIProcessAN', N'EDIProcessAN', N'                              ', N'e30b9f39-2b98-429a-95f9-2f86423eea49', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'204                 ', N'Bill of Lading                                    ', N'SM                            ', N'S', N'SEND204', N'SEND204', N'SYCEDISM                      ', N'3e0465f8-1c09-4a98-8087-21ac512417e2', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'753                 ', N'Request for Routing Instructions                  ', N'RF                            ', N'S', N'SEND753', N'SEND753', N'SYCEDIRF                      ', N'3e0465f8-1c09-4a98-8087-21ac512417e1', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'754                 ', N'Routing Instructions                              ', N'RG                            ', N'R', N'EDIProcessRG', N'EDIProcessRG', NULL, N'113580d7-f20c-443f-93c3-2128c142fd53', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'810                 ', N'Invoice                                           ', N'IN                            ', N'S', N'SEND810', N'SEND810', N'SYCEDIFS                      ', N'16544003-0979-49e0-83c1-5309b8d87c4b', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'811                 ', N'Invoice Batch Summary                             ', N'IN                            ', N'S', N'SEND811', N'SEND811', N'SYCEDIFS                      ', N'91abf9ab-da60-48c4-93a3-00985bffd091', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'812                 ', N'Credit/Debit Adjustment                           ', N'CD                            ', N'R', N'EDIProcessCD', N'EDIProcessCD', NULL, N'3e0465f8-1c09-4a98-8087-21ac512417e2', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'816                 ', N'Organizational Relationship                       ', N'OR                            ', N'R', N'EDIProcessOR', N'EDIProcessOR', NULL, N'3e0465f8-1c09-4a98-8087-21ac512417e4', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'820                 ', N'Payment Order/Remittance Advice                   ', N'RA                            ', N'R', N'EDIProcessRA', N'EDIProcessRA', NULL, N'3e0465f8-1c09-4a98-8087-21ac512417e5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'824                 ', N'Application Advice                                ', N'AG                            ', N'R', N'EDIProcessAg', N'EDIProcessAg', NULL, N'3e0465f8-1c09-4a98-8087-21ac512417e6', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'830                 ', N'Planning Schedule                                 ', N'PS                            ', N'R', N'EDIProcessPS', N'EDIProcessPS', NULL, N'f97beae9-c10a-483d-829b-486326b69fce', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'832                 ', N'Price & Sales Catalog                             ', N'SC                            ', N'R', N'EDIProcessSC', N'EDIProcessSC', NULL, N'bb0b0121-c1b6-45a9-8c44-74cc328ad84a', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'832                 ', N'Price & Sales Catalog                             ', N'SC                            ', N'S', N'SEND832', N'SEND832', N'SYCEDISC                      ', N'13ebdd42-30d5-4f22-be1b-138d7fe38db9', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'850                 ', N'Purchase Order                                    ', N'PO                            ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, N'b1fedcdb-5044-4e70-a924-d2b464d986a4', N'EDIProcessPO')
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'850                 ', N'Purchase Order                                    ', N'PO                            ', N'S', N'SEND850', N'SEND850', N'SYCEDIPO                      ', N'b8b9c1e7-b31c-417c-a441-813acc7f49ad', N'SendPos850')
-- *!* INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'852                 ', N'Product Activity                                  ', N'PD                            ', N'R', N'EDIProcessPD', N'EDIProcessPD', NULL, N'fd56852e-c85a-4790-a358-ddd53f302701', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'855                 ', N'Reverse Order                                     ', N'PR                            ', N'R', N'EDIProcessCC', N'EDIProcessCC', NULL, N'5f71add2-8c1a-4824-b0eb-c9b8318e18d3', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'855                 ', N'Reverse Order                                     ', N'PR                            ', N'S', N'SEND855', N'SEND855', N'SYCEDIPR                      ', N'd8153ec7-2988-4cc5-a299-07183bffeef8', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'856                 ', N'Advance Ship Notice                               ', N'SH                            ', N'S', N'SEND856', N'SEND856', N'SYCEDISH                      ', N'69c331c1-60fb-4426-b010-6e70ed113d6c', N'SEND856')
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'856                 ', N'Advance Ship Notice                               ', N'SH                            ', N'R', N'EDIPROCESSSH', N'EDIPROCESSSH', NULL, N'69c331c1-60fb-4426-b010-6e70ed444d6c', N'EDIPROCESSPOSSH')
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'860                 ', N'Purchase Order Modify                             ', N'PC                            ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, N'ab277d5b-209b-457f-a3ef-239a8cfa1c8c', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'864                 ', N'Text Message & Location Address                   ', N'TX                            ', N'R', N'EDIProcessTX', N'EDIProcessTX', NULL, N'aa236e7d-5b46-4eeb-8720-e5468dbe2abe', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'864                 ', N'Text Message & Location Address                   ', N'TX                            ', N'S', N'SEND864', N'SEND864', N'SYCEDITX                      ', N'aa236e7d-5b46-4eeb-8720-e5468dbe2abe', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'869                 ', N'Order Status Inquiry                              ', N'RS                            ', N'R', N'EDIProcessRS', N'EDIProcessRS', NULL, N'809ffdb7-c726-4ea8-96b1-6347aefed6ea', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'870                 ', N'Order Status Report                               ', N'RS                            ', N'S', N'SEND870', N'SEND870', N'SYCEDIRS                      ', N'fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'870                 ', N'Order Status Report                               ', N'RS                            ', N'R', N'EDIProcessRs70', N'EDIProcessRs70', NULL, N'fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'997                 ', N'Functional Acknowledgement                        ', N'FA                            ', N'R', N'EDIProcessFA', N'EDIProcessFA', NULL, N'81aebdb1-a74a-495f-9793-8b6f4dc2bc7a', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'846                 ', N'Inventory Inquiry/Advice                          ', N'IB                            ', N'S', N'EDIPD.SEND846', N'EDIPD.SEND846', N'SYCEDIIB                      ', N'8a118804-9175-4677-8f6f-06514e913d05', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'846                 ', N'Inventory Inquiry/Advice                          ', N'IB                            ', N'R', N'EDIProcessPD', N'EDIProcessPD', NULL, N'ef18cbbe-8424-4bb0-8046-b039040f65dc', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'940                 ', N'Warehouse Shipping Order                          ', N'OW                            ', N'S', N'SEND940', N'SEND940', N'SYCEDIOW                      ', N'1c77c0e4-4a2b-4795-9096-b8d57efc09e5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'211                 ', N'Motor Bill of Lading                              ', N'SM                            ', N'S', N'Send204', N'Send204', N'SYCEDISM                      ', N'388a4d85-601d-435f-bd07-3719f9aecf38', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'945                 ', N'Warehouse Shipping Advice                         ', N'SW                            ', N'R', N'EDIProcessSW', N'EDIProcessSW', NULL, N'04baf2c5-ce5c-4f68-8b8f-d793d1da8969', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'944                 ', N'Warehouse Receipt Confirmation                    ', N'SW                            ', N'R', N'EDIProcessRE', N'EDIProcessRE', NULL, N'2087c2ec-dd9f-43cc-9023-9ae33d50d147', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'865                 ', N'Supplier PO Change                                ', N'CA                            ', N'S', N'EDICA.SEND865', N'EDICA.SEND865', NULL, N'024d2f79-430e-4894-9ac5-277d48cac9ce', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'997                 ', N'Functional Acknowledgement                        ', N'CONTRL                        ', N'R', N'EDIProcessFA', N'EDIProcessFA', NULL, N'81aebdb1-a74a-495f-9793-8b6f4dc2bc7a', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'830                 ', N'Planning Schedule                                 ', N'DELFOR                        ', N'R', N'EDIProcessPS', N'EDIProcessPS', NULL, N'f97beae9-c10a-483d-829b-486326b69fce', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'856                 ', N'Advance Ship Notice                               ', N'DESADV                        ', N'S', N'SEND856', N'SEND856', N'SYCEDISH                      ', N'69c331c1-60fb-4426-b010-6e70ed113d6c', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'810                 ', N'Invoice                                           ', N'INVOIC                        ', N'S', N'SEND810', N'SEND810', N'SYCEDIFS                      ', N'16544003-0979-49e0-83c1-5309b8d87c4b', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'860                 ', N'Purchase Order Modify                             ', N'ORDCHG                        ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, N'ab277d5b-209b-457f-a3ef-239a8cfa1c8c', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'850                 ', N'Purchase Order                                    ', N'ORDERS                        ', N'R', N'EDIProcessPO', N'EDIProcessPO', NULL, N'b1fedcdb-5044-4e70-a924-d2b464d986a4', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'850                 ', N'Purchase Order                                    ', N'ORDERS                        ', N'S', N'SEND850', N'SEND850', N'SYCEDIPO                      ', N'b8b9c1e7-b31c-417c-a441-813acc7f49ad', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'870                 ', N'Order Status Report                               ', N'ORDREP                        ', N'S', N'SEND870', N'SEND870', N'SYCEDIRS                      ', N'fc44bc71-4b29-4ee3-a9d3-ebd6f7f1955e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'855                 ', N'Reverse Order                                     ', N'ORDRSP                        ', N'R', N'EDIProcessCC', N'EDIProcessCC', NULL, N'5f71add2-8c1a-4824-b0eb-c9b8318e18d3', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'855                 ', N'Reverse Order                                     ', N'ORDRSP                        ', N'S', N'SEND855', N'SEND855', N'SYCEDIPR                      ', N'5f71add2-8c1a-4824-b0eb-c9b8318e18d3', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'869                 ', N'Order Status Inquiry                              ', N'ORSSTA                        ', N'R', N'EDIProcessRS', N'EDIProcessRS', NULL, N'809ffdb7-c726-4ea8-96b1-6347aefed6ea', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'832                 ', N'Price & Sales Catalog                             ', N'PRICAT                        ', N'R', N'EDIProcessSC', N'EDIProcessSC', NULL, N'bb0b0121-c1b6-45a9-8c44-74cc328ad84a', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'UN                  ', N'832                 ', N'Price & Sales Catalog                             ', N'PRICAT                        ', N'S', N'SEND832', N'SEND832', N'SYCEDISC                      ', N'bb0b0121-c1b6-45a9-8c44-74cc328ad84a', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'850                 ', N'Order Report                                      ', N'OrderReport                   ', N'R', N'XMLPROCESSPO', N'XMLPROCESSPO', N'AMXPO.XML|OrderReport.Xsd     ', N'91b27369-39db-46db-b572-efa410dc0de5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'856                 ', N'Shipment Confirmation                             ', N'OrderFulfillment              ', N'S', N'SENDXML856', N'SENDXML856', N'AMXSH.XML|OrderFulfillment.XSD', N'66e097cc-5e2d-4d80-98e9-f51d6e41f58e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'855                 ', N'Order Acknowledgement                             ', N'OrderAcknowledgement          ', N'S', N'SENDXML855', N'SENDXML855', N'AMXPR.XML                     ', N'66e097ca-5e2d-4d80-98e9-f51d6e41f58e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'860                 ', N'Order Adjustment                                  ', N'OrderAdjustment               ', N'R', N'XMLPROCESSPO', N'XMLPROCESSPO', N'AMXPC.XML                     ', N'66e097ca-5e2d-4d80-98e9-f51d6e41f58e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'812                 ', N'Settlement Report                                 ', N'SettlementReport              ', N'R', N'XMLPROCESSCD', N'XMLPROCESSCD', N'AMXCD.XML                     ', N'66e097cb-5e2d-4d80-98e9-f51d6e41f58e', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'AMZ                 ', N'846                 ', N'Inventory Feed                                    ', N'Inventory                     ', N'S', N'SENDXML846', N'SENDXML846', N'AMXPD.XML|Inventory.XSD       ', N'66e097cc-5e2d-4d80-98e9-f51d6e41f587', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'FREWAY              ', N'850                 ', N'PO                                                ', N'FREEWAY Purchase Order        ', N'R', N'EDIPO.ADPPROCESSPO', N'FREEWAY.RECEIVE850            ', N'                              ', N'66e097cc-5e2d-4d80-98e9-f51d6e41f588', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'FREWAY              ', N'810                 ', N'IN                                                ', N'FREEWAY Invoice               ', N'S', N'EDIIN.EXTRACT810DATA', N'FREEWAY.SEND810               ', N'                              ', N'66e097cc-5e2d-4d80-98e9-f51d6e41f589', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'FREWAY              ', N'856                 ', N'SH                                                ', N'FREEWAY Advanced Ship Notice  ', N'S', N'EDISH.EXTRACT856DATA', N'FREEWAY.SEND856               ', N'                              ', N'66e097cc-5e2d-4d80-98e9-f51d6e41f580', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE], [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'180                 ', N'Return Authorization                              ', N'AN                            ', N'R', N'EDIProcessAN', N'EDIProcessAN', NULL, N'b1fedcdb-5044-4e70-a924-d2b464d986a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'CSV                 ', N'945                 ', N'Warehouse Shipping Advice                         ', N'Warehouse Shipping Advice     ', N'R', N'AL.ADPPROCESSSW', N'CsvTranslator.RECEIVE945     ', N'                              ',N'D:\Shared\ARIA4XP\Classes\AL.VCX', N'66e097cc-5e2d-4d80-98e9-f51d6e41f887', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'CSV                 ', N'940                 ', N'Warehouse Shipping Order                          ', N'Warehouse Shipping Order      ', N'S', N'AL.EXTRACT940DATA', N'CsvTranslator.Send940', N'                              ',N'D:\Shared\ARIA4XP\Classes\AL.VCX', N'b1fedcdb-5044-4e70-a924-d2b464d886a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'CSV                 ', N'944                 ', N'Warehouse Stock Transfer Receipt Advice           ', N'Stock Transfer Receipt Advice ', N'R', N'WORKORDERS.ADPPROCESSRE', N'CsvTranslator.RECEIVE944     ', N'                              ',N'D:\Shared\ARIA4XP\Classes\WORKORDERS.VCX', N'b1fedcdb-5044-5e70-a924-d2b464d886a5', NULL)

INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'940                 ', N'Warehouse Shipping Order                               ', N'OW                            ', N'R', N'AL.ADPPROCESSOW', N'X12Translator.RECEIVE', N'                              ',N'D:\Shared\ARIA4XP\Classes\AL.VCX', N'b1fedcdb-5044-5e70-a924-d2b477d878a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'945                 ', N'Warehouse Shipping Advice                              ', N'SW                            ', N'S', N'AL.EXTRACT945DATA', N'EDIOW.Send945', N'                              ',N'D:\Shared\ARIA4XP\Classes\AL.VCX', N'b1feffdb-5044-5e70-a924-d2b477d878a5', NULL)

INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'944                 ', N'Warehouse Receipt Confirmation                               ', N'RE                            ', N'S', N'IC.Extract944Data', N'X12Translator.Send944', N'                              ',N'D:\Shared\ARIA4XP\Classes\IC.VCX', N'b1fedcdb-5044-5e70-a924-d2b464d878a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'944                 ', N'Warehouse Receipt Confirmation                               ', N'RE                            ', N'R', N'workorders.Import944Batch', N'X12Translator.RECEIVE', N'                              ',N'D:\Shared\ARIA4XP\Classes\workorders.VCX', N'b1fedcdb-5044-5e70-a924-d2b464d248a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'943                 ', N'Stock Transfer Shipment Advice                               ', N'SW                            ', N'S', N'workorders.EXTRACT943DATA', N'X12Translator.Send943', N'                              ',N'D:\Shared\ARIA4XP\Classes\workorders.VCX', N'b1fedcdb-5044-5e70-a924-d2b464d222a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'943                 ', N'Stock Transfer Shipment Advice                               ', N'SW                            ', N'R', N'IC.Import943Batch', N'X12Translator.RECEIVE', N'                              ',N'D:\Shared\ARIA4XP\Classes\IC.VCX', N'b1fedcdb-5044-5e70-a924-d2b464d111a5', NULL)

INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'852                 ', N'Product Activity                               ', N'PD                            ', N'S', N'ProductActivity.extract852data', N'X12Translator.Send852', N'                              ',N'D:\Shared\ARIA4XP\Classes\ProductActivity.VCX', N'b1fedcdb-5034-5e70-a924-d2b464d222a5', NULL)
INSERT [dbo].[ELECTRONIC_TRANSACTIONS_T] ([FILE_TYPE], [DOCUMENT_TYPE], [DOCUMENT_NAME], [TRANSACTION_CODE], [PROCESS_TYPE], [CLASS_NAME], [TRANSLATE_CLASS], [MAPPING_FILE] , [addclass_path] , [ELECTRONIC_TRANSACTIONS_KEY], [Ncclass_name]) VALUES (N'X12                 ', N'852                 ', N'Product Activity                               ', N'PD                            ', N'R', N'ProductActivity.Receive852data', N'X12Translator.RECEIVE', N'                              ',N'D:\Shared\ARIA4XP\Classes\ProductActivity.VCX', N'b1fedcdb-5044-5e70-a934-d2b464d111a5', NULL)




ALTER TABLE [dbo].[ELECTRONIC_TRANSACTIONS_T] ADD  CONSTRAINT [DF_ELECTRONIC_TRANSACTIONS_T_ELECTRONIC_TRANSACTIONS_KEY]  DEFAULT (newid()) FOR [ELECTRONIC_TRANSACTIONS_KEY]
SET ANSI_PADDING OFF
-- *E303596,1 AEG 08/25/2015 upgrade 850 transaction for send  added new field Nccclass_name [End]
--Indexes of table dbo.ELECTRONIC_TRANSACTIONS_T
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE NONCLUSTERED INDEX [IX_ELECTRONIC_TRANSACTIONS_T] ON [dbo].[ELECTRONIC_TRANSACTIONS_T]  ([FILE_TYPE], [DOCUMENT_TYPE], [PROCESS_TYPE])


CREATE NONCLUSTERED INDEX [IX_ELECTRONIC_TRANSACTIONS_T_1] ON [dbo].[ELECTRONIC_TRANSACTIONS_T]  ([FILE_TYPE], [TRANSACTION_CODE], [PROCESS_TYPE])

END


IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVENTORY_DETAILS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVENTORY_DETAILS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVENTORY_DETAILS_T]') AND type in (N'U'))
BEGIN
	 CREATE TABLE [dbo].[INVENTORY_DETAILS_T](
		[PARTNER_ID] [varchar](20) NULL,
		[INVINTORY_ADVICE_ID] [varchar](20) NULL,
		[BUYER_STYLE] [varchar](30) NULL,
		[VENDOR_STYLE] [varchar](30) NULL,
		[VENDOR_STYLE_DESCRIPTION] [varchar](100) NULL,
		[QUANTITY] [int] NULL,
		[AVAILABLE] [bit] NULL,
		[UNIT_PRICE] [decimal](13, 2) NULL,
		[RETAIL_PRICE] [decimal](13, 2) NULL,
		[UPC] [varchar](100) NULL,
		[INVENTORY_HEADER_KEY] [bigint] NOT NULL,
		[INVENTORY_DETAILS_KEY] [bigint] IDENTITY(1,1) NOT NULL
	 ) ON [PRIMARY]

	 SET ANSI_PADDING OFF
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVENTORY_HEADER_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVENTORY_HEADER_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVENTORY_HEADER_T]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[INVENTORY_HEADER_T](
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVINTORY_ADVICE_ID] [varchar](20) NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[PURPOSE_CODE] [varchar](30) NULL,
	[PURPOSE_DESCRIPTION] [varchar](100) NULL,
	[INVENTORY_NAME] [varchar](100) NULL,
	[INVENTORY_ADDRESS_1] [varchar](100) NULL,
	[INVENTORY_ADDRESS_2] [varchar](100) NULL,
	[INVENTORY_CITY] [varchar](30) NULL,
	[INVENTORY_STATE] [varchar](30) NULL,
	[INVENTORY_ZIP] [varchar](30) NULL,
	[INVENTORY_COUNTRY] [varchar](30) NULL,
	[CONTACT_NAME] [varchar](100) NULL,
	[CONTACT_PHONE] [varchar](30) NULL,
	[CONTACT_FAX] [varchar](30) NULL,
	[CONTACT_EMAIL] [varchar](100) NULL,
	[INVENTORY_HEADER_KEY] [bigint] IDENTITY(1,1) NOT NULL,
	 CONSTRAINT [PK_INVENTORY_HEADER_T_1] PRIMARY KEY CLUSTERED
	(
		[PARTNER_ID] ASC,
		[INVINTORY_ADVICE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ADDRESS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_ADDRESS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ADDRESS_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PO_ADDRESS_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ADDRESS_TYPE] [char](10) NULL,
	[LOCATION_CODE] [char](20) NULL,
	[NAME] [char](100) NULL,
	[ADDRESS_LINE_1] [char](100) NULL,
	[ADDRESS_LINE_2] [char](100) NULL,
	[CITY] [char](30) NULL,
	[STATE] [char](30) NULL,
	[ZIP_CODE] [char](30) NULL,
	[COUNTRY] [char](30) NULL,
	[CONTACT] [char](30) NULL,
	[PHONE] [char](30) NULL,
	[EMAIL_ADDRESS] [char](100) NULL,
	[GLN_NUMBER] [char](20) NULL,
	[DUNS_NUMBER] [char](20) NULL,
	[PO_ADDRESS_KEY] [uniqueidentifier] NULL)

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_CHARGES_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_CHARGES_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_CHARGES_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PO_CHARGES_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[CHARGE_TYPE] [char](20) NULL,
	[CHARGE_CODE] [char](50) NULL,
	[CHARGE_DESCRIPTION] [text] NULL,
	[CHARGE_AMOUNT] [decimal](13, 2) NULL,
	[METHOD_OF_HANDLING] [char](20) NULL,
	[PO_CHARGES_KEY] [uniqueidentifier] NULL);

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_HEADER_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_HEADER_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_HEADER_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PO_HEADER_T](
		[PARTNER_ID] [char](20) NOT NULL,
		[RETAILER_PO] [char](30) NOT NULL,
		[TRANSACTION_TYPE] [char](2) NOT NULL,
		[ENTERED] [datetime] NULL,
		[RELEASE_NUMBER] [char](30) NULL,
		[BLANKET_NUMBER] [char](30) NULL,
		[CONTRACT_NUMBER] [char](30) NULL,
		[MERCHANDISE_TYPE] [char](30) NULL,
		[PROMOTION_CODE] [char](30) NULL,
		[PO_TYPE] [char](30) NULL,
		[VENDOR_NUMBER] [char](30) NULL,
		[DEPARTMENT] [char](30) NULL,
		[BUYER] [char](100) NULL,
		[ORDER_CONTACT] [char](30) NULL,
		[DELIVERY_CONTACT] [char](30) NULL,
		[DELIVERY_REQUESTED] [datetime] NULL,
		[CANCEL_AFTER] [datetime] NULL,
		[REQUESTED_SHIP] [datetime] NULL,
		[SHIP_NOT_BEFORE] [datetime] NULL,
		[DONT_DELIVER_AFTER] [datetime] NULL,
		[DONT_DELIVER_BEFORE] [datetime] NULL,
		[HANDLING_INSTRUCTIONS] [text] NULL,
		[FULFILLMENTSERVICELEVEL] [char](30) NULL,
		[PO_HEADER_KEY] [uniqueidentifier] NULL,
	 CONSTRAINT [PK_PO_HEADER_T_1] PRIMARY KEY CLUSTERED
	(
		[PARTNER_ID] ASC,
		[RETAILER_PO] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ITEM_DISTENTION_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_ITEM_DISTENTION_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ITEM_DISTENTION_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PO_ITEM_DISTENTION_T](
		[PARTNER_ID] [char](20) NULL,
		[RETAILER_PO] [char](30) NULL,
		[ITEM_LINE_NO] [bigint] NULL,
		[LOCATION_ID] [char](20) NULL,
		[QUANTITY_ORDERED] [int] NULL,
		[UOM] [char](20) NULL,
		[PO_ITEM_DISTENTION_KEY] [uniqueidentifier] NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ITEMS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_ITEMS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_ITEMS_T]') AND type in (N'U'))
BEGIN
	 CREATE TABLE [dbo].[PO_ITEMS_T](
		[PARTNER_ID] [char](20) NULL,
		[RETAILER_PO] [char](30) NULL,
		[ITEM_LINE_NO] [bigint] NULL,
		[VENDOR_ITEM] [char](50) NULL,
		[VENDOR_STYLE] [char](50) NULL,
		[VENDOR_COLOR] [char](50) NULL,
		[VENDOR_SIZE] [char](50) NULL,
		[BUYER_ITEM] [char](50) NULL,
		[BUYER_STYLE] [char](50) NULL,
		[BUYER_COLOR] [char](50) NULL,
		[BUYER_SIZE] [char](50) NULL,
		[COLOR_NRF] [char](50) NULL,
		[SIZE_NRF] [char](50) NULL,
		[UPC_NUMBER] [char](50) NULL,
		[ITEM_DESCRIPTION] [text] NULL,
		[INNER_CONTAINERS] [int] NULL,
		[CONTAINER_EACHES] [int] NULL,
		[QUANTITY_ORDERED] [int] NULL,
		[UOM] [char](20) NULL,
		[UNIT_PRICE] [decimal](13, 2) NULL,
		[CATALOGUE_PRICE] [decimal](13, 2) NULL,
		[RETAIL_PRICE] [decimal](13, 2) NULL,
		[SUGGESTED_RETAIL_PRICE] [decimal](13, 2) NULL,
		[PROMOTIONAL_PRICE] [decimal](13, 2) NULL,
		[REQUEST_SHIP_DATE] [datetime] NULL,
		[DELIVERY_REQUESTED_DATE] [datetime] NULL,
		[HANDLING_INSTRUCTIONS] [text] NULL,
		[PO_ITEMS_KEY] [uniqueidentifier] NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_MESSAGES_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_MESSAGES_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_MESSAGES_T]') AND type in (N'U'))
BEGIN
	 CREATE TABLE [dbo].[PO_MESSAGES_T](
		[PARTNER_ID] [char](20) NULL,
		[RETAILER_PO] [char](30) NULL,
		[ITEM_LINE_NO] [bigint] NULL,
		[MESSAGE_NO] [int] NULL,
		[MESSAGE_TITLE] [char](50) NULL,
		[MESSAGE] [text] NULL,
		[PO_MESSAGES_KEY] [uniqueidentifier] NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_SUBLINE_ITEM_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_SUBLINE_ITEM_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_SUBLINE_ITEM_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PO_SUBLINE_ITEM_T](
		[PARTNER_ID] [char](20) NULL,
		[RETAILER_PO] [char](30) NULL,
		[ITEM_LINE_NO] [bigint] NULL,
		[SUB_ITEM_LINE_NO] [int] NULL,
		[VENDOR_ITEM] [char](50) NULL,
		[VENDOR_STYLE] [char](50) NULL,
		[VENDOR_COLOR] [char](50) NULL,
		[VENDOR_SIZE] [char](50) NULL,
		[BUYER_ITEM] [char](50) NULL,
		[BUYER_STYLE] [char](50) NULL,
		[BUYER_COLOR] [char](50) NULL,
		[BUYER_SIZE] [char](50) NULL,
		[COLOR_NRF] [char](50) NULL,
		[SIZE_NRF] [char](50) NULL,
		[UPC_NUMBER] [char](50) NULL,
		[QUANTITY_ORDERED] [int] NULL,
		[UOM] [char](20) NULL,
		[UNIT_PRICE] [decimal](13, 2) NULL,
		[PO_SUBLINE_ITEM_KEY] [uniqueidentifier] NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF
END


IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_TERMS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[PO_TERMS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[PO_TERMS_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PO_TERMS_T](
		[PARTNER_ID] [char](20) NULL,
		[RETAILER_PO] [char](30) NULL,
		[TERM_CODE] [char](30) NULL,
		[TERM_DESCRIPTION] [text] NULL,
		[BASIC_DATE_CODE] [char](10) NULL,
		[DISCOUNT_PERCENT] [decimal](5, 2) NULL,
		[DISCOUNT_DUE_DATE] [datetime] NULL,
		[DISCOUNT_DAYS_DUE] [int] NULL,
		[NET_DUE_DATE] [datetime] NULL,
		[NET_DAYS] [int] NULL,
		[DISCOUNT_AMOUNT] [decimal](13, 2) NULL,
		[DEFERRED_DUE_DATE] [datetime] NULL,
		[DEFERRED_AMOUNT_DUE] [decimal](13, 2) NULL,
		[PERCENT_INVOICE_PAYABLE] [int] NULL,
		[DAY_OF_MONTH] [int] NULL,
		[PAYMENT_METHOD] [char](10) NULL,
		[PO_TERMS_KEY] [uniqueidentifier] NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_CONTAINERS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_CONTAINERS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_CONTAINERS_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_CONTAINERS_T](
		[PARTNER_ID] [varchar](20) NULL,
		[SHIPMENT_ID] [varchar](30) NULL,
		[SSCC_18] [varchar](18) NULL,
		[SSCC_20] [varchar](20) NULL,
		[UPC_SHIPPING_CODE] [varchar](14) NULL,
		[CARRIER_PACKAGE_ID] [varchar](50) NULL,
		[SHIPPER_ID] [varchar](50) NULL,
		[QUANTITY_SHIPPED] [int] NULL,
		[UOM] [varchar](20) NULL,
		[WIDTH] [decimal](13, 2) NULL,
		[HEIGHT] [decimal](13, 2) NULL,
		[LENGTH] [decimal](13, 2) NULL,
		[DIMENSIONS_UOM] [varchar](20) NULL,
		[WEIGHT] [decimal](13, 2) NULL,
		[WEIGHT_UOM] [varchar](20) NULL,
		[PACKAGE_TYPE] [varchar](50) NULL,
		[BUYING_PARTY_LOCATION] [varchar](20) NULL,
		[BUYING_PARTY_GLN_NUMBER] [varchar](20) NULL,
		[BUYING_PARTY_DUNS_NUMBER] [varchar](20) NULL,
		[BUYING_PARTY_NAME] [varchar](100) NULL,
		[BUYING_PARTY_ADDRESS_1] [varchar](100) NULL,
		[BUYING_PARTY_ADDRESS_2] [varchar](100) NULL,
		[BUYING_PARTY_CITY] [varchar](30) NULL,
		[BUYING_PARTY_STATE] [varchar](30) NULL,
		[BUYING_PARTY_ZIP] [varchar](30) NULL,
		[BUYING_PARTY_COUNTRY] [varchar](30) NULL,
		[BUYING_PARTY_CONTACT] [varchar](100) NULL,
		[BUYING_PARTY_PHONE] [varchar](30) NULL,
		[BUYING_PARTY_FAX] [varchar](30) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
		[SHIPMENT_DETAILS_KEY] [bigint] NOT NULL,
		[SHIPMENT_CONTAINERS_KEY] [bigint] IDENTITY(1,1) NOT NULL
	) ON [PRIMARY]


	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_DETAILS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_DETAILS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_DETAILS_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_DETAILS_T](
		[PARTNER_ID] [varchar](20) NULL,
		[SHIPMENT_ID] [varchar](30) NULL,
		[RETAILER_PO] [varchar](30) NULL,
		[RETAILER_PO_RELEASE] [varchar](30) NULL,
		[RETAILER_PO_DATE] [datetime] NULL,
		[BOL_NO] [varchar](30) NULL,
		[SELLER_INVOICE] [varchar](30) NULL,
		[VENDOR_ORDER] [varchar](30) NULL,
		[VENDOR_NUMBER] [varchar](30) NULL,
		[MERCHANDISE_TYPE] [varchar](30) NULL,
		[PROMOTION_CODE] [varchar](30) NULL,
		[DEPARTMENT] [varchar](30) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
		[SHIPMENT_DETAILS_KEY] [bigint] IDENTITY(1,1) NOT NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_HEADER_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_HEADER_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_HEADER_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_HEADER_T](
    	[SENDER_ID] [varchar](20) COLLATE Arabic_CI_AS NULL,
		[PARTNER_ID] [varchar](20) NOT NULL,
		[SHIPMENT_ID] [varchar](20) NOT NULL,
		[DATE] [datetime] NULL,
		[BOL] [varchar](30) NULL,
		[MASTER_BOL] [varchar](30) NULL,
		[ALTERNATE_BOL] [varchar](30) NULL,
		[LADING_QUANTITY] [int] NULL,
		[GROSS_WEIGHT] [decimal](13, 2) NULL,
		[WEIGHT_UOM] [varchar](20) NULL,
		[SHIP_FROM_LOCATION] [varchar](20) NULL,
		[SHIP_FROM_GLN_NUMBER] [varchar](20) NULL,
		[SHIP_FROM_DUNS_NUMBER] [varchar](20) NULL,
		[SHIP_FROM_NAME] [varchar](100) NULL,
		[SHIP_FROM_ADDRESS_1] [varchar](100) NULL,
		[SHIP_FROM_ADDRESS_2] [varchar](100) NULL,
		[SHIP_FROM_CITY] [varchar](30) NULL,
		[SHIP_FROM_STATE] [varchar](30) NULL,
		[SHIP_FROM_ZIP] [varchar](30) NULL,
		[SHIP_FROM_COUNTRY] [varchar](30) NULL,
		[SHIP_FROM_CONTACT] [varchar](100) NULL,
		[SHIP_FROM_PHONE] [varchar](30) NULL,
		[SHIP_FROM_FAX] [varchar](30) NULL,
		[SHIP_TO_LOCATION] [varchar](20) NULL,
		[SHIP_TO_GLN_NUMBER] [varchar](20) NULL,
		[SHIP_TO_DUNS_NUMBER] [varchar](20) NULL,
		[SHIP_TO_NAME] [varchar](100) NULL,
		[SHIP_TO_ADDRESS_1] [varchar](100) NULL,
		[SHIP_TO_ADDRESS_2] [varchar](100) NULL,
		[SHIP_TO_CITY] [varchar](30) NULL,
		[SHIP_TO_STATE] [varchar](30) NULL,
		[SHIP_TO_ZIP] [varchar](30) NULL,
		[SHIP_TO_COUNTRY] [varchar](30) NULL,
		[SHIP_TO_CONTACT] [varchar](100) NULL,
		[SHIP_TO_PHONE] [varchar](30) NULL,
		[SHIP_TO_FAX] [varchar](30) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] IDENTITY(1,1) NOT NULL,
	 CONSTRAINT [PK_SHIPMENT_HEADER_T_1] PRIMARY KEY CLUSTERED
	(
		[PARTNER_ID] ASC,
		[SHIPMENT_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ITEM_CONTAINERS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_ITEM_CONTAINERS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ITEM_CONTAINERS_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_ITEM_CONTAINERS_T](
		[PARTNER_ID] [varchar](20) NULL,
		[SHIPMENT_ID] [varchar](30) NULL,
		[RETAILER_PO] [varchar](30) NULL,
		[QUANTITY_SHIPPED] [int] NULL,
		[UOM] [varchar](20) NULL,
		[SHIPMENT_STATUS] [varchar](100) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
		[SHIPMENT_ITEMS_KEY] [bigint] NOT NULL,
		[SHIPMENT_CONTAINERS_KEY] [bigint] NOT NULL,
		[SHIPMENT_ITEM_CONTAINERS_KEY] [bigint] IDENTITY(1,1) NOT NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ITEMS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_ITEMS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ITEMS_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_ITEMS_T](
		[PARTNER_ID] [varchar](20) NULL,
		[SHIPMENT_ID] [varchar](30) NULL,
		[VENDOR_ITEM] [varchar](50) NULL,
		[VENDOR_STYLE] [varchar](50) NULL,
		[VENDOR_COLOR] [varchar](50) NULL,
		[VENDOR_SIZE] [varchar](50) NULL,
		[BUYER_ITEM] [varchar](50) NULL,
		[BUYER_STYLE] [varchar](50) NULL,
		[BUYER_COLOR] [varchar](50) NULL,
		[BUYER_SIZE] [varchar](50) NULL,
		[COLOR_NRF] [varchar](50) NULL,
		[SIZE_NRF] [varchar](50) NULL,
		[UPC_NUMBER] [varchar](50) NULL,
		[INNER_CONTAINERS] [int] NULL,
		[QUANTITY_SHIPPED] [int] NULL,
		[QUANTITY_ORDERED] [int] NULL,
		[UOM] [varchar](20) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
		[SHIPMENT_ITEMS_KEY] [bigint] IDENTITY(1,1) NOT NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ROUTING_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SHIPMENT_ROUTING_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SHIPMENT_ROUTING_T]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[SHIPMENT_ROUTING_T](
		[PARTNER_ID] [varchar](20) NULL,
		[SHIPMENT_ID] [varchar](30) NULL,
		[ROUTING_SEQUENCE] [varchar](50) NULL,
		[CARRIER_CODE] [varchar](50) NULL,
		[TRANSPORTATION_METHOD] [varchar](50) NULL,
		[ROUTING_DESCRIPTION] [text] NULL,
		[SHIPPER_TRACKING_NUMBER] [varchar](50) NULL,
		[TRANSIT_TIME] [varchar](20) NULL,
		[SERVICE_LEVEL] [varchar](30) NULL,
		[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
		[SHIPMENT_ROUTING_KEY] [bigint] IDENTITY(1,1) NOT NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_CHARGES_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVOICE_CHARGES_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_CHARGES_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[INVOICE_CHARGES_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[SERVICE_TYPE] [varchar](2) NULL,
	[SERVICE_CODE] [varchar](20) NULL,
	[SERVICE_DESCRIPTION] [text] NULL,
	[AMOUNT] [decimal](13, 2) NULL,
	[PERCENT] [decimal](6, 2) NULL,
	[HANDLING_METHOD] [char](2) NULL,
	[INVOICE_CHARGES_KEY] [int] NOT NULL IDENTITY (1, 1));

	SET ANSI_PADDING OFF

END 

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicdc]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdicdc]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicdc]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sycdicdc](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[ceditrntyp] [char](3) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dlok_date] [datetime] NULL,
	[llok_stat] [bit] NULL,
	[trandesc] [char](255) NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[sycdicdc] ADD  CONSTRAINT [DF__sycdicdc__rec_no__22AA2996]  DEFAULT (newid()) FOR [rec_no]

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicel]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdicel]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicel]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sycdicel](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[cusage] [char](1) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dicelmno] [char](6) NULL,
	[dlok_date] [datetime] NULL,
	[fldtype] [char](3) NULL,
	[fld_desc] [char](255) NULL,
	[f_order] [char](3) NULL,
	[llok_stat] [bit] NULL,
	[maximum] [char](8) NULL,
	[minimum] [char](8) NULL,
	[related] [char](12) NULL,
	[segid] [char](3) NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]


SET ANSI_PADDING OFF
ALTER TABLE [dbo].[sycdicel] ADD  DEFAULT (newid()) FOR [rec_no]

END 

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdiclp]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdiclp]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdiclp]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sycdiclp](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[cdesc1] [char](255) NULL,
	[ceditrntyp] [char](3) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[cloop_id] [char](12) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dlok_date] [datetime] NULL,
	[llok_stat] [bit] NULL,
	[loop_id] [char](3) NULL,
	[loop_max] [char](12) NULL,
	[segid] [char](3) NULL,
	[sg_order] [char](8) NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[sycdiclp] ADD  DEFAULT (newid()) FOR [rec_no]

END 

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicpr]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdicpr]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicpr]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sycdicpr](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[ceditrntyp] [char](3) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[color] [char](6) NULL,
	[cpartcode] [char](6) NULL,
	[cpartgsid] [char](15) NULL,
	[cpartid] [char](15) NULL,
	[cpartname] [char](30) NULL,
	[cpartqual] [char](2) NULL,
	[c_jpg] [char](255) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dlok_date] [datetime] NULL,
	[fntcolor] [char](6) NULL,
	[llok_stat] [bit] NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[sycdicpr] ADD  DEFAULT (newid()) FOR [rec_no]

END 

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicql]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdicql]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicql]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sycdicql](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[ccode_no] [char](6) NULL,
	[cdesc1] [char](255) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dicelmno] [char](6) NULL,
	[dlok_date] [datetime] NULL,
	[llok_stat] [bit] NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[sycdicql] ADD  DEFAULT (newid()) FOR [rec_no]

END 

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicst]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[sycdicst]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[sycdicst]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sycdicst](
	[cadd_time] [char](11) NULL,
	[cadd_user] [char](10) NULL,
	[cadd_ver] [char](3) NULL,
	[ceditrntyp] [char](3) NULL,
	[cedit_time] [char](11) NULL,
	[cedit_user] [char](10) NULL,
	[cedt_ver] [char](3) NULL,
	[clok_time] [char](8) NULL,
	[clok_user] [char](10) NULL,
	[cloop_id] [char](12) NULL,
	[cusage] [char](1) NULL,
	[dadd_date] [datetime] NULL,
	[dedit_date] [datetime] NULL,
	[dlok_date] [datetime] NULL,
	[llok_stat] [bit] NULL,
	[loop_id] [char](3) NULL,
	[loop_max] [char](10) NULL,
	[maximum] [char](8) NULL,
	[segid] [char](3) NULL,
	[seg_desc] [char](255) NULL,
	[sg_order] [char](8) NULL,
	[rec_no] [uniqueidentifier] NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[sycdicst] ADD  CONSTRAINT [DF__sycdicst__rec_no__30F848ED]  DEFAULT (newid()) FOR [rec_no]
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SYCEDILOG]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[SYCEDILOG]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[SYCEDILOG]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[SYCEDILOG](
	[CCLIENTID] [varchar](5) NULL,
	[ROWGUIDEID] [uniqueidentifier] NOT NULL,
	[USER_ID] [varchar](20) NOT NULL,
	[EDI_TRANSACTION_TYPE] [varchar](3) NULL,
	[PARTNER_CODE] [varchar](6) NULL,
	[VERSION] [varchar](12) NULL,
	[MAPSET] [varchar](3) NULL,
	[LOOP_ID] [varchar](3) NULL,
	[SEGMENT_ID] [varchar](8) NULL,
	[USAGE] [varchar](1) NULL,
	[NEW_USAGE] [varchar](1) NULL,
	[FIELD_NAME] [varchar](20) NULL,
	[NEW_FIELD_NAME] [varchar](20) NULL,
	[FIELD_CONDITION] [varchar](120) NULL,
	[NEW_FIELD_CONDITION] [varchar](120) NULL,
	[FIELD_VALUE] [varchar](120) NULL,
	[NEW_FIELD_VALUE] [varchar](120) NULL,
	[TYPE] [varchar](10) NULL,
	[FIELD_ORDER] [numeric](2, 0) NULL,
	[ACTION_FLAG] [bit] NULL,
	[REPORT_NAME_BEFORE] [varchar](12) NULL,
	[LABEL_TYPE] [char](6) NULL,
	[REPORT_NAME_AFTER] [varchar](120) NULL,
	[SESSION_DATE] [datetime] NOT NULL,
	[SESSION_ID] [varchar](14) NOT NULL,	
 CONSTRAINT [PK_SYCEDILOG] PRIMARY KEY CLUSTERED 
(
	[ROWGUIDEID] ASC,
	[USER_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_LOCATIONS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVOICE_LOCATIONS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_LOCATIONS_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[INVOICE_LOCATIONS_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[LOCATION_TYPE] [varchar](2) NULL,
	[LOCATION] [varchar](20) NULL,
	[GLN_NUMBER] [varchar](13) NULL,
	[DUNS_NUMBER] [varchar](9) NULL,
	[NAME] [varchar](100) NULL,
	[ADDRESS_1] [varchar](100) NULL,
	[ADDRESS_2] [varchar](100) NULL,
	[CITY] [varchar](30) NULL,
	[STATE] [varchar](30) NULL,
	[ZIP] [varchar](30) NULL,
	[COUNTRY] [varchar](30) NULL,
	[CONTACT] [varchar](100) NULL,
	[PHONE] [varchar](30) NULL,
	[FAX] [varchar](30) NULL,
	[INVOICE_LOCATIONS_KEY] [int] NOT NULL IDENTITY (1, 1));

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_HEADER_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVOICE_HEADER_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_HEADER_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[INVOICE_HEADER_T](
	[SENDER_ID] [varchar](20) NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[DATE] [datetime] NULL,
	[SHIP_DATE] [datetime] NULL,
	[RETAILER_PO] [varchar](30) NULL,
	[RETAILER_PO_RELEASE] [varchar](30) NULL,
	[RETAILER_PO_DATE] [datetime] NULL,
	[CONSOLIDATED_INVOICE] [varchar](30) NULL,
	[BOL] [varchar](30) NULL,
	[PURCHASER_CURRENCY] [varchar](10) NULL,
	[SELLING_CURRENCY] [varchar](10) NULL,
	[EXCHANGE_RATE] [decimal](13, 4) NULL,
	[EFFECTIVE_DATE] [datetime] NULL,
	[CONTRACT_NUMBER] [varchar](20) NULL,
	[DEPARTMENT] [varchar](30) NULL,
	[PROMOTION_CODE] [varchar](30) NULL,
	[MERCHANDISE_TYPE] [varchar](30) NULL,
	[VENDOR_ORDER] [varchar](30) NULL,
	[VENDOR_NUMBER] [varchar](30) NULL,
	[TERMS_DISCOUNT_PERCENT] [decimal](6, 2) NULL,
	[TERMS_DISCOUNT_AMOUNT] [decimal](13, 2) NULL,
	[TERMS_DISCOUNT_DUE_DATE] [datetime] NULL,
	[TERMS_DISCOUNT_DAYS_DUE] [int] NULL,
	[TERMS_NET_DUE_DATE] [datetime] NULL,
	[TERMS_NET_DAYS] [int] NULL,
	[TERMS_DESCRIPTION] [text] NULL,
	[CARTONS] [int] NULL,
	[PIECES] [int] NULL,
	[WEIGHT] [decimal](13, 2) NULL,
	[WEIGHT_UOM] [varchar](20) NULL,
	[VOLUME] [decimal](13, 2) NULL,
	[VOLUME_UOM] [varchar](20) NULL,
	[INVOICE_AMOUNT] [decimal](13, 2) NULL,
	[SHIP_AMOUNT] [decimal](13, 2) NULL,
	[TRANSPORTATION] [text] NULL,
	[EQUIPMENT_NUMBER] [varchar](20) NULL,
	[ROUTING] [text] NULL,
	[INVOICE_HEADER_KEY] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_INVOICE_HEADER_T] PRIMARY KEY CLUSTERED 
(
	[PARTNER_ID] ASC,
	[INVOICE_NUMBER] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	SET ANSI_PADDING OFF

END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_DETAILS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[INVOICE_DETAILS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[INVOICE_DETAILS_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[INVOICE_DETAILS_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[ARSTATUS] [varchar](50) NULL,
	[VENDOR_ITEM] [varchar](50) NULL,
	[VENDOR_STYLE] [varchar](50) NULL,
	[VENDOR_COLOR] [varchar](50) NULL,
	[VENDOR_SIZE] [varchar](50) NULL,
	[ITEM_DESCRIPTION] [varchar](80) NULL,
	[ITEM_DESCRIPTION1] [varchar](80) NULL,
	[COLOR_DESCRIPTION] [varchar](80) NULL,
	[SIZE_DESCRIPTION] [varchar](80) NULL,
	[BUYER_ITEM] [varchar](50) NULL,
	[BUYER_STYLE] [varchar](50) NULL,
	[BUYER_COLOR] [varchar](50) NULL,
	[BUYER_SIZE] [varchar](50) NULL,
	[COLOR_NRF] [varchar](50) NULL,
	[SIZE_NRF] [varchar](50) NULL,
	[UPC_NUMBER] [varchar](50) NULL,
	[QUANTITY_INVOICED] [int] NULL,
	[PACK] [int] NULL,
	[INNER_PACK] [int] NULL,
	[UOM] [varchar](20) NULL,
	[UNIT_PRICE] [decimal](15, 2) NULL,
	[GROSS_PRICE] [decimal](15, 2) NULL,
	[DISCOUNT_PERCENT] [decimal](6, 2) NULL,
	[RETAIL_PRICE] [decimal](15, 2) NULL,
	[UNIT_COST] [decimal](15, 2) NULL,
	[CATALOG_PRICE] [decimal](15, 2) NULL,
	[PROMOTIONAL_PRICE] [decimal](15, 2) NULL,
	[INVOICE_DETAILS_KEY] [int] NOT NULL IDENTITY (1, 1));

	SET ANSI_PADDING OFF
END 


IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[edifiles]') AND type in (N'U'))
BEGIN 
drop index [rec_no] ON [dbo].[edifiles]

drop index [edifilespk] ON [dbo].[edifiles]

drop index [edifilesfk] ON [dbo].[edifiles]

alter table [edifiles] 
alter column [line_no] numeric(6,0) null

/****** Object:  Index [rec_no]    Script Date: 10/06/2011 13:30:40 ******/
CREATE NONCLUSTERED INDEX [rec_no] ON [dbo].[edifiles] 
(
	[rec_no] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

/****** Object:  Index [edifilespk]    Script Date: 10/06/2011 13:30:34 ******/
CREATE NONCLUSTERED INDEX [edifilespk] ON [dbo].[edifiles] 
(
	[cedifiltyp] ASC,
	[cpartcode] ASC,
	[cintchgseq] ASC,
	[cgroupseq] ASC,
	[ceditrntyp] ASC,
	[ctranseq] ASC,
	[loop_id] ASC,
	[cloop_id] ASC,
	[line_no] ASC,
	[f_order] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

/****** Object:  Index [edifilesfk]    Script Date: 10/06/2011 13:41:30 ******/
CREATE NONCLUSTERED INDEX [edifilesfk] ON [dbo].[edifiles] 
(
	[cedifiltyp] ASC,
	[cfilecode] ASC,
	[cpartcode] ASC,
	[cintchgseq] ASC,
	[cgroupseq] ASC,
	[ceditrntyp] ASC,
	[ctranseq] ASC,
	[loop_id] ASC,
	[cloop_id] ASC,
	[line_no] ASC,
	[f_order] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

  ENDTEXT

  LOCAL lcEnd
  TEXT TO lcEnd

COMMIT;
  ENDTEXT
  SCRPT = SCRPT + lcLineFeed +lcEnd
  SCRPT = TEXTMERGE(SCRPT)
  SET TEXTMERGE &lcMergeSetting.
  * HES

  * Get the SQL Connection Settings(Server name , DB Name , User Name , Password) for each company
  IF !USED("SYCCOMP")
     USE lcSysDir+"SYCCOMP" SHARE IN 0
  ENDIF
  SELECT  SYCCOMP
  SCAN
    lcServName = ALLT(cconserver)
    lcDBasName = ALLT(ccondbname)
    lcUserName = ALLT(cconuserid)
    lcPassWord = ALLT(cconpaswrd)
    lnHand=SQLSTRINGCONNECT("driver={SQL Server};server="+lcServName+";DATABASE="+lcDBasName+";uid="+lcUserName+";pwd="+lcPassWord)
    lnAriaMasterHand=SQLSTRINGCONNECT("driver={SQL Server};server="+lcServName+";DATABASE=aria.master;uid="+lcUserName+";pwd="+lcPassWord)    
    IF(lnHand > 0)
      * Loop for each FoxPro DBF files to insert it in SQL
      
      SET STEP ON

      * HES
      lnRemResult = SQLEXEC(lnHand,"SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[ELECTRONIC_TRANSACTIONS_T]') AND type in (N'U')","Checker")
      select Checker
      if reccount() > 0
        lnRes=SQLEXEC(lnHand,"Drop table [dbo].[ELECTRONIC_TRANSACTIONS_T]") 
      endif
      lnRes=SQLEXEC(lnHand,SCRPT)
      IF lnRes < 1
        =MESSAGEBOX('Updating SQL Standards Failed',16,'Update SQL Standards')
        RETURN
      ENDIF
      * HES      
      
      FOR i=1 TO ALEN(FileNames)
        USE FileNames[i] SHARED IN 0
        SELECT FileNames[i]
        * Use MBuildString Function to get sql insert command for the selected table
        SQLCommand = mbuildstring(FileNames[i])
        * Delete whole data in SQL Table before inserting
        WAIT WINDOW "Truncate Table " + FileNames[i] NOWAIT

        lnRes=SQLEXEC(lnHand,"Truncate Table " + FileNames[i] )
        IF(lnRes > 0)
          * Insert row by row in SQL Table from the FoxPro DBF
          SCAN
            WAIT WINDOW "Update Table " + FileNames[i] NOWAIT
            SCATTER MEMV MEMO
            lnRes=SQLEXEC(lnHand,SQLCommand )
          ENDSCAN
        ELSE
          lnRes=SQLEXEC(lnHand,"Create Table " + FileNames[i] )
          IF lnRes > 0
            SCAN
              WAIT WINDOW "Update Table " + FileNames[i] NOWAIT
              SCATTER MEMV MEMO
              lnRes=SQLEXEC(lnHand,SQLCommand )
            ENDSCAN
          ELSE
            MESSAGEBOX('Failed to create table ' + FileNames[i])
          ENDIF
        ENDIF
        USE IN FileNames[i]
      ENDFOR

    ELSE
      MESSAGEBOX("Couldn't Connect to Data Base : " + lcDBasName ,0,"Update SQL Mapppings Dictionary")
      RETURN
    ENDIF

  ENDSCAN
  
  * HES ========================================================================================================
  LOCAL AriaSCRPT
  lcMergeSetting = SET("Textmerge")
  SET TEXTMERGE OFF

  TEXT TO AriaSCRPT NOSHOW
BEGIN TRANSACTION

use [Aria.Master]

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[TRANSACTION_SEGMENTS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[TRANSACTION_SEGMENTS_T]
 
END 



IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[TRANSACTION_MAP_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRANSACTION_MAP_T] (
	[TRANSACTION_SEGMENTS_KEY] [int] NOT NULL,
	[FIELD_ORDER] [smallint] NOT NULL,
	[START_POSITION] [smallint] NULL,
	[FIELD_LENGTH] [smallint] NULL,
	[FIELD_NAME] [varchar](20) NOT NULL,
	[CONDITION] [text] NULL,
	[VALUE] [text] NULL,
	[DATA_TYPE] [char](2) NULL,
	[USAGE] [char](1) NULL,
	[TRANSACTION_MAP_KEY] [int] NOT NULL)
	
INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 1, 1, 5, N'MSEGID', N'', N'', N'C ', N'M', 1)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 2, 6, 20, N'FIELD', N'', N'', N'C ', N'O', 2)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 3, 26, 20, N'FIELD', N'', N'', N'C ', N'O', 3)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 17, 285, 40, N'AFIELDS(17)', N'', N'MSTNAME', N'C ', N'M', 102)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 5, 66, 25, N'MCUSTPO', N'', N'', N'C ', N'O', 5)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 6, 91, 11, N'MSTART', N'', N'', N'D ', N'O', 6)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 7, 102, 11, N'MCOMPLETE', N'', N'', N'D ', N'O', 7)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 9, 121, 40, N'MNOTE', N'', N'', N'O ', N'O', 8)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 10, 161, 40, N'MNOTE', N'', N'', N'O ', N'O', 9)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 11, 201, 40, N'MNOTE', N'', N'', N'O ', N'O', 10)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 12, 241, 40, N'MNOTE', N'', N'', N'O ', N'O', 11)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 13, 281, 40, N'MNOTE', N'', N'', N'O ', N'O', 12)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 15, 341, 11, N'MCANCEL', N'', N'', N'D ', N'O', 13)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 17, 353, 35, N'MSTNAME', N'', N'', N'C ', N'O', 14)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 18, 388, 40, N'MSTADD1', N'', N'', N'C ', N'O', 15)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 19, 428, 40, N'MSTADD2', N'', N'', N'C ', N'O', 16)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 20, 468, 30, N'MSTCITY', N'', N'', N'C ', N'O', 17)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 21, 598, 25, N'MSTSTATE', N'', N'', N'C ', N'O', 18)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 22, 523, 10, N'MSTZIP', N'', N'', N'C ', N'O', 19)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 23, 533, 13, N'MACCOUNTID', N'', N'', N'C ', N'M', 20)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 24, 546, 13, N'MSTOREGLN', N'', N'', N'C ', N'O', 21)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 25, 559, 17, N'MSTORE', N'', N'', N'C ', N'O', 22)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 35, 700, 13, N'MBSTOREGLN', N'', N'', N'C ', N'O', 23)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 36, 713, 17, N'MBSTORE', N'', N'', N'C ', N'O', 24)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (1, 37, 730, 20, N'MDEPT', N'', N'', N'C ', N'O', 25)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 3, 10, 30, N'MSTYL', N'', N'', N'C ', N'O', 26)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 5, 60, 10, N'MQTY', N'', N'', N'N ', N'M', 27)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 6, 70, 13, N'MUPC', N'', N'', N'C ', N'O', 28)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 7, 83, 10, N'MSTYLE', N'', N'', N'G ', N'O', 29)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 10, 135, 12, N'MPRICE', N'', N'', N'N ', N'O', 30)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (4, 11, 147, 40, N'MNOTE', N'', N'', N'O ', N'O', 31)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 1, 1, 5, N'AFIELDS(1)', N'', N'[HEAD]', N'C ', N'M', 32)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 2, 6, 20, N'AFIELDS(2)', N'', N'MSENDERID', N'C ', N'M', 33)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 3, 26, 20, N'AFIELDS(3)', N'', N'MRECEIVERID', N'C ', N'M', 34)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 4, 46, 20, N'AFIELDS(4)', N'', N'MSTORE', N'C ', N'M', 35)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 5, 66, 25, N'AFIELDS(5)', N'', N'XINVOICE', N'C ', N'M', 36)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 6, 91, 11, N'AFIELDS(6)', N'', N'MINVDTE', N'D ', N'M', 37)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 7, 102, 25, N'AFIELDS(7)', N'', N'MCUSTPO', N'C ', N'M', 38)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 8, 127, 11, N'AFIELDS(8)', N'', N'MENTERED', N'D ', N'M', 39)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 12, 199, 11, N'AFIELDS(12)', N'', N'MSHIPDATE', N'D ', N'M', 40)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 14, 218, 50, N'AFIELDS(14)', N'', N'MTERMS_DAT', N'C ', N'M', 41)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 15, 268, 11, N'AFIELDS(15)', N'', N'MDUEDATE', N'D ', N'M', 42)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 22, 453, 1, N'AFIELDS(22)', N'', N'[N]', N'C ', N'M', 43)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 23, 454, 13, N'AFIELDS(23)', N'', N'MSTOREGLN', N'C ', N'M', 44)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 1, 1, 5, N'AFIELDS(1)', N'', N'[LINE]', N'C ', N'M', 45)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 2, 6, 30, N'AFIELDS(2)', N'', N'MSTYLE', N'C ', N'M', 46)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 4, 56, 5, N'AFIELDS(4)', N'XPCKQTY <> 0', N'XPCKQTY', N'N0', N'C', 47)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 7, 76, 10, N'AFIELDS(7)', N'', N'XTOTQTY', N'N0', N'O', 48)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 10, 101, 10, N'AFIELDS(10)', N'', N'XGRSPRICE', N'N2', N'M', 49)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 11, 111, 6, N'AFIELDS(11)', N'', N'XDISC_PCNT', N'N2', N'M', 50)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 12, 117, 10, N'AFIELDS(12)', N'', N'XLNDSCAMT', N'N2', N'M', 51)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 13, 127, 10, N'AFIELDS(13)', N'', N'XPRICE', N'N2', N'M', 52)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 14, 137, 5, N'AFIELDS(14)', N'', N'XTAXRATE', N'N0', N'M', 53)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 15, 142, 10, N'AFIELDS(15)', N'', N'XTOTQTY*XGRSPRICE', N'N2', N'M', 54)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 16, 152, 10, N'AFIELDS(16)', N'', N'XTOTQTY*XPRICE', N'N2', N'M', 55)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 17, 162, 1, N'AFIELDS(17)', N'XDISC_PCNT = 0', N'[N]', N'C ', N'M', 56)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 17, 162, 1, N'AFIELDS(17)', N'XDISC_PCNT > 0', N'[Y]', N'C ', N'M', 57)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 18, 163, 13, N'AFIELDS(18)', N'', N'XUPC', N'C ', N'M', 58)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 19, 176, 30, N'AFIELDS(19)', N'', N'XSKU', N'C ', N'M', 59)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 1, 1, 5, N'AFIELDS(1)', N'', N'[VAT]', N'C ', N'M', 60)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 2, 6, 5, N'AFIELDS(2)', N'', N'XTAXRATE', N'N0', N'M', 61)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 3, 11, 4, N'AFIELDS(3)', N'', N'MCTT', N'N0', N'M', 62)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 4, 15, 10, N'AFIELDS(4)', N'', N'XSHIPAMT', N'N2', N'M', 63)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 5, 25, 10, N'AFIELDS(5)', N'', N'XSHIPAMT', N'N2', N'M', 64)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 6, 35, 10, N'AFIELDS(6)', N'', N'XDISC', N'N2', N'M', 65)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (11, 7, 45, 10, N'AFIELDS(7)', N'', N'XTAX', N'N3', N'M', 66)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (12, 1, 1, 5, N'AFIELDS(1)', N'', N'[TLR]', N'C ', N'M', 67)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (12, 2, 6, 10, N'AFIELDS(2)', N'', N'XSHIPAMT', N'N2', N'M', 68)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (12, 6, 46, 10, N'AFIELDS(6)', N'', N'XDISC', N'N2', N'M', 69)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (12, 7, 56, 10, N'AFIELDS(7)', N'', N'XTAX', N'N2', N'M', 70)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 1, 1, 5, N'AFIELDS(1)', N'', N'[HEAD]', N'C ', N'M', 71)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 3, 26, 13, N'AFIELDS(3)', N'', N'MSENDERID', N'C ', N'M', 72)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 5, 56, 13, N'AFIELDS(5)', N'', N'MRECEIVERID', N'C ', N'M', 73)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 9, 116, 17, N'AFIELDS(9)', N'', N'MSHIP_CODE', N'C ', N'M', 74)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 10, 133, 13, N'AFIELDS(10)', N'', N'MSHIPTOGLN', N'C ', N'M', 75)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 12, 163, 30, N'AFIELDS(12)', N'', N'MBOL_NO', N'C ', N'M', 76)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 14, 213, 10, N'AFIELDS(14)', N'', N'MSHIP_DATE', N'D ', N'M', 77)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 16, 231, 30, N'AFIELDS(16)', N'', N'MCUSTPO', N'C ', N'M', 78)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 17, 261, 10, N'AFIELDS(17)', N'', N'MORDDATE', N'D ', N'M', 79)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 18, 271, 4, N'AFIELDS(18)', N'', N'MSHIPCART', N'N0', N'M', 80)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (13, 19, 275, 7, N'AFIELDS(19)', N'', N'MSHIPPCS', N'N0', N'M', 81)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 1, 1, 5, N'AFIELDS(1)', N'', N'[SUNIT]', N'C ', N'M', 82)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 2, 6, 15, N'AFIELDS(2)', N'', N'[PACKAGE]', N'C ', N'M', 83)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 3, 21, 17, N'AFIELDS(3)', N'', N'MSTORE', N'C ', N'M', 84)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 4, 38, 13, N'AFIELDS(4)', N'', N'MBILLTOGLN', N'C ', N'M', 85)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 10, 96, 7, N'AFIELDS(10)', N'', N'MCRTWGHT', N'N2', N'M', 86)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 11, 103, 4, N'AFIELDS(11)', N'', N'[SSCC]', N'C ', N'M', 87)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 12, 107, 30, N'AFIELDS(4)', N'', N'XBOX_SER', N'C ', N'M', 88)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 14, 154, 30, N'AFIELDS(16)', N'', N'MCUSTPO', N'C ', N'M', 89)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 15, 184, 10, N'AFIELDS(17)', N'', N'MORDDATE', N'D ', N'M', 90)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (14, 16, 194, 10, N'AFIELDS(17)', N'', N'MMCRTNQTY', N'N0', N'M', 91)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 1, 1, 5, N'AFIELDS(1)', N'', N'[LINE]', N'C ', N'M', 92)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 3, 26, 30, N'AFIELDS(3)', N'', N'MSYLE', N'C ', N'M', 93)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 5, 70, 13, N'AFIELDS(5)', N'', N'MUPC', N'C ', N'M', 94)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 6, 83, 17, N'AFIELDS(6)', N'', N'MSKU', N'O ', N'M', 95)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 9, 111, 10, N'AFIELDS(9)', N'', N'MORGQTY', N'N0', N'M', 96)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (15, 11, 131, 10, N'AFIELDS(11)', N'', N'MQTY', N'N0', N'M', 97)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 24, 467, 17, N'AFIELDS(24)', N'', N'MSTORE', N'C ', N'M', 98)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 30, 395, 1, N'AFIELDS(30)', N'', N'MINVARSTAT', N'C ', N'M', 99)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 25, 272, 40, N'AFIELDS(25)', N'', N'MSTYDESC', N'C ', N'M', 100)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (10, 26, 312, 40, N'AFIELDS(26)', N'', N'MSTYDESC1', N'C ', N'M', 101)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 18, 325, 40, N'AFIELDS(18)', N'', N'MSTADDR', N'C ', N'M', 103)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 19, 365, 40, N'AFIELDS(19)', N'', N'MSTADDR2', N'C ', N'M', 104)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 20, 365, 40, N'AFIELDS(20)', N'', N'MSTCITY', N'C ', N'M', 105)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 21, 405, 8, N'AFIELDS(21)', N'', N'MSTZIP', N'C ', N'M', 106)


INSERT INTO [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY])
	VALUES (9, 11, 174, 25, N'AFIELDS(11)', N'', N'XINVOICE', N'C ', N'M', 107)	
	
END

IF EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[TRANSACTION_SEGMENTS_T]') AND type in (N'U'))
BEGIN 
 Drop table [dbo].[TRANSACTION_SEGMENTS_T] 
END 

IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE [id] = OBJECT_ID(N'[dbo].[TRANSACTION_SEGMENTS_T]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRANSACTION_SEGMENTS_T] (
	[DIRECTION] [char](1) NOT NULL,
	[TRANSACTION_TYPE] [varchar](20) NOT NULL,
	[MAP_SET] [varchar](20) NOT NULL,
	[VERSION] [varchar](20) NOT NULL,
	[LOOP_ID] [varchar](10) NOT NULL,
	[SEGMENT_ORDER] [smallint] NOT NULL,
	[SEGMENT_ID] [varchar](10) NOT NULL,
	[USAGE] [char](1) NULL,
	[TRANSACTION_SEGMENTS_KEY] [int] NOT NULL)

INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'H-01', 1, N'HEAD', N'M', 1)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'H-01', 2, N'BRNCH', N'O', 2)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'H-01', 3, N'TEXT', N'O', 3)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'D-01', 1, N'LINE', N'M', 4)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'D-02', 1, N'DELIV', N'O', 5)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'D-03', 1, N'TEXT', N'O', 6)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'D-04', 1, N'SCHED', N'O', 7)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'R', N'850', N'FRW', N'2.806.0042', N'R-01', 1, N'RECON', N'M', 8)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'810', N'FRW', N'2.806.0042', N'H-01', 1, N'HEAD', N'M', 9)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'810', N'FRW', N'2.806.0042', N'D-01', 1, N'LINE', N'M', 10)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'810', N'FRW', N'2.806.0042', N'T-01', 1, N'VAT', N'M', 11)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'810', N'FRW', N'2.806.0042', N'T-01', 2, N'TLR', N'M', 12)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'856', N'FRW', N'2.806.0042', N'H-01', 1, N'HEAD', N'M', 13)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'856', N'FRW', N'2.806.0042', N'P-01', 1, N'SUNIT', N'M', 14)


INSERT INTO [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY])
	VALUES (N'S', N'856', N'FRW', N'2.806.0042', N'I-01', 1, N'LINE', N'M', 15)
END

  ENDTEXT

  LOCAL lcEnd
  TEXT TO lcEnd

COMMIT;
  ENDTEXT
  AriaSCRPT = AriaSCRPT + lcLineFeed +lcEnd
  AriaSCRPT = TEXTMERGE(AriaSCRPT)
  SET TEXTMERGE &lcMergeSetting.  
  
  SET STEP ON 
  lnRes=SQLEXEC(lnHand,AriaSCRPT)
  IF lnRes > 1
    MESSAGEBOX("Aria.Master Database not found, please refer to Aria",16+512,"Faild!")
    RETURN 
  ENDIF 
  * HES ========================================================================================================

  =MESSAGEBOX('Updating SQL Mapppings Dictionary Done',64,'Update SQL Mapppings Dictionary')

  CLOSE DATA

ENDIF
**********************************************************************************************************************
*Function take DBF File as paramter and returns full sql in insert command that reads the data from memvar
*EX: MBuildString(FoxProDBFName)
*Ex: Insert into SQLTableName (Field1,Field2,...) Values (m.Value1,m.Value2,...)

FUNCTION mbuildstring
  PARAMETERS lcfileName
  LOCAL lcStr
  lcStr = ""    && Default return string by empty string.
  lcStr = "INSERT INTO " +lcfileName
  STORE "" TO lcStr1,lcStr2
  *--Loop on the cursor fields.
  FOR lnI=1 TO FCOUNT()
    *--Read field in variable.
    lcCField = FIELD(lnI)
    lcCFldDType = TYPE(lcCField)
    lcStr1 = lcStr1 +"["+lcCField+"],"
    IF UPPER(lcCField) = "REC_NO"
      lcStr2 = lcStr2 +"newid(),"
    ELSE
      lcStr2 = lcStr2 +"?m."+lcCField+","
    ENDIF
  ENDFOR

  *--Remove last comma,
  lcStr1 = SUBSTR(lcStr1,1,LEN(lcStr1)-1)
  lcStr2 = SUBSTR(lcStr2,1,LEN(lcStr2)-1)
  lcStr  = lcStr + " ( "+lcStr1+" ) VALUES ( "+lcStr2+" )"
  RETURN lcStr
ENDFUNC

