
capture log close all_ages_unadj
clear
set more off

use "H:\spd_mort_data_code\expand_data_final.dta"


log using "H:\spd_mort_results\all_ages_unadj.log", name (all_ages_unadj) replace


gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85

label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v

recode sex (1=1)(2=0), gen(male)
recode racehisp (1=1)(2/4=0), gen(white)
recode racehisp (3=1)(1 2 4=0), gen(black)


// list of key variables
//dur_cat a_age xaa_age_grp sex racehisp marital i.educ_cat  i.poverty
//xspd2 chronic1p  racehisp bmicat pa08_3r xcigsmoke  xalcstat

								 
fvset base 2 xspd2 chronic1p  racehisp bmicat 
fvset base 3 pa08_3r educ_cat
fvset base 1  xcigsmoke  xalcstat  
//fvset base 4 poverty 

local demo i.dur_cat a_age i.sex i.racehisp i.marital
local demox i.dur_cat a_age i.racehisp i.marital
local ses  i.educ_cat  


svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

foreach xaa_age_grp in 1  2 3 {
  foreach v of varlist xspd2  chronic1p xcigsmoke xalcstat pa08_3r {
     display _newline(2) _column(40) "Model unadjusted for potential confounders by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead i.`v', eform nolog
		// est store un_m`xaa_age_grp'
		// margins, at (xspd2 = (1 2) )
	}
}


log close all_ages_unadj


