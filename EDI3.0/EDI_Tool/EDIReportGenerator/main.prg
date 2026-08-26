* EDI Report Generator
* Standalone Visual FoxPro 9 application.

SET TALK OFF
SET SAFETY OFF
SET DELETED ON
SET EXCLUSIVE OFF
SET MULTILOCKS ON
SET CENTURY ON
SET DATE YMD

PUBLIC gcAppFolder, gcConfigFile, gcSystemFilesPath
gcAppFolder = GetAppFolder()
gcConfigFile = ADDBS(gcAppFolder) + "EDIReportGenerator.ini"
gcSystemFilesPath = ""

IF NOT EnsureSystemFilesPath()
    RETURN
ENDIF

DO frmReportGenerator.prg
READ EVENTS
RETURN


FUNCTION GetAppFolder
    LOCAL lcProgram
    lcProgram = SYS(16, 0)
    IF ":" $ lcProgram OR LEFT(lcProgram, 2) == "\\"
        RETURN JUSTPATH(FULLPATH(lcProgram))
    ENDIF
    RETURN FULLPATH("")
ENDFUNC


FUNCTION EnsureSystemFilesPath
    LOCAL lcSavedPath, lcSelectedPath, lnEqualsAt
    lcSavedPath = ""

    IF FILE(gcConfigFile)
        lcSavedPath = ALLTRIM(CHRTRAN(FILETOSTR(gcConfigFile), CHR(13) + CHR(10) + CHR(9), ""))
        lnEqualsAt = AT("=", lcSavedPath)
        IF lnEqualsAt > 0
            lcSavedPath = ALLTRIM(SUBSTR(lcSavedPath, lnEqualsAt + 1))
        ENDIF
    ENDIF

    IF ValidSystemFilesPath(lcSavedPath)
        gcSystemFilesPath = NormalizeFolder(lcSavedPath)
        RETURN .T.
    ENDIF

    IF NOT EMPTY(lcSavedPath)
        MESSAGEBOX("The configured system-files folder is unavailable or does not contain SYCCOMP.DBF.", 48, "EDI Report Generator")
    ENDIF

    DO WHILE .T.
        lcSelectedPath = GETDIR("", "Select the system-files folder containing SYCCOMP.DBF", "Select System Files", 64)
        IF EMPTY(lcSelectedPath)
            RETURN .F.
        ENDIF

        IF ValidSystemFilesPath(lcSelectedPath)
            gcSystemFilesPath = NormalizeFolder(lcSelectedPath)
            STRTOFILE("SystemFilesPath=" + gcSystemFilesPath + CHR(13) + CHR(10), gcConfigFile, 0)
            RETURN .T.
        ENDIF

        MESSAGEBOX("SYCCOMP.DBF was not found in the selected folder. Please select the correct system-files folder.", 48, "EDI Report Generator")
    ENDDO
ENDFUNC


FUNCTION ValidSystemFilesPath
    LPARAMETERS tcPath
    LOCAL lcPath
    lcPath = NormalizeFolder(tcPath)
    RETURN NOT EMPTY(lcPath) AND FILE(ADDBS(lcPath) + "SYCCOMP.DBF")
ENDFUNC


FUNCTION NormalizeFolder
    LPARAMETERS tcPath
    LOCAL lcPath
    lcPath = ALLTRIM(CHRTRAN(IIF(VARTYPE(tcPath) = "C", tcPath, ""), '"' + CHR(13) + CHR(10) + CHR(9), ""))
    DO WHILE LEN(lcPath) > 3 AND RIGHT(lcPath, 1) $ "\/"
        lcPath = LEFT(lcPath, LEN(lcPath) - 1)
    ENDDO
    RETURN lcPath
ENDFUNC


