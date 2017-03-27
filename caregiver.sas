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
data caregiver;
set caregiver;

/* COMPUTES FOR PCORI CAREGIVER SURVEY – BASELINE;

* overall quality of health care since lung cancer diagnosis (p. 1 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing*/;
if 6 le caregiver_pt_quality le 7 then caregiver_pt_quality = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4)
xcaregiver_pt_quality= abs(caregiver_pt_quality)-5;

/* Quality of care compared to other lung cancer patients (p. 1 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing*/;

if 6 le caregiver_lung_care le 7 then caregiver_lung_care = .; 
* reverse code so greater numeric response = greater satisfaction (range 0-4);
xcaregiver_lung_care = abs(caregiver_lung_care-5);

/* CAHPS items – Treatment Decision Making (pp 1-3 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 10-51);
* Coding of these items is based on Keating et al., J Clinical Oncol, 2010, 28, 4364-4370 and Weeks et al., NEJM, 2012, 367:1616-25;
* For each modality (surgery, chemo, radiation), categorize responses into “patient controlled,” “shared control,” or “physician control” per Keating;
* Computes for modality = surgery*/;

if 1 le cg_1d_tx_surgery le 2 then cgsurgdecision= 0; *0=patient controlled;
if cg_1d_tx_surgery = 3 then cgsurgdecision= 1; *1=shared decision;
if 4 le cg_1d_tx_surgery le 5 then cgsurgdecision= 2; *2= physician decision;

* Computes for modality = radiation;
if 1 le cg_2d_tx_radiation le 2 then cgraddecision= 0; *0=patient controlled;
if cg_2d_tx_radiation = 3 then cgraddecision= 1; *1=shared decision;
if 4 le cg_2d_tx_radiation le 5 then cgraddecision= 2; *2= physician decision;

* Computes for modality = chemotherapy;
if 1 le cg_3d_tx_chemo le 2 then cgchemodecision= 0; *0=patient controlled;
if cg_3d_tx_chemo = 3 then cgchemodecision= 1; *1=shared decision;
if 4 le cg_3d_tx_chemo le 5 then cgchemodecision= 2; *2= physician decision;

/* Computes for decision-making role of the family;
* if 1 le cg_4_family_decision le 2 then cgfamilydecision= 0; *0=patient controlled;*/

if cg_4_family_decision = 3 then cgfamilydecision= 1; *1=shared decision;
if 4 le cg_4_family_decision le 5 then cgfamilydecision= 2; *2= physician decision;

* Satisfaction with treatment plan (p. 3 caregiver survey);
* We created these items;
* Note that the 2 items can’t be summed (as they were for the patient survey) because the 2nd item 
(can pt complete treatment plan) was asked only of patients who have not yet initiated treatment or
were currently receiving treatment; 
* change scaling from 1-3 to 0-2 for both items;
xcaregiver_tx_option= caregiver_tx_option-1;
xcaregiver_tx_complete= caregiver_tx_complete-1;

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



/* Communication about disease-specific information (p 4 caregiver survey);
/* Items are the same that are used on the patient survey; they are adapted from K. Pardon 
et al., Are patients’ preferences for information and participation in medical decision-making being met?
Interview study with lung cancer patients. Palliative Medicine, 2011, 25(1), 62-70.  For consistency, responses
changes from 6-point Likert (totally disagree to totally agree) to 4 items that are used in the CAHPS patient
survey (always, usually, sometimes, never) */
* set 5 (don’t know) and 6 (does not apply) to missing;*/;

if 5 le cg_inform_diagnosis le 6 then cg_inform_diagnosis= .;
if 5 le cg_inform_tx_options le 6 then cg_inform_tx_options= .;
if 5 le cg_inform_cure_chance le 6 then cg_inform_cure_chance= .;
if 5 le cg_inform_life_expectancy le 6 then cg_inform_life_expectancy= .;
if 5 le cg_inform_palliative_care le 6 then cg_inform_palliative_care = .;
if 5 le cg_inform_end_of_life le 6 then cg_inform_end_of_life = .;

* reverse code so greater numeric response = better (more frequent) response (range 0-3);

xcg_inform_diagnosis= abs(cg_inform_diagnosis-4); 
xcg_inform_tx_options= abs(cg_inform_tx_options-4); 
xcg_inform_cure_chance= abs(cg_inform_cure_chance-4); 
xcg_inform_life_expectancy= abs(cg_inform_life_expectancy-4); 
xcg_inform_palliative_care= abs(cg_inform_palliative_care-4); 
xcg_inform_end_of_life= abs(cg_inform_end_of_life-4); 
* create sum score from these 6 items – check inter-item consistency later;
sumcginfo= sum(xcg_inform_diagnosis, xcg_inform_tx_options,  xcg_inform_cure_chance, xcg_inform_life_expectancy, xcg_inform_palliative_care, xcg_inform_end_of_life); 


