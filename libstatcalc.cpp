//**************************************************************
// Copyright Xensys Corporation 2009-2014
// (see LICENSE.txt)
//
// libstatcalc.cpp 
// C++ shared object library to be called by a Progress program
// for statistical functions equivalent to those available in 
// MS Excel 
//
// 29 Aug 2009
// Fred Hill - Xensys Corporation (http://www.xensys.net)
//**************************************************************

#include "libstatcalc.h"

// init() and fini() need for shared object
void _init()
{
	  
} 

void _fini()
{
	 
}

// AVERAGE
double average(double * parray, int size)
{
 
 return mean(parray, size);
 
} 

// IRR - Internal rate of return
// NOTE: This is a combination of two algorithms from the the 3 web sites below
//       which yields the IRR: Discrete interest calculation
// http://www.linuxjournal.com/article/2545?page=0,0
// http://stackoverflow.com/questions/530192/implementing-excel-and-vbs-irr-function
// http://finance-old.bi.no/~bernt/gcc_prog/index.html
// Internal Rate of Return: Discrete interest calculation
inline int sgn(const double& r){ int i; if (r>=0) {i = 1;} else {i = -1;}; return i;};

double IRR(double * parray, int size)
{
	double negative, d_negative, positive, d_positive;
	double u, temp, delta;
	register int i, it;
    const int iterations = 20;
    int sign_changes = 0;

    // first check Descartes rule
    for (int t=1; t<size; ++t){
        if (sgn(parray[t-1]) !=sgn(parray[t])) sign_changes++;
    }

    if (sign_changes == 0) return ERROR;  // can not find any IRR

    if (sign_changes == 1) { // IRR can be determined exactly

        u = 0;
        //for (it = 1; it < iterations; it++)
        for (it = iterations; it > 0; it--)
        {
            positive = negative = d_positive = d_negative = 0.00;

            for (i = 0; i < size; i++) {
                if (parray[i] > 0.00) {
                    temp = parray[i] * exp(u * i);
                    positive += temp;
                    d_positive += temp * i;
                } // if
                else {
                    temp = fabs(parray[i]) * exp(u * i);
                    negative += temp;
                    d_negative += temp * i;
                } // else
            } //for (i = 0; it < size; it++) {

            delta = log( negative / positive) / (d_negative / negative - d_positive / positive);

            if ( fabs(delta) < DBL_EPSILON) break;

            u -= delta;

        } // for (it = 1; i < iterations; i++)

        if (it > iterations)
            return ML_NEGINF;
        else {
            return (exp(-u) - 1.0);
        }
    }
    else { // if (sign_changes > 1)

        const int MAX_ITERATIONS = 50;
        double x1 = 0.0;
        double x2 = 0.2;

        // create an initial bracket, with a root somewhere between bot,top
        double f1 = NPV(x1, parray, size);
        double f2 = NPV(x2, parray, size);

        int i;

        for (i = 0; i < MAX_ITERATIONS; i++) {
            if ( (f1 * f2) < 0.0) { break; }; //
            if (fabs(f1) < fabs(f2)) {
                f1 = NPV((x1+=1.6*(x1-x2)), parray, size);
            }
            else {
                f2 = NPV((x2+=1.6*(x2-x1)), parray, size);
            }
    	}

        if (f2 * f1 > 0.0) { return ERROR; }

        double f = NPV(x1, parray, size);
        double rtb;
        double dx = 0;

        if (f < 0.0) {
            rtb = x1;
            dx = x2 - x1;
        }
        else {
            rtb = x2;
            dx = x1 - x2;
        }

        for (i=0; i < MAX_ITERATIONS; i++){
            dx *= 0.5;
            double x_mid = rtb + dx;
            double f_mid = NPV(x_mid, parray, size);
            if (f_mid <= 0.0) { rtb = x_mid; }
            if ( (fabs(f_mid ) < DBL_EPSILON) || (fabs(dx ) < DBL_EPSILON) ) return x_mid;
        }

        return ERROR;   // error.
    }

}

// MAX
double MAX(double * parray, int size)
{
 
 register int i;
 double max;

 max = parray[0];

 for (i = 0; i < size; i++)
 {
	 if (parray[i] > max) {
		max = parray[i];
	 }
 }

 return max;
 
}

