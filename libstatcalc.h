//**************************************************************
// Copyright Xensys Corporation 2009-2014
// (see LICENSE.txt)
//
// libstatcalc.h
//
// Include file for libstatcalc.cpp
// Function declarations and manifest constant declarations
//
// 29 Aug 2009
// Fred Hill - Xensys Corporation (http://www.xensys.net)
//**************************************************************

#ifndef STATCALC_H_
#define STATCALC_H_

#include "string.h"
#include "math.h"
#include <algorithm>

using namespace std;

#define R_D_Cval(p) (lower_tail ? (1 - (p)) : (p))  /*  1 - p */

#define R_DT_CIv(p) (log_p ? (lower_tail ? -expm1(p) : exp(p)) \
                             : R_D_Cval(p))
#define R_D_Lval(p)   (lower_tail ? (p) : (1 - (p)))

// TODO: Find out how to use /OPT:IEEE_NaN_inf=on for ML_NEGINF or check into System.Double.PositiveInfinity
#define ML_NEGINF   ((-1.0) /  0.0000000000000000000000000001)
//#define ML_NEGINF   ((-1.0) /  0)

#define R_D__0  (log_p ? ML_NEGINF : 0.)        /* 0 */
#define R_D__1  (log_p ? 0. : 1.)           /* 1 */

// TODO: Find out how to use /OPT:IEEE_NaN_inf=on for ML_POSINF or check into System.Double.PositiveInfinity
#define ML_POSINF       (1.0 / 0.0000000000000000000000000001)
//#define ML_POSINF       (1.0 / 0)

#define R_DT_0  (lower_tail ? R_D__0 : R_D__1)      /* 0 */
#define R_DT_1  (lower_tail ? R_D__1 : R_D__0)      /* 1 */
#define R_Q_P01_check(p)            \
         if ((log_p  && p > 0) ||            \
                        (!log_p && (p < 0 || p > 1)) )      \
    return 0;
#define R_DT_qIv(p) (log_p ? (lower_tail ? exp(p) : - expm1(p)) \
                             : R_D_Lval(p))
// DBL_EPSILON
#ifndef DBL_EPSILON
#define DBL_EPSILON 0.0000001
#endif

// ERROR
#ifndef ERROR
#define ERROR -1e30
#endif

#ifdef PROGRESS
// Function declarations for calls from Progress OpenEdge (R)
// ref: http://zone.ni.com/devzone/cda/tut/p/id/3056
extern "C" double average(double * parray, int size);
extern "C" double IRR(double * parray, int size);
extern "C" double MAX(double * parray, int size);
extern "C" double mean(double * parray, int size);
extern "C" double median(double * parray, int size);
extern "C" double MIN(double * parray, int size);
extern "C" double mode(double *data, int size);
extern "C" double normdist(double x, double mean, double standard_dev);
extern "C" double norminv(double p, double mu, double sigma);
extern "C" double numelements(double *data);
extern "C" double NPV(double rate, double *data, int size);
extern "C" double power(double base, double exponent);
extern "C" double stdev(double * parray, int size);
#else
// For calls from other than Progress use these function declarations:
double average(double * parray, int size);
double IRR(double * parray, int size);
double MAX(double * parray, int size);
double mean(double * parray, int size);
double median(double * parray, int size);
double MIN(double * parray, int size);
double mode(double *data, int size);
double normdist(double x, double mean, double standard_dev);
double norminv(double p, double mu, double sigma);
double numelements(double *data);
double NPV(double rate, double *data, int size);
double power(double base, double exponent);
double stdev(double * parray, int size);
#endif

#endif /*STATCALC_H_*/