* Satisfaction with quality of care from various team members (p. 4 patient survey);
* set 5 (don’t know) and 6 (does not apply) to missing;
array gg [8] sat_caregiver_pc sat_caregiver_onc sat_caregiver_pulmo sat_caregiver_surg sat_caregiver_nurse sat_caregiver_nav sat_caregiver_other_staff sat_caregiver_whole;
array hh [8] xsat_caregiver_pc xsat_caregiver_onc xsat_caregiver_pulmo xsat_caregiver_surg xsat_caregiver_nurse xsat_caregiver_nav xsat_caregiver_other_staff xsat_caregiver_whole;

do i= 1 to 8;
if 5 le gg[i] le 6 then gg[i]= .;
end;  drop i; 
* reverse code so greater numeric response = greater satisfaction (range 0-3);

do i= 1 to 8;
hh[i]= abs(gg[i]-4);
end; drop i;
* create sum score for overall satisfaction with quality of care;
sumcgsatqc= sum(xsat_caregiver_pc, xsat_caregiver_onc, xsat_caregiver_pulmo, xsat_caregiver_surg, xsat_caregiver_nurse, xsat_caregiver_nav, xsat_caregiver_other_staff, xsat_caregiver_whole);




* CAHPS items – Physician communication – 5 item version (p. 5 caregiver survey);
* Replicate scale used in Weeks et al., NEJM, 2012, 367:1616-25 (see p. 1618), which is sum of 5 CAHPS items; 
* note that Weeks et al. re-scales instrument for a 0-100 range – we are retaining the 1-4 scores on each of 
the 5 items (total scale score range of 5-20) from the original CAHPS survey;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_pt_1 le 6 then caregiver_pt_1= .;
if 5 le caregiver_pt_2 le 6 then caregiver_pt_2 = .;
if 5 le caregiver_pt_3 le 6 then caregiver_pt_3 = .;
if 5 le caregiver_pt_4 le 6 then caregiver_pt_4 = .;
if 5 le caregiver_pt_5 le 6 then caregiver_pt_5 = .;
/* reverse code so greater numeric response = better (more frequent) physician communication but retain 1-4 scoring to match original CAHPS survey */
xcaregiver_pt_1=  abs(caregiver_pt_1-5); 
xcaregiver_pt_2 = abs(caregiver_pt_2-5); 
xcaregiver_pt_3 = abs(caregiver_pt_3-5); 
xcaregiver_pt_4 = abs(caregiver_pt_4-5); 
xcaregiver_pt_5 = abs(caregiver_pt_5-5); 
* create sum score for 5-item scale – check inter-item consistency later;
sumcgphyscomm5= sum(xcaregiver_pt_1, xcaregiver_pt_2, xcaregiver_pt_3, xcaregiver_pt_4, xcaregiver_pt_5); 



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





* We created a 6-item nurse communication measure based on the CAHPS Physician 
ommunication items (pp 5-6 caregiver survey);
* will need to verify internal consistency of this measure;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le cg_careteam_8 le 6 then cg_careteam_8= .;
if 5 le cg_careteam_9 le 6 then cg_careteam_9= .;
if 5 le cg_careteam_10 le 6 then cg_careteam_10= .;
if 5 le cg_careteam_11 le 6 then cg_careteam_11= .;
if 5 le cg_careteam_12 le 6 then cg_careteam_12= .;
if 5 le cg_careteam_13 le 6 then cg_careteam_13= .;
* reverse code so greater numeric response = better (more frequent) nurse communication (1-4 scoring for each item);
xcg_careteam_8= abs(cg_careteam_8-5); 
xcg_careteam_9= abs(cg_careteam_9-5); 
xcg_careteam_10= abs(cg_careteam_10-5); 
xcg_careteam_11= abs(cg_careteam_11-5); 
xcg_careteam_12= abs(cg_careteam_12-5); 
xcg_careteam_13= abs(cg_careteam_13-5); 
* create sum score;
sumcgnursecomm= sum(xcg_careteam_8, xcg_careteam_9, xcg_careteam_10,  xcg_careteam_11, xcg_careteam_12, xcg_careteam_13); 


