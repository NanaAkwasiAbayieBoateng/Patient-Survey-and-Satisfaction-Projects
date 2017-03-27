dm 'clear log';
dm 'clear output';
ods html;
proc print data=WORK.'3monthPCORICaregiverSurvey_DATA_'n;
run;

proc print data=WORK.'3monthPatient'n;
run;
proc print data=WORK.BASELINE;
run;
data patient;
set WORK.BASELINE;
run;
data caregiver;
set WORK.CaregiverSurvey;
run;


proc print data=caregiver3;
run;
data caregiver3;
set WORK.'3monthPCORICaregiverSurvey_DATA_'n;
run;
proc print data=caregiver3;
run;

data patient3;
set WORK.'3monthPatient'n;
run;
proc print data=patient3;
run;
ods html close;
ods listing;

/*
 create a new variable ID from caregiver id to be able to split the 
data into PCMD or PCSC
*/

ods html;
dm 'clear log';
dm 'clear output';

data caregiver3;
set caregiver3;
/*
create a new id to categorize all PCMD and PCSC 
1 where the character starts
4 how many characters to select
*/
if substr(caregiver_id, 1, 4) = 'PCMD' then ID = 'PCMD';
if substr(caregiver_id, 1, 4) = 'PCSC' then ID = 'PCSC';
*else ID='PCSC';
run;
proc print data=caregiver3;
*var ID;
run;

ods html close;
ods listing;


/*
 
 create a new variable ID from patient id  to be able to split the 
data into PCMD or PCSC
*/

ods html;

data patient3;
set patient3;
/*
create a new id to categorize all PCMD and PCSC 
1 where the character starts
4 how many characters to select
*/
if substr( patient_id, 1, 4) = 'PCMD' then ID = 'PCMD';
*if substr( patient_id, 1, 4) = 'PCSC' then ID = 'PCSC';
else ID='PCSC';
run;
proc print data=patient3;
*var ID;
run;

ods html close;


ods html;
dm 'clear log';
dm 'clear output';
data patient3;
set patient3;
* Combining variables;
if pt_overall_quality___1 =1 then pt_overall_quality=1;
if pt_overall_quality___2 =1  then pt_overall_quality =2;
if pt_overall_quality___3 =1 then  pt_overall_quality =3; 
if pt_overall_quality___4 =1  then pt_overall_quality =4; 
if pt_overall_quality___5 =1  then pt_overall_quality =5;
if pt_overall_quality___6 =1   then pt_overall_quality =6;
if pt_overall_quality___7  =1 then  pt_overall_quality =7;
drop pt_overall_quality___1 pt_overall_quality___2 pt_overall_quality___3 pt_overall_quality___4 pt_overall_quality___5 pt_overall_quality___6 pt_overall_quality___7;


* overall quality of health care since lung cancer diagnosis (p. 1 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing;

if 6 le pt_overall_quality le 7 then pt_overall_quality = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4);

xpt_overall_quality= abs(pt_overall_quality-5);

* overall pt_care_comparison since lung cancer diagnosis (p. 1 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing;

if 6 le pt_care_comparison le 7 then pt_care_comparison = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4);

xpt_care_comparison= abs(pt_care_comparison-5);
if hads_1___1=1 then hads_1=1;
if hads_1___2=1  then hads_1=2;
if hads_1___3=1  then hads_1=3;
if hads_1___4=1  then hads_1=4; 
drop hads_1___1 hads_1___2 hads_1___3 hads_1___4;

if hads_2___1=1   then hads_2=1;
if hads_2___2=1 then hads_2=2;
if hads_2___3=1 then hads_2=3;
if hads_2___4=1  then hads_2=4;
drop hads_2___1 hads_2___2 hads_2___3 hads_2___4;

if hads_3___1=1 then hads_3=1;
if hads_3___2=1 then hads_3=2; 
if  hads_3___3=1 then hads_3=3;
if hads_3___4=1 then hads_3=4; 
drop hads_3___1 hads_3___2 hads_3___3 hads_3___4;

if hads_4___1=1 then  hads_4=1;
if hads_4___2=1  then hads_4=2;
if hads_4___3=1 then hads_4=3;
if hads_4___4=1  then hads_4=4;
drop hads_4___1 hads_4___2 hads_4___3 hads_4___4;

if hads_5___1=1 then hads_5=1;
if hads_5___2=1 then hads_5=2;
if hads_5___3=1  then hads_5=3;
if hads_5___4=1 then hads_5=4;
drop hads_5___1 hads_5___2 hads_5___3 hads_5___4;

if hads_6___1=1 then  hads_6=1;
if hads_6___2=1 then hads_6=2;
if hads_6___3=1 then hads_6=3;
if hads_6___4=1 then hads_6=4;
drop hads_6___1 hads_6___2 hads_6___3 hads_6___4;

if hads_7___1=1 then hads_7=1;
if hads_7___2=1 then hads_7=2;
if hads_7___3=1  then hads_7=3;
if hads_7___4=1 then hads_7=4;
drop hads_7___1 hads_7___2 hads_7___3 hads_7___4;

if hads_8___1=1 then hads_8=1;
if hads_8___2=1 then hads_8=2;
if hads_8___3=1 then hads_8=3;
if hads_8___4=1 then hads_8=4;  
drop hads_8___1 hads_8___2 hads_8___3 hads_8___4;

if hads_9___1=1  then hads_9=1;
if hads_9___2=1  then  hads_9=2;
if hads_9___3=1  then  hads_9=3;
if hads_9___4=1 then hads_9=4;
drop hads_9___1 hads_9___2 hads_9___3 hads_9___4;

if hads_10___1=1 then hads_10=1;
if hads_10___2=1 then hads_10=2;
if hads_10___3=1 then hads_10=3;
if hads_10___4=1 then  hads_10=4; 
drop hads_10___1   hads_10___2 hads_10___3 hads_10___4;

if hads_11___1=1 then hads_11=1;
if  hads_11___2=1 then hads_11=2;
if  hads_11___3=1 then hads_11=3;
if  hads_11___4=1 then hads_11=4;
drop  hads_11___1  hads_11___2  hads_11___3  hads_11___4;

if hads_12___1=1  then hads_12=1;
if hads_12___2=1  then hads_12=2;
if hads_12___3=1  then  hads_12=3;
if hads_12___4=1    then hads_12=4;
drop hads_12___1 hads_12___2 hads_12___3 hads_12___4;

if hads_13___1=1  then  hads_13=1;
if hads_13___2=1 then  hads_13=2;
if hads_13___3=1  then hads_13=3;
if hads_13___4=1 then  hads_13=4;
drop hads_13___1 hads_13___2 hads_13___3 hads_13___4;

if hads_14___1=1   then hads_14=1;
if hads_14___2=1  then hads_14=2;
if hads_14___3=1  then hads_14=3;
if hads_14___4=1 then hads_14=4;  
drop hads_14___1 hads_14___2 hads_14___3 hads_14___4; 
/* CAHPS items – Treatment Decision Making (pp 1-3 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 10-51);
* Coding of these items is based on Keating et al., J Clinical Oncol, 2010, 28, 4364-4370 and Weeks et al., NEJM, 2012, 367:1616-25;
* For each modality (surgery, chemo, radiation), categorize responses into “patient controlled,” “shared control,” or “physician control” per Keating;
* To keep the scoring simple, we will assume that the patient response “does not apply to me” means that the modality was not considered as an option, 
however if there is substantial missing data we will need to examine responses to the preceding items on whether the patient received the modality, is 
scheduled to receive the modality and discussed the modality with the physician;
* Computes for modality = surgery;*/

if 1 le treatment_1d_surgery le 2 then surgdecision= 0; *0=patient controlled;
*if  treatment_1d_surgery le 2 then  surgdecision= 0; *0=patient controlled;






if treatment_1d_surgery= 3 then surgdecision= 1; *1=shared decision;
if 4 le treatment_1d_surgery le 5 then surgdecision= 2; *2= physician decision;
* Computes for modality = radiation;
if 1 le treatment_2d_radiation le 2 then raddecision= 0; *0=patient controlled;
if treatment_2d_radiation= 3 then raddecision= 1; *1=shared decision;
if 4 le treatment_2d_radiation le 5 then raddecision= 2; *2= physician decision;
* Computes for modality = chemotherapy;
if 1 le treatment_3d_chemo le 2 then chemodecision= 0; *0=patient controlled;
if treatment_3d_chemo= 3 then chemodecision= 1; *1=shared decision;
if 4 le treatment_3d_chemo le 5 then chemodecision= 2; *2= physician decision;
* Computes for decision-making role of the family;
* if 1 le family_tx_decision le 2 then familydecision= 0; *0=patient controlled;
if family_tx_decision = 3 then familydecision= 1; *1=shared decision;
if 4 le family_tx_decision le 5 then familydecision= 2; *2= physician decision;
/** Satisfaction with treatment length of time (p. 3 patient survey);
* We created these items;
* set 5 (don’t know) and 6 (does not apply) to missing;
   */