//MEAN
double mean(double * parray, int size)
{
 double sum=0.0;
 register int i;

 for (i = 0; i < size; i++)
 {
	sum = sum + parray[i];
 }

 return sum / size;
 
} 


// MEDIAN
double median(double * parray, int size)
{

 double median;
 int mid;
 
 // Sort the array
 sort(parray,parray+size); // since parray is zero based, 
						   // size is already 1 past the end 
 
 // If we have an even # of elements then average the middle 2
 if (size % 2 == 0) { 
	 mid = (size / 2) - 1;
	 median = (parray[mid] + parray[mid + 1]) / 2;
 }
 else { // Odd # elements - just return the middle value
	 mid = ((size + 1) / 2) - 1;
	 median = parray[mid];
 }

 return median;

}

//MIN
double MIN(double * parray, int size)
{
 
 register int i;
 double min;

 min  = parray[0];

 for (i = 0; i < size; i++)
 {
	 if (parray[i] < min) {
		min = parray[i];
	 }
 }

 return min;
 
}

//MODE
double mode(double *data, int size)
{
  register int t, w;
  double md, oldmd;
  int count, oldcount;

  oldmd = 0;
  oldcount = 0;
  for(t=0; t<size; t++) {
    md = data[t];
    count = 1;
    for(w = t+1; w < size; w++) 
      if(md==data[w]) count++;
    if(count > oldcount) {
      oldmd = md;
      oldcount = count;
    }
  }
  return oldmd;
}

//NORMDIST
// Code for NORMDIST: Normal cumulative distribution
// http://www.alina.ch/oliver/faq-excel-normdist.shtml
// Oliver Maag
double normdist(double x, double mean, double standard_dev)
{
    double res;

    x = (x - mean) / standard_dev;
    
    if (x == 0)
    {
        res=0.5;
    }
    else
    {
        double oor2pi = 1/(sqrt(double(2) * 3.14159265358979323846));
        double t = 1 / (double(1) + 0.2316419 * fabs(x));
        t *= oor2pi * exp(-0.5 * x * x) 
             * (0.31938153   + t 
             * (-0.356563782 + t
             * (1.781477937  + t 
             * (-1.821255978 + t * 1.330274429))));
        if (x >= 0)
        {
            res = double(1) - t;
        }
        else
        {
            res = t;
        }
    }
    return res;
}

// NORMINV
// Code for NORMINV: Inverse normal cumulative distribution 
// aka. quantile function
// http://www.wilmott.com/messageview.cfm?catid=10&threadid=38771
// sjoo
/*
 *     Compute the quantile function for the normal distribution.
 *
 *     For small to moderate probabilities, algorithm referenced
 *     below is used to obtain an initial approximation which is
 *     polished with a final Newton step.
 *
 *     For very large arguments, an algorithm of Wichura is used.
 *
 *  REFERENCE
 *
 *     Beasley, J. D. and S. G. Springer (1977).
 *     Algorithm AS 111: The percentage points of the normal distribution,
 *     Applied Statistics, 26, 118-121.
 *
 *     Wichura, M.J. (1988).
 *     Algorithm AS 241: The Percentage Points of the Normal Distribution.
 *     Applied Statistics, 37, 477-484.
 */