/* 3 items about satisfaction with care from the team as a whole (pp 10-11 caregiver survey)  */
/* note that the 4th item from the patient survey (“When you leave/left your appointment for your cancer
care, how often do/did you have a clear understanding of what needs to happen next?”) was omitted from the caregiver survey – I don’t know why */ 
* the first two items are from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 6) and the third item we created ourselves;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_often_14 le 6 then caregiver_often_14= .;
if 5 le caregiver_often_15 le 6 then caregiver_often_15= .;
if 5 le caregiver_often_16 le 6 then caregiver_often_16= .;
/* reverse code so greater numeric response = better (more frequent) physician communication (range 1-4) */
xcaregiver_often_14= abs(caregiver_often_14-5); 
xcaregiver_often_15= abs(caregiver_often_15-5); 
xcaregiver_often_16= abs(caregiver_often_16-5); 
* create sum score from these 3 items – check inter-item consistency later;
sumcgteamsat= sum(xcaregiver_often_14, xcaregiver_often_15, xcaregiver_often_16);   

/* Caregiver Burden: 14-item Brief Assessment Scale for Caregivers (BASC) (pp 6-7 caregiver survey) */
* from: Glajchen et al., J Pain Symptom Management, 2005, 29, 245-254;
/* instrument includes a total score (14 item) and a sub-scale measuring negative personal impact (NPI) – note that the paper’s 
abstract states that the NPI is 8 items whereas Table 2 (p. 250) lists only 5 items that load on this sub-scale – for now, we’ll use only the total score */
/* the Data Dictionary lists only 4 response choices (not at all, a little, some, a lot) and no opportunity for respondent 
to indicate “don’t know” or “doesn’t apply to me  */
/* reverse coding is not necessary: all 14 items are 1-4 with higher scores indicating more distress */
* rescore so that range is 0-3 instead of 1-4;*/;

array jj [14] qol_caregiver_worried qol_caregiver_illness qol_caregiver_upset
qol_caregiver_overwhelmed qol_caregiver_seeing qol_caregiver_decisions
qol_caregiver_hosp qol_caregiver_procedures qol_caregiver_change qol_caregiver_family qol_caregiver_drawn qol_caregiver_meaning qol_caregiver_mem qol_caregiver_feel;
array kk [14] xqol_caregiver_worried xqol_caregiver_illness xqol_caregiver_upset
xqol_caregiver_overwhelmed xqol_caregiver_seeing xqol_caregiver_decisions
xqol_caregiver_hosp xqol_caregiver_procedures xqol_caregiver_change xqol_caregiver_family xqol_caregiver_drawn xqol_caregiver_meaning xqol_caregiver_mem xqol_caregiver_feel;
do i = 1 to 14;
kk[i]=jj[i]-1;
end; drop i; 




/* sum the 14 items
basc= sum(xqol_caregiver_worried, xqol_caregiver_illness, xqol_caregiver_upset,
xqol_caregiver_overwhelmed, xqol_caregiver_seeing, xqol_caregiver_decisions,
xqol_caregiver_hosp, xqol_caregiver_procedures, xqol_caregiver_change, xqol_caregiver_family, xqol_caregiver_drawn, 
xqol_caregiver_meaning, xqol_caregiver_mem, xqol_caregiver_feel);

* Hospital Anxiety and Depression Scale (HADS; Zigmond & Snaith, 1983);
* p 7-8 caregiver survey;
/* Note that per the Data Dictionary, the same variable names for HADS items appear to have been assigned 
to the patient and caregiver surveys, with the exception that item 1 is hads_1 in the patient survey and hads_1_cont 
in the caregiver survey – I will rename the variables in the caregiver dataset */

array ll  hads_1_cont hads_2 hads_3 hads_4 hads_5 hads_6 hads_7 hads_8
hads_9 hads_10 hads_11 hads_12  hads_13 hads_14;
array mm  cghads_1 cghads_2 cghads_3 cghads_4 cghads_5 cghads_6 cghads_7 cghads_8 cghads_9 cghads_10 cghads_11 cghads_12  cghads_13 cghads_14;
do i = 1 to 14;
mm[i] = ll[i];
end; drop i;

* will need to check later for missing data… if so, will need to adjust scale scores;
* correct scoring of individual items to match scoring in Zigmond & Snaith, 1983;
array nn [8] cghads_1 cghads_3 cghads_5 cghads_6 cghads_8 cghads_10 cghads_11 cghads_13; * subtract 4 to reverse scoring and change range to 0-3;
array oo [6] cghads_2 cghads_4 cghads_7 cghads_9 cghads_12 cghads_14; *scoring does not need to be reversed on these items – just subtract 1 to change range from 0-3;
array pp [8] cghads1 cghads3 cghads5 cghads6 cghads8 cghads10 cghads11 cghads13;
array qq [6] cghads2 cghads4 cghads7 cghads9 cghads12 cghads14;

do i = 1 to 8;
pp[i]= abs(nn[i]-4); 
end; drop i; 

do i= 1 to 6;
qq[i]= oo[i]-1;
end; drop i; 

/*create HADS sub-scales, Depression and Anxiety -- high score means worse depression or anxiety */
cgHADS_d= sum(cghads2, cghads4, cghads6, cghads8, cghads10, cghads12, cghads14); *depression;
cgHADS_a= sum(cghads1, cghads3, cghads5, cghads7, cghads9, cghads11, cghads13); *anxiety;