if 5 le pt_sat_time_to_diagnosis le 6 then pt_sat_time_to_diagnosis= .;
if 5 le pt_sat_time_to_treatment le 6 then pt_sat_time_to_treatment= .;
if 5 le pt_sat_time_to_complete_tx le 6 then pt_sat_time_to_treatment= .;


* reverse code so greater numeric response = better (more frequent) physician communication (range 0-3);
xpt_sat_time_to_diagnosis_3= abs(pt_sat_time_to_diagnosis-4); 
xpt_sat_time_to_treatment_3= abs(pt_sat_time_to_treatment-4); 
xpt_sat_time_to_complete_tx_3= abs(pt_sat_time_to_complete_tx-4); 




/* 
* Satisfaction with treatment plan (p. 3 patient survey);
* Note that on the patient survey, both of these items were asked, regardless of whether the patient’s treatment
had yet been completed… likewise, items regarding obstacles on completing treatment (p. 4 patient survey) were asked
regardless of whether treatment was completed;
* We created these items;
* recode so range is 0-2 instead of 1-3;
*/

xpt_sat_treatment_plan= pt_sat_treatment_plan-1; *(pt_sat_time_to_treatment);
xpt_sat_treatment_compl= pt_sat_treatment_compl;
* sum the 2 items – later, check intercorrelation;
ptsumsattxplan_3= sum(xpt_sat_treatment_plan, xpt_sat_treatment_compl);





/* * Barriers to completing treatment plan (p. 4 patient survey);
* rescore 1=yes, 2=no to 0=no, 1=yes;
* note that these items were asked regardless of whether treatment was completed;

array aa [8] pt_issues_a  pt_issues_b  pt_issues_c  pt_issues_d  pt_issues_e  pt_issues_f  pt_issues_g  pt_issues_h; 
array bb [8] xpt_issues_a  xpt_issues_b  xpt_issues_c  xpt_issues_d  xpt_issues_e  xpt_issues_f  xpt_issues_g  xpt_issues_h; 
do i= 1 to 8;
bb[i]= abs(aa[i]-2);
end; drop i;
*/

* create sum score;
*sumbarriers = sum(xpt_issues_a, xpt_issues_b, xpt_issues_c, xpt_issues_d, xpt_issues_e, xpt_issues_f, xpt_issues_g, xpt_issues_h); 
*drop xpt_issues_a xpt_issues_b xpt_issues_c xpt_issues_d xpt_issues_e xpt_issues_f xpt_issues_g xpt_issues_h; 
*/;

xpt_issues_a=abs(pt_issues_a-2);
xpt_issues_b =abs(pt_issues_b-2);
xpt_issues_c =abs(pt_issues_c-2);
xpt_issues_d= abs(pt_issues_d-2); 
xpt_issues_e = abs(pt_issues_e-2); 
xpt_issues_f= abs(pt_issues_f -2);  
xpt_issues_g= abs(pt_issues_g-2);   
xpt_issues_h= abs(pt_issues_h-2) ;

sumbarriers_3 = sum(xpt_issues_a, xpt_issues_b, xpt_issues_c, xpt_issues_d, xpt_issues_e, xpt_issues_f, xpt_issues_g, xpt_issues_h); 







/* 
* Satisfaction with quality of care from various team members (p. 4 patient survey);
* set 5 (don’t know) and 6 (does not apply) to missing;

*/

array bba [8] pt_sat_care_pcc  pt_sat_care_onc  pt_sat_care_pulm  pt_sat_care_surgeon  pt_sat_care_nurse_nav  pt_sat_care_other_nurses  pt_sat_care_nonclinic  
pt_sat_care_whole_team;
array cc [8] xpt_sat_care_pcc xpt_sat_care_onc  xpt_sat_care_pulm  xpt_sat_care_surgeon xpt_sat_care_nurse_nav xpt_sat_care_other_nurses xpt_sat_care_nonclinic  
xpt_sat_care_whole_team;
do i= 1 to 8;
if 5 le bba[i] le 6 then bba[i]= .;

* reverse code so greater numeric response = greater satisfaction (range 0-3);
cc[i]= abs(bba[i]-4);
end; drop i;
* create sum score for overall satisfaction with quality of care;
sumsatteam_3= sum( xpt_sat_care_onc,  xpt_sat_care_pulm, xpt_sat_care_nurse_nav, xpt_sat_care_other_nurses, xpt_sat_care_nonclinic, xpt_sat_care_whole_team);

* sumsatteam xpt_sat_care_surgeon,xpt_sat_care_pcc;

sumsatqc_3= sum(xpt_sat_care_pcc, xpt_sat_care_onc,  xpt_sat_care_pulm,  xpt_sat_care_surgeon, xpt_sat_care_nurse_nav, xpt_sat_care_other_nurses, xpt_sat_care_nonclinic, xpt_sat_care_whole_team);




/* CAHPS items – Physician communication – 5 item version (p. 5 patient survey);
* Replicate scale used in Weeks et al., NEJM, 2012, 367:1616-25 (see p. 1618), which is sum of 5 CAHPS items; 
* note that Weeks et al. re-scales instrument for a 0-100 range – we are retaining the 1-4 scores on each of the 5 items 
(total scale score range of 5-20) from the original CAHPS survey;
* set 5 (don’t know) and 6 (does not apply) to missing;*/

if 5 le pt_exp_phys_listen le 6 then pt_exp_phys_listen= .;
if 5 le pt_exp_phys_explain le 6 then pt_exp_phys_explain= .;
if 5 le pt_exp_phys_tx_inform le 6 then pt_exp_phys_tx_inform= .;
if 5 le pt_exp_phys_encourage le 6 then pt_exp_phys_encourage= .;
if 5 le pt_exp_phys_respect le 6 then pt_exp_phys_respect= .;
* reverse code so greater numeric response = better (more frequent) physician communication;
xpt_exp_phys_listen= abs(pt_exp_phys_listen-5); 
xpt_exp_phys_explain= abs(pt_exp_phys_explain-5); 
xpt_exp_phys_tx_inform= abs(pt_exp_phys_tx_inform-5); 
xpt_exp_phys_encourage= abs(pt_exp_phys_encourage-5); 
xpt_exp_phys_respect= abs(pt_exp_phys_respect-5); 
* create sum score;
sumphyscomm5_3= sum(xpt_exp_phys_listen, xpt_exp_phys_explain, xpt_exp_phys_tx_inform, 
xpt_exp_phys_encourage, xpt_exp_phys_respect); 





/* CAHPS items – Physician communication – 7 item version (p. 5 patient survey);
* We created 2 additional items (How often were doctors as helpful as you thought 
they should be, and How often did doctors seem to be aware of treatments for your lung 
cancer that other doctors recommend) to flesh out the 5-item CAHPS scale;
* Create a 7 item scale using the 5-item scale from Weeks et al., NEJM, 2012; 
* will need to evaluate internal consistency of these items later;
* set 5 (don’t know) and 6 (does not apply) to missing;*/

if 5 le pt_exp_phys_helpful le 6 then pt_exp_phys_helpful= .;
if 5 le pt_exp_phys_aware le 6 then pt_exp_phys_aware= .;
xpt_exp_phys_helpful= abs(pt_exp_phys_helpful-5); 
xpt_exp_phys_aware= abs(pt_exp_phys_aware-5); 
sumphyscomm7_3= sum(xpt_exp_phys_listen, xpt_exp_phys_explain, xpt_exp_phys_tx_inform, 
xpt_exp_phys_encourage, xpt_exp_phys_respect, xpt_exp_phys_helpful, xpt_exp_phys_aware); 






/*
* We created a 6-item nurse communication measure based on the CAHPS Physician Communication items (pp 5-6 patient survey);
* will need to verify internal consistency of this measure;
* set 5 (don’t know) and 6 (does not apply) to missing;
*/

