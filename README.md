# Call-Centre-Data-Analysis
This project involves analyzing call center data as part of a [visualization challenge](https://www.linkedin.com/posts/datafrenchy-academy_the-next-datafrenchy-academy-data-challenge-activity)posted by [DataFrenchy](https://www.datafrenchy.com/).
🔗	Problem Statement:
In this analysis, I aim to answer critical questions related to customer satisfaction (CSAT) within a call center context. The data provided key insights into how various factors, such as call center performance, response time, feedback type, and issue categories affect customer experience. Customer satisfaction plays a vital role in the success of any business. Understanding the factors influencing customer feedback can help improve operational efficiency and customer experience.The findings will guide targeted interventions to enhance service quality and customer experience

 🔗Key Questions:
•	How do customer satisfaction scores differ by call center, response time, or feedback type?
•	Which states or cities experience the most billing or service outage issues?
•	Are there significant differences in customer satisfaction or call duration between the call center and chatbot channels?
•	Which call center performs the best in terms of CSAT scores, call duration, and feedback?
•	What is the distribution of feedback (e.g., Very Positive, Neutral, Negative) across different call centers or cities?

🔗	Requirement Gathering: 
Dataset & Tools:
The dataset used for this analysis consists of 12 columns and 32,941 rows, providing a comprehensive view of call center interactions, customer feedback, and service performance. 
For this analysis, I utilized the following tools:
•	SQL: To import, clean, and query the data. SQL was pivotal for transforming the data, checking for missing values, handling outliers, and calculating key metrics like average CSAT scores and call duration.
•	Power BI: To visualize the results. I created a dashboard to help easily communicate insights, including slicers and various visualizations like bar charts, line graphs, and pie charts.

🔗	Data Cleaning & Preprocessing:
I started by importing the raw data and loading it into the database. Ensuring the data was correctly loaded allowed me to execute queries to assess the dataset.

Data Cleaning:
•	Column Names: I standardized column names, such as renaming the "call duration in minutes" column for clarity.
![image](https://github.com/user-attachments/assets/c2721a59-36d8-4ff5-a899-47aba8d574f9)


EXEC sp_rename 'call_center_data.[call duration in minutes]', 'call_duration_in_minutes', 'COLUMN';

•	Data Types: Using INFORMATION_SCHEMA_COLUMNS, I identified that all columns were stored as varchar. I then converted csat_score and call_duration to integers and changed call_timestamp to datetime using ALTER TABLE commands.
--Checking data type 
SELECT column_name, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'call_center_data'
--We can see all dataa types are varchar here and we need to convert the data as needed

--Convert the data type

ALTER TABLE call_center_data
ALTER COLUMN csat_score integer

ALTER TABLE call_center_data
ALTER COLUMN call_timestamp Datetime

ALTER TABLE call_center_data
ALTER COLUMN call_duration_in_minutes Integer



•	Missing Values: I examined the data for missing values. Notably, the csat_score column had 20,670 missing entries, which I decided to impute with the average score based on the feedback type. I used a WITH clause to calculate and update the missing values.
SELECT AVG(csat_score) AS avg_csat_score, feedback --Find out the average of csat_score for each feedback 
FROM call_center_data
where csat_score is not NULL
group by feedback
order by avg_csat_score desc;

--Impute the average csat_score using with claus and updated the missing csat score according to that

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

•	Outliers: I examined the CSAT scores for outliers. Based on the standard deviation method, I confirmed that no significant outliers existed.
SELECT count(*) as detecting_outliers
from call_center_data
where csat_score > (Select Avg(csat_score) + (3 * STDEV(csat_score)) from call_Center_Data) 
--There are no outliers above the threshold 
--By looking at the average we know that data is symmetrically distributed

	Data Analysis
With clean data in hand, I moved on to answering the key questions:
•	CSAT Scores by Call Center and Feedback Type:
I used GROUP BY and ORDER BY SQL queries to calculate the average CSAT score for each call center and feedback type.
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
•	Billing and Service Outage Issues by City and State:
Using SQL, I grouped the data by state and city to identify locations with the highest number of billing questions and service outage issues. This was accomplished with simple COUNT and GROUP BY operations.
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

•	Differences Between Call Center and Chatbot Channels:
I ran queries comparing customer satisfaction and call duration between the two channels, identifying any significant differences in service quality.

-- satisfaction

Select channel , sum(csat_score) as sum_csat_score 
from call_center_data
where channel in('Call-Center' , 'Chatbot')
group by channel
order by sum_csat_Score desc

--Call_center  > chatbot

--Call duration

Select channel , sum(call_duration_in_minutes) as sum_call_duration
from call_center_data
where channel in('Call-Center','Chatbot')
group by channel
order by sum_call_duration desc

•	Performance of Call Centers:
I grouped data by call center to assess the total number of feedback entries, average call duration, and CSAT scores, helping identify top-performing call centers.
--in terms of satisfaction_score					
SELECT call_center,  count(csat_score) as count_csat_score
from Call_Center_Data
group by call_center
order by count_csat_score desc

--los angeles> baltimore > chicago > denver

SELECT call_center,   avg (call_duration_in_minutes) as avg_call_duration 
from Call_Center_Data
group by call_center
order by avg_call_duration desc

•	Feedback Distribution Across Call Centers and Cities:
I examined the distribution of feedback types (e.g., Very Positive, Neutral, Negative) for both cities and call centers. This was done using COUNT and GROUP BY queries to give a clear picture of customer sentiment across different regions and centers.
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

Visualization:
Power BI Dashboard
To communicate the insights effectively, I created a Power BI dashboard with the following visualizations. The dashboard includes two slicers for dynamic filtering, allowing users to focus on specific cities, states, or feedback types.

1.	Table chart : Distribution of Call Center Based on Feedback . It displays feedback distribution (e.g., Very Positive, Positive, Neutral, Negative) for each call center.
2.	Pie chart : Call Center Performance by Call Duration within SLA. Visualizes the proportion of call centers meeting SLA (Service Level Agreement) criteria based on call duration.
3.	Bar chart : Billing and Outage Issue by City . Compares the volume of billing and service outage issues across different cities.
4.	Bar chart : Customer Satisfaction by Call Center. Shows average CSAT scores for each call center, providing a clear view of performance.
5.	Bar chart : Billing and Outage Issue by State. Displays the distribution of billing and service outage issues across different states.

	Insights
After completing the analysis, I obtained the following key insights:
1.	Customer Satisfaction by Call Center: Some call centers consistently achieved higher customer satisfaction scores than others.
2.	Problematic Regions: Certain states and cities were found to have a significantly higher volume of billing issues and service outages, which could be areas of focus for service improvement.
3.	Call Center vs. Chatbot Performance: The analysis revealed differences in both customer satisfaction and call duration between the call center and chatbot channels, offering valuable insights into where improvements can be made for each.
4.	Call Center Performance: By examining CSAT scores and call durations, I identified which call centers are performing the best in terms of customer satisfaction and efficiency.
5.	Feedback Distribution: I identified patterns in customer feedback across different call centers and cities, helping the business understand where to focus efforts for improvement.
Recommendation:
•	Improve Low-Performing Call Centers: Focus on the call centers with consistently lower customer satisfaction (CSAT) scores. Conduct root cause analyses to identify gaps in performance.
•	Address Issues in Problematic Regions: Introduce localized support initiatives, such as dedicated teams or additional resources, to address specific regional challenges more efficiently.
•	Enhance Chatbot Performance: Analyze the gaps in chatbot performance compared to call centers.
•	Leverage Insights from Top-Performing Call Centers: Identify best practices from high-performing call centers with superior CSAT scores and efficiency. Standardize these practices across all centers.


Challenges faced & lessons learned:
	The data contained some missing values and inconsistencies, which required careful cleaning and handling to avoid skewing the results.
	Determining the right approach for identifying and handling outliers was challenging, especially given that the dataset had a wide spread of values.