* Code out-of-range values to missing;



ARRAY PT3 sf_a sf_b sf_c sf_d sf_e sf_f sf_g sf_h sf_i sf_j;
DO OVER PT3;
IF PT3 NOT IN (1,2,3) THEN PT3=.;
END;

ARRAY PT5  sf_1 sf_2 sf_4a sf_4b sf_4c sf_4d sf_5a  sf_5b sf_5c sf_6 sf_8 sf_9a sf_9b sf_9c sf_9d sf_9e sf_9f sf_9g sf_9h sf_9i sf_10 sf_11a sf_11b sf_11c sf_11d;
DO OVER PT5;
IF PT5 NOT IN (1,2,3,4,5) THEN PT5=.;
END;

IF sf_7 NOT IN (1,2,3,4,5,6) THEN sf_7=.;




Array rr  sf_1 sf_2 sf_6 sf_7 sf_8  sf_11b sf_11d;
Array ss  sf1 sf2 sf20 sf21 sf22 sf34 sf36;

DO OVER ss;
If rr= 1 then ss= 100;else
If rr= 2 then ss= 75;else
If rr= 3 then ss= 50;else
If rr= 4 then ss= 25;else
If rr= 5 then ss= 0;else
END;


Array tt  sf_a sf_b sf_c sf_d sf_e sf_f sf_g sf_h sf_i sf_j ;
Array uu  sf3-sf12;

do over uu;
If tt= 1 then uu= 0;
If tt= 2 then uu= 50;
If tt= 3 then uu= 100;
End;


Array vv  sf_4a  sf_4b sf_4c sf_4d sf_5a sf_5b sf_5c;
Array ww  sf13-sf19;

do over ww;
If vv= 1 then ww= 0;
If vv= 2 then ww= 100;
End;





Array xx  sf_9a sf_9d sf_9e sf_9h;
Array yy  sf23 sf26 sf27 sf30;
Do over yy;
If xx= 1 then yy= 100;
If xx= 2 then yy= 80;
If xx= 3 then yy= 60;
If xx= 4 then yy= 40;
If xx= 5 then yy= 20;
If xx= 6 then yy= 0;
End;





Array aaa sf_9b  sf_9c sf_9f sf_9g sf_9i sf_10; 
Array bbb  sf24 sf25 sf28 sf29 sf31 sf32;

Do over bbb;
If aaa= 1 then bbb= 0;
If aaa= 2 then bbb= 20;
If aaa= 3 then bbb= 40;
If aaa= 4 then bbb= 60;
If aaa= 5 then bbb= 80;
If aaa= 6 then bbb= 100;
End;






Array ccc  sf_11a  sf_11c;
Array ddd  sf33 sf35;

Do over ddd;
If ccc= 1 then ddd= 0;
If ccc= 2 then ddd= 25;
If ccc= 3 then ddd= 50;
If ccc= 4 then ddd= 75;
If ccc= 5 then ddd= 100;
End;



* Create sub-scales;
PHYFUN10=MEAN(sf3,sf4,sf5,sf6,sf7,sf8,sf9,sf10,sf11,sf12);
ROLEP4=MEAN(sf13,sf14,sf15,sf16);
SFPAIN2=MEAN(sf21,sf22);
SFGENH5=MEAN(sf1,sf33,sf34,sf35,sf36);
ENFAT4=MEAN(sf23,sf27,sf29,sf31);
SOCFUN2=MEAN(sf20,sf32);
ROLEE3=MEAN(sf17,sf18,sf19);
EMOT5=MEAN(sf24,sf25,sfI26,sf28,sf30);

label phyfun10="Physical functioning scale";
label rolep4="Physical health problems scale";
label sfpain2="SF-36 pain scale";
label sfgenh5="SF-36 general health perceptions scale";
label enfat4="Energy/fatigue scale";
label socfun2="Social functioning scale";
label rolee3="Emotional health problems scale";
label emot5="Emotional well-being scale";



run;
ods html close;


proc print data=caregiver;
var sumcgbarriers sumcginfo sumcgsatqc sumcgphyscomm7  sumcgphyscomm5   sumcgnursecomm sumcgteamsat  cgHADS_d  cgHADS_a
PHYFUN10 ROLEP4 SFPAIN2 SFGENH5 ENFAT4 SOCFUN2 ROLEE3 EMOT5;
run;





ods html;
dm 'clear log';
dm 'clear output';
data caregiver3;
set caregiver3;

/* COMPUTES FOR PCORI CAREGIVER SURVEY – BASELINE;

* overall quality of health care since lung cancer diagnosis (p. 1 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing*/;
if 6 le caregiver_pt_quality le 7 then caregiver_pt_quality = .; 