if 5 le pt_exp_nurse_listen le 6 then pt_exp_nurse_listen= .;
if 5 le pt_nurses_often_explain le 6 then pt_nurses_often_explain= .;
if 5 le pt_nurses_often_info le 6 then pt_nurses_often_info= .;
if 5 le pt_nurses_often_encourage le 6 then pt_nurses_often_encourage= .;
if 5 le pt_nurses_often_treat le 6 then pt_nurses_often_treat= .;
if 5 le pt_nurses_often_help le 6 then pt_nurses_often_help= .;
* reverse code so greater numeric response = better (more frequent) nurse communication (0-3 scoring for each item);
xpt_exp_nurse_listen= abs(pt_exp_nurse_listen-4); 
xpt_nurses_often_explain = abs(pt_nurses_often_explain-4); 
xpt_nurses_often_info = abs(pt_nurses_often_info-4); 
xpt_nurses_often_encourage = abs(pt_nurses_often_encourage-4); 
xpt_nurses_often_treat = abs(pt_nurses_often_treat-4); 
xpt_nurses_often_help = abs(pt_nurses_often_help-4); 
* create sum score;
sumnursecomm_3= sum(xpt_exp_nurse_listen, xpt_nurses_often_explain, xpt_nurses_often_info, xpt_nurses_often_encourage, xpt_nurses_often_treat,  
xpt_nurses_often_help); 

  



/* 4 items (p. 6 of patient survey) plus 1 item (item 7 on p. 7 patient survey) ask about satisfaction with care from the team as a whole; 
* the first two items are from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 6) and the second two we created ourselves;
* item 7 on p.7 patient survey (included with the Pardon et al., 2011 items) belongs here – pt_inform_all_they_could;
* create sum score from these 4 items – check inter-item consistency later;
 * set 5 (don’t know) and 6 (does not apply) to missing;
*/
if 5 le pt_nurses_often_handle le 6 then pt_nurses_often_handle= .;
if 5 le pt_nurses_often_team le 6 then pt_nurses_often_team= .;
if 5 le pt_nurses_often_discomfort le 6 then pt_nurses_often_discomfort= .;
if 5 le pt_nurses_often_understand le 6 then pt_nurses_often_understand= .;
if 5 le pt_inform_all_they_could le 6 then pt_inform_all_they_could = .;
* reverse code so greater numeric response = better (more frequent) physician communication (range 0-3);
xpt_nurses_often_handle= abs(pt_nurses_often_handle-4);
xpt_nurses_often_team= abs(pt_nurses_often_team-4); 
xpt_nurses_often_discomfort= abs(pt_nurses_often_discomfort-4); 
xpt_nurses_often_understand= abs(pt_nurses_often_understand-4); 
xpt_inform_all_they_could= abs(pt_inform_all_they_could-4);
* create sum score;
sumteamsat_3= sum(xpt_nurses_often_handle, xpt_nurses_often_team,  
xpt_nurses_often_discomfort, xpt_nurses_often_understand, xpt_inform_all_they_could);  





/*
* Communication about disease-specific information;
/* The questions are adapted from K. Pardon et al., Are patients’ preferences for information and 
participation in medical decision-making being met? Interview study with lung cancer patients. 
Palliative Medicine, 2011, 25(1), 62-70.  For consistency, responses changes from 6-point Likert 
(totally disagree to totally agree) to 4 items that are used in the CAHPS patient survey (always,
usually, sometimes, never) */
* note that Item 7 (p. 7 of patient survey) does not belong here – it is not an item from the
Pardon et al. scale, which has just 6 items about specific types of information (we did not include 
the “In general…” question);
* set 5 (don’t know) and 6 (does not apply) to missing; 
 
*/;

if 5 le pt_inform_diagnosis le 6 then pt_inform_diagnosis= .;
if 5 le pt_inform_tx_options le 6 then pt_inform_tx_options= .;
if 5 le pt_inform_cure_chance le 6 then pt_inform_cure_chance= .;
if 5 le pt_inform_life_expectancy le 6 then pt_inform_life_expectancy= .;
if 5 le pt_inform_palliative_care le 6 then pt_inform_palliative_care = .;
if 5 le pt_inform_end_of_life le 6 then pt_inform_end_of_life = .;
* reverse code so greater numeric response = better (more frequent) response (range 0-3);
xpt_inform_diagnosis= abs(pt_inform_diagnosis-4); 
xpt_inform_tx_options= abs(pt_inform_tx_options-4); 
xpt_inform_cure_chance= abs(pt_inform_cure_chance-4); 
xpt_inform_life_expectancy= abs(pt_inform_life_expectancy-4); 
xpt_inform_palliative_care= abs(pt_inform_palliative_care-4); 
xpt_inform_end_of_life= abs(pt_inform_end_of_life-4); 
* create sum score from these 6 items – check inter-item consistency later;
sumptinfo_3= sum(xpt_inform_diagnosis, xpt_inform_tx_options, xpt_inform_cure_chance, xpt_inform_life_expectancy, xpt_inform_palliative_care, xpt_inform_end_of_life); 



/* Functional Assessment of Cancer Therapy – Lung (FACT-L) – Version 4;
* Some items must be reverse-scored, so that higher scores on all sub-scales and summary scores indicate better QOL;
* At least 80% of the questions should be answered, per Paull et al. (p. 566) for the instrument to be scored;
* As long as at least half of the items for any particular sub-scale are answered, a sub-scale score can be estimated by taking an average (Browning et al., p. 4; also see http://www.meducator3.net/algorithms/content/lung-cancer-subscale-lcs-fact-l-1);
/* example algorithm to adjust the 6-item LCS sub-scale when only 4 of 6 items were answered;
total score adjusted to 7 items= ((score for answered items)*7)/(number of items answered);
*/ 
* need to check missing data patterns: there may be very little missing data because Redcap doesn’t allow skips…if there is missing data, we need to follow above rules to calculate estimates;
 
*set 6 (don’t know) and 7 (does not apply) to missing;*/;

array dd [36] pt_factl1 - pt_factl35 pt_smoking_regret;
do i= 1 to 36;
if 6 le dd[i] le 7 then dd[i] = .; 
end; drop i; 


* reverse score negative items so that higher score means better functioning;
* note that according to the Data Dictionary, the Baptist programmer changed the naming 
convention on the FACT-L after item 28 (e.g., item 28= pt_factl28 while item 29= pt_fctl_29);

array ee [17] pt_factl1 pt_factl2 pt_factl3 pt_factl4 pt_factl5 pt_factl6 pt_factl7 pt_factl15  pt_factl17 pt_factl18 pt_factl19 pt_factl20  pt_factl28 pt_fctl_29 pt_fctl_31 pt_fctl_32 pt_fctl_34;
array ff [17] xpt_factl1 xpt_factl2 xpt_factl3 xpt_factl4 xpt_factl5 xpt_factl6 xpt_factl7 xpt_factl15  xpt_factl17 xpt_factl18 xpt_factl19 xpt_factl20 xpt_factl28 xpt_fctl_29 xpt_fctl_31 xpt_fctl_32 xpt_fctl_34;
do i= 1 to 17;
ff[i] = abs(ee[i]-6);
end; drop i; 
*create the 5 sub-scales;
* Physical well-being (PWB) sub-scale;
PWB_3= sum(xpt_factl1, xpt_factl2, xpt_factl3, xpt_factl4, xpt_factl5, xpt_factl6, xpt_factl7);
* Social well-being (SWB) sub-scale;
SWB_3= sum(pt_factl8, pt_factl9, pt_factl10, pt_factl11, pt_factl12, pt_factl13, pt_factl14);
* Emotional well-being (EWB) sub-scale;
EWB_3= sum(xpt_factl15, pt_factl16, xpt_factl17, xpt_factl18, xpt_factl19, xpt_factl20);
* Functional well-being (FWB) sub-scale;
FWB_3= sum(pt_factl21, pt_factl22, pt_factl23, pt_factl24, pt_factl25, pt_factl26, pt_factl27);
* Lung cancer scale (LCS) sub-scale;
LCS_3= sum(xpt_factl28, xpt_fctl_29, pt_fctl_30, xpt_fctl_31, xpt_fctl_32, pt_fctl_33, xpt_fctl_34, pt_fctl_35, pt_smoking_regret);
* calculate summary scales;
/* Total summary score – see Paull et al., p. 566 */
FACTL_3= PWB_3 + SWB_3 + EWB_3 + FWB_3 + LCS_3; *score range 0-136 -- * note that total overall score range is 0-135 (not 0-136) per Browning et al., Lung Cancer, 2009, 66, 134-39;
/* FACT-G score (generic measurement of QOL for patients with cancer in general, not lung cancer-specific, is the total FACT-L score minus the lung cancer subscale */
FACTG_3= PWB_3 + SWB_3 + EWB_3 + FWB_3; *score range 0-108;
/* Trial outcome index (TOI) is a lung cancer-specific score that includes only the physical, functional, and lung cancer subscales.. 
TOI is particularly useful for postoperative lung cancer patients, per Paull et al. Am J Surgery, 2006, 192, 565-571 */
TOI_3= PWB_3 + FWB_3 + LCS_3; *score range 0-84;

