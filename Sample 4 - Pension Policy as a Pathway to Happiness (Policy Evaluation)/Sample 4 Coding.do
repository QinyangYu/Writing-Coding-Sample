/*******************************************************************************
Pension Policy as a Pathway to Happiness: 
Insights from China’s New Rural Pension Scheme
********************************************************************************/
clear  
clear matrix
clear mata
set maxvar 30000
set more off 
cap log close 

pwd  
cd "D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401"

log using ORSP12.log, text replace 




// Merge the data sets

*use ecfps2012adult_201906, clear
*merge 1:1 pid using ecfps2010adult_202008.dta, force
*drop if _merge == 2  
*drop _merge

*merge 1:1 pid using ecfps2016adult_201906.dta
*drop if _merge == 2  
*drop _merge

*merge 1:1 pid using ecfps2014adult_201906.dta, force
*drop if _merge == 2  
*drop _merge

*compress
*save merge_data12.dta, replace





/*******************************************************************************
(1)Data Preparation: Generate Running Variable, Cutoff, Outcomes and Controls
*******************************************************************************/
use merge_data12.dta, clear
set more off 

// year of birth 
tab cfps2012_birthy
label list cfps2012_birthy
gen yob = cfps2012_birthy
replace yob = . if cfps2012_birthy < 0

// gender
tab cfps2012_gender
label list cfps2012_gender
gen male = (cfps2012_gender == 1)
replace male = . if cfps2012_gender < 0

// age
tab cfps2012_age
label list cfps2012_age
gen age = cfps2012_age
replace age = . if cfps2012_age < 0

gen testage = cyear - yob -age
tab testage
keep if testage == 0

// education year
tab eduy2012
label list eduy2012
gen educy = eduy2012
replace educy = . if eduy2012 < 0

// marriage
tab cfps2010_marriage
label list  cfps2010_marriage
gen marriage =  cfps2010_marriage
replace marriage = . if cfps2010_marriage <= 0

// family social status
tab qn12011
label list qn12011
gen status = qn12011
replace status = . if qn12011 < 0 | qn12011 == 79

// Income status
tab qn8011
label list qn8011
gen incomelevel = qn8011
replace incomelevel = . if qn8011 < 0 | qn8011 == 79 

// easten coastal province
tab provcd
label list provcd
gen coast = 0
replace coast = 1 if provcd == 11 | provcd == 12 | provcd == 13 | provcd == 31 | provcd == 32 | provcd == 33 | provcd == 35 | provcd == 37 | provcd == 44 | provcd == 46
replace coast = . if provcd < 0 | provcd == 99

// southern province
gen south = 0
replace south = 1 if provcd == 31 | provcd == 32 | provcd == 33 | provcd == 34 | provcd == 35 | provcd == 36 | provcd == 42 | provcd == 43 | provcd == 44 | provcd == 45 | provcd == 50 | provcd == 51 | provcd == 52 | provcd == 53 | provcd == 54 | provcd == 51
replace south = . if provcd < 0 | provcd == 99

gen southeast = 0
replace southeast = 1 if coast == 1 & south == 1
replace southeast = . if coast == . | south == .


// Lived in birth place at age 3
tab qa3
label list qa3
gen livedbirth3 = (qa3 == 1) 
replace livedbirth3 = . if qa3 < 0 | qa3 == 79

// Lived in birth place at age 12
tab qa4
label list qa4
gen livedbirth12 = (qa4 == 1) 
replace livedbirth12 = . if qa4 < 0 | qa4 == 79

// minority
tab qa5code
label list qa5code
gen han = (qa5code == 1)
replace han = . if qa5code < 0

// county ID
tab countyid
label list countyid
replace countyid = . if countyid < 0

// retirement
tab qi101
label list qi101
gen retire = 1
replace retire = 0 if qi101 == 78
replace retire = . if qi101 < 0




 
////////Outcomes///////////
///Subjective well-being///

