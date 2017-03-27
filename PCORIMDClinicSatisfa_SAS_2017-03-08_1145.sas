%macro removeOldFile(bye); %if %sysfunc(exist(&bye.)) %then %do; proc delete data=&bye.; run; %end; %mend removeOldFile; %removeOldFile(work.redcap); data REDCAP; %let _EFIERR_ = 0;
infile 'PCORIMDClinicSatisfa_DATA_NOHDRS_2017-03-08_1145.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=1 ; 
	informat participant_id $500. ;
	informat part_care best32. ;
	informat onc best32. ;
	informat pulm best32. ;
	informat surg best32. ;
	informat nn best32. ;
	informat other_nurses best32. ;
	informat support best32. ;
	informat whole_staff best32. ;
	informat team best32. ;
	informat comm best32. ;
	informat encourage best32. ;
	informat answer best32. ;
	informat listen best32. ;
	informat gave_info best32. ;
	informat gave_enough_info best32. ;
	informat courtesy best32. ;
	informat helpful best32. ;
	informat referring_doc best32. ;
	informat clear_understand best32. ;
	informat best_options best32. ;
	informat clinic_satisfaction__v_0 best32. ;

	format participant_id $500. ;
	format part_care best12. ;
	format onc best12. ;
	format pulm best12. ;
	format surg best12. ;
	format nn best12. ;
	format other_nurses best12. ;
	format support best12. ;
	format whole_staff best12. ;
	format team best12. ;
	format comm best12. ;
	format encourage best12. ;
	format answer best12. ;
	format listen best12. ;
	format gave_info best12. ;
	format gave_enough_info best12. ;
	format courtesy best12. ;
	format helpful best12. ;
	format referring_doc best12. ;
	format clear_understand best12. ;
	format best_options best12. ;
	format clinic_satisfaction__v_0 best12. ;

input
		participant_id $
		part_care
		onc
		pulm
		surg
		nn
		other_nurses
		support
		whole_staff
		team
		comm
		encourage
		answer
		listen
		gave_info
		gave_enough_info
		courtesy
		helpful
		referring_doc
		clear_understand
		best_options
		clinic_satisfaction__v_0
;
if _ERROR_ then call symput('_EFIERR_',"1");
run;

proc contents;run;


data redcap;
	set redcap;
	label participant_id='Participant ID';
	label part_care='Please Check One: ';
	label onc='The oncologist (cancer doctor)';
	label pulm='The pulmonologist (lung doctor)';
	label surg='The surgeon';
	label nn='The nurse navigator';
	label other_nurses='Other nurse(s)';
	label support='Support Staff (such as front desk receptionist)';
	label whole_staff='The staff as a whole';
	label team='Worked well together as a team?';
	label comm='Communicated well about the care received?';
	label encourage='Encouraged you to ask questions?';
	label answer='Answered all your questions?';
	label listen='Listened carefully to you?';
	label gave_info='Gave you information in a way you could understand?';
	label gave_enough_info='Gave you enough information (not too little, and not too much)?';
	label courtesy='Treated you with courtesy and respect?';
	label helpful='Were as helpful as you thought they should be?';
	label referring_doc='Will give information about this visit quickly to the doctor who referred the patient?';
	label clear_understand='leaving this appointment with a clear understanding of the next steps (getting more tests, seeing another doctor, beginning treatment, etc)?';
	label best_options='with the recommended next steps presented today?';
	label clinic_satisfaction__v_0='Complete?';
	run;

proc format;
	value part_care_ 1='Patient' 2='Caregiver';
	value onc_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value pulm_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value surg_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value nn_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value other_nurses_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value support_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value whole_staff_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value team_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value comm_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value encourage_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value answer_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value listen_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value gave_info_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value gave_enough_info_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value courtesy_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value helpful_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value referring_doc_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value clear_understand_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value best_options_ 1='Very satisfied' 2='Somewhat satisfied' 
		3='Somewhat dissatisfied' 4='Very dissatisfied' 
		5='Don''t know' 6='Doesn''t apply to me';
	value clinic_satisfaction__v_0_ 0='Incomplete' 1='Unverified' 
		2='Complete';
	run;

data redcap;
	set redcap;

	format part_care part_care_.;
	format onc onc_.;
	format pulm pulm_.;
	format surg surg_.;
	format nn nn_.;
	format other_nurses other_nurses_.;
	format support support_.;
	format whole_staff whole_staff_.;
	format team team_.;
	format comm comm_.;
	format encourage encourage_.;
	format answer answer_.;
	format listen listen_.;
	format gave_info gave_info_.;
	format gave_enough_info gave_enough_info_.;
	format courtesy courtesy_.;
	format helpful helpful_.;
	format referring_doc referring_doc_.;
	format clear_understand clear_understand_.;
	format best_options best_options_.;
	format clinic_satisfaction__v_0 clinic_satisfaction__v_0_.;
	run;

proc contents data=redcap;
proc print data=redcap;
run;
quit;