* cigarette smoking;
* double check my computes – if/then statements may have errors;
if pt_smoking_how_many=1 then evercigsmoker= 1;
if pt_smoking_how_many=0 then evercigsmoker= 0;

*current cigarette smoker vs. never or former cigarette smoker;
if evercigsmoker=1 and pt_smoking_current=1 then currentcigsmoker=1;
if 0 le evercigsmoker le 1 and (currentcigsmoker ne 1) then currentcigsmoker=0;


/* Hospital Anxiety and Depression Scale (HADS; Zigmond & Snaith, 1983);
* HADS has 2 sub-scales, Depression and Anxiety, and requires reverse coding on some items;
* high score means worse depression or anxiety;
* will need to check later for missing data… if so, will need to adjust scale scores;
* correct scoring of individual items to match scoring in Zigmond & Snaith, 1983;*/;

array aax [8] hads_1 hads_3 hads_5 hads_6 hads_8 hads_10 hads_11 hads_13; * subtract 4 to reverse scoring and change range to 0-3;
array bbx [6] hads_2 hads_4 hads_7 hads_9 hads_12 hads_14; *scoring does not need to be reversed on these items – just subtract 1 to change range from 0-3;
array ccx [8] hads1 hads3 hads5 hads6 hads8 hads10 hads11 hads13;
array ddx [6] hads2 hads4 hads7 hads9 hads12 hads14;

do i = 1 to 8;
ccx[i]= abs(aax[i]-4); 
end; drop i; 

do i= 1 to 6;
ddx[i]= bbx[i]-1;
end; drop i; 

*create HADS sub-scales;
HADS_d_3= sum(hads2, hads4, hads6, hads8, hads10, hads12, hads14); *depression;
HADS_a_3= sum(hads1, hads3, hads5, hads7, hads9, hads11, hads13); *anxiety;


* Health literacy screener (from Chew et al., J Gen Intern Med, 2008, 23, 561-6);
* rescale from 1-5 to 0-4 to be consistent with original measure;


* Health literacy screener (from Chew et al., J Gen Intern Med, 2008, 23, 561-6);
* rescale from 1-5 to 0-4 to be consistent with original measure;
if 1 le pt_health_literacy_forms le 5 then do;
healthlit= abs(pt_health_literacy_forms-1);
end;


/* Financial burden of medical care;
/* from R.A. Cohen et al., Burden of medical care cost: early release of estimates from the National Health Interview Survey, 
January-June, 2011. National Center for Health Statistics. March 2012 */
/* Note that these items are analyzed individually in the original publication, above,
but we will sum them to create a total score, with higher score indicating greater burden…
Later, check the inter-item consistency of these items */

If (1 le pt_burden_past_12 le 2) and (1 le pt_burden_paid_off le 2) and (1 le pt_burden_not_paid le 2) then do; 
Financialburden_3= sum(pt_burden_past_12, pt_burden_paid_off, pt_burden_not_paid);
End;





* Barriers to completing treatment plan (pp 3-4 caregiver survey);
* Note that these were asked only if caregiver responded “not at all sure” or “a little sure” to caregiver_tx_option or caregiver_tx_completed;
/* Potential error: Note that according to the Data Dictionary, these variables were assigned identical names on the caregiver and patient files (e.g., pt_issues_a is the name for the item “Physical problems, such as …being too sick or not having enough strength” on both patient and caregiver surveys.  */
* Rename the variables on the caregiver survey – but check to see if this error has already been caught by Baptist;
*and rescore 1=yes, 2=no to 0=no, 1=yes;

array eex [8] pt_issues_a  pt_issues_b  pt_issues_c  pt_issues_d  pt_issues_e  pt_issues_f  pt_issues_g  pt_issues_h;
array ffx [8] cg_issues_a  cg_issues_b  cg_issues_c  cg_issues_d  cg_issues_e  cg_issues_f  cg_issues_g  cg_issues_h;

do i= 1 to 8;
ffx[i]= abs(eex[i]-2);
end; drop i; 
* create sum score;
sumcgbarriers_3= sum(cg_issues_a, cg_issues_b, cg_issues_c, cg_issues_d, cg_issues_e, cg_issues_f, cg_issues_g, cg_issues_h);
/*  be sure to drop pt_issues_a through pt_issues_h on the CAREGIVER file so that these variables are not overwritten on the PATIENT file  */
drop pt_issues_a pt_issues_b pt_issues_c pt_issues_d pt_issues_e pt_issues_f pt_issues_g pt_issues_h; 









* CAHPS items – Physician communication – 7 item version (p. 5 patient survey);
* We created 2 additional items (How often were doctors as helpful as you thought 
they should be, and How often did doctors seem to be aware of treatments for your 
lung cancer that other doctors recommend) to flesh out the 5-item CAHPS scale;
* Create a 7 item scale using the 5-item scale from Weeks et al., NEJM, 2012; 
* will need to evaluate internal consistency of these items later;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_pt_6 le 6 then caregiver_pt_6= .;
if 5 le caregiver_pt_7 le 6 then caregiver_pt_7= .;
* reverse scoring so that higher score indicates more positive communication (1-4 range);
xcaregiver_pt_6= abs(caregiver_pt_6-5); 
xcaregiver_pt_7= abs(caregiver_pt_7-5); 
sumcgphyscomm7_3= sum(xcaregiver_pt_1, xcaregiver_pt_2, xcaregiver_pt_3, xcaregiver_pt_4, xcaregiver_pt_5, xcaregiver_pt_6, xcaregiver_pt_7); 
run;
ods html close;



dm 'clear log';
dm 'clear output';
ods html;
title "patient 3 month";
proc print data=patient3;
var ptsumsattxplan_3 sumbarriers_3 sumsatteam_3 sumsatqc_3  sumphyscomm5_3 sumphyscomm7_3 sumnursecomm_3  sumteamsat_3  sumptinfo_3  PWB_3 SWB_3 EWB_3 FWB_3 LCS_3 FACTL_3
FACTG_3 TOI_3 sumcgphyscomm7_3 sumcgbarriers_3 Financialburden_3 HADS_d_3 HADS_a_3
 ;
run;
ods html close;



ods html;
dm 'clear log';
dm 'clear output';
data patient;
set patient;
* Combining variables;
if pt_overall_quality___1 =1 then pt_overall_quality=1;
if pt_overall_quality___2 =1  then pt_overall_quality =2;
if pt_overall_quality___3 =1 then  pt_overall_quality =3; 
if pt_overall_quality___4 =1  then pt_overall_quality =4; 
if pt_overall_quality___5 =1  then pt_overall_quality =5;
if pt_overall_quality___6 =1   then pt_overall_quality =6;
if pt_overall_quality___7  =1 then  pt_overall_quality =7;
drop pt_overall_quality___1 pt_overall_quality___2 pt_overall_quality___3 pt_overall_quality___4 pt_overall_quality___5 pt_overall_quality___6 pt_overall_quality___7;


* overall quality of health care since lung cancer diagnosis (p. 1 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing;

if 6 le pt_overall_quality le 7 then pt_overall_quality = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4);

xpt_overall_quality= abs(pt_overall_quality-5);

* overall pt_care_comparison since lung cancer diagnosis (p. 1 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing;

if 6 le pt_care_comparison le 7 then pt_care_comparison = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4);

xpt_care_comparison= abs(pt_care_comparison-5);
if hads_1___1=1 then hads_1=1;
if hads_1___2=1  then hads_1=2;
if hads_1___3=1  then hads_1=3;
if hads_1___4=1  then hads_1=4; 
drop hads_1___1 hads_1___2 hads_1___3 hads_1___4;

if hads_2___1=1   then hads_2=1;
if hads_2___2=1 then hads_2=2;
if hads_2___3=1 then hads_2=3;
if hads_2___4=1  then hads_2=4;
drop hads_2___1 hads_2___2 hads_2___3 hads_2___4;

if hads_3___1=1 then hads_3=1;
if hads_3___2=1 then hads_3=2; 
if  hads_3___3=1 then hads_3=3;
if hads_3___4=1 then hads_3=4; 
drop hads_3___1 hads_3___2 hads_3___3 hads_3___4;

if hads_4___1=1 then  hads_4=1;
if hads_4___2=1  then hads_4=2;
if hads_4___3=1 then hads_4=3;
if hads_4___4=1  then hads_4=4;
drop hads_4___1 hads_4___2 hads_4___3 hads_4___4;

