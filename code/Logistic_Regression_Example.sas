/********************************************************************************
 *  Project: Logistic Regression Example	
    Requester: 
    Programmer: Ou Zhang
    Request date: 11-23-2013
    Initial code: 11-23-2013
    Goals: 
    Input: 
    Output: SAS data:
    Notes: 
 ********************** Modification History *************************************
   When:     
   Who:      Ou Zhang
   Change:                
********************************************************************************/
/**  STEP 1: Define Work Environment  **/
proc datasets lib = work nolist kill; run;
ods listing;
dm 'log' clear;dm 'output' clear;
*Delete all user-defined macro variables from the global symbol table;
%SYMDEL;
%let DateTime = %sysfunc(compress(%sysfunc(today(),yymmddN7.), ':'));

%put &DateTime;

%let project_dir = ;
%let source_dir = ;
%let code_dir = ;
%let data_dir = ;

libname x "&data_dir"; 
libname h "&source_dir";

/*Logistical regression model check*/ 
data arthrits; 
	input sex$ trtment$ improve$ count; 
    _treat_=(trtment='Active'); 
    _sex_ =(sex='F'); 
    better =(improve='some'); 
    /* some means improve, none means not improve*/ 
cards; 
F Active none 6 
M Active none 7 
F Active some 21 
M Active some 7 
F Placebo none 19 
M Placebo none 10 
F Placebo some 13 
M Placebo some 1 
;

proc logistic data=arthrits descending; 
	freq count; 
	model better = _sex_ _treat_ / scale=none aggregate; 
run;

*CTABLE;
proc logistic data=arthrits descending;
	freq count;
	model better = _sex_ _treat_ / ctable pprob=(.25 .5 .75) scale=none aggregate;
run;

/*** ROC Curve ***/
proc logistic data=sashelp.sad_PLFO; 
	where PLFO in (0,1); 
	class sexmf (ref='1') / param=ref; 
    model PLFO (event='1') = agebl_dec sexmf raceblack racehisp presentsmk 
                             pastsmk ihxad_fam ipet sxduyn sxasyn collgrad 
                             sxasyn amdurbl_dec_male amdurbl_dec_female / outroc=rocdata; 
run; 
* Plotting the ROC data; 
proc gplot data=rocdata; 
	title1 "ROC curve - Final model as a predictor for PLFO"; 
	plot _sensit_*_1mspec_; 
run; quit;

/************************************/
/********         EOF          ******/
/************************************/
