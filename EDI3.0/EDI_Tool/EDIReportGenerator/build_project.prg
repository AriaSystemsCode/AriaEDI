* Run from Visual FoxPro 9 to recreate and build the project/executable.
LPARAMETERS tlSilent
LOCAL lcFolder, lcProject, lcExe
lcFolder = JUSTPATH(FULLPATH(SYS(16, 0)))
lcProject = ADDBS(lcFolder) + "EDIReportGenerator.pjx"
lcExe = ADDBS(lcFolder) + "EDIReportGenerator.exe"

CLOSE DATABASES ALL
SET DEFAULT TO (lcFolder)
SET SAFETY OFF

IF FILE(lcProject)
    ERASE (lcProject)
ENDIF
IF FILE(FORCEEXT(lcProject, "pjt"))
    ERASE (FORCEEXT(lcProject, "pjt"))
ENDIF

CREATE PROJECT (lcProject) NOWAIT
_VFP.ActiveProject.Files.Add(ADDBS(lcFolder) + "main.prg")
_VFP.ActiveProject.Files.Add(ADDBS(lcFolder) + "frmReportGenerator.prg")
_VFP.ActiveProject.SetMain(ADDBS(lcFolder) + "main.prg")
_VFP.ActiveProject.Build(lcExe, 3, .T., .T., .T.)
_VFP.ActiveProject.Close()

IF NOT (VARTYPE(tlSilent) = "L" AND tlSilent)
    MESSAGEBOX("Build completed:" + CHR(13) + lcExe, 64, "EDI Report Generator")
ENDIF