if hads_5___1=1 then hads_5=1;
if hads_5___2=1 then hads_5=2;
if hads_5___3=1  then hads_5=3;
if hads_5___4=1 then hads_5=4;
drop hads_5___1 hads_5___2 hads_5___3 hads_5___4;

if hads_6___1=1 then  hads_6=1;
if hads_6___2=1 then hads_6=2;
if hads_6___3=1 then hads_6=3;
if hads_6___4=1 then hads_6=4;
drop hads_6___1 hads_6___2 hads_6___3 hads_6___4;

if hads_7___1=1 then hads_7=1;
if hads_7___2=1 then hads_7=2;
if hads_7___3=1  then hads_7=3;
if hads_7___4=1 then hads_7=4;
drop hads_7___1 hads_7___2 hads_7___3 hads_7___4;

if hads_8___1=1 then hads_8=1;
if hads_8___2=1 then hads_8=2;
if hads_8___3=1 then hads_8=3;
if hads_8___4=1 then hads_8=4;  
drop hads_8___1 hads_8___2 hads_8___3 hads_8___4;

if hads_9___1=1  then hads_9=1;
if hads_9___2=1  then  hads_9=2;
if hads_9___3=1  then  hads_9=3;
if hads_9___4=1 then hads_9=4;
drop hads_9___1 hads_9___2 hads_9___3 hads_9___4;

if hads_10___1=1 then hads_10=1;
if hads_10___2=1 then hads_10=2;
if hads_10___3=1 then hads_10=3;
if hads_10___4=1 then  hads_10=4; 
drop hads_10___1   hads_10___2 hads_10___3 hads_10___4;

if hads_11___1=1 then hads_11=1;
if  hads_11___2=1 then hads_11=2;
if  hads_11___3=1 then hads_11=3;
if  hads_11___4=1 then hads_11=4;
drop  hads_11___1  hads_11___2  hads_11___3  hads_11___4;

if hads_12___1=1  then hads_12=1;
if hads_12___2=1  then hads_12=2;
if hads_12___3=1  then  hads_12=3;
if hads_12___4=1    then hads_12=4;
drop hads_12___1 hads_12___2 hads_12___3 hads_12___4;

if hads_13___1=1  then  hads_13=1;
if hads_13___2=1 then  hads_13=2;
if hads_13___3=1  then hads_13=3;
if hads_13___4=1 then  hads_13=4;
drop hads_13___1 hads_13___2 hads_13___3 hads_13___4;

if hads_14___1=1   then hads_14=1;
if hads_14___2=1  then hads_14=2;
if hads_14___3=1  then hads_14=3;
if hads_14___4=1 then hads_14=4;  
drop hads_14___1 hads_14___2 hads_14___3 hads_14___4; 
/* CAHPS items – Treatment Decision Making (pp 1-3 patient survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 10-51);
* Coding of these items is based on Keating et al., J Clinical Oncol, 2010, 28, 4364-4370 and Weeks et al., NEJM, 2012, 367:1616-25;
* For each modality (surgery, chemo, radiation), categorize responses into “patient controlled,” “shared control,” or “physician control” per Keating;
* To keep the scoring simple, we will assume that the patient response “does not apply to me” means that the modality was not considered as an option, 
however if there is substantial missing data we will need to examine responses to the preceding items on whether the patient received the modality, is 
scheduled to receive the modality and discussed the modality with the physician;
* Computes for modality = surgery;*/

if 1 le treatment_1d_surgery le 2 then surgdecision= 0; *0=patient controlled;
*if  treatment_1d_surgery le 2 then  surgdecision= 0; *0=patient controlled;






if treatment_1d_surgery= 3 then surgdecision= 1; *1=shared decision;
if 4 le treatment_1d_surgery le 5 then surgdecision= 2; *2= physician decision;
* Computes for modality = radiation;
if 1 le treatment_2d_radiation le 2 then raddecision= 0; *0=patient controlled;
if treatment_2d_radiation= 3 then raddecision= 1; *1=shared decision;
if 4 le treatment_2d_radiation le 5 then raddecision= 2; *2= physician decision;
* Computes for modality = chemotherapy;
if 1 le treatment_3d_chemo le 2 then chemodecision= 0; *0=patient controlled;
if treatment_3d_chemo= 3 then chemodecision= 1; *1=shared decision;
if 4 le treatment_3d_chemo le 5 then chemodecision= 2; *2= physician decision;
* Computes for decision-making role of the family;
* if 1 le family_tx_decision le 2 then familydecision= 0; *0=patient controlled;
if family_tx_decision = 3 then familydecision= 1; *1=shared decision;
if 4 le family_tx_decision le 5 then familydecision= 2; *2= physician decision;
/** Satisfaction with treatment length of time (p. 3 patient survey);
* We created these items;
* set 5 (don’t know) and 6 (does not apply) to missing;
   */

if 5 le pt_sat_time_to_diagnosis le 6 then pt_sat_time_to_diagnosis= .;
if 5 le pt_sat_time_to_treatment le 6 then pt_sat_time_to_treatment= .;
if 5 le pt_sat_time_to_complete_tx le 6 then pt_sat_time_to_treatment= .;


* reverse code so greater numeric response = better (more frequent) physician communication (range 0-3);
xpt_sat_time_to_diagnosis_3= abs(pt_sat_time_to_diagnosis-4); 
xpt_sat_time_to_treatment_3= abs(pt_sat_time_to_treatment-4); 
xpt_sat_time_to_complete_tx_3= abs(pt_sat_time_to_complete_tx-4); 




/* 
* Satisfaction with treatment plan (p. 3 patient survey);
* Note that on the patient survey, both of these items were asked, regardless of whether the patient’s treatment
had yet been completed… likewise, items regarding obstacles on completing treatment (p. 4 patient survey) were asked
regardless of whether treatment was completed;
* We created these items;
* recode so range is 0-2 instead of 1-3;
*/

xpt_sat_treatment_plan= pt_sat_treatment_plan-1; *(pt_sat_time_to_treatment);
xpt_sat_treatment_compl= pt_sat_treatment_compl;
* sum the 2 items – later, check intercorrelation;
ptsumsattxplan= sum(xpt_sat_treatment_plan, xpt_sat_treatment_compl);





/* * Barriers to completing treatment plan (p. 4 patient survey);
* rescore 1=yes, 2=no to 0=no, 1=yes;
* note that these items were asked regardless of whether treatment was completed;

array aa [8] pt_issues_a  pt_issues_b  pt_issues_c  pt_issues_d  pt_issues_e  pt_issues_f  pt_issues_g  pt_issues_h; 
array bb [8] xpt_issues_a  xpt_issues_b  xpt_issues_c  xpt_issues_d  xpt_issues_e  xpt_issues_f  xpt_issues_g  xpt_issues_h; 
do i= 1 to 8;
bb[i]= abs(aa[i]-2);
end; drop i;
*/

* create sum score;
*sumbarriers = sum(xpt_issues_a, xpt_issues_b, xpt_issues_c, xpt_issues_d, xpt_issues_e, xpt_issues_f, xpt_issues_g, xpt_issues_h); 
*drop xpt_issues_a xpt_issues_b xpt_issues_c xpt_issues_d xpt_issues_e xpt_issues_f xpt_issues_g xpt_issues_h; 
*/;

xpt_issues_a=abs(pt_issues_a-2);
xpt_issues_b =abs(pt_issues_b-2);
xpt_issues_c =abs(pt_issues_c-2);
xpt_issues_d= abs(pt_issues_d-2); 
xpt_issues_e = abs(pt_issues_e-2); 
xpt_issues_f= abs(pt_issues_f -2);  
xpt_issues_g= abs(pt_issues_g-2);   
xpt_issues_h= abs(pt_issues_h-2) ;

sumbarriers = sum(xpt_issues_a, xpt_issues_b, xpt_issues_c, xpt_issues_d, xpt_issues_e, xpt_issues_f, xpt_issues_g, xpt_issues_h); 







/* 
* Satisfaction with quality of care from various team members (p. 4 patient survey);
* set 5 (don’t know) and 6 (does not apply) to missing;

*/

array bba [8] pt_sat_care_pcc  pt_sat_care_onc  pt_sat_care_pulm  pt_sat_care_surgeon  pt_sat_care_nurse_nav  pt_sat_care_other_nurses  pt_sat_care_nonclinic  
pt_sat_care_whole_team;
array cc [8] xpt_sat_care_pcc xpt_sat_care_onc  xpt_sat_care_pulm  xpt_sat_care_surgeon xpt_sat_care_nurse_nav xpt_sat_care_other_nurses xpt_sat_care_nonclinic  
xpt_sat_care_whole_team;
do i= 1 to 8;
if 5 le bba[i] le 6 then bba[i]= .;

