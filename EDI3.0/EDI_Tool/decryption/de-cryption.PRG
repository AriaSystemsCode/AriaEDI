LCSYSTEMPATH = Getdir('', '', 'Select Sysfiles Folder Please')
If !Empty(LCSYSTEMPATH)

  Cd (LCSYSTEMPATH)
  Set Talk Off
  Close Tables All
  Close Databases All
  *------------------------------------------------------------*
  Dimension LAMAPFILES[17]
  LAMAPFILES[1] = 'SYCEDIFS'
  LAMAPFILES[2] = 'SYCEDISF'
  LAMAPFILES[3] = 'SYCEDISG'
  LAMAPFILES[4] = 'SYCEDISH'
  LAMAPFILES[5] = 'SYCEDITX'
  LAMAPFILES[6] = 'SYCEDISC'
  LAMAPFILES[7] = 'SYCEDIPR'
  LAMAPFILES[8] = 'SYCEDIRS'
  LAMAPFILES[9] = 'SYCEDISM'
  LAMAPFILES[10]= 'SYCEDIPO'
  LAMAPFILES[11]= 'SYCEDIPA'
  LAMAPFILES[12]= 'SYCEDIPC'
  LAMAPFILES[13]= 'SYCEDICD'
  LAMAPFILES[14]= 'SYCEDIRF'
  LAMAPFILES[15]= 'SYCEDIOW'
  LAMAPFILES[16] = 'SYCEDIST'
  LAMAPFILES[17] = 'SYCEDIIB'

  Copy File (LCSYSTEMPATH+'MAPPINGS.EXE') To (LCSYSTEMPATH+'BACKUP\MAPPINGS.EXE')
  *-----------------------------------------------------------------------------------------------*
  For I = 1 To Alen(LAMAPFILES,1)
    WAIT WINDOW  'Decryption File: '+Alltrim(LAMAPFILES[I]) NOWAIT 
    If File(LCSYSTEMPATH+'BACKUP\'+Alltrim(LAMAPFILES[I])+'.DBF')
      Do openfile With LAMAPFILES[I] ,'' In ("Mappings.exe")
      Copy File (LCSYSTEMPATH+'BACKUP\'+Alltrim(LAMAPFILES[I])+'.*') To (LCSYSTEMPATH+Alltrim(LAMAPFILES[I])+'.*')
      Use (LCSYSTEMPATH+Alltrim(LAMAPFILES[I])) In 0 Alias NEWFILE
      Select NEWFILE
      Append From (LAMAPFILES[I])
      Use In (LAMAPFILES[I])
      Use In NEWFILE
    ELSE
      WAIT WINDOW  'File: '+Alltrim(LAMAPFILES[I]) +' Not Found At Backup' NOWAIT 
    Endif
  Endfor

Endif

=MESSAGEBOX('Decryption Is Finished')