//// Evaluative Measures
// personal life satisfaction
tab qn12012 
label list qn12012 
gen satisfactionp = qn12012
replace satisfactionp = . if qn12012 < 0 | qn12012 == 79

// family life satisfaction
tab qn12013
label list qn12013
gen satisfactionf = qn12013
replace satisfactionf = . if qn12013 < 0 | qn12013 == 79

// health life satisfaction
tab qp201
label list qp201
gen satisfactionh = qp201
replace satisfactionh = . if qp201 < 0 
replace satisfactionh = 5 if qp201 == 1 
replace satisfactionh = 4 if qp201 == 2 
replace satisfactionh = 2 if qp201 == 4 
replace satisfactionh = 1 if qp201 == 5 



//// Affect Measures (PA/NA)
/// PA
// I was happy.
tab qq60112
label list qq60112
gen happy = qq60112
replace happy = . if qq60112 < 0

// I enjoyed life.
tab qq60116
label list qq60116
gen enjoy = qq60116
replace enjoy = . if qq60116 < 0

/// NA
// I was bothered by things that usually don't bother me.
tab qq6011
label list qq6011
gen bother = qq6011
replace bother = . if qq6011 < 0

// I did not feel like eating; my appetite was poor.
tab qq6012
label list qq6012
gen appetite = qq6012
replace appetite = . if qq6012 < 0

// I felt I could not shake off the blues even with help from my family and friends
tab qq6013
label list qq6013
gen blue = qq6013
replace blue = . if qq6013 < 0

// I had trouble keeping my mind on what I was doing.
tab qq6015
label list qq6015
gen mind = qq6015
replace mind = . if qq6015 < 0

// I felt depressed.
tab qq6016
label list qq6016
gen depressed = qq6016
replace depressed = . if qq6016 < 0

// I felt that everything I did was an effort.
tab qq6017
label list qq6017
gen effort = qq6017
replace effort = . if qq6017 < 0

// I felt fearful.
tab qq60110
label list qq60110
gen fearful = qq60110
replace fearful = . if qq60110 < 0

// My sleep was restless.
tab qq60111
label list qq60111
gen restless = qq60111
replace restless = . if qq60111 < 0

// I talked less than usual.
tab qq60113
label list qq60113
gen talkless = qq60113
replace talkless = . if qq60113 < 0

// I felt lonely.
tab qq60114
label list qq60114
gen lonely = qq60114
replace lonely = . if qq60114 < 0

// I had crying spells.
tab qq60117
label list qq60117
gen crying = qq60117
replace crying = . if qq60117 < 0

// I felt sad.
tab qq60118
label list qq60118
gen sad = qq60118
replace sad = . if qq60118 < 0

// I could not get going.
tab qq60120
label list qq60120
gen going = qq60120
replace going = . if qq60120 < 0



//// Eudaimonic Measures
// Confidence in future
tab qn12014
label list qn12014
gen confidence = qn12014
replace confidence = . if qn12014 < 0 | qn12014 == 79

// I felt that I was just as good as other people.
tab qq6014
label list qq6014
gen good = qq6014
replace good = . if qq6014 < 0

// I felt hopeful about the future.
tab qq6018
label list qq6018
gen hopeful = qq6018
replace hopeful = . if qq6018 < 0

// I thought my life had been a failure.
tab qq6019
label list qq6019
gen failure = qq6019
replace failure = . if qq6019 < 0

// People were unfriendly.
tab qq60115
label list qq60115
gen unfriendly = qq60115
replace unfriendly = . if qq60115 < 0

// I felt that people dislike me.
tab qq60119
label list qq60119
gen dislike = qq60119
replace dislike = . if qq60119 < 0

// PCA
pca satisfactionp satisfactionf
predict Cognition, score

