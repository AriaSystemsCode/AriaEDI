# EDI Report Generator (Visual FoxPro 9)

Standalone VFP application for generating the five requested `.xls` reports.

## First run

1. Run `main.prg` from Visual FoxPro, or build and run `EDIReportGenerator.exe`.
2. Select the system-files folder containing `SYCCOMP.DBF`.
3. The selected path is saved in `EDIReportGenerator.ini` beside the application.

The application lists active (not deleted) companies using `CCOM_NAME`, `CCOMP_ID`, and `CCOM_DDIR`. It defaults to the first company alphabetically.

## Reports

- `Rejected850.xls`
- `NotProssed850.xls` (filename retained exactly as requested)
- `Rejected860.xls`
- `NotProssed860.xls` (filename retained exactly as requested)
- `TempOrders.xls`

Outputs are written to the `Reports` folder beside the application. Existing files with the same names are replaced.
After report generation, use **Copy path** to copy the full Reports-folder path to the Windows clipboard.

Excel row 1 uses the business labels from the supplied samples. EDI reports use `file_no`, `partner`, `cust_po`, `Status`, `receive_date`, and `processed_date`. Temp orders use `cordtype`, `order`, `account`, `dept`, `custpo`, `entered`, `start`, `complete`, `Warehouse`, and `dadd_date`.

The Date from value defaults to `2013/01/01`; Date to defaults to today. EDI reports are filtered inclusively by `DACKDATE`. Temp orders are filtered inclusively by `DADD_DATE`. Deleted source records are excluded because `SET DELETED ON` is active.

## Build

Open Visual FoxPro 9 and run:

```foxpro
DO build_project.prg
```

This recreates `EDIReportGenerator.pjx` and builds `EDIReportGenerator.exe`.
