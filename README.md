# Projet-ada-AntiVirus
Projet ada premiere année DUT info
It's a beautifull project which aims to create the fabulous game AntiVirus !
you want to bang your head on a wall,
well launch the antivirus program in a shell ;)

Installation guide :
first you have to download libs and the compiler
  - download ada gnat compiler
  - Download libraries : putlink


second you will update your path for the compiler know where they are :
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:[Path/to/the/folder]/adabib/lib

third use this options to compile the code (make a script) :
#!/bin/bash
ADA_BIB="[Path/to/the/folder]/adabib"
ADAX_PATH="$ADA_BIB/x11ada"
ADA_FORMS="$ADA_BIB/lib"
ADA_OBJECTS_PATH="$ADAX_PATH:$ADA_OBJECTS_PATH"
ADA_INCLUDE_PATH="$ADAX_PATH:$ADA_INCLUDE_PATH"
LD_LIBRARY_PATH="$ADA_FORMS"
export ADA_OBJECTS_PATH ADA_INCLUDE_PATH LD_LIBRARY_PATH
LARGS="-L$ADA_FORMS -largs -lforms -largs ${ADAX_PATH}/var.o -largs -lX11 -largs -lXt"
gnatmake $* $LARGS

don't forget the rights ! (+x)

finally compile with your new script, for me : build test.adb

soon a file for compiling :)
