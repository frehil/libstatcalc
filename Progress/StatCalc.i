/*------------------------------------------------------------------------
  Copyright Xensys Corporation 2009-2014
  (see LICENSE.txt)

  File:              StatCalc.i
  Description:       External declarations of libstatcalc.dll functions
  Input Parameters:  <none>
  Output Parameters: <none>
  Author:            Fred Hill - Xensys Corporation (http://www.xensys.net)
  Created:           17JUL09
------------------------------------------------------------------------*/

PROCEDURE normdist EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER X AS DOUBLE.  
    DEFINE INPUT PARAMETER mu AS DOUBLE.  
    DEFINE INPUT PARAMETER sigma AS DOUBLE.  
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE norminv EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER p AS DOUBLE.  
    DEFINE INPUT PARAMETER mu AS DOUBLE.  
    DEFINE INPUT PARAMETER sigma AS DOUBLE.  
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE mean EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE stdev EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE MIN EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE MAX EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE median EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE mode EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE NPV EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT  PARAMETER rate AS DOUBLE.
    DEFINE INPUT  PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE IRR EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT  PARAMETER parray AS DOUBLE.
    DEFINE INPUT  PARAMETER iNumElements AS LONG.
    DEFINE RETURN PARAMETER dresult AS DOUBLE.
END.

PROCEDURE power EXTERNAL "libstatcalc.dll" CDECL PERSISTENT:  
    DEFINE INPUT  PARAMETER base     AS DOUBLE.
    DEFINE INPUT  PARAMETER exponent AS DOUBLE.
    DEFINE RETURN PARAMETER dresult  AS DOUBLE.
END.