* reverse code so greater numeric response = greater satisfaction (range 0-3);
cc[i]= abs(bba[i]-4);
end; drop i;
* create sum score for overall satisfaction with quality of care;
sumsatteam= sum( xpt_sat_care_onc,  xpt_sat_care_pulm, xpt_sat_care_nurse_nav, xpt_sat_care_other_nurses, xpt_sat_care_nonclinic, xpt_sat_care_whole_team);

* sumsatteam xpt_sat_care_surgeon,xpt_sat_care_pcc;

sumsatqc= sum(xpt_sat_care_pcc, xpt_sat_care_onc,  xpt_sat_care_pulm,  xpt_sat_care_surgeon, xpt_sat_care_nurse_nav, xpt_sat_care_other_nurses, xpt_sat_care_nonclinic, xpt_sat_care_whole_team);




/* CAHPS items – Physician communication – 5 item version (p. 5 patient survey);
* Replicate scale used in Weeks et al., NEJM, 2012, 367:1616-25 (see p. 1618), which is sum of 5 CAHPS items; 
* note that Weeks et al. re-scales instrument for a 0-100 range – we are retaining the 1-4 scores on each of the 5 items 
(total scale score range of 5-20) from the original CAHPS survey;
* set 5 (don’t know) and 6 (does not apply) to missing;*/

if 5 le pt_exp_phys_listen le 6 then pt_exp_phys_listen= .;
if 5 le pt_exp_phys_explain le 6 then pt_exp_phys_explain= .;
if 5 le pt_exp_phys_tx_inform le 6 then pt_exp_phys_tx_inform= .;
if 5 le pt_exp_phys_encourage le 6 then pt_exp_phys_encourage= .;
if 5 le pt_exp_phys_respect le 6 then pt_exp_phys_respect= .;
* reverse code so greater numeric response = better (more frequent) physician communication;
xpt_exp_phys_listen= abs(pt_exp_phys_listen-5); 
xpt_exp_phys_explain= abs(pt_exp_phys_explain-5); 
xpt_exp_phys_tx_inform= abs(pt_exp_phys_tx_inform-5); 
xpt_exp_phys_encourage= abs(pt_exp_phys_encourage-5); 
xpt_exp_phys_respect= abs(pt_exp_phys_respect-5); 
* create sum score;
sumphyscomm5= sum(xpt_exp_phys_listen, xpt_exp_phys_explain, xpt_exp_phys_tx_inform, 
xpt_exp_phys_encourage, xpt_exp_phys_respect); 





/* CAHPS items – Physician communication – 7 item version (p. 5 patient survey);
* We created 2 additional items (How often were doctors as helpful as you thought 
they should be, and How often did doctors seem to be aware of treatments for your lung 
cancer that other doctors recommend) to flesh out the 5-item CAHPS scale;
* Create a 7 item scale using the 5-item scale from Weeks et al., NEJM, 2012; 
* will need to evaluate internal consistency of these items later;
* set 5 (don’t know) and 6 (does not apply) to missing;*/

if 5 le pt_exp_phys_helpful le 6 then pt_exp_phys_helpful= .;
if 5 le pt_exp_phys_aware le 6 then pt_exp_phys_aware= .;
xpt_exp_phys_helpful= abs(pt_exp_phys_helpful-5); 
xpt_exp_phys_aware= abs(pt_exp_phys_aware-5); 
sumphyscomm7= sum(xpt_exp_phys_listen, xpt_exp_phys_explain, xpt_exp_phys_tx_inform, 
xpt_exp_phys_encourage, xpt_exp_phys_respect, xpt_exp_phys_helpful, xpt_exp_phys_aware); 






/*
* We created a 6-item nurse communication measure based on the CAHPS Physician Communication items (pp 5-6 patient survey);
* will need to verify internal consistency of this measure;
* set 5 (don’t know) and 6 (does not apply) to missing;
*/

if 5 le pt_exp_nurse_listen le 6 then pt_exp_nurse_listen= .;
if 5 le pt_nurses_often_explain le 6 then pt_nurses_often_explain= .;
if 5 le pt_nurses_often_info le 6 then pt_nurses_often_info= .;
if 5 le pt_nurses_often_encourage le 6 then pt_nurses_often_encourage= .;
if 5 le pt_nurses_often_treat le 6 then pt_nurses_often_treat= .;
if 5 le pt_nurses_often_help le 6 then pt_nurses_often_help= .;
* reverse code so greater numeric response = better (more frequent) nurse communication (0-3 scoring for each item);
xpt_exp_nurse_listen= abs(pt_exp_nurse_listen-4); 
xpt_nurses_often_explain = abs(pt_nurses_often_explain-4); 
xpt_nurses_often_info = abs(pt_nurses_often_info-4); 
xpt_nurses_often_encourage = abs(pt_nurses_often_encourage-4); 
xpt_nurses_often_treat = abs(pt_nurses_often_treat-4); 
xpt_nurses_often_help = abs(pt_nurses_often_help-4); 
* create sum score;
sumnursecomm= sum(xpt_exp_nurse_listen, xpt_nurses_often_explain, xpt_nurses_often_info, xpt_nurses_often_encourage, xpt_nurses_often_treat,  
xpt_nurses_often_help); 

  



/* 4 items (p. 6 of patient survey) plus 1 item (item 7 on p. 7 patient survey) ask about satisfaction with care from the team as a whole; 
* the first two items are from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 6) and the second two we created ourselves;
* item 7 on p.7 patient survey (included with the Pardon et al., 2011 items) belongs here – pt_inform_all_they_could;
* create sum score from these 4 items – check inter-item consistency later;
 * set 5 (don’t know) and 6 (does not apply) to missing;
*/
if 5 le pt_nurses_often_handle le 6 then pt_nurses_often_handle= .;
if 5 le pt_nurses_often_team le 6 then pt_nurses_often_team= .;
if 5 le pt_nurses_often_discomfort le 6 then pt_nurses_often_discomfort= .;
if 5 le pt_nurses_often_understand le 6 then pt_nurses_often_understand= .;
if 5 le pt_inform_all_they_could le 6 then pt_inform_all_they_could = .;
* reverse code so greater numeric response = better (more frequent) physician communication (range 0-3);
xpt_nurses_often_handle= abs(pt_nurses_often_handle-4);
xpt_nurses_often_team= abs(pt_nurses_often_team-4); 
xpt_nurses_often_discomfort= abs(pt_nurses_often_discomfort-4); 
xpt_nurses_often_understand= abs(pt_nurses_often_understand-4); 
xpt_inform_all_they_could= abs(pt_inform_all_they_could-4);
* create sum score;
sumteamsat= sum(xpt_nurses_often_handle, xpt_nurses_often_team,  
xpt_nurses_often_discomfort, xpt_nurses_often_understand, xpt_inform_all_they_could);  





/*
* Communication about disease-specific information;
/* The questions are adapted from K. Pardon et al., Are patients’ preferences for information and 
participation in medical decision-making being met? Interview study with lung cancer patients. 
Palliative Medicine, 2011, 25(1), 62-70.  For consistency, responses changes from 6-point Likert 
(totally disagree to totally agree) to 4 items that are used in the CAHPS patient survey (always,
usually, sometimes, never) */
* note that Item 7 (p. 7 of patient survey) does not belong here – it is not an item from the
Pardon et al. scale, which has just 6 items about specific types of information (we did not include 
the “In general…” question);
* set 5 (don’t know) and 6 (does not apply) to missing; 
 
*/;

if 5 le pt_inform_diagnosis le 6 then pt_inform_diagnosis= .;
if 5 le pt_inform_tx_options le 6 then pt_inform_tx_options= .;
if 5 le pt_inform_cure_chance le 6 then pt_inform_cure_chance= .;
if 5 le pt_inform_life_expectancy le 6 then pt_inform_life_expectancy= .;
if 5 le pt_inform_palliative_care le 6 then pt_inform_palliative_care = .;
if 5 le pt_inform_end_of_life le 6 then pt_inform_end_of_life = .;
* reverse code so greater numeric response = better (more frequent) response (range 0-3);
xpt_inform_diagnosis= abs(pt_inform_diagnosis-4); 
xpt_inform_tx_options= abs(pt_inform_tx_options-4); 
xpt_inform_cure_chance= abs(pt_inform_cure_chance-4); 
xpt_inform_life_expectancy= abs(pt_inform_life_expectancy-4); 
xpt_inform_palliative_care= abs(pt_inform_palliative_care-4); 
xpt_inform_end_of_life= abs(pt_inform_end_of_life-4); 
* create sum score from these 6 items – check inter-item consistency later;
sumptinfo= sum(xpt_inform_diagnosis, xpt_inform_tx_options, xpt_inform_cure_chance, xpt_inform_life_expectancy, xpt_inform_palliative_care, xpt_inform_end_of_life); 



