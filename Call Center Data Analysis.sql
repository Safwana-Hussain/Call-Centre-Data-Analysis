--Importing data 
select * from  call_center_data


--DATA CLEANING
--We can see column name call duratiion in minutes have spaces between words.

EXEC sp_rename 'call_center_data.[call duration in minutes]', 'call_duration_in_minutes', 'COLUMN';

--Checking data type 
SELECT column_name, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'call_center_data'

ALTER TABLE call_center_data
ALTER COLUMN csat_score integer

ALTER TABLE call_center_data
ALTER COLUMN call_timestamp Datetime

ALTER TABLE call_center_data
ALTER COLUMN call_duration_in_minutes Integer


-- Checking missing values in numerical columns 
Select count(*) AS Missing_csat_score
from call_center_data
where csat_score is NULL

Select count(*) as missing_call_duration_count
from call_center_data
where call_duration_in_minutes = ' ' or  call_duration_in_minutes is null

Select count(*) as missing_customer_name
from call_center_data
where customer_name is NULL or customer_name = ' '

Select count(*) as missing_call_center_data
from call_center_data
where feedback is NULL or feedback= ' '

Select count(*) as missing_call_timestamp
from call_center_data
where call_timestamp is NULL or call_timestamp = ' '

Select count(*) as missing_city
from call_center_data
where city is NULL or city = ' '

Select count(*) as missing_state
from call_center_data
where state  is NULL or state  = ' '

Select count(*) as missing_channel
from call_center_data
where channel is NULL or channel = ' '

Select count(*) as missing_response_time
from call_center_data
where response_time is NULL or response_time = ' '

Select count(*) as missing_call_centre
from call_center_data
where call_center is NULL or call_center = ' '
-- No missing values in chategorical columns 


--Fill missing values in csat score


SELECT AVG(csat_score) AS avg_csat_score, feedback 
FROM call_center_data
where csat_score is not NULL
group by feedback
order by avg_csat_score desc;

--Impute the average csat_score using with clause 

WITH avg_scores AS (
    SELECT feedback, AVG(csat_score) AS avg_csat_score
    FROM call_center_data
    WHERE csat_score IS NOT NULL
    GROUP BY feedback)

UPDATE call_center_data
SET csat_score = (
    SELECT avg_csat_score 
    FROM avg_scores 
    WHERE call_center_data.feedback = avg_scores.feedback)
WHERE csat_score IS NULL 

select * from call_center_data -- checking if the table/column has been updated

-- Check Outliers 

SELECT 
MIN(csat_score)AS min_score, 
MAX(csat_score)AS max_score, 
AVG(csat_score)AS avg_score
FROM call_center_data;

SELECT count(*) as detecting_outliers
from call_center_data
where csat_score > (Select Avg(csat_score) + (3 * STDEV(csat_score)) from call_Center_Data) 
--Therer are no outliers above the threshold 
--By looking at the average we know that data is symmetrically distributed

--Creating table with cleaned data
SELECT * 
INTO cleaned_call_center_data
FROM call_center_data;

select * from cleaned_call_center_data




--How many call_centers are there?
 select call_center, count(call_Center) as count_call_center
 from call_center_data
 group by call_center
 order by count_call_center desc

 --how many cities are there
 select city, count(city) as count_city
 from call_center_data
 group by city
 order by count_city desc

 --how many states are there?
  select state , count(state) as count_state
 from call_center_data
 group by state 
 order by count_state  desc

-- Analyzing 
--1.How do customer satisfaction scores differ by call center, response time, or feedback type?

--customer satisfaction scores differ by call center
Select call_center, count(call_center), sum(csat_score) AS  count_csat_score
from Call_Center_Data
group by call_center 
order by count_csat_score desc

 ----customer satisfaction scores differ by response time
Select response_time, count(csat_score) AS  count_csat_score
from Call_Center_Data
group by response_time
order by count_csat_score desc

 ----customer satisfaction scores differ by feedback
Select feedback, avg(csat_score) AS  avg_csat_score
from Call_Center_Data
group by feedback
order by avg_csat_score desc

--Negative > Neutral > Very Negative >Positive> Very Positive 

--Q2. 2) Which states or cities experience the most billing or service outage issues?	

-- Which cities experience most billing question
Select  top 5 city, reason , count(*) as reason_count 
from call_center_data
where reason in ( 'Billing Question')
group by city,reason
order by reason_count desc 

-- Which cities experience most service outage  question
Select  top 5 city, reason , count(*) as reason_count 
from call_center_data
where reason in ( 'Service Outage')
group by city,reason
order by reason_count desc 


-- Which states experience most billing question
Select  TOP 5 state , reason , count(*) as reason_count 
from call_center_data
where reason in ( 'Billing Question')
group by reason, state 
order by reason_count desc


-- Which states experience most service outage issue 
Select  TOP 5 state , reason , count(*) as reason_count 
from call_center_data
where reason in ( 'Service outage')
group by reason, state 
order by reason_count desc

-- california > texas > florida > nyc > ohio


--Q3) Are there significant differences in customer satisfaction or call duration between the call center and chatbot channels?									

-- satisfaction
Select channel , sum(csat_score) as sum_csat_score 
from call_center_data
where channel in('Call-Center' , 'Chatbot')
group by channel
order by sum_csat_Score desc

--Call duration
Select channel , sum(call_duration_in_minutes) as sum_call_duration
from call_center_data
where channel in('Call-Center','Chatbot')
group by channel
order by sum_call_duration desc

--Q4) Which call center performs the best in terms of CSAT scores, call duration, and feedback?	

--in terms of satisfaction_score					
SELECT call_center,  count(csat_score) as count_csat_score
from Call_Center_Data
group by call_center
order by count_csat_score desc

--in terms of call duration
SELECT call_center,   avg (call_duration_in_minutes) as avg_call_duration 
from Call_Center_Data
group by call_center
order by avg_call_duration desc

--los angeles > denver > chicago > baltimore

 

-- los angeles > baltimore > chicago > denver

--5) What is the distribution of feedback (e.g., Very Positive, Neutral, Negative) across different call centers or cities?

 --For City
SELECT top 10 CITY,
    count(CASE WHEN FEEDBACK = 'VERY POSITIVE' THEN 1  END) AS Very_Positive,
    count(CASE WHEN FEEDBACK = 'POSITIVE' THEN 1 END) AS Positive,
    count(CASE WHEN FEEDBACK = 'NEGATIVE' THEN 1  END) AS Negative,
	count(CASE WHEN FEEDBACK = 'VERY Negative' THEN 1 END) AS Very_Negative,
	count(CASE WHEN FEEDBACK = 'Neutral' THEN 1  END) AS Neutral
FROM  call_center_data
GROUP BY CITY
ORDER BY  CITY ;


--For call_centers
SELECT call_center,
    Count(CASE WHEN FEEDBACK = 'VERY POSITIVE' THEN 1  END) AS Very_Positive,
    Count(CASE WHEN FEEDBACK = 'POSITIVE' THEN 1  END) AS Positive,
    COUNT(CASE WHEN FEEDBACK = 'NEGATIVE' THEN 1 END) AS Negative, 
	Count(CASE WHEN FEEDBACK = 'VERY Negative' THEN 1 END) AS Very_Negative,
	Count(CASE WHEN FEEDBACK = 'Neutral' THEN 1 END) AS Neutral
FROM  call_center_data
GROUP BY call_center
ORDER BY  call_center ;
