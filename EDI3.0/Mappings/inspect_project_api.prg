CD "D:\Aria\Aria3EDI\AriaEDI\EDI3.0\Mappings"
MODIFY PROJECT mapsql_build NOWAIT
LOCAL loProject, loFile, lcOut, lnCount, lnI
loProject = _VFP.ActiveProject
loFile = loProject.Files.Item(1)
DIMENSION laMembers[1]
lnCount = AMEMBERS(laMembers, loFile, 1)
lcOut = ""
FOR lnI = 1 TO lnCount
  lcOut = lcOut + TRANSFORM(laMembers[lnI,1]) + " | " + TRANSFORM(laMembers[lnI,2]) + ;
    " | " + TRANSFORM(laMembers[lnI,3]) + " | " + TRANSFORM(laMembers[lnI,4]) + CHR(13) + CHR(10)
ENDFOR
=STRTOFILE(lcOut, "project_file_api.txt", 0)
loProject.Close()
QUIT