* reverse code so greater numeric response = greater satisfaction (range 0-4)
xcaregiver_pt_quality= abs(caregiver_pt_quality)-5;

/* Quality of care compared to other lung cancer patients (p. 1 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 35);
*set 6 (don’t know) and 7 (does not apply) to missing*/;

if 6 le caregiver_lung_care le 7 then caregiver_lung_care = .; 
* reverse code so greater numeric response = greater satisfaction (range 0-4);
xcaregiver_lung_care = abs(caregiver_lung_care-5);

/* CAHPS items – Treatment Decision Making (pp 1-3 caregiver survey);
* from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 10-51);
* Coding of these items is based on Keating et al., J Clinical Oncol, 2010, 28, 4364-4370 and Weeks et al., NEJM, 2012, 367:1616-25;
* For each modality (surgery, chemo, radiation), categorize responses into “patient controlled,” “shared control,” or “physician control” per Keating;
* Computes for modality = surgery*/;

if 1 le cg_1d_tx_surgery le 2 then cgsurgdecision= 0; *0=patient controlled;
if cg_1d_tx_surgery = 3 then cgsurgdecision= 1; *1=shared decision;
if 4 le cg_1d_tx_surgery le 5 then cgsurgdecision= 2; *2= physician decision;

* Computes for modality = radiation;
if 1 le cg_2d_tx_radiation le 2 then cgraddecision= 0; *0=patient controlled;
if cg_2d_tx_radiation = 3 then cgraddecision= 1; *1=shared decision;
if 4 le cg_2d_tx_radiation le 5 then cgraddecision= 2; *2= physician decision;

* Computes for modality = chemotherapy;
if 1 le cg_3d_tx_chemo le 2 then cgchemodecision= 0; *0=patient controlled;
if cg_3d_tx_chemo = 3 then cgchemodecision= 1; *1=shared decision;
if 4 le cg_3d_tx_chemo le 5 then cgchemodecision= 2; *2= physician decision;

/* Computes for decision-making role of the family;
* if 1 le cg_4_family_decision le 2 then cgfamilydecision= 0; *0=patient controlled;*/

if cg_4_family_decision = 3 then cgfamilydecision= 1; *1=shared decision;
if 4 le cg_4_family_decision le 5 then cgfamilydecision= 2; *2= physician decision;

* Satisfaction with treatment plan (p. 3 caregiver survey);
* We created these items;
* Note that the 2 items can’t be summed (as they were for the patient survey) because the 2nd item 
(can pt complete treatment plan) was asked only of patients who have not yet initiated treatment or
were currently receiving treatment; 
* change scaling from 1-3 to 0-2 for both items;
xcaregiver_tx_option= caregiver_tx_option-1;
xcaregiver_tx_complete= caregiver_tx_complete-1;

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



/* Communication about disease-specific information (p 4 caregiver survey);
/* Items are the same that are used on the patient survey; they are adapted from K. Pardon 
et al., Are patients’ preferences for information and participation in medical decision-making being met?
Interview study with lung cancer patients. Palliative Medicine, 2011, 25(1), 62-70.  For consistency, responses
changes from 6-point Likert (totally disagree to totally agree) to 4 items that are used in the CAHPS patient
survey (always, usually, sometimes, never) */
* set 5 (don’t know) and 6 (does not apply) to missing;*/;

if 5 le cg_inform_diagnosis le 6 then cg_inform_diagnosis= .;
if 5 le cg_inform_tx_options le 6 then cg_inform_tx_options= .;
if 5 le cg_inform_cure_chance le 6 then cg_inform_cure_chance= .;
if 5 le cg_inform_life_expectancy le 6 then cg_inform_life_expectancy= .;
if 5 le cg_inform_palliative_care le 6 then cg_inform_palliative_care = .;
if 5 le cg_inform_end_of_life le 6 then cg_inform_end_of_life = .;

* reverse code so greater numeric response = better (more frequent) response (range 0-3);

xcg_inform_diagnosis= abs(cg_inform_diagnosis-4); 
xcg_inform_tx_options= abs(cg_inform_tx_options-4); 
xcg_inform_cure_chance= abs(cg_inform_cure_chance-4); 
xcg_inform_life_expectancy= abs(cg_inform_life_expectancy-4); 
xcg_inform_palliative_care= abs(cg_inform_palliative_care-4); 
xcg_inform_end_of_life= abs(cg_inform_end_of_life-4); 
* create sum score from these 6 items – check inter-item consistency later;
sumcginfo_3= sum(xcg_inform_diagnosis, xcg_inform_tx_options,  xcg_inform_cure_chance, xcg_inform_life_expectancy, xcg_inform_palliative_care, xcg_inform_end_of_life); 


* Satisfaction with quality of care from various team members (p. 4 patient survey);
* set 5 (don’t know) and 6 (does not apply) to missing;
array gg [8] sat_caregiver_pc sat_caregiver_onc sat_caregiver_pulmo sat_caregiver_surg sat_caregiver_nurse sat_caregiver_nav sat_caregiver_other_staff sat_caregiver_whole;
array hh [8] xsat_caregiver_pc xsat_caregiver_onc xsat_caregiver_pulmo xsat_caregiver_surg xsat_caregiver_nurse xsat_caregiver_nav xsat_caregiver_other_staff xsat_caregiver_whole;

do i= 1 to 8;
if 5 le gg[i] le 6 then gg[i]= .;
end;  drop i; 
* reverse code so greater numeric response = greater satisfaction (range 0-3);

do i= 1 to 8;
hh[i]= abs(gg[i]-4);
end; drop i;
* create sum score for overall satisfaction with quality of care;
sumcgsatqc_3= sum(xsat_caregiver_pc, xsat_caregiver_onc, xsat_caregiver_pulmo, xsat_caregiver_surg, xsat_caregiver_nurse, xsat_caregiver_nav, xsat_caregiver_other_staff, xsat_caregiver_whole);




* CAHPS items – Physician communication – 5 item version (p. 5 caregiver survey);
* Replicate scale used in Weeks et al., NEJM, 2012, 367:1616-25 (see p. 1618), which is sum of 5 CAHPS items; 
* note that Weeks et al. re-scales instrument for a 0-100 range – we are retaining the 1-4 scores on each of 
the 5 items (total scale score range of 5-20) from the original CAHPS survey;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_pt_1 le 6 then caregiver_pt_1= .;
if 5 le caregiver_pt_2 le 6 then caregiver_pt_2 = .;
if 5 le caregiver_pt_3 le 6 then caregiver_pt_3 = .;
if 5 le caregiver_pt_4 le 6 then caregiver_pt_4 = .;
if 5 le caregiver_pt_5 le 6 then caregiver_pt_5 = .;
/* reverse code so greater numeric response = better (more frequent) physician communication but retain 1-4 scoring to match original CAHPS survey */
xcaregiver_pt_1=  abs(caregiver_pt_1-5); 
xcaregiver_pt_2 = abs(caregiver_pt_2-5); 
xcaregiver_pt_3 = abs(caregiver_pt_3-5); 
xcaregiver_pt_4 = abs(caregiver_pt_4-5); 
xcaregiver_pt_5 = abs(caregiver_pt_5-5); 
* create sum score for 5-item scale – check inter-item consistency later;
sumcgphyscomm5_3= sum(xcaregiver_pt_1, xcaregiver_pt_2, xcaregiver_pt_3, xcaregiver_pt_4, xcaregiver_pt_5); 



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





* We created a 6-item nurse communication measure based on the CAHPS Physician 
ommunication items (pp 5-6 caregiver survey);
* will need to verify internal consistency of this measure;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le cg_careteam_8 le 6 then cg_careteam_8= .;
if 5 le cg_careteam_9 le 6 then cg_careteam_9= .;
if 5 le cg_careteam_10 le 6 then cg_careteam_10= .;
if 5 le cg_careteam_11 le 6 then cg_careteam_11= .;
if 5 le cg_careteam_12 le 6 then cg_careteam_12= .;
if 5 le cg_careteam_13 le 6 then cg_careteam_13= .;
* reverse code so greater numeric response = better (more frequent) nurse communication (1-4 scoring for each item);
xcg_careteam_8= abs(cg_careteam_8-5); 
xcg_careteam_9= abs(cg_careteam_9-5); 
xcg_careteam_10= abs(cg_careteam_10-5); 
xcg_careteam_11= abs(cg_careteam_11-5); 
xcg_careteam_12= abs(cg_careteam_12-5); 
xcg_careteam_13= abs(cg_careteam_13-5); 
* create sum score;
sumcgnursecomm_3= sum(xcg_careteam_8, xcg_careteam_9, xcg_careteam_10,  xcg_careteam_11, xcg_careteam_12, xcg_careteam_13); 


