%macro removeOldFile(bye); %if %sysfunc(exist(&bye.)) %then %do; proc delete data=&bye.; run; %end; %mend removeOldFile; %removeOldFile(work.redcap); data REDCAP; %let _EFIERR_ = 0;
infile 'PCORIMDSmokingCessat_DATA_NOHDRS_2016-10-19_0921.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=1 ; 
	informat record_id $500. ;
	informat date_of_survey yymmdd10. ;
	informat pt_sex $500. ;
	informat pt_age best32. ;
	informat pt_race $500. ;
	informat pt_marital_status $500. ;
	informat pt_ed_level $500. ;
	informat pt_ed_level_other $500. ;
	informat pt_employment $500. ;
	informat pt_occupation $500. ;
	informat pt_cl_stage best32. ;
	informat pt_histologic_diagnosis $500. ;
	informat pt_p_stage best32. ;
	informat pt_med_conditions $500. ;
	informat pt_exercise $500. ;
	informat pt_smoke_status $500. ;
	informat pt_smoke_ppd $500. ;
	informat pt_smoke_age_start $500. ;
	informat pt_smoke_age_stop $500. ;
	informat pt_smoke_day_start $500. ;
	informat pt_smoke_quit_interest $500. ;
	informat pt_smoke_cess_prog $500. ;
	informat pt_smoke_cigarette $500. ;
	informat pt_smoke_cigars $500. ;
	informat pt_chewing_tobacco $500. ;
	informat pt_snuff $500. ;
	informat pt_illicit_drugs $500. ;
	informat pt_alcohol $500. ;
	informat pt_alcohol_drink_number $500. ;
	informat pt_alcohol_days_number $500. ;
	informat pt_alcohol_year_quit $500. ;
	informat smoking_cessation_complete best32. ;

	format record_id $500. ;
	format date_of_survey yymmdd10. ;
	format pt_sex $500. ;
	format pt_age best12. ;
	format pt_race $500. ;
	format pt_marital_status $500. ;
	format pt_ed_level $500. ;
	format pt_ed_level_other $500. ;
	format pt_employment $500. ;
	format pt_occupation $500. ;
	format pt_cl_stage best12. ;
	format pt_histologic_diagnosis $500. ;
	format pt_p_stage best12. ;
	format pt_med_conditions $500. ;
	format pt_exercise $500. ;
	format pt_smoke_status $500. ;
	format pt_smoke_ppd $500. ;
	format pt_smoke_age_start $500. ;
	format pt_smoke_age_stop $500. ;
	format pt_smoke_day_start $500. ;
	format pt_smoke_quit_interest $500. ;
	format pt_smoke_cess_prog $500. ;
	format pt_smoke_cigarette $500. ;
	format pt_smoke_cigars $500. ;
	format pt_chewing_tobacco $500. ;
	format pt_snuff $500. ;
	format pt_illicit_drugs $500. ;
	format pt_alcohol $500. ;
	format pt_alcohol_drink_number $500. ;
	format pt_alcohol_days_number $500. ;
	format pt_alcohol_year_quit $500. ;
	format smoking_cessation_complete best12. ;

input
		record_id $
		date_of_survey
		pt_sex $
		pt_age
		pt_race $
		pt_marital_status $
		pt_ed_level $
		pt_ed_level_other $
		pt_employment $
		pt_occupation $
		pt_cl_stage
		pt_histologic_diagnosis $
		pt_p_stage
		pt_med_conditions $
		pt_exercise $
		pt_smoke_status $
		pt_smoke_ppd $
		pt_smoke_age_start $
		pt_smoke_age_stop $
		pt_smoke_day_start $
		pt_smoke_quit_interest $
		pt_smoke_cess_prog $
		pt_smoke_cigarette $
		pt_smoke_cigars $
		pt_chewing_tobacco $
		pt_snuff $
		pt_illicit_drugs $
		pt_alcohol $
		pt_alcohol_drink_number $
		pt_alcohol_days_number $
		pt_alcohol_year_quit $
		smoking_cessation_complete
;
if _ERROR_ then call symput('_EFIERR_',"1");
run;

proc contents;run;


