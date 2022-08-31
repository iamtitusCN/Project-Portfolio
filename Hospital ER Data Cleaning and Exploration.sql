use hospital;
select * from Hospital_ER limit 50;
select * from Insurance_Policies limit 50;
describe Hospital_ER;

-- This syntax converts the date column from datetime to date format
select date, cast(date as date) converted from Hospital_ER;


-- This syntax updates the converted date in the dataset
Update Hospital_ER SET Converted = Cast(date as date);


-- Filtering based on patient initials(H) and wait time
select * from Hospital_ER where patient_first_initial = 'H' and patient_waittime in (20, 60);


-- Modifying column name to a new one
alter table Hospital_ER change column patient_first_inital  patient_first_initial varchar(25);


-- Show count of the unique values
select patient_gender, count(*) Tot_count from Hospital_ER group by patient_gender;


-- Filtering based on specific column 
select * 
from Hospital_ER 
where patient_race = 'African american' and department_referral = 'General Practice';


-- Using case statement to group patient_age
select patient_gender, patient_age, 
case when patient_age <= 10 then 'Teen'
when patient_age <=20 then 'Adolesce'
when patient_age <=30 then 'Almost_Adult'
when patient_age >=30 then 'Adult'
else 'Other'
end cal
from Hospital_ER;


-- Filtering based on specific gender(F), department_referred and date
select date, patient_gender, department_referral
from Hospital_ER 
where date between '2019-12-31'and '2020-12-31' and patient_gender = 'F' and department_referral = 'General Practice'
order by 1;


-- Filtering based on specific gender(M), department_referred and date
select date, patient_gender, department_referral
from Hospital_ER 
where date between '2019-12-31'and '2020-12-31' and patient_gender = 'M' and department_referral = 'General Practice'
order by 1;


-- filtering based on patient whose Admin_flag is false and department_referral is None
select * 
from Hospital_ER 
where patient_admin_flag != 'true' and department_referral ='None' 
order by 6 limit 100;






