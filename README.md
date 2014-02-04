libstatcalc
===========

Math and statistics library (.dll and .so) for use by Progress OpenEdge&#8482;.  Written in C/C++.

The results should approximate those returned by Excel&#8482; for the equivalent functions.

For Windows you will need to install the MinGW GNU tools (http://www.mingw.org/)

For AIX you will need the IBM AIX Toolbox for Linux applications which normally ships with the AIX installation media.

For most Linux distributions you will need make sure you have g++ installed.  On Ubuntu installing looks like this:
sudo apt-get install build-essential 
sudo apt-get install g++

The make-* scripts have additional OS specific information.  To be able to call the functions from within Progress make sure you modify the compile scripts to specify the -DPROGRESS macro.  If you want to test it on Linux without Progress leave the -DPROGRESS flag off and then you can just run the statcalc program. 

The current functions included are as follows:
average
IRR
MAX
mean
median
MIN
mode
normdist
norminv
NPV
power
stdev

Once the .dll and/or .so has been built just move it to where the libraries "normally" live on you OS.  Typically for Windows 32 bitthis is C:\Windows\System32, for AIX it's /lib, and for Ubuntu 13.10 it's /usr/lib.