/* 3 items about satisfaction with care from the team as a whole (pp 10-11 caregiver survey)  */
/* note that the 4th item from the patient survey (“When you leave/left your appointment for your cancer
care, how often do/did you have a clear understanding of what needs to happen next?”) was omitted from the caregiver survey – I don’t know why */ 
* the first two items are from the CAHPS survey: Patient_Survey_v7.0_17March2004.doc, p. 6) and the third item we created ourselves;
* set 5 (don’t know) and 6 (does not apply) to missing;
if 5 le caregiver_often_14 le 6 then caregiver_often_14= .;
if 5 le caregiver_often_15 le 6 then caregiver_often_15= .;
if 5 le caregiver_often_16 le 6 then caregiver_often_16= .;
/* reverse code so greater numeric response = better (more frequent) physician communication (range 1-4) */
xcaregiver_often_14= abs(caregiver_often_14-5); 
xcaregiver_often_15= abs(caregiver_often_15-5); 
xcaregiver_often_16= abs(caregiver_often_16-5); 
* create sum score from these 3 items – check inter-item consistency later;
sumcgteamsat_3= sum(xcaregiver_often_14, xcaregiver_often_15, xcaregiver_often_16);   

/* Caregiver Burden: 14-item Brief Assessment Scale for Caregivers (BASC) (pp 6-7 caregiver survey) */
* from: Glajchen et al., J Pain Symptom Management, 2005, 29, 245-254;
/* instrument includes a total score (14 item) and a sub-scale measuring negative personal impact (NPI) – note that the paper’s 
abstract states that the NPI is 8 items whereas Table 2 (p. 250) lists only 5 items that load on this sub-scale – for now, we’ll use only the total score */
/* the Data Dictionary lists only 4 response choices (not at all, a little, some, a lot) and no opportunity for respondent 
to indicate “don’t know” or “doesn’t apply to me  */
/* reverse coding is not necessary: all 14 items are 1-4 with higher scores indicating more distress */
* rescore so that range is 0-3 instead of 1-4;*/;

array jj [14] qol_caregiver_worried qol_caregiver_illness qol_caregiver_upset
qol_caregiver_overwhelmed qol_caregiver_seeing qol_caregiver_decisions
qol_caregiver_hosp qol_caregiver_procedures qol_caregiver_change qol_caregiver_family qol_caregiver_drawn qol_caregiver_meaning qol_caregiver_mem qol_caregiver_feel;
array kk [14] xqol_caregiver_worried xqol_caregiver_illness xqol_caregiver_upset
xqol_caregiver_overwhelmed xqol_caregiver_seeing xqol_caregiver_decisions
xqol_caregiver_hosp xqol_caregiver_procedures xqol_caregiver_change xqol_caregiver_family xqol_caregiver_drawn xqol_caregiver_meaning xqol_caregiver_mem xqol_caregiver_feel;
do i = 1 to 14;
kk[i]=jj[i]-1;
end; drop i; 




/* sum the 14 items
basc= sum(xqol_caregiver_worried, xqol_caregiver_illness, xqol_caregiver_upset,
xqol_caregiver_overwhelmed, xqol_caregiver_seeing, xqol_caregiver_decisions,
xqol_caregiver_hosp, xqol_caregiver_procedures, xqol_caregiver_change, xqol_caregiver_family, xqol_caregiver_drawn, 
xqol_caregiver_meaning, xqol_caregiver_mem, xqol_caregiver_feel);

* Hospital Anxiety and Depression Scale (HADS; Zigmond & Snaith, 1983);
* p 7-8 caregiver survey;
/* Note that per the Data Dictionary, the same variable names for HADS items appear to have been assigned 
to the patient and caregiver surveys, with the exception that item 1 is hads_1 in the patient survey and hads_1_cont 
in the caregiver survey – I will rename the variables in the caregiver dataset */

array ll  hads_1_cont hads_2 hads_3 hads_4 hads_5 hads_6 hads_7 hads_8
hads_9 hads_10 hads_11 hads_12  hads_13 hads_14;
array mm  cghads_1 cghads_2 cghads_3 cghads_4 cghads_5 cghads_6 cghads_7 cghads_8 cghads_9 cghads_10 cghads_11 cghads_12  cghads_13 cghads_14;
do i = 1 to 14;
mm[i] = ll[i];
end; drop i;

* will need to check later for missing data… if so, will need to adjust scale scores;
* correct scoring of individual items to match scoring in Zigmond & Snaith, 1983;
array nn [8] cghads_1 cghads_3 cghads_5 cghads_6 cghads_8 cghads_10 cghads_11 cghads_13; * subtract 4 to reverse scoring and change range to 0-3;
array oo [6] cghads_2 cghads_4 cghads_7 cghads_9 cghads_12 cghads_14; *scoring does not need to be reversed on these items – just subtract 1 to change range from 0-3;
array pp [8] cghads1 cghads3 cghads5 cghads6 cghads8 cghads10 cghads11 cghads13;
array qq [6] cghads2 cghads4 cghads7 cghads9 cghads12 cghads14;

do i = 1 to 8;
pp[i]= abs(nn[i]-4); 
end; drop i; 

do i= 1 to 6;
qq[i]= oo[i]-1;
end; drop i; 

