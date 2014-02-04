&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME StatWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS StatWin 
/*------------------------------------------------------------------------
  Copyright Xensys Corporation 2009-2014
  (see LICENSE.txt)

  File:              StatCalc-Demo.w
  Description:       Demonstration of libstatcalc.so functions
  Input Parameters:  <none>
  Output Parameters: <none>
  Author:            Fred Hill - Xensys Corporation (http://www.xensys.net)
  Created:           17JUL09
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Include files */
{StatCalc.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i            AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumElements AS INTEGER     NO-UNDO.
DEFINE VARIABLE dMean        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dStDev       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dNormDist    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dNormInv     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dmin         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dmax         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dMedian      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dmode        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dnpv         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dirr         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dExcellIRR   AS DECIMAL     NO-UNDO.

DEFINE VARIABLE parray       AS DECIMAL     EXTENT 100    NO-UNDO.
DEFINE VARIABLE iTime AS INTEGER     NO-UNDO.


DEFINE VARIABLE chExcelApplication         AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorkbook                 AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorksheet                AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chChart                    AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorksheetRange           AS COM-HANDLE  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 fiValues btnClear fiValue btnRunCalc ~
fiProbability fiRate tbExcel edResults 
&Scoped-Define DISPLAYED-OBJECTS fiValues fiValue fiProbability fiRate ~
tbExcel edResults 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR StatWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnClear 
     LABEL "Clear" 
     SIZE 17 BY 1.14.

DEFINE BUTTON btnRunCalc 
     LABEL "Run StatCalc" 
     SIZE 17 BY 1.14.

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 77 BY 7.14 NO-UNDO.

DEFINE VARIABLE fiProbability AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL .95 
     LABEL "Probability for NORMINV" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiRate AS DECIMAL FORMAT "->>,>>9.99999":U INITIAL .005 
     LABEL "Rate for NPV" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fiValue AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 326.8333 
     LABEL "Value for normal distribution" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiValues AS CHARACTER FORMAT "x(999)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.57.

DEFINE VARIABLE tbExcel AS LOGICAL INITIAL no 
     LABEL "Test IRR with Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiValues AT ROW 3.86 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btnClear AT ROW 5.76 COL 56 WIDGET-ID 18
     fiValue AT ROW 5.91 COL 9 WIDGET-ID 10
     btnRunCalc AT ROW 6.91 COL 56 WIDGET-ID 2
     fiProbability AT ROW 7.05 COL 11.4 WIDGET-ID 12
     fiRate AT ROW 8.19 COL 34 COLON-ALIGNED WIDGET-ID 20
     tbExcel AT ROW 9.33 COL 36 WIDGET-ID 22
     edResults AT ROW 10.67 COL 4 NO-LABEL WIDGET-ID 14
     "Enter a list of values separated by commas" VIEW-AS TEXT
          SIZE 44 BY .71 AT ROW 2.91 COL 10 WIDGET-ID 6
     "Results" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 9.71 COL 4 WIDGET-ID 16
          FONT 6
     RECT-1 AT ROW 1.95 COL 3 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 17.86 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW StatWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Statitical Calculator"
         HEIGHT             = 17.86
         WIDTH              = 83.6
         MAX-HEIGHT         = 17.86
         MAX-WIDTH          = 83.6
         VIRTUAL-HEIGHT     = 17.86
         VIRTUAL-WIDTH      = 83.6
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW StatWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fiProbability IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiValue IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(StatWin)
THEN StatWin:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME StatWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL StatWin StatWin
ON END-ERROR OF StatWin /* Statitical Calculator */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL StatWin StatWin
ON WINDOW-CLOSE OF StatWin /* Statitical Calculator */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClear StatWin
ON CHOOSE OF btnClear IN FRAME DEFAULT-FRAME /* Clear */
DO:
   assign
       edResults:SCREEN-VALUE = "" 
       fiProbability:SCREEN-VALUE = ""  
       fiValue:SCREEN-VALUE = ""  
       fiValues:SCREEN-VALUE = "" 
       .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRunCalc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRunCalc StatWin
ON CHOOSE OF btnRunCalc IN FRAME DEFAULT-FRAME /* Run StatCalc */
DO:
  IF NUM-ENTRIES(fiValues:SCREEN-VALUE) < 1 THEN DO:
      MESSAGE "Please enter a list of values."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.

  ASSIGN
      pArray = 0
      iNumElements = 0.

  DO i = 1 TO NUM-ENTRIES(fiValues:SCREEN-VALUE):
    pArray[i] = decimal(ENTRY(i,fiValues:SCREEN-VALUE)).
    iNumElements = iNumElements + 1.
  END.

  IF tbExcel:CHECKED IN FRAME {&FRAME-NAME}
      THEN RUN ExcelIRRCalc.

  RUN StatCalc.
  RUN DisplayResults.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK StatWin 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  
  fiValues:screen-value in frame default-frame = 
      "-28.02169,0,-0.312579757,-3.989988657,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.80410249,3.80410249,7.479376631,7.479376631,-3.549828369,7.479376631,7.479376631,-3.549828369,7.479376631,7.479376631,-3.549828369,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,-43.98923947".
/*       "-28.02169,0,0.312579757,3.989988657,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.804016875,3.80410249,3.80410249,7.479376631,7.479376631,3.549828369,7.479376631,7.479376631,3.549828369,7.479376631,7.479376631,3.549828369,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,7.479376631,43.98923947".  */


  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI StatWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(StatWin)
  THEN DELETE WIDGET StatWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayResults StatWin 
PROCEDURE DisplayResults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    edResults:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "Average ~t~t= " + STRING(dMean) + "~n" +
        "Standard Deviation ~t= " + STRING(dStdev) + "~n" +
        "NORMDIST ~t= " + string(dNormDist)  + "~n" +
        "NORMINV ~t= " + STRING(dNormInv)  + "~n" +
        "MIN ~t= " + STRING(dmin)  + "~n" +
        "MAX ~t= " + STRING(dmax)  + "~n" +
        "Median ~t= " + STRING(dmedian) + "~n" +
        "Mode ~t= " + STRING(dmode)  + "~n" +
        "NPV ~t= " + STRING(dnpv)  + "~n" +
        "IRR ~t= " + STRING(dirr)  + "~n" +
        "ExcellIRR ~t= " + STRING(dExcellIRR)  + "~n" +
        "Elapsed Time ~t= " + STRING(iTime) + " milliseconds.".
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI StatWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiValues fiValue fiProbability fiRate tbExcel edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW StatWin.
  ENABLE RECT-1 fiValues btnClear fiValue btnRunCalc fiProbability fiRate 
         tbExcel edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW StatWin.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW StatWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelIRRCalc StatWin 
PROCEDURE ExcelIRRCalc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:Add().
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    DO WITH FRAME default-frame:
        DO i = 1 TO NUM-ENTRIES(fiValues:SCREEN-VALUE):
             chworksheet:Range("A" + STRING(i)):VALUE = ENTRY(i,fiValues:SCREEN-VALUE).
        END.
    END.

    chworksheet:Range("B1") = "=IRR(A1:A" + STRING(NUM-ENTRIES(fiValues:SCREEN-VALUE)) + ")".
    
    ASSIGN
        dExcellIRR = DECIMAL(chworksheet:Range("B1"):VALUE).
    
    /* chExcelApplication:Visible = TRUE. */
    chWorkbook:saved = TRUE.
    chexcelApplication:workbooks:CLOSE().
        
    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StatCalc StatWin 
PROCEDURE StatCalc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
iTime = MTIME.

RUN mean(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dMean).

RUN stdev(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dStDev).

RUN normdist(
    INPUT DECIMAL(fiValue:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
    INPUT dMean,
    INPUT dStDev,
    OUTPUT dNormDist).

RUN norminv(
    INPUT DECIMAL(fiProbability:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
    INPUT dMean,
    INPUT dStDev,
    OUTPUT dNormInv).
    
RUN median(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dmedian).

    
RUN MIN(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dmin).

    
RUN MAX(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dmax).

    
RUN mode(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dmode).
    
RUN NPV(
    input DECIMAL(fiRate:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dnpv).
    
RUN IRR(
    INPUT pArray,
    INPUT iNumElements,
    OUTPUT dirr).

iTime = MTIME - iTime.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

