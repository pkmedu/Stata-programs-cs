
foreach package in logout {
capture which `package'
if _rc==111 ssc install `package'
}

capture log close yyrates
//clolog_attained_age_duration.do
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\py_working_file2"
*log using "H:\spd_mort_data_code\yycontent.log", name (yyrates) replace



recode cigsmoke_r2 (2 3 =2)  (4=3) (99=.), gen(cigsmoke_3c)

    label define cigsmoke_3c_lab ///  
			1 "Never"  ///
	        2 "Current" ///   
	        3 "Former"  
	 label values  cigsmoke_3c cigsmoke_3c_lab

	 tab1 cigsmoke_3c
	 
gen y_age_grp=. if age_p >= 18 & age_p <=49
replace y_age_grp=1 if age_p >=50 & age_p <=54
replace y_age_grp=2 if age_p >=55 & age_p <=59
replace y_age_grp=3 if age_p >=60 & age_p <=64
replace y_age_grp=4 if age_p >=65 & age_p <=69
replace y_age_grp=5 if age_p >=70 & age_p <=74
replace y_age_grp=. if age_p >=75

label define y_age_lab 1 "50-54 Yrs"  2 "55-59 Yrs" 3 "60-64 Yrs" ///
                       4 "65-69 Yrs" 5 "70-74 Yrs"
label values y_age_grp y_age_lab




 
/*
gen std_wgt = .5207 if aa_age_grp ==1
replace std_wgt = .3327 if aa_age_grp ==2
replace std_wgt = .1465 if aa_age_grp ==3
*/
gen xstd_wgt = 0.694 if aa_age_grp ==2
replace xstd_wgt = 0.306 if aa_age_grp ==3


gen std_wgt = 0.360776161 if x_age_grp ==1
replace std_wgt = 0.299145166 if x_age_grp ==2
replace std_wgt = 0.193567782 if x_age_grp ==3
replace std_wgt = 0.14651089 if x_age_grp ==4

gen ystd_wgt = 0.2904 if y_age_grp ==1
replace ystd_wgt = 0.2243 if y_age_grp ==2
replace ystd_wgt = 0.1796 if y_age_grp ==3
replace ystd_wgt = 0.1586 if y_age_grp ==4
replace ystd_wgt = 0.1471 if y_age_grp ==5

gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
 xalcstat, chronic1p, pa08_3r,cigsmoke_3c, chronic1p, xspd2)

 /*
tab1 model_obs
tab1 model_obs if dead==1
tab1 model_obs if lp_death==1
tab1 model_obs if m_cvd_death==1

tab1 model_obs 
 */
recode dead (.=0), gen(xdead) 


gen xd1000 = xdead*1000

 gen xlp_death =  lp_death*1000

 gen xlpc_death =  lpc_death*1000
 gen xm_cvd_death = m_cvd_death*1000
 /*
tab1 model_obs if xlp_death==1000
tab1 model_obs if xm_cvd_death==1000
*/

 *table  model_obs cigsmoke_3c sex, by (model_obs) content(freq) row col sc
 
* table  tab1_nmiss cigsmoke_3c sex, by (xspd2)  content(freq) row col sc
 
 * table  tab1_nmiss cigsmoke_3c sex,  content(freq) row col sc

*run H:\spd_mort_data_code\xtra_labels.do


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(centered)

*logout, save(H:\spd_mort_results\rates) excel replace: ///
/*

svy: tab xspd2, count cellwidth(15) format(%15.2f) missing	 	  
svy, subpop (if age_p>=50 & age_p<=74): mean xd1000, stdize(y_age_grp) stdweight(ystd_wgt) ///
      over (sex)
	  lincom [xd1000]Male - [xd1000]Female
*/ 
  
	  
foreach depvar of varlist xd1000 xlp_death xm_cvd_death {
	 display _newline(2) _column(35) " Dependent variable = `depvar' "  
	  svy, subpop (if model_obs==1): mean `depvar', stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (sex xspd2)
	  lincom [`depvar']_subpop_1 - [`depvar']_subpop_2
	  lincom [`depvar']_subpop_3 - [`depvar']_subpop_4
	 	 }	 
	
	
	 
foreach depvar of varlist xd1000 xlp_death xm_cvd_death {
	 display _newline(2) _column(35) " Dependent variable = `depvar' "  
	  svy, subpop (if model_obs==1): mean `depvar', stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (sex cigsmoke_3c)	  
	  lincom [`depvar']_subpop_1 - [`depvar']_subpop_2
	  lincom [`depvar']_subpop_3 - [`depvar']_subpop_4
	  
     svy, subpop (if model_obs==1): mean `depvar', stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (sex xspd2 cigsmoke_3c)
	    
		lincom [`depvar']_subpop_1 - [`depvar']_subpop_4
		lincom [`depvar']_subpop_2 - [`depvar']_subpop_5
		lincom [`depvar']_subpop_3 - [`depvar']_subpop_6
		
		lincom [`depvar']_subpop_7 - [`depvar']_subpop_10
		lincom [`depvar']_subpop_8 - [`depvar']_subpop_11
		lincom [`depvar']_subpop_9 - [`depvar']_subpop_12
		
	 	 }	
	  
/*
eststo: svy, subpop (if age_p>=35 & age_p<=74): mean xd1000, stdize(x_age_grp) stdweight(std_wgt) ///
      over (sex xspd2 xcigsmoke)
esttab using "H:\spd_mort_results\esttab_standardized,rtf", replace	
 */
log close yyrates


