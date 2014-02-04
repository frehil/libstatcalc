//**************************************************************
// Copyright Xensys Corporation 2009-2014
// (see LICENSE.txt)
//
// statcalc.cpp
// Linux demonstration of libstatcalc.so functions
// for statistical functions equivalent to those available in
// MS Excel
//
// 29 Aug 2009
// Fred Hill - Xensys Corporation (http://www.xensys.net)
//**************************************************************

#include <iostream>
#include "libstatcalc.h"

using namespace std;

int main(int argc, char** argv) {
	int i, size;

	size = argc - 1;

	if (argc < 2) {
		cout << "Usage:  Enter a list of numbers separated\n";
        cout << "\tby spaces to calculate the average\n";
		cout << "\tExample: statcalc 1 2 3 4 5\n";
		return -1;
	}

	double ave, paray[size];

	for (i = 1; i < argc; i++) {
		paray[i - 1] = (double) atof(argv[i]);
	}

	ave = average(paray, size);

	cout << "The mean is: " << ave << "\n";

	return 0;

}