gen bother2 = -bother
gen appetite2 = -appetite 
gen blue2 = -blue
gen mind2 = -mind
gen depressed2 = -depressed
gen effort2 = -effort
gen fearful2 = -fearful
gen restless2 = -restless
gen talkless2 = -talkless
gen lonely2 = -lonely
gen crying2 = -crying
gen sad2 = -sad
gen going2 = -going
pca happy enjoy bother2 appetite2 blue2 mind2 depressed2 effort2 fearful2 restless2 talkless2 lonely2 crying2 sad2 going2
predict Affect1 Affect2 Affect3, score
gen Affect = 0.355*Affect1+0.0947*Affect2+0.0679*Affect3  // Kaiser

gen failure2 = -failure
gen unfriendly2 = -unfriendly
gen dislike2 = -dislike
pca confidence good hopeful failure2 unfriendly2 dislike2
predict Eudaimonia1 Eudaimonia2, score
gen Eudaimonia = 0.3247*Eudaimonia1 + 0.2327*Eudaimonia2 

pca satisfactionp satisfactionf happy enjoy bother2 appetite2 blue2 mind2 depressed2 effort2 fearful2 restless2 talkless2 lonely2 crying2 sad2 going2 confidence good hopeful failure2 unfriendly2 dislike2
predict SWB1 SWB2 SWB3 SWB4, score
gen SWB = 0.2884*SWB1+0.1017*SWB2+0.0632*SWB3+0.0493*SWB4




///Treatment: NRPS///   
tab qi5014
label list qi5014 

gen NRPS = (qi5014 == 1)
replace NRPS = 0 if qi5014 == 0 | qi5014 == 5
replace NRPS = . if qi5014 < 0 | qi5014 == 79 | qi5014 == .
tab NRPS


///Cutoff, Running Variable and Polynomials///
*Cutoff: 60 years old 
gen cutoff = 60

*Distance (in year) to the Cutoff
gen dist_y = age - cutoff

*Normalized Running Variable
gen X = dist_y

*Treatment (location) Dummy
gen D =(dist_y >= 0)
replace D = . if dist_y == .

*Polynomial Terms
gen DX=D*X

gen X2=X*X
gen DX2=D*X2

gen X3=X*X*X
gen DX3=D*X3

gen X4=X*X*X*X
gen DX4=D*X4


///Sample Restriction///
tab qa301
label list qa301
keep if qa301 ==  1 //keep rural household registration

tab NRPS

tab X
sum X, d
keep if X >= -15 & X <= 15 


///Save Dataset///
*compress
*save reg_data_12.dta, replace







/*******************************************************************************
(2) Validity test for estimation: Density and Predetermined Characteristics
*******************************************************************************/
use reg_data_12.dta, clear

//summary statistics 
asdoc sum X SWB Cognition Affect Eudaimonia satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if NRPS == 1
asdoc sum X SWB Cognition Affect Eudaimonia satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if NRPS == 0

sum NRPS satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike if X < 0

local outcomes "X SWB Cognition Affect Eudaimonia satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12"
foreach x of local outcomes {
reg `x' NRPS, robust
*outreg2 using Table_summary, excel dec(3) drop(_I*)
}


// [1] density test
* histogram
histogram X, discrete width(1) addplot (pci 0 0 0.05 0) legend(col(2)) xtitle("Birth Cohort") legend(label(1 "Histogram") label(2 "Normalized Cutoff") order(1 2) col(2) size(small))
graph save density_histogram,replace
graph export density_histogram.tif, as(tif) replace

* regression test
use reg_data_12.dta, clear 

by dist_y, sort: egen countbin = count(X)
reg countbin D X DX X2 DX2, cluster(X)
outreg2 using Table_Density, excel dec(3) drop(_I*)

predict p_countbin if e(sample)
predict d_countbin if e(sample), stdp
gen u_countbin=p_countbin+1.96*d_countbin
gen l_countbin=p_countbin-1.96*d_countbin

by X, sort: egen mm_countbin=mean(countbin)

preserve

collapse mm_countbin p_countbin u_countbin l_countbin, by(X)

twoway /* 
	*/ (bar mm_countbin X, sort ms(O) mc(gray 10) msize(small) lcolor(gray 10) lwidth(medthick)) /* 
	*/ (line p_countbin X if X<0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_countbin l_countbin X if X<0, sort lpattern(dash) lcolor(black)) /*
	*/ (line p_countbin X if X>=0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_countbin l_countbin X if X>=0, sort lpattern(dash) lcolor(black)), /*
	*/ xline(0, lcolor(black)) /*
	*/ xlabel(-15[5]15) ylabel (#5) /*
	*/ title("Density", size(4) justification(center) color(black)) xtitle("Birth Cohort") ytitle("`3'") /*
	*/ legend(label(1 "Cohort Average") label(2 "Local Linear Fit") label(3 "95% Confidence Interval") order(1 2) size(small)) /*
	*/ xsize(6.5) ysize(3) graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2)) plotregion(fcolor(white))
	*graph save fig_density, replace
	*graph save Graph "D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_density.gph", replace
	*graph export fig_density.pdf, as(pdf) replace
	
