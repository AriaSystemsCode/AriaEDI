* This form launcher lets MAIN.PRG use standard DO FORM syntax while the
* form class itself remains source-controlled in MAIN.PRG.
PUBLIC goReportForm
goReportForm = CREATEOBJECT("frmReportGenerator")
goReportForm.Show()
