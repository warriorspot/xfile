xb tokenize.x -lib
xb tearoff.x -lib
xb xfile.x
nmake -f tokenize.mak
nmake -f tearoff.mak
nmake -f xfile.mak