restore





// [2] smoothness of predetermined variables (parametric)
use reg_data_12.dta, clear
set more off

local outcomes "male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12"

foreach x of local outcomes {
sum `x' 
ivreg2 `x' (NRPS = D) X DX X2 DX2, cluster(X)
*outreg2 using Table_Validity_IV, excel dec(3) drop(_I*)

}




gen Gender_Male = male
gen Ethnicity_Han = han
gen Education_Year = educy
gen Marriage_Status = marriage
gen Income_Level = incomelevel
gen Social_Status = status
gen Whether_have_Retired = retire
gen Whether_have_Religion = religion
gen Lived_in_Coastal_Areas = coast
gen Lived_in_Southern_Areas = south
gen Lived_in_Birth_Place_Age_3 = livedbirth3 
gen Lived_in_Birth_Place_Age_12 = livedbirth12 

local outcomes "Gender_Male Ethnicity_Han Education_Year Marriage_Status Income_Level Social_Status Whether_have_Retired Whether_have_Religion Lived_in_Coastal_Areas Lived_in_Southern_Areas Lived_in_Birth_Place_Age_3 Lived_in_Birth_Place_Age_12"

foreach x of local outcomes {
sum `x' 
reg `x' D X DX X2 DX2, cluster(X)
*outreg2 using Table_Validity_OLS, excel dec(3) drop(_I*)

*get fitted value and 95% CI
predict p_`x' if e(sample)
predict d_`x' if e(sample), stdp
gen u_`x'=p_`x'+1.96*d_`x'
gen l_`x'=p_`x'-1.96*d_`x'

by dist, sort: egen mm_`x'=mean(`x')

preserve


twoway /* 
	*/ (scatter mm_`x' dist_y, sort ms(O) mc(gray 10) msize(small) lcolor(gray 10) lwidth(medthick)) /* 
	*/ (line p_`x' dist_y if dist_y<0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_`x' l_`x' dist_y if dist_y<0, sort lpattern(dash) lcolor(black)) /*
	*/ (line p_`x' dist_y if dist_y>=0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_`x' l_`x' dist_y if dist_y>=0, sort lpattern(dash) lcolor(black)), /*
	*/ xline(0, lcolor(black)) /*
	*/ xlabel(-15[5]15) ylabel (#5) /*
	*/ title("`x'", size(4) justification(center) color(black)) xtitle("Birth Cohort") ytitle("`3'") /*
	*/ legend(label(1 "Cohort Average") label(2 "Polynomial Fit `i'") label(3 "95% Confidence Interval") order(1 2) size(small)) /*
	*/ xsize(6.5) ysize(3) graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2)) plotregion(fcolor(white))
	*graph save fig_`x', replace
	*graph save Graph "D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_`x'.gph", replace
	*graph export fig_`x'.tif, as(tif) replace

restore	
}
grc1leg  ///     
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Gender_Male" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Ethnicity_Han" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Education_Year" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Marriage_Status" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Income_Level" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Social_Status" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Whether_have_Retired" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Whether_have_Religion" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Lived_in_Coastal_Areas" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Lived_in_Southern_Areas" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Lived_in_Birth_Place_Age_3" ///
"D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_Lived_in_Birth_Place_Age_12" ///
, cols(4) ///
saving("D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_smoothness",replace asis)
graph export fig_smoothness, as(pdf) replace













/*******************************************************************************
(3)Parametric Approach for Estimation: Use D as IV for NRPS, Control 
for a Polynomial Function of X (Quadratic as baseline)
*******************************************************************************/
use reg_data_12.dta, clear
set more off

//First Stage: Regress NRPS on IV(D), Control for f(x)
reg NRPS D X DX X2 DX2, cluster(X) 
*outreg2 using Table_Baseline_NRPS, excel dec(3) drop(_I*)

predict p_NRPS if e(sample)
predict d_NRPS if e(sample), stdp
gen u_NRPS=p_NRPS+1.96*d_NRPS
gen l_NRPS=p_NRPS-1.96*d_NRPS

by dist, sort: egen mm_NRPS=mean(NRPS)

preserve

twoway /* 
	*/ (scatter mm_NRPS dist_y, sort ms(O) mc(gray 10) msize(small) lcolor(gray 10) lwidth(medthick)) /* 
	*/ (line p_NRPS dist_y if dist_y<0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_NRPS l_NRPS dist_y if dist_y<0, sort lpattern(dash) lcolor(black)) /*
	*/ (line p_NRPS dist_y if dist_y>=0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_NRPS l_NRPS dist_y if dist_y>=0, sort lpattern(dash) lcolor(black)), /*
	*/ xline(0, lcolor(black)) /*
	*/ xlabel(-15[5]15) ylabel (#5) /*
	*/ title("NRPS", size(4) justification(center) color(black)) xtitle("Birth Cohort") ytitle("`3'") /*
	*/ legend(label(1 "Cohort Average") label(2 "Polynomial Fit `i'") label(3 "95% Confidence Interval") order(1 2) size(small)) /*
	*/ xsize(6.5) ysize(3) graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2)) plotregion(fcolor(white))
	*graph save fig_NRPS, replace
	*graph save Graph "D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_NRPS.gph", replace
	*graph export fig_NRPS.pdf, as(pdf) replace