/* Functional Assessment of Cancer Therapy – Lung (FACT-L) – Version 4;
* Some items must be reverse-scored, so that higher scores on all sub-scales and summary scores indicate better QOL;
* At least 80% of the questions should be answered, per Paull et al. (p. 566) for the instrument to be scored;
* As long as at least half of the items for any particular sub-scale are answered, a sub-scale score can be estimated by taking an average (Browning et al., p. 4; also see http://www.meducator3.net/algorithms/content/lung-cancer-subscale-lcs-fact-l-1);
/* example algorithm to adjust the 6-item LCS sub-scale when only 4 of 6 items were answered;
total score adjusted to 7 items= ((score for answered items)*7)/(number of items answered);
*/ 
* need to check missing data patterns: there may be very little missing data because Redcap doesn’t allow skips…if there is missing data, we need to follow above rules to calculate estimates;
 
*set 6 (don’t know) and 7 (does not apply) to missing;*/;

array dd [36] pt_factl1 - pt_factl35 pt_smoking_regret;
do i= 1 to 36;
if 6 le dd[i] le 7 then dd[i] = .; 
end; drop i; 


* reverse score negative items so that higher score means better functioning;
* note that according to the Data Dictionary, the Baptist programmer changed the naming 
convention on the FACT-L after item 28 (e.g., item 28= pt_factl28 while item 29= pt_fctl_29);

array ee [17] pt_factl1 pt_factl2 pt_factl3 pt_factl4 pt_factl5 pt_factl6 pt_factl7 pt_factl15  pt_factl17 pt_factl18 pt_factl19 pt_factl20  pt_factl28 pt_fctl_29 pt_fctl_31 pt_fctl_32 pt_fctl_34;
array ff [17] xpt_factl1 xpt_factl2 xpt_factl3 xpt_factl4 xpt_factl5 xpt_factl6 xpt_factl7 xpt_factl15  xpt_factl17 xpt_factl18 xpt_factl19 xpt_factl20 xpt_factl28 xpt_fctl_29 xpt_fctl_31 xpt_fctl_32 xpt_fctl_34;
do i= 1 to 17;
ff[i] = abs(ee[i]-6);
end; drop i; 
*create the 5 sub-scales;
* Physical well-being (PWB) sub-scale;
PWB= sum(xpt_factl1, xpt_factl2, xpt_factl3, xpt_factl4, xpt_factl5, xpt_factl6, xpt_factl7);
* Social well-being (SWB) sub-scale;
SWB= sum(pt_factl8, pt_factl9, pt_factl10, pt_factl11, pt_factl12, pt_factl13, pt_factl14);
* Emotional well-being (EWB) sub-scale;
EWB= sum(xpt_factl15, pt_factl16, xpt_factl17, xpt_factl18, xpt_factl19, xpt_factl20);
* Functional well-being (FWB) sub-scale;
FWB= sum(pt_factl21, pt_factl22, pt_factl23, pt_factl24, pt_factl25, pt_factl26, pt_factl27);
* Lung cancer scale (LCS) sub-scale;
LCS= sum(xpt_factl28, xpt_fctl_29, pt_fctl_30, xpt_fctl_31, xpt_fctl_32, pt_fctl_33, xpt_fctl_34, pt_fctl_35, pt_smoking_regret);
* calculate summary scales;
/* Total summary score – see Paull et al., p. 566 */
FACTL= PWB + SWB + EWB + FWB + LCS; *score range 0-136 -- * note that total overall score range is 0-135 (not 0-136) per Browning et al., Lung Cancer, 2009, 66, 134-39;
/* FACT-G score (generic measurement of QOL for patients with cancer in general, not lung cancer-specific, is the total FACT-L score minus the lung cancer subscale */
FACTG= PWB + SWB + EWB + FWB; *score range 0-108;
/* Trial outcome index (TOI) is a lung cancer-specific score that includes only the physical, functional, and lung cancer subscales.. 
TOI is particularly useful for postoperative lung cancer patients, per Paull et al. Am J Surgery, 2006, 192, 565-571 */
TOI= PWB + FWB + LCS; *score range 0-84;

* cigarette smoking;
* double check my computes – if/then statements may have errors;
if pt_smoking_how_many=1 then evercigsmoker= 1;
if pt_smoking_how_many=0 then evercigsmoker= 0;

*current cigarette smoker vs. never or former cigarette smoker;
if evercigsmoker=1 and pt_smoking_current=1 then currentcigsmoker=1;
if 0 le evercigsmoker le 1 and (currentcigsmoker ne 1) then currentcigsmoker=0;


/* Hospital Anxiety and Depression Scale (HADS; Zigmond & Snaith, 1983);
* HADS has 2 sub-scales, Depression and Anxiety, and requires reverse coding on some items;
* high score means worse depression or anxiety;
* will need to check later for missing data… if so, will need to adjust scale scores;
* correct scoring of individual items to match scoring in Zigmond & Snaith, 1983;*/;

array aax [8] hads_1 hads_3 hads_5 hads_6 hads_8 hads_10 hads_11 hads_13; * subtract 4 to reverse scoring and change range to 0-3;
array bbx [6] hads_2 hads_4 hads_7 hads_9 hads_12 hads_14; *scoring does not need to be reversed on these items – just subtract 1 to change range from 0-3;
array ccx [8] hads1 hads3 hads5 hads6 hads8 hads10 hads11 hads13;
array ddx [6] hads2 hads4 hads7 hads9 hads12 hads14;

do i = 1 to 8;
ccx[i]= abs(aax[i]-4); 
end; drop i; 

do i= 1 to 6;
ddx[i]= bbx[i]-1;
end; drop i; 

*create HADS sub-scales;
HADS_d= sum(hads2, hads4, hads6, hads8, hads10, hads12, hads14); *depression;
HADS_a= sum(hads1, hads3, hads5, hads7, hads9, hads11, hads13); *anxiety;


* Health literacy screener (from Chew et al., J Gen Intern Med, 2008, 23, 561-6);
* rescale from 1-5 to 0-4 to be consistent with original measure;


* Health literacy screener (from Chew et al., J Gen Intern Med, 2008, 23, 561-6);
* rescale from 1-5 to 0-4 to be consistent with original measure;
if 1 le pt_health_literacy_forms le 5 then do;
healthlit= abs(pt_health_literacy_forms-1);
end;


/* Financial burden of medical care;
/* from R.A. Cohen et al., Burden of medical care cost: early release of estimates from the National Health Interview Survey, 
January-June, 2011. National Center for Health Statistics. March 2012 */
/* Note that these items are analyzed individually in the original publication, above,
but we will sum them to create a total score, with higher score indicating greater burden…
Later, check the inter-item consistency of these items */

If (1 le pt_burden_past_12 le 2) and (1 le pt_burden_paid_off le 2) and (1 le pt_burden_not_paid le 2) then do; 
Financialburden= sum(pt_burden_past_12, pt_burden_paid_off, pt_burden_not_paid);
End;





* Barriers to completing treatment plan (pp 3-4 caregiver survey);
* Note that these were asked only if caregiver responded “not at all sure” or “a little sure” to caregiver_tx_option or caregiver_tx_completed;
/* Potential error: Note that according to the Data Dictionary, these variables were assigned identical names on the caregiver and patient files (e.g., pt_issues_a is the name for the item “Physical problems, such as …being too sick or not having enough strength” on both patient and caregiver surveys.  */
* Rename the variables on the caregiver survey – but check to see if this error has already been caught by Baptist;
*and rescore 1=yes, 2=no to 0=no, 1=yes;

array eex [8] pt_issues_a  pt_issues_b  pt_issues_c  pt_issues_d  pt_issues_e  pt_issues_f  pt_issues_g  pt_issues_h;
array ffx [8] cg_issues_a  cg_issues_b  cg_issues_c  cg_issues_d  cg_issues_e  cg_issues_f  cg_issues_g  cg_issues_h;

do i= 1 to 8;
ffx[i]= abs(eex[i]-2);
end; drop i; 
* create sum score;
sumcgbarriers= sum(cg_issues_a, cg_issues_b, cg_issues_c, cg_issues_d, cg_issues_e, cg_issues_f, cg_issues_g, cg_issues_h);
/*  be sure to drop pt_issues_a through pt_issues_h on the CAREGIVER file so that these variables are not overwritten on the PATIENT file  */
drop pt_issues_a pt_issues_b pt_issues_c pt_issues_d pt_issues_e pt_issues_f pt_issues_g pt_issues_h; 