/*create HADS sub-scales, Depression and Anxiety -- high score means worse depression or anxiety */
cgHADS_d_3= sum(cghads2, cghads4, cghads6, cghads8, cghads10, cghads12, cghads14); *depression;
cgHADS_a_3= sum(cghads1, cghads3, cghads5, cghads7, cghads9, cghads11, cghads13); *anxiety;


* Code out-of-range values to missing;



ARRAY PT3 sf_a sf_b sf_c sf_d sf_e sf_f sf_g sf_h sf_i sf_j;
DO OVER PT3;
IF PT3 NOT IN (1,2,3) THEN PT3=.;
END;

ARRAY PT5  sf_1 sf_2 sf_4a sf_4b sf_4c sf_4d sf_5a  sf_5b sf_5c sf_6 sf_8 sf_9a sf_9b sf_9c sf_9d sf_9e sf_9f sf_9g sf_9h sf_9i sf_10 sf_11a sf_11b sf_11c sf_11d;
DO OVER PT5;
IF PT5 NOT IN (1,2,3,4,5) THEN PT5=.;
END;

IF sf_7 NOT IN (1,2,3,4,5,6) THEN sf_7=.;




Array rr  sf_1 sf_2 sf_6 sf_7 sf_8  sf_11b sf_11d;
Array ss  sf1 sf2 sf20 sf21 sf22 sf34 sf36;

DO OVER ss;
If rr= 1 then ss= 100;else
If rr= 2 then ss= 75;else
If rr= 3 then ss= 50;else
If rr= 4 then ss= 25;else
If rr= 5 then ss= 0;else
END;


Array tt  sf_a sf_b sf_c sf_d sf_e sf_f sf_g sf_h sf_i sf_j ;
Array uu  sf3-sf12;

do over uu;
If tt= 1 then uu= 0;
If tt= 2 then uu= 50;
If tt= 3 then uu= 100;
End;


Array vv  sf_4a  sf_4b sf_4c sf_4d sf_5a sf_5b sf_5c;
Array ww  sf13-sf19;

do over ww;
If vv= 1 then ww= 0;
If vv= 2 then ww= 100;
End;





Array xx  sf_9a sf_9d sf_9e sf_9h;
Array yy  sf23 sf26 sf27 sf30;
Do over yy;
If xx= 1 then yy= 100;
If xx= 2 then yy= 80;
If xx= 3 then yy= 60;
If xx= 4 then yy= 40;
If xx= 5 then yy= 20;
If xx= 6 then yy= 0;
End;





Array aaa sf_9b  sf_9c sf_9f sf_9g sf_9i sf_10; 
Array bbb  sf24 sf25 sf28 sf29 sf31 sf32;

Do over bbb;
If aaa= 1 then bbb= 0;
If aaa= 2 then bbb= 20;
If aaa= 3 then bbb= 40;
If aaa= 4 then bbb= 60;
If aaa= 5 then bbb= 80;
If aaa= 6 then bbb= 100;
End;






Array ccc  sf_11a  sf_11c;
Array ddd  sf33 sf35;

Do over ddd;
If ccc= 1 then ddd= 0;
If ccc= 2 then ddd= 25;
If ccc= 3 then ddd= 50;
If ccc= 4 then ddd= 75;
If ccc= 5 then ddd= 100;
End;



* Create sub-scales;
PHYFUN10_3=MEAN(sf3,sf4,sf5,sf6,sf7,sf8,sf9,sf10,sf11,sf12);
ROLEP4_3=MEAN(sf13,sf14,sf15,sf16);
SFPAIN2_3=MEAN(sf21,sf22);
SFGENH5_3=MEAN(sf1,sf33,sf34,sf35,sf36);
ENFAT4_3=MEAN(sf23,sf27,sf29,sf31);
SOCFUN2_3=MEAN(sf20,sf32);
ROLEE3_3=MEAN(sf17,sf18,sf19);
EMOT5_3=MEAN(sf24,sf25,sfI26,sf28,sf30);

label phyfun10="Physical functioning scale";
label rolep4="Physical health problems scale";
label sfpain2="SF-36 pain scale";
label sfgenh5="SF-36 general health perceptions scale";
label enfat4="Energy/fatigue scale";
label socfun2="Social functioning scale";
label rolee3="Emotional health problems scale";
label emot5="Emotional well-being scale";



run;
ods html close;


proc print data=caregiver3;
var sumcgbarriers_3 sumcginfo_3 sumcgsatqc_3 sumcgphyscomm7_3  sumcgphyscomm5_3   sumcgnursecomm_3 sumcgteamsat_3  cgHADS_d_3  cgHADS_a_3
PHYFUN10_3 ROLEP4_3 SFPAIN2_3 SFGENH5_3 ENFAT4_3 SOCFUN2_3 ROLEE3_3 EMOT5_3;
run;
