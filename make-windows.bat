REM **************************************************************
REM Copyright Xensys Corporation 2009-2014
REM (see LICENSE.txt)
REM
REM Requires MinGW to be installed
REM REF: http://www.mingw.org/
REM
REM Run this in the directory where you have the code for this project
REM which is assumed to be C:\Users\YourUserNameHere\workspace
REM
REM NOTE: You can also configure Eclipse to build and run a generated makefile 
REM
REM This is the 32 bit version although I'm thinking 64 is possible with minor changes
REM When finished just copy the libstatcalc.dll to C:\Windows\System32 (may need to be Admin)

g++ -shared -o libstatcalc.dll -D PROGRESS libstatcalc.cpp 