* CAHPS items – Physician communication – 7 item version (p. 5 patient survey);
* We created 2 additional items (How often were doctors as helpful as you thought 
they should be, and How often did doctors seem to be aware of treatments for your 
lung cancer that other doctors recommend) to flesh out the 5-item CAHPS scale;
* Create a 7 item scale using the 5-item scale from Weeks et al., NEJM, 2012; 
* will need to evaluate internal consistency of these items later;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_pt_6 le 6 then caregiver_pt_6= .;
if 5 le caregiver_pt_7 le 6 then caregiver_pt_7= .;
* reverse scoring so that higher score indicates more positive communication (1-4 range);
xcaregiver_pt_6= abs(caregiver_pt_6-5); 
xcaregiver_pt_7= abs(caregiver_pt_7-5); 
sumcgphyscomm7= sum(xcaregiver_pt_1, xcaregiver_pt_2, xcaregiver_pt_3, xcaregiver_pt_4, xcaregiver_pt_5, xcaregiver_pt_6, xcaregiver_pt_7); 
run;
ods html close;

dm 'clear log';
dm 'clear output';
ods html;
title "patient Baseline";
proc print data=patient;
var ptsumsattxplan sumbarriers sumsatteam sumsatqc  sumphyscomm5 sumphyscomm7 sumnursecomm  sumteamsat  sumptinfo  PWB SWB EWB FWB LCS FACTL
FACTG TOI sumcgphyscomm7 sumcgbarriers Financialburden HADS_d HADS_a
 ;
run;
ods html close;




/* 
join two tables with inner join
*/


proc sql;
create table mergepatient as
select
     T1.patient_id,ID,ptsumsattxplan, sumbarriers, sumsatteam, sumsatqc,  sumphyscomm5, sumphyscomm7, sumnursecomm,sumteamsat,
sumptinfo,PWB,SWB, EWB, FWB, LCS, FACTL,FACTG, TOI, sumcgphyscomm7, sumcgbarriers, Financialburden, HADS_d, HADS_a,
  ptsumsattxplan_3, sumbarriers_3, sumsatteam_3, sumsatqc_3,  sumphyscomm5_3, sumphyscomm7_3, sumnursecomm_3,  sumteamsat_3,  sumptinfo_3,
PWB_3, SWB_3, EWB_3, FWB_3, LCS_3, FACTL_3,FACTG_3, TOI_3, sumcgphyscomm7_3, sumcgbarriers_3, Financialburden_3, HADS_d_3, HADS_a_3  
from
    patient AS T1
        inner join
    patient3 AS T2 ON T1.patient_id = T2.patient_id
order patient_id;

quit;
proc print data=mergepatient;
run;



data mergepatient;
set mergepatient;
array a [22]  ptsumsattxplan sumbarriers sumsatteam sumsatqc  sumphyscomm5 sumphyscomm7 sumnursecomm sumteamsat
sumptinfo PWB SWB EWB FWB LCS FACTL FACTG TOI sumcgphyscomm7 sumcgbarriers Financialburden HADS_d HADS_a;
array b [22] ptsumsattxplan_3 sumbarriers_3 sumsatteam_3 sumsatqc_3  sumphyscomm5_3 sumphyscomm7_3 sumnursecomm_3 sumteamsat_3 sumptinfo_3
PWB_3 SWB_3 EWB_3 FWB_3 LCS_3 FACTL_3 FACTG_3 TOI_3 sumcgphyscomm7_3 sumcgbarriers_3 Financialburden_3 HADS_d_3 HADS_a_3;

array c [22] diffptsumsattxplan diffsumbarriers diffsumsatteam diffsumsatqc  diffsumphyscomm5 diffsumphyscomm7 diffsumnursecomm diffsumteamsat
diffsumptinfo diffPWB diffSWB diffEWB diffFWB diffLCS diffFACTL diffFACTG diffTOI diffsumcgphyscomm7 diffsumcgbarriers diffFinancialburden diffHADSd diffHADSa;

do i = 1 to 20;
c[i]= abs(b[i]-a[i]); 
*c[i]= (a[i]-b[i]);
end; drop i; 


proc print data=mergepatient;
var ID diffptsumsattxplan diffsumbarriers diffsumsatteam diffsumsatqc  diffsumphyscomm5 diffsumphyscomm7 diffsumnursecomm diffsumteamsat
diffsumptinfo diffPWB diffSWB diffEWB diffFWB diffLCS diffFACTL diffFACTG diffTOI diffsumcgphyscomm7 diffsumcgbarriers diffFinancialburden diffHADSd diffHADSa;
run;

/*

SAS Macro for Wilcoxon Test
*/


dm 'clear log';
dm 'clear output';
ods html;
%macro  wilcoxontest (variable=, data=);

proc NPAR1WAY data=&data wilcoxon correct=yes ;
	*title "Nonparametric test  for FACTG";
	class ID;
	var   &Variable;
	*exact wilcoxon;
	title "&variable";
   run;
   %mend  wilcoxontest;
%wilcoxontest( variable=diffptsumsattxplan, data=mergepatient )

   ods html close;


dm 'clear log';
dm 'clear output';
ods html;
proc freq data = mergepatient;
by ID;
run;
proc means data = mergepatient mean std range n  nmiss sum var median;
var diffptsumsattxplan diffsumbarriers diffsumsatteam diffsumsatqc  diffsumphyscomm5 diffsumphyscomm7 diffsumnursecomm diffsumteamsat
diffsumptinfo diffPWB diffSWB diffEWB diffFWB diffLCS diffFACTL diffFACTG diffTOI diffsumcgphyscomm7 diffsumcgbarriers diffFinancialburden diffHADSd diffHADSa ; 
run;
ods html close;
ods listing;

*------------------------------------------------------------------------------------------------------------------*;
/* join two tables with  join
*------------------------------------------------------------------------------------------------------------------*;


proc sql;
create table newdiff as
select a.participant_id, a.onc, a.pulm, a.surg, a.nn, a.other_nurses, a.support, a.whole_staff, a.team, a.comm, a.encourage,
a.answer, a.listen, a.gave_info, a.gave_enough_info, a.courtesy, a.helpful, a.referring_doc, a.clear_understand ,
a.best_options, a.clinic_satisfaction_survey_compl,

 b.participant_id as  b_participant_id, b.onc as b_onc, a.pulm as a_pulm, b.surg as b_surg, b.nn as b_nn, b.other_nurses as b_other_nurses,
b.support as b_support, b.whole_staff as b_whole_staff, b.team as b_team, b.comm as b_comm, b.encourage as b_encourage,
b.answer as b_answer, b.listen as b_listen, b.gave_info as b_gave_info, b.gave_enough_info as b_gave_enough_info, b.courtesy as b_courtesy, 
b.helpful as b_helpful, b.referring_doc as b_referring_doc, b.clear_understand as b_clear_understand, 
b.best_options as b_best_options, b.clinic_satisfaction_survey_compl as b_clinic_satisfaction

from work.Patient as a,
work.Caregiver as b
where substr(a.participant_id, 1, 10)=substr(b_participant_id, 1, 10);
*order by participant_id;
quit;
proc print data=work.newdiff;
run;
ods html close;
ods listing;


*------------------------------------------------------------------------------------------------------------------*;
/* create difference score  between Caregiver satisfaction
  and Patient Satisfaction
*------------------------------------------------------------------------------------------------------------------*;
 
ods html;
dm 'clear log';
dm 'clear output';

data work.newdiff1;
set work.newdiff;
array a [20] onc pulm surg nn other_nurses support whole_staff team comm encourage
answer listen gave_info gave_enough_info courtesy helpful referring_doc clear_understand 
best_options clinic_satisfaction_survey_compl;
array b [20] b_onc pulm b_surg b_nn b_other_nurses b_support b_whole_staff b_team b_comm b_encourage
b_answer b_listen b_gave_info b_gave_enough_info b_courtesy b_helpful b_referring_doc b_clear_understand 
b_best_options b_clinic_satisfaction;

array c [20] diffonc diffpulm diffsurg diffnn diffother_nurses diffsupport diffwhole_staff diffteam diffcomm diffencourage
diffanswer difflisten diffgave_info diffgave_enough_info diffcourtesy diffhelpful diffreferring_doc diffclear_understand 
diffbest_options diffclinic_sat;

do i = 1 to 20;
c[i]= abs(a[i]-b[i]); 
*c[i]= (a[i]-b[i]);
end; drop i; 

run;
