IF EXIST xfile.mak DEL xfile.mak
IF EXIST xfile.exe DEL xfile.exe
xb xfile.x
IF EXIST xfile.mak nmake -f xfile.mak
IF EXIST xfile.exe copy xfile.exe c:\xfile