restore	




//Second Stage: Regress Outcomes on IV(D DX), Control for f(x)
use reg_data_12.dta, clear
set more off

local outcomes "satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike" 

foreach x of local outcomes {
reg `x' D X DX X2 DX2, cluster(X) 
*outreg2 using Table_Baseline_OLS, excel dec(3) drop(_I*)

}



local outcomes "satisfactionp satisfactionf happy enjoy bother appetite blue mind depressed effort fearful restless talkless lonely crying sad going confidence hopeful good failure unfriendly dislike" 

foreach x of local outcomes {
ivreg2 `x' (NRPS = D) X DX X2 DX2, cluster(X)
*outreg2 using Table_Baseline_IV, excel dec(3) drop(_I*)

}


local outcomes "SWB Cognition Affect Eudaimonia"

foreach x of local outcomes {
ivreg2 `x' (NRPS = D) X DX X2 DX2, cluster(X)
*outreg2 using Table_PCA_IV, excel dec(3) drop(_I*)

}


local outcomes "SWB Cognition Affect Eudaimonia"

foreach x of local outcomes {

reg `x' D DX X X2 DX2, cluster(X)
*outreg2 using Table_PCA_OLS, excel dec(3) drop(_I*)

predict p_`x' if e(sample)
predict d_`x' if e(sample), stdp
gen u_`x'=p_`x'+1.96*d_`x'
gen l_`x'=p_`x'-1.96*d_`x'

by dist, sort: egen mm_`x'=mean(`x')

preserve

twoway /* 
	*/ (scatter mm_`x' dist_y, sort ms(O) mc(gray 10) msize(small) lcolor(gray 10) lwidth(medthick)) /* 
	*/ (line p_`x' dist_y if dist_y<0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_`x' l_`x' dist_y if dist_y<0, sort lpattern(dash) lcolor(black)) /*
	*/ (line p_`x' dist_y if dist_y>=0, sort lcolor(black) lwidth(medthick) lcolor(black)) /* 
	*/ (rline u_`x' l_`x' dist_y if dist_y>=0, sort lpattern(dash) lcolor(black)), /*
	*/ xline(0, lcolor(black)) /*
	*/ xlabel(-15[5]15) ylabel (#5) /*
	*/ title("`x'", size(4) justification(center) color(black)) xtitle("Birth Cohort") ytitle("`3'") /*
	*/ legend(label(1 "Cohort Average") label(2 "Polynomial Fit `i'") label(3 "95% Confidence Interval") order(1 2) size(small)) /*
	*/ xsize(6.5) ysize(3) graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2)) plotregion(fcolor(white))
	*graph save fig_`x', replace
	*graph save Graph "D:\CUHK\CUHK_study\2022-2023 Term Summer\NRPS\202401\fig_`x'.gph", replace
	*graph export fig_`x'.pdf, as(pdf) replace

restore	

}



/*******************************************************************************
(4)Robustness check for RD Estimation: Using non-parametric approach, Varying
polynomial orders, Including predetermined characteristics and fixed effects
*******************************************************************************/

// [1] changing the polynomial order ((with or without county fixed effect or predetermined characteristics))
use reg_data_12.dta, clear
set more off

// first stage
local controls_q1 "X"
local controls_q2 "X X2 DX2"
local controls_q3 "X X2 DX2 X3 DX3"
local controls_q4 "X X2-X4 DX2-DX4"

forvalues i=1(1)4 {

reg NRPS D DX `controls_q`i'', cluster(X)
outreg2 using Table_parametric_NRPS, excel dec(3) 

reg NRPS D DX `controls_q`i'' i.countyid, cluster(X)
outreg2 using Table_parametric_NRPS_f, excel dec(3) drop(_I*)

reg NRPS D DX `controls_q`i'' male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12, cluster(X)
outreg2 using Table_parametric_NRPS_c, excel dec(3) 

reg NRPS D DX `controls_q`i'' i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12, cluster(X)
outreg2 using Table_parametric_NRPS_fc, excel dec(3) drop(_I*)

}


// IV
use reg_data_12.dta, clear
set more off

local controls_q1 "X"
local controls_q2 "X X2 DX2"
local controls_q3 "X X2 DX2 X3 DX3"
local controls_q4 "X X2-X4 DX2-DX4"

local outcomes "SWB Cognition Affect Eudaimonia"

foreach x of local outcomes{ 
  forvalues i=1(1)4 {

ivreg2 `x' (NRPS = D) DX `controls_q`i'', cluster(X)
outreg2 using Table_parametric, excel dec(3) 

ivreg2 `x' (NRPS = D) DX `controls_q`i'' i.countyid, cluster(X)
outreg2 using Table_parametric_f, excel dec(3) drop(_I*)

ivreg2 `x' (NRPS = D) DX `controls_q`i'' male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12, cluster(X)
outreg2 using Table_parametric_c, excel dec(3) 

ivreg2 `x' (NRPS = D) DX `controls_q`i'' i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12, cluster(X)
outreg2 using Table_parametric_fc, excel dec(3) drop(_I*)

}
}









// [2] using nonparametric estimation (with or without county fixed effect or predetermined characteristics)
use reg_data_12.dta, clear
set more off

* rectangle/triangular kernal weights
// first stage

*calculate IK bandwidth
rdbwselect NRPS X, bwselect(IK)
gen bw_NRPS = round(e(h_IK)) 

*generate triangle weights
gen triw_NRPS = 1-abs(X/bw_NRPS)
replace triw_NRPS = 1/bw_NRPS if triw_NRPS == 0

*calculate control mean
sum NRPS if D == 0
global meanvar=r(mean)

*local linear regression
// rectangle kernal weights
reg NRPS D DX X if abs(X) <= bw_NRPS, cluster(X)
outreg2 using Table_nonparametric_NRPS, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X i.countyid if abs(X) <= bw_NRPS, cluster(X)
outreg2 using Table_nonparametric_NRPS_f, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_NRPS, cluster(X)
outreg2 using Table_nonparametric_NRPS_c, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_NRPS, cluster(X)
outreg2 using Table_nonparametric_NRPS_fc, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

// triangular kernal weights
reg NRPS D DX X if abs(X) <= bw_NRPS [pw = triw_NRPS], cluster(X)
outreg2 using Table_nonparametric2_NRPS, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X i.countyid if abs(X) <= bw_NRPS [pw = triw_NRPS], cluster(X)
outreg2 using Table_nonparametric2_NRPS_f, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_NRPS [pw = triw_NRPS], cluster(X)
outreg2 using Table_nonparametric2_NRPS_c, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 

reg NRPS D DX X i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_NRPS [pw = triw_NRPS], cluster(X)
outreg2 using Table_nonparametric2_NRPS_fc, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_NRPS) 



// IV
local outcomes "SWB Cognition Affect Eudaimonia"
foreach x of local outcomes {
*calculate IK bandwidth
rdbwselect `x' X, bwselect(IK)
gen bw_`x' = round(e(h_IK)) 

*generate triangle weights
gen triw_`x' = 1-abs(X/bw_`x')
replace triw_`x' = 1/bw_`x' if triw_`x' == 0

*calculate control mean
sum `x' if D == 0
global meanvar=r(mean)

*local linear regression
// rectangle kernal weights
ivreg2 `x' (NRPS = D) DX X if abs(X) <= bw_`x' [pw = triw_`x'], cluster(X)
outreg2 using Table_nonparametric, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X i.countyid if abs(X) <= bw_`x', cluster(X)
outreg2 using Table_nonparametric_f, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_`x', cluster(X)
outreg2 using Table_nonparametric_c, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_`x', cluster(X)
outreg2 using Table_nonparametric_fc, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

// triangular kernal weights
ivreg2 `x' (NRPS = D) DX X if abs(X) <= bw_`x' [pw = triw_`x'], cluster(X)
outreg2 using Table_nonparametric2, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X i.countyid if abs(X) <= bw_`x' [pw = triw_`x'], cluster(X)
outreg2 using Table_nonparametric2_f, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_`x' [pw = triw_`x'], cluster(X)
outreg2 using Table_nonparametric2_c, excel dec(3) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

ivreg2 `x' (NRPS = D) DX X i.countyid male han educy marriage incomelevel status retire religion coast south livedbirth3 livedbirth12 if abs(X) <= bw_`x' [pw = triw_`x'], cluster(X)
outreg2 using Table_nonparametric2_fc, excel dec(3) drop(_I*) addstat(controlmean, $meanvar, bandwidth, bw_`x') 

}









/*******************************************************************************
(5) Heterogeneous Effect
*******************************************************************************/

//// Heterogeneous effect
use reg_data_12.dta, clear
set more off

local hetero "male han educy incomelevel status coast"

foreach y of local hetero {

gen NRPS`y' = NRPS * `y'
gen D`y' = D * `y'

local outcomes "SWB Cognition Affect Eudaimonia"

foreach x of local outcomes {

ivreg2 `x' (NRPS NRPS`y' = D D`y') DX X X2 DX2, cluster(X)
*outreg2 using Table_heterogeneous, excel dec(3) drop(_I*)
}
}










********************************************************************************


cap log close    


