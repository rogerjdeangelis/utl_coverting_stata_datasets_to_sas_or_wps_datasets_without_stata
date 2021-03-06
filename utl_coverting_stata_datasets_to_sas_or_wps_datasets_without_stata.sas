
Coverting stata datasets to sas or wps datasets without stata open source;

Last time I checked the free WPS Express does not limit the size of the exported SAS dataset.

see
https://tinyurl.com/yb62db8x
https://stackoverflow.com/questions/51308978/importing-stata-into-sas-file-error

 Importing Stata into SAS dataset

  1.  R: WPS Express Proc R or  SAS IML/R  ( R Supports STATA 12 and 13+)
  2.  PYTHON: WPS Proc Python
      I don't think Perl supports Stata 12?


INPUT  (STATA dataset - created without STATA)
=======================

   d:/dta/have.dta (STATA version 12)

 EXAMPLE OUTPUT (SAS Dataset WORK.WANT)
 ---------------------------------------

 WORK.WANTR total obs=32

   MPG    CYL     DISP     HP    DRAT      WT

  21.0     6     160.0    110    3.90    2.620
  21.0     6     160.0    110    3.90    2.875
  22.8     4     108.0     93    3.85    2.320
  21.4     6     258.0    110    3.08    3.215
  18.7     8     360.0    175    3.15    3.440
  18.1     6     225.0    105    2.76    3.460
 ....

PROCESS  (WORKING CODE)
=======================

 1.  R: WPS Express Proc R or  SAS IML/R  ( R Supports STATA 12 and 13+)

     want = pd.io.stata.read_stata('d:/dta/have.dta');
     import r=want data=wrk.wantR;

 2.  PYTHON: WPS Proc Python

     want = read_dta("d:/dta/have.dta");
     import python=want data=wantPython;


OUTPUT
======

 WANT.WANTR total obs=32

  Obs     MPG    CYL     DISP     HP    DRAT      WT      QSEC

    1    21.0     6     160.0    110    3.90    2.620    16.46
    2    21.0     6     160.0    110    3.90    2.875    17.02
    3    22.8     4     108.0     93    3.85    2.320    18.61
  ....
   30    19.7     6     145.0    175    3.62    2.770    15.50
   31    15.0     8     301.0    335    3.54    3.570    14.60
   32    21.4     4     121.0    109    4.11    2.780    18.60

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;
* create STATA dataset;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(foreign);
write.dta(mtcars,convert.factors="string",version = 12L, "d:/dta/have.dta");
endsubmit;
');

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;
*____
|  _ \
| |_) |
|  _ <
|_| \_\

;
%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
libname hlp  sas7bdat "C:\Progra~1\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
want = read_dta("d:/dta/have.dta");
endsubmit;
import r=want data=wrk.wantR;
run;quit;
');

*            _   _
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/
;

%utl_submit_wps64("
options set=PYTHONHOME 'C:\Progra~1\Python~1.5\';
options set=PYTHONPATH 'C:\Progra~1\Python~1.5\lib\';
libname sd1 'd:/sd1';
proc python;
submit;
import pandas as pd;
want = pd.io.stata.read_stata('d:/dta/have.dta');
endsubmit;
import python=want data=wantPython;
");

