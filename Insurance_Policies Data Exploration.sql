-- This syntax shows us the schema in our dataset
describe Insurance_Policies;


-- This syntax shows the first 100 rows in the dataset
select * from Insurance_Policies limit 100;

-- This syntax shows us the total count of the unique values(Gender and Marital status) in our dataset
select gender, marital_status, count(*) Count_Tot
from Insurance_Policies 
group by gender, marital_status
order by gender;

-- This syntax shows us the total count of the unique values(Car use) in our dataset
select car_use, count(*) Count_Tot
from Insurance_Policies
group by car_use;


-- This syntax shows us the total count of the unique values(Education) in our dataset
select education, count(*) Count_Tot
from Insurance_Policies
group by education;

-- This syntax shows us the total count of the unique values(Parent) in our dataset
select parent, count(*) Count_Tot
from Insurance_Policies
group by parent;

-- This syntax shows us the total count of the unique values(Car make) in our dataset
select car_make, count(*) Count_Tot 
from Insurance_Policies 
group by car_make
order by 1;

-- This syntax shows us the total count of the unique values(Coverage zone) in our dataset
select coverage_zone, count(*) Count_Tot 
from Insurance_Policies 
group by coverage_zone;


-- Filtering based on marital status, education and car use
select * 
from Insurance_Policies
where marital_status = 'Single'
and (education = 'Bachelors'and car_use = 'Private')
order by birthdate;

-- Filtering based on car make
select * 
from Insurance_Policies 
where car_make like 'b__';

-- Filtering based on car make and model
select car_make, car_model, count(*) Count_Tot
from Insurance_Policies
where car_make = 'Toyota'
group by car_make, car_model;


-- Filtering based on car make and marital status
select car_make, car_model, count(*) Count_Tot
from Insurance_Policies
where car_make = 'Toyota' and marital_status = 'Single'
group by car_make, car_model;


-- Filtering based on car make, model and education
select car_make, car_model, education, count(*) Count_Tot
from Insurance_Policies
where (car_make = 'Mercedes-Benz' and marital_status = 'Single')
and education in('Bachelors', 'Masters', 'PhD') -- and (car_color = 'green' and car_year = '2010')
group by car_make, car_model, education
order by education;


-- This shows the max claim amount and max household income 
select marital_status, education, max(claim_amt) Max_Claim, max(household_income) Max_Income, count(*) Count_Tot
from Insurance_Policies
group by marital_status, education
order by marital_status, education;

-- This shows the max claim amount and max household income
select marital_status, education, min(claim_amt) Min_Claim, min(household_income) Min_Income, count(*) Count_Tot
from Insurance_Policies
group by marital_status, education
order by marital_status, education;


-- This shows the marital status, education, average claim freq, min claim freq, max claim freq
select marital_status, education, avg(claim_freq) Avg_Freq, min(claim_freq) Min_Freq, max(claim_freq) Max_Freq, count(*) Count_Tot
from Insurance_Policies
group by marital_status, education
order by marital_status, education;
















