
capture log close age35_49
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_data_final.dta"
log using "E:\Stata_mortality\age35_49.log", name (age35_49) replace

gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85
label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v
gen age_35_49= xaa_age==1 if !missing(xaa_age_grp)
gen age_50_69= xaa_age==2 if !missing(xaa_age_grp)
gen age_70_84= xaa_age==3 if !missing(xaa_age_grp)


gen age_5yr=a_age
replace age_5yr=. if a_age >= 18 & a_age <35  | a_age >=85
replace age_5yr=1 if a_age >=35 & a_age <40
replace age_5yr=2 if a_age >=40 & a_age <45
replace age_5yr=3 if a_age >=45 & a_age <50
replace age_5yr=4 if a_age >=50 & a_age <55
replace age_5yr=5 if a_age >=55 & a_age <60
replace age_5yr=6 if a_age >=60 & a_age <65
replace age_5yr=7 if a_age >=65 & a_age <70
replace age_5yr=8 if a_age >=70 & a_age <75
replace age_5yr=9 if a_age >=75 & a_age <80
replace age_5yr=10 if a_age >=80 & a_age <85

label define  age_5yr_vx 1 "35-39 Yrs" 2 "40-44 Yrs" 3 "45-49 Yrs" ///
             4 "50-54 Yrs" 5 "55-59 Yrs" 6 "60-64 Yrs"  ///
			 7 "65-69 Yrs" 8 "70-74 Yrs" 9 "75-79 Yrs" 10 "80-84 Yrs"
label values age_5yr age_5yr_vx
tab a_age age_5yr	 

//generate chronic1p_r = xchronic
//recode   chronic1p_r (2/3=1) (1=2)

//label define  chronic1p_r_lab 1 " 1+ Condition" 2 "None"
//label values  chronic1p_r chronic1p_r_lab

//table age_5yr xspd2, by(cigsmoke_r2 dead) contents(freq)
//table age_5yr xspd2, by(chronic1p_r dead) contents(freq)
	 

fvset base 2 xspd2 chronic1p_r racehisp bmicat_r
fvset base 1 cigsmoke_r2 alcstat_r poverty_r

local base_vars i.dur_cat a_age i.sex i.xspd2
local base_sd i.dur_cat a_age i.sex i.xspd2 i.marital_r  i.educ_cat_r i.racehisp poverty_r

local base_smk i.dur_cat a_age i.sex i.xspd2 i.cigsmoke_r2
local base_dis i.dur_cat a_age i.sex i.xspd2 i.chronic1p_r 

local base_s_d i.dur_cat a_age i.sex i.xspd2 i.cigsmoke_r2 i.chronic1p_r


local base_bmi i.dur_cat a_age i.sex i.xspd2 i.bmi 
local base_s_dbmi i.dur_cat a_age i.sex i.xspd2 i.cigsmoke_r2 i.chronic1p_r i.bmi
local base_s_d_sb  i.dur_cat a_age i.sex i.xspd2 i.cigsmoke_r2 i.chronic1p_r i.bmi i.marital_r  i.educ_cat_r i.racehisp

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

capture noisily svy,subpop(age_35_49): cloglog dead `base_vars', eform nolog
est store m1 

margins, at(xspd2= (1 2))
margins, dydx( xspd2)

capture noisily svy,subpop(age_35_49): cloglog dead `base_smk', eform nolog
est store m2

margins, at(cigsmoke_r2= (1 2 3) xspd2= (1 2))
margins, dydx( xspd2 cigsmoke_r2)

capture noisily svy,subpop(age_35_49): cloglog dead `base_dis', eform nolog
est store m3 

margins, at(chronic1p_r= (1 2) xspd2= (1 2))
margins, dydx( xspd2 chronic1p_r)

capture noisily svy,subpop(age_35_49): cloglog dead `base_s_d', eform nolog
est store m4

margins, at(cigsmoke_r2= (1 2 3) xspd2= (1 2))
margins, at(chronic1p_r= (1 2) xspd2= (1 2))
margins, dydx( xspd2 cigsmoke_r2 chronic1p_r)
 
capture noisily svy,subpop(age_35_49): cloglog dead `base_s_d_s', eform nolog
est store m5
margins, at(cigsmoke_r2= (1 2 3) xspd2= (1 2))
margins, at(chronic1p_r= (1 2) xspd2= (1 2))
margins, dydx(xspd2 cigsmoke_r2 chronic1p_r)

    
estout m1 m2  m3 m4 m5 using "E:\Stata_mortality\models_ages35_49.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)

capture noisily svy,subpop(age_35_49): cloglog dead `base_bmi', eform nolog
est store m6

capture noisily svy,subpop(age_35_49): cloglog dead `base_s_dbmi', eform nolog
est store m7

capture noisily svy,subpop(age_35_49): cloglog dead `base_s_d_sb', eform nolog
est store m8

estout m6 m7 m8 using "E:\Stata_mortality\m6_7_8_ages35_49.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)
			
log close age35_49


