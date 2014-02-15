@ECHO OFF
REM **************************************************************
REM Copyright Xensys Corporation 2009-2014
REM (see LICENSE.txt)
REM
REM Requires MinGW to be installed
REM REF: http://www.mingw.org/
REM
REM Run this in the directory where you have the code for this project
REM which is assumed to be C:\Users\YourUserNameHere\workspace\libstatcalc
REM
REM NOTE: Eclipse will generate a makefile - just set your compile and link
REM       options to the equivalent of what you see in the command line options
REM       below
REM
REM This is the 32 bit version although I'm thinking 64 is possible with minor changes
REM When finished just copy the libstatcalc.dll to C:\Windows\System32 (may need to be Admin)
REM
REM NOTE: MinGW 4.6.x does not require the -lm but v 4.8.x does 
REM
REM To use the .dll on a machine where MinGW is not installed you will need to use:
g++ -shared -o libstatcalc.dll -D PROGRESS libstatcalc.cpp -static-libgcc -static-libstdc++ -lm
REM
REM To use the .dll on the same machine with MinGW installed then this will work
REM g++ -shared -o libstatcalc.dll -D PROGRESS libstatcalc.cpp -lm

