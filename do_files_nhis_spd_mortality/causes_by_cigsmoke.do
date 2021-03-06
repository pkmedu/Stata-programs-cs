
capture log close indi
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\c11causes_added", clear
drop spd2_r xcigsmoke
*describe
log using "H:\spd_mort_data_code\indi.log", name (indi) replace

gen f_age_grp=1 if age_p >= 18 & age_p <=34
replace f_age_grp=2 if age_p >=35 & age_p <=44
replace f_age_grp=3 if age_p >=45 & age_p <=54
replace f_age_grp=4 if age_p >=55 & age_p <=64
replace f_age_grp=5 if age_p >=65 & age_p <=74
replace f_age_grp=6 if age_p >=75 & age_p <=84
replace f_age_grp=7 if age_p >=85


gen x_age_grp=. if age_p >= 18 & age_p <=34
replace x_age_grp=1 if age_p >=35 & age_p <=44
replace x_age_grp=2 if age_p >=45 & age_p <=54
replace x_age_grp=3 if age_p >=55 & age_p <=64
replace x_age_grp=4 if age_p >=65 & age_p <=74
replace x_age_grp=. if age_p >=75


gen aa_age_grp=. if age_p >= 18 & age_p <=34
replace aa_age_grp=1 if age_p >=35 & age_p <=49
replace aa_age_grp=2 if age_p >=50 & age_p <=64
replace aa_age_grp=3 if age_p >=65 & age_p <=74
replace aa_age_grp=. if age_p >=75

gen a35_74=0 
replace a35_74=1 if age_p >= 35 & age_p <=74
	
 recode chronic (1/2=1) (0=2), gen(chronic1p)
 recode cigsmoke (4 10 99 = 99) , gen(cigsmoke_r)
 recode cigsmoke   (5 6 7 8 9 10=4) (4 99 = 99), gen(cigsmoke_r2)
 recode alcstat (4 9 10 = 99), gen(alcstat_r)
 recode alcstat (2 3 4=2) (9 10 = 99) , gen(alcstat_r2)
 recode alcstat_r2 (5/6=3) (7=4) (8=5) (99=.), gen(xalcstat)
 recode cigsmoke_r2 (99=.), gen(xcigsmoke)
 recode SPD2 (0=2), gen(xspd2)
 recode mdd (0=2), gen(xmdd)
 
 recode cig_dis(1 3=1) (2=2) (4=3), gen(cig_dis3)
 recode cig_dis(1 2 3=1) (4=2), gen(cig_dis2)
 
 foreach i of varlist marital educ_cat poverty bmicat pa08_3r pa08_4r chronic chronic1p {
	 	 recode `i' (9=.), gen(`i'_r) 
	 	 }

 
 
run H:\spd_mort_data_code\flabels.do

 tab1 pa08_3r_r
 tab1 chronic1p_r
 
 compress 
 save "H:\spd_mort_data_code\causes_added_data_rev", replace

log close indi 

	
	