double expm1(double x)
{
    double y, a = fabs(x);

    if (a < DBL_EPSILON) return x;
    if (a > 0.697) return exp(x) - 1;  /* negligible cancellation */

    if (a > 1e-8)
    y = exp(x) - 1;
    else /* Taylor expansion, more accurate in this range */
    y = (x / 2 + 1) * x;

    /* Newton step for solving   log(1 + y) = x   for y : */
    /* WARNING: does not work for y ~ -1: bug in 1.5.0 */
    y -= (1 + y) * (log(1+ y) - x);

    return y;
}

                                                          
double norminv(double p, double mu, double sigma)
{
    double p_, q, r, val;
    int lower_tail = 1;
    int log_p = 0;

    if (p == R_DT_0)     return ML_NEGINF;
    if (p == R_DT_1)     return ML_POSINF;
    
	R_Q_P01_check(p);

    if(sigma  < 0)     return 0;
    if(sigma == 0)     return mu;

    p_ = R_DT_qIv(p);/* real lower_tail prob. p */
    q = p_ - 0.5;

/*-- use AS 241 --- */
/* double ppnd16_(double *p, long *ifault)*/
/*      ALGORITHM AS241  APPL. STATIST. (1988) VOL. 37, NO. 3

        Produces the normal deviate Z corresponding to a given lower
        tail area of P; Z is accurate to about 1 part in 10**16.

        (original fortran code used PARAMETER(..) for the coefficients
         and provided hash codes for checking them...)
*/
    if (fabs(q) <= .425) {/* 0.075 <= p <= 0.925 */
        r = .180625 - q * q;
     val =
            q * (((((((r * 2509.0809287301226727 +
                       33430.575583588128105) * r + 67265.770927008700853) * r +
                     45921.953931549871457) * r + 13731.693765509461125) * r +
                   1971.5909503065514427) * r + 133.14166789178437745) * r +
                 3.387132872796366608)
            / (((((((r * 5226.495278852854561 +
                     28729.085735721942674) * r + 39307.89580009271061) * r +
                   21213.794301586595867) * r + 5394.1960214247511077) * r +
                 687.1870074920579083) * r + 42.313330701600911252) * r + 1.);
    }
    else { /* closer than 0.075 from {0,1} boundary */

     /* r = min(p, 1-p) < 0.075 */
     if (q > 0)
         r = R_DT_CIv(p);/* 1-p */
     else
         r = p_;/* = R_DT_Iv(p) ^=  p */

     r = sqrt(- ((log_p &&
               ((lower_tail && q <= 0) || (!lower_tail && q > 0))) ?
              p : /* else */ log(r)));
        /* r = sqrt(-log(r))  <==>  min(p, 1-p) = exp( - r^2 ) */

        if (r <= 5.) { /* <==> min(p,1-p) >= exp(-25) ~= 1.3888e-11 */
            r += -1.6;
            val = (((((((r * 7.7454501427834140764e-4 +
                       .0227238449892691845833) * r + .24178072517745061177) *
                     r + 1.27045825245236838258) * r +
                    3.64784832476320460504) * r + 5.7694972214606914055) *
                  r + 4.6303378461565452959) * r +
                 1.42343711074968357734)
                / (((((((r *
                         1.05075007164441684324e-9 + 5.475938084995344946e-4) *
                        r + .0151986665636164571966) * r +
                       .14810397642748007459) * r + .68976733498510000455) *
                     r + 1.6763848301838038494) * r +
                    2.05319162663775882187) * r + 1.);
        }
        else { /* very close to  0 or 1 */
            r += -5.;
            val = (((((((r * 2.01033439929228813265e-7 +
                       2.71155556874348757815e-5) * r +
                      .0012426609473880784386) * r + .026532189526576123093) *
                    r + .29656057182850489123) * r +
                   1.7848265399172913358) * r + 5.4637849111641143699) *
                 r + 6.6579046435011037772)
                / (((((((r *
                         2.04426310338993978564e-15 + 1.4215117583164458887e-7)*
                        r + 1.8463183175100546818e-5) * r +
                       7.868691311456132591e-4) * r + .0148753612908506148525)
                     * r + .13692988092273580531) * r +
                    .59983220655588793769) * r + 1.);
        }

     if(q < 0.0)
         val = -val;
        /* return (q >= 0.)? r : -r ;*/
    }
    return mu + sigma * val;
}

// NPV - Net present value of a regularly spaced series of cash flows
double NPV(double rate, double * parray, int size)
{
	 double sum=0.0;
	 register int i;

	 for (i = 0; i < size; i++)
	 {
		 sum+= (parray[i] / pow((1 + rate),i + 1));
	 }

	 return sum;
}

// power
double power(double base, double exponent) {

	return pow(base,exponent);
}

//STDEV
double stdev(double * parray, int size)
{
 double sum, xbar;
 register int i;

 xbar = mean(parray, size);

 sum = 0;
 for (i = 0; i < size; i++)
 {
	sum = sum + pow((parray[i] - xbar),2.0);
 }

 return sqrt((sum  / (size - 1.0)));

} 