DEFINE CLASS frmReportGenerator AS Form
    Caption = "EDI Report Generator"
    Width = 650
    Height = 430
    AutoCenter = .T.
    MinButton = .F.
    MaxButton = .F.
    Closable = .T.
    BorderStyle = 2
    BackColor = RGB(245, 247, 250)
    cSystemFilesPath = ""
    cLastOutputFolder = ""

    ADD OBJECT lblCompany AS Label WITH ;
        Caption = "Company", Left = 24, Top = 25, Width = 90, Height = 22, FontBold = .T.
    ADD OBJECT cboCompany AS ComboBox WITH ;
        Left = 120, Top = 20, Width = 490, Height = 28, Style = 2

    ADD OBJECT shpDates AS Shape WITH ;
        Left = 20, Top = 65, Width = 590, Height = 72, SpecialEffect = 0, BackColor = RGB(255,255,255)
    ADD OBJECT lblDateFrom AS Label WITH ;
        Caption = "Date from", Left = 40, Top = 91, Width = 75, Height = 22
    ADD OBJECT txtDateFrom AS TextBox WITH ;
        Left = 120, Top = 85, Width = 120, Height = 27, Value = {^2013-01-01}, Format = "D"
    ADD OBJECT lblDateTo AS Label WITH ;
        Caption = "Date to", Left = 330, Top = 91, Width = 60, Height = 22
    ADD OBJECT txtDateTo AS TextBox WITH ;
        Left = 395, Top = 85, Width = 120, Height = 27, Value = DATE(), Format = "D"

    ADD OBJECT lblReports AS Label WITH ;
        Caption = "Reports", Left = 24, Top = 158, Width = 90, Height = 22, FontBold = .T.
    ADD OBJECT chkRejected850 AS CheckBox WITH ;
        Caption = "Rejected 850", Left = 42, Top = 190, Width = 180, Height = 24, Value = 1
    ADD OBJECT chkOpen850 AS CheckBox WITH ;
        Caption = "Open 850 (not processed)", Left = 42, Top = 225, Width = 230, Height = 24, Value = 1
    ADD OBJECT chkRejected860 AS CheckBox WITH ;
        Caption = "Rejected 860", Left = 330, Top = 190, Width = 180, Height = 24, Value = 1
    ADD OBJECT chkOpen860 AS CheckBox WITH ;
        Caption = "Open 860 (not processed)", Left = 330, Top = 225, Width = 230, Height = 24, Value = 1
    ADD OBJECT chkTempOrders AS CheckBox WITH ;
        Caption = "Temp orders", Left = 42, Top = 260, Width = 180, Height = 24, Value = 1

    ADD OBJECT cmdGenerate AS CommandButton WITH ;
        Caption = "Generate reports", Left = 340, Top = 330, Width = 150, Height = 38, Default = .T., FontBold = .T.
    ADD OBJECT cmdClose AS CommandButton WITH ;
        Caption = "Close", Left = 505, Top = 330, Width = 105, Height = 38, Cancel = .T.
    ADD OBJECT lblStatus AS Label WITH ;
        Caption = "", Left = 24, Top = 385, Width = 465, Height = 22, ForeColor = RGB(60, 75, 90)
    ADD OBJECT cmdCopyPath AS CommandButton WITH ;
        Caption = "Copy path", Left = 505, Top = 378, Width = 105, Height = 30, Enabled = .F.

    PROCEDURE Init
        THIS.cSystemFilesPath = gcSystemFilesPath
        IF NOT THIS.LoadCompanies()
            RETURN .F.
        ENDIF
    ENDPROC

    PROCEDURE LoadCompanies
        LOCAL lcCompanyTable
        lcCompanyTable = ADDBS(THIS.cSystemFilesPath) + "SYCCOMP.DBF"

        IF USED("syccomp")
            USE IN syccomp
        ENDIF
        IF USED("curCompanies")
            USE IN curCompanies
        ENDIF

        TRY
            USE (lcCompanyTable) IN 0 SHARED ALIAS syccomp
            SELECT ALLTRIM(ccom_name) AS company_name, ;
                   ALLTRIM(ccomp_id) AS company_id, ;
                   ALLTRIM(ccom_ddir) AS data_dir ;
              FROM syccomp ;
             WHERE NOT DELETED() ;
             ORDER BY ccom_name ;
              INTO CURSOR curCompanies READWRITE
        CATCH TO loError
            MESSAGEBOX("Unable to load companies:" + CHR(13) + loError.Message, 16, "EDI Report Generator")
            RETURN .F.
        FINALLY
            IF USED("syccomp")
                USE IN syccomp
            ENDIF
        ENDTRY

        IF RECCOUNT("curCompanies") = 0
            MESSAGEBOX("No active companies were found in SYCCOMP.DBF.", 48, "EDI Report Generator")
            RETURN .F.
        ENDIF

        THIS.cboCompany.RowSourceType = 6
        THIS.cboCompany.RowSource = "curCompanies.company_name,company_id,data_dir"
        THIS.cboCompany.ColumnCount = 3
        THIS.cboCompany.ColumnWidths = "470,0,0"
        THIS.cboCompany.BoundColumn = 2
        THIS.cboCompany.ListIndex = 1
        RETURN .T.
    ENDPROC

    PROCEDURE cmdGenerate.Click
        THISFORM.GenerateReports()
    ENDPROC

    PROCEDURE cmdClose.Click
        THISFORM.Release()
    ENDPROC

    PROCEDURE cmdCopyPath.Click
        IF NOT EMPTY(THISFORM.cLastOutputFolder)
            _CLIPTEXT = THISFORM.cLastOutputFolder
            THISFORM.lblStatus.Caption = "Report path copied to the clipboard."
        ENDIF
    ENDPROC

    PROCEDURE GenerateReports
        LOCAL ldFrom, ldTo, lcCompanyId, lcConfiguredDataDir, lcDataDir
        LOCAL lcOutputFolder, lnGenerated, lcProblems

        ldFrom = THIS.txtDateFrom.Value
        ldTo = THIS.txtDateTo.Value
        IF VARTYPE(ldFrom) # "D" OR EMPTY(ldFrom) OR VARTYPE(ldTo) # "D" OR EMPTY(ldTo)
            MESSAGEBOX("Enter a valid Date from and Date to.", 48, "EDI Report Generator")
            RETURN
        ENDIF
        IF ldFrom > ldTo
            MESSAGEBOX("Date from cannot be later than Date to.", 48, "EDI Report Generator")
            RETURN
        ENDIF
        IF THIS.cboCompany.ListIndex < 1
            MESSAGEBOX("Select a company.", 48, "EDI Report Generator")
            RETURN
        ENDIF
        IF THIS.chkRejected850.Value = 0 AND THIS.chkOpen850.Value = 0 AND ;
           THIS.chkRejected860.Value = 0 AND THIS.chkOpen860.Value = 0 AND ;
           THIS.chkTempOrders.Value = 0
            MESSAGEBOX("Select at least one report.", 48, "EDI Report Generator")
            RETURN
        ENDIF

        GO (THIS.cboCompany.ListIndex) IN curCompanies
        lcCompanyId = ALLTRIM(curCompanies.company_id)
        lcConfiguredDataDir = ALLTRIM(curCompanies.data_dir)
        lcDataDir = THIS.ResolveCompanyDataFolder(lcConfiguredDataDir, lcCompanyId)
        IF EMPTY(lcDataDir)
            MESSAGEBOX("The database folder for company " + lcCompanyId + " could not be found." + CHR(13) + ;
                "Configured CCOM_DDIR: " + lcConfiguredDataDir, 16, "EDI Report Generator")
            RETURN
        ENDIF

        lcOutputFolder = ADDBS(gcAppFolder) + "Reports"
        IF NOT DIRECTORY(lcOutputFolder)
            MD (lcOutputFolder)
        ENDIF

        THIS.cmdGenerate.Enabled = .F.
        THIS.lblStatus.Caption = "Generating reports..."
        THISFORM.Refresh()
        lnGenerated = 0
        lcProblems = ""

        IF THIS.chkRejected850.Value = 1
            IF THIS.ExportEdiReport(lcDataDir, "850", "R", ldFrom, ldTo, ADDBS(lcOutputFolder) + "Rejected850.xls", @lcProblems)
                lnGenerated = lnGenerated + 1
            ENDIF
        ENDIF
        IF THIS.chkOpen850.Value = 1
            IF THIS.ExportEdiReport(lcDataDir, "850", "", ldFrom, ldTo, ADDBS(lcOutputFolder) + "NotProssed850.xls", @lcProblems)
                lnGenerated = lnGenerated + 1
            ENDIF
        ENDIF
        IF THIS.chkRejected860.Value = 1
            IF THIS.ExportEdiReport(lcDataDir, "860", "R", ldFrom, ldTo, ADDBS(lcOutputFolder) + "Rejected860.xls", @lcProblems)
                lnGenerated = lnGenerated + 1
            ENDIF
        ENDIF
        IF THIS.chkOpen860.Value = 1
            IF THIS.ExportEdiReport(lcDataDir, "860", "", ldFrom, ldTo, ADDBS(lcOutputFolder) + "NotProssed860.xls", @lcProblems)
                lnGenerated = lnGenerated + 1
            ENDIF
        ENDIF
        IF THIS.chkTempOrders.Value = 1
            IF THIS.ExportTempOrders(lcDataDir, ldFrom, ldTo, ADDBS(lcOutputFolder) + "TempOrders.xls", @lcProblems)
                lnGenerated = lnGenerated + 1
            ENDIF
        ENDIF

        THIS.cmdGenerate.Enabled = .T.
        THIS.cLastOutputFolder = lcOutputFolder
        THIS.cmdCopyPath.Enabled = .T.
        THIS.lblStatus.Caption = TRANSFORM(lnGenerated) + " report(s) generated in " + lcOutputFolder

        IF EMPTY(lcProblems)
            MESSAGEBOX(TRANSFORM(lnGenerated) + " report(s) generated successfully." + CHR(13) + lcOutputFolder, 64, "EDI Report Generator")
        ELSE
            MESSAGEBOX(TRANSFORM(lnGenerated) + " report(s) generated." + CHR(13) + CHR(13) + ;
                "Problems:" + CHR(13) + lcProblems, 48, "EDI Report Generator")
        ENDIF
    ENDPROC

    PROCEDURE ResolveCompanyDataFolder
        LPARAMETERS tcConfiguredDir, tcCompanyId
        LOCAL lcConfigured, lcSystemParent, lcCandidate
        lcConfigured = NormalizeFolder(tcConfiguredDir)
        lcSystemParent = JUSTPATH(THIS.cSystemFilesPath)

        IF NOT EMPTY(lcConfigured)
            IF DIRECTORY(lcConfigured)
                RETURN lcConfigured
            ENDIF
            lcCandidate = FULLPATH(lcConfigured, lcSystemParent)
            IF DIRECTORY(lcCandidate)
                RETURN NormalizeFolder(lcCandidate)
            ENDIF
        ENDIF

        lcCandidate = ADDBS(lcSystemParent) + "DBFS\" + ALLTRIM(tcCompanyId)
        IF DIRECTORY(lcCandidate)
            RETURN NormalizeFolder(lcCandidate)
        ENDIF
        RETURN ""
    ENDPROC

    PROCEDURE ExportEdiReport
        LPARAMETERS tcDataDir, tcTransactionType, tcStatus, tdFrom, tdTo, tcOutput, tcProblems
        LOCAL lcTable, loError
        lcTable = ADDBS(tcDataDir) + "EDILIBDT.DBF"
        IF NOT FILE(lcTable)
            tcProblems = tcProblems + "EDILIBDT.DBF not found for " + JUSTFNAME(tcOutput) + CHR(13)
            RETURN .F.
        ENDIF

        IF USED("srcEdi")
            USE IN srcEdi
        ENDIF
        IF USED("curReport")
            USE IN curReport
        ENDIF

        TRY
            USE (lcTable) IN 0 SHARED ALIAS srcEdi
            IF EMPTY(tcStatus)
                SELECT srcEdi.cFileCode, srcEdi.cPartCode, srcEdi.cEdiTranNo, srcEdi.cStatus, srcEdi.dDate, srcEdi.dAckDate ;
                  FROM srcEdi ;
                 WHERE srcEdi.cEdiTrnTyp == m.tcTransactionType ;
                   AND BETWEEN(srcEdi.dAckDate, m.tdFrom, m.tdTo) ;
                   AND EMPTY(srcEdi.cStatus) ;
                  INTO CURSOR curReport READWRITE
            ELSE
                SELECT srcEdi.cFileCode, srcEdi.cPartCode, srcEdi.cEdiTranNo, srcEdi.cStatus, srcEdi.dDate, srcEdi.dAckDate ;
                  FROM srcEdi ;
                 WHERE srcEdi.cEdiTrnTyp == m.tcTransactionType ;
                   AND BETWEEN(srcEdi.dAckDate, m.tdFrom, m.tdTo) ;
                   AND srcEdi.cStatus == m.tcStatus ;
                  INTO CURSOR curReport READWRITE
            ENDIF
            SELECT curReport
            COPY TO (tcOutput) TYPE XL5
            IF NOT THIS.ApplyEdiHeaders(tcOutput, @tcProblems)
                RETURN .F.
            ENDIF
        CATCH TO loError
            tcProblems = tcProblems + JUSTFNAME(tcOutput) + ": " + loError.Message + CHR(13)
            RETURN .F.
        FINALLY
            IF USED("curReport")
                USE IN curReport
            ENDIF
            IF USED("srcEdi")
                USE IN srcEdi
            ENDIF
        ENDTRY
        RETURN .T.
    ENDPROC

    PROCEDURE ExportTempOrders
        LPARAMETERS tcDataDir, tdFrom, tdTo, tcOutput, tcProblems
        LOCAL lcTable, loError
        lcTable = ADDBS(tcDataDir) + "ORDHDR.DBF"
        IF NOT FILE(lcTable)
            tcProblems = tcProblems + "ORDHDR.DBF not found for " + JUSTFNAME(tcOutput) + CHR(13)
            RETURN .F.
        ENDIF

        IF USED("srcOrders")
            USE IN srcOrders
        ENDIF
        IF USED("curReport")
            USE IN curReport
        ENDIF

        TRY
            USE (lcTable) IN 0 SHARED ALIAS srcOrders
            SELECT srcOrders.cOrdType, srcOrders.Order, srcOrders.Account, srcOrders.Dept, srcOrders.CustPO, ;
                   srcOrders.Entered, srcOrders.Start, srcOrders.Complete, srcOrders.cWareCode, srcOrders.dAdd_Date ;
              FROM srcOrders ;
             WHERE srcOrders.cOrdType == "T" ;
               AND srcOrders.Status # "X" ;
               AND BETWEEN(srcOrders.dAdd_Date, m.tdFrom, m.tdTo) ;
              INTO CURSOR curReport READWRITE
            SELECT curReport
            COPY TO (tcOutput) TYPE XL5
            IF NOT THIS.ApplyTempOrderHeaders(tcOutput, @tcProblems)
                RETURN .F.
            ENDIF
        CATCH TO loError
            tcProblems = tcProblems + JUSTFNAME(tcOutput) + ": " + loError.Message + CHR(13)
            RETURN .F.
        FINALLY
            IF USED("curReport")
                USE IN curReport
            ENDIF
            IF USED("srcOrders")
                USE IN srcOrders
            ENDIF
        ENDTRY
        RETURN .T.
    ENDPROC

    PROCEDURE ApplyEdiHeaders
        LPARAMETERS tcOutput, tcProblems
        RETURN THIS.ReplaceExcelHeaders(tcOutput, ;
            "file_no|partner|cust_po|Status|receive_date|processed_date", @tcProblems)
    ENDPROC

    PROCEDURE ApplyTempOrderHeaders
        LPARAMETERS tcOutput, tcProblems
        RETURN THIS.ReplaceExcelHeaders(tcOutput, ;
            "cordtype|order|account|dept|custpo|entered|start|complete|Warehouse|dadd_date", @tcProblems)
    ENDPROC

    PROCEDURE ReplaceExcelHeaders
        LPARAMETERS tcOutput, tcHeaders, tcProblems
        LOCAL loExcel, loWorkbook, loSheet, loError, lnColumn, lnHeaderCount
        loExcel = .NULL.
        loWorkbook = .NULL.

        TRY
            loExcel = CREATEOBJECT("Excel.Application")
            loExcel.DisplayAlerts = .F.
            loExcel.Visible = .F.
            loWorkbook = loExcel.Workbooks.Open(FULLPATH(tcOutput))
            loSheet = loWorkbook.Worksheets(1)
            lnHeaderCount = GETWORDCOUNT(tcHeaders, "|")
            FOR lnColumn = 1 TO lnHeaderCount
                loSheet.Cells(1, lnColumn).Value = GETWORDNUM(tcHeaders, lnColumn, "|")
            ENDFOR
            loSheet.Rows(1).Font.Bold = .T.
            loSheet.Columns.AutoFit()
            loWorkbook.Save()
            loWorkbook.Close(.F.)
            loWorkbook = .NULL.
            loExcel.Quit()
            loExcel = .NULL.
        CATCH TO loError
            tcProblems = tcProblems + JUSTFNAME(tcOutput) + ;
                ": unable to apply the requested Excel headers - " + loError.Message + CHR(13)
            IF VARTYPE(loWorkbook) = "O"
                loWorkbook.Close(.F.)
            ENDIF
            IF VARTYPE(loExcel) = "O"
                loExcel.Quit()
            ENDIF
            RETURN .F.
        ENDTRY
        RETURN .T.
    ENDPROC

    PROCEDURE QueryUnload
        CLEAR EVENTS
    ENDPROC

    PROCEDURE Destroy
        IF USED("curCompanies")
            USE IN curCompanies
        ENDIF
        CLEAR EVENTS
    ENDPROC
ENDDEFINE