data redcap;
	set redcap;
	label record_id='Record ID';
	label date_of_survey='Date of survey';
	label pt_sex='Sex';
	label pt_age='Age';
	label pt_race='Race';
	label pt_marital_status='Marital Status';
	label pt_ed_level='Education Level';
	label pt_ed_level_other='Other Education Level';
	label pt_employment='Employment Status';
	label pt_occupation='Occupation';
	label pt_cl_stage='Clinical Stage';
	label pt_histologic_diagnosis='Final Diagnosis';
	label pt_p_stage='Pathologic Stage';
	label pt_med_conditions='Number of Other Previous or Current Medical Conditions';
	label pt_exercise='Do you exercise regularly?';
	label pt_smoke_status='Have you ever smoked?';
	label pt_smoke_ppd='On average, how many packs per day do you or did you smoke?';
	label pt_smoke_age_start='At what age did you start smoking regularly?';
	label pt_smoke_age_stop='If you quit, at what age did you stop smoking?';
	label pt_smoke_day_start='If you smoke now, how soon after you wake up do you have your first cigarette?';
	label pt_smoke_quit_interest='If you smoke now, how interested are you in quitting in the next month?';
	label pt_smoke_cess_prog='How likely are you to participate in a smoking cessation program?';
	label pt_smoke_cigarette='Have you ever used cigarettes?';
	label pt_smoke_cigars='Have you ever used cigars?';
	label pt_chewing_tobacco='Have you ever used chewing tobacco?';
	label pt_snuff='Have you ever used snuff?';
	label pt_illicit_drugs='Have you ever used illicit drugs?';
	label pt_alcohol='Have you ever or do you currently consume(d) alcohol?';
	label pt_alcohol_drink_number='How many alcoholic drinks (i.e., beer, wine, mixed drinks, etc.) do/did you consume on average a day?';
	label pt_alcohol_days_number='On average how many days of the week do you consume at least one alcoholic drink?';
	label pt_alcohol_year_quit='If you have since quit drinking, in what year did you quit?';
	label smoking_cessation_complete='Complete?';
	run;

proc format;
	value $pt_race_ a='Asian' b='Black or African-American' 
		c='Caucasian' h='Hispanic/Latino';
	value $pt_marital_status_ d='Divorced' m='Married' 
		p='Partnered' s='Single' 
		w='Widowed' n='Not reported';
	value $pt_ed_level_ e='Elementary' h='High School/GED' 
		p='Post Sec. Vocational Training' b='Bachelor''s Degree' 
		m='Master''s Degree' d='Doctorate Degree' 
		o='Other' n='Not reported';
	value $pt_employment_ f='Employed, Full-Time' p='Employed, Part-Time' 
		h='Homemaker' d='Disabled' 
		r='Retired' n='Not reported';
	value pt_cl_stage_ 0='Stage 0' 1='Stage IA' 
		2='Stage IB' 3='Stage IIA' 
		4='Stage IIB' 5='Stage IIIA' 
		6='Stage IIIB' 7='Stage IV' 
		8='Not reported';
	value pt_p_stage_ 0='Stage 0' 1='Stage IA' 
		2='Stage IB' 3='Stage IIA' 
		4='Stage IIB' 5='Stage IIIA' 
		6='Stage IIIB' 7='Stage IV' 
		8='Not reported/Unknown';
	value $pt_exercise_ y='Yes' n='No' 
		x='Not reported';
	value $pt_smoke_status_ c='Yes, currently' p='Yes, but only in the past' 
		n='No, never' x='Not reported';
	value $pt_smoke_day_start_ 1='Within 5 minutes' 2='Within 6-30 minutes' 
		3='Within 31-60 minutes' 4='After 60 minutes' 
		x='Not reported';
	value $pt_smoke_quit_interest_ 1='Very interested' 2='A little interested' 
		3='Not at all' x='Not reported';
	value $pt_smoke_cess_prog_ 1='I would participate' 2='I might participate but am not sure' 
		3='I would not participate' x='Not reported';
	value $pt_smoke_cigarette_ y='Yes' n='No' 
		x='Not reported';
	value $pt_smoke_cigars_ y='Yes' n='No' 
		x='Not reported';
	value $pt_chewing_tobacco_ y='Yes' n='No' 
		x='Not reported';
	value $pt_snuff_ y='Yes' n='No' 
		x='Not reported';
	value $pt_illicit_drugs_ y='Yes' n='No' 
		x='Not reported';
	value $pt_alcohol_ c='Yes, currently' p='Yes, but only in the past' 
		n='No, never' x='Not reported';
	value smoking_cessation_complete_ 0='Incomplete' 1='Unverified' 
		2='Complete';
	run;

data redcap;
	set redcap;

	format pt_race pt_race_.;
	format pt_marital_status pt_marital_status_.;
	format pt_ed_level pt_ed_level_.;
	format pt_employment pt_employment_.;
	format pt_cl_stage pt_cl_stage_.;
	format pt_p_stage pt_p_stage_.;
	format pt_exercise pt_exercise_.;
	format pt_smoke_status pt_smoke_status_.;
	format pt_smoke_day_start pt_smoke_day_start_.;
	format pt_smoke_quit_interest pt_smoke_quit_interest_.;
	format pt_smoke_cess_prog pt_smoke_cess_prog_.;
	format pt_smoke_cigarette pt_smoke_cigarette_.;
	format pt_smoke_cigars pt_smoke_cigars_.;
	format pt_chewing_tobacco pt_chewing_tobacco_.;
	format pt_snuff pt_snuff_.;
	format pt_illicit_drugs pt_illicit_drugs_.;
	format pt_alcohol pt_alcohol_.;
	format smoking_cessation_complete smoking_cessation_complete_.;
	run;

proc contents data=redcap;
proc print data=redcap;
run;
quit;