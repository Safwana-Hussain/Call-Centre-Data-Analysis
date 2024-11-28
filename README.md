# Call-Centre-Data-Analysis
This project involves analyzing call center data as part of a [visualization challenge](https://www.linkedin.com/posts/datafrenchy-academy_the-next-datafrenchy-academy-data-challenge-activity) posted by [DataFrenchy](https://www.datafrenchy.com/).

# Problem Statement:
In this analysis, I aim to answer critical questions related to customer satisfaction (CSAT) within a call center context. The data provided key insights into how various factors, such as call center performance, response time, feedback type, and issue categories affect customer experience. Customer satisfaction plays a vital role in the success of any business. Understanding the factors influencing customer feedback can help improve operational efficiency and customer experience.The findings will guide targeted interventions to enhance service quality and customer experience


# Key Questions:
•	How do customer satisfaction scores differ by call center, response time, or feedback type?
•	Which states or cities experience the most billing or service outage issues?
•	Are there significant differences in customer satisfaction or call duration between the call center and chatbot channels?
•	Which call center performs the best in terms of CSAT scores, call duration?
•	What is the distribution of feedback (e.g., Very Positive, Neutral, Negative) across different call centers or cities?


# Requirement Gathering: 
Dataset & Tools:
The dataset used for this analysis consists of 12 columns and 32,941 rows, providing a comprehensive view of call center interactions, customer feedback, and service performance. 
For this analysis, I utilized the following tools:
•	SQL: To import, clean, and query the data. SQL was pivotal for transforming the data, checking for missing values, handling outliers, and calculating key metrics like average CSAT scores and call duration.
•	Power BI: To visualize the results. I created a dashboard to help easily communicate insights, including slicers and various visualizations like bar charts, line graphs, and pie charts.

# Data Cleaning & Preprocessing:
I started by importing the raw data and loading it into the database. Ensuring the data was correctly loaded allowed me to execute queries to assess the dataset.

Data Cleaning:
• Column Names: I standardized column names, such as renaming the "call duration in minutes" column for clarity.

![image](https://github.com/user-attachments/assets/2e7346e0-ad01-46aa-bc2b-0ca987500b35)


• Data Types: Using INFORMATION_SCHEMA_COLUMNS,  I reviewed the data types of each column and converted them where necessary.

 
![image](https://github.com/user-attachments/assets/b83ecf51-e80d-474c-884c-0545fa9fc4ac)


• Missing Values: I examined the data for missing values. Notably, the csat_score column had 20,670 missing entries, which I decided to impute with the average score based on the feedback type. I used a WITH clause to calculate and update the missing values.

![image](https://github.com/user-attachments/assets/d1da401a-1953-4dcd-ba13-af02331453eb)
![image](https://github.com/user-attachments/assets/39addfb1-2feb-4132-a7a9-d091c30435bb)

I used the `WITH` clause to calculate the average CSAT score and updated the missing CSAT values accordingly.

![image](https://github.com/user-attachments/assets/7dae1d44-24a8-40b1-b799-ea5652495060)

• Outliers: I examined the CSAT scores for outliers. Based on the standard deviation method, I confirmed that no significant outliers existed.

![image](https://github.com/user-attachments/assets/fac35058-1237-4dc8-8a7e-defb8505c60c)


# Data Analysis
With clean data in hand, I moved on with the analysis.

• How do customer satisfaction scores differ by call center, response time, or feedback type?

=> I used GROUP BY and ORDER BY  to calculate the average CSAT score for each call center and feedback type.

![image](https://github.com/user-attachments/assets/37bb65a7-05e6-4c2a-8800-d249908aa8c5)


•   Which states or cities experience the most billing or service outage issues?	

=> Using SQL, I grouped the data by state and city to identify locations with the highest number of billing questions and service outage issues. This was accomplished with simple COUNT and GROUP BY operations.

![image](https://github.com/user-attachments/assets/8e9ccb86-9668-4abf-ad99-ef4ee2e8cccb)


•  Are there significant differences in customer satisfaction or call duration between the call center and chatbot channels?									

=> I ran queries comparing customer satisfaction and call duration between the two channels, identifying any significant differences in service quality.


![image](https://github.com/user-attachments/assets/209b1649-57de-40ab-9e24-60b692b10457)


•  Which call center performs the best in terms of CSAT scores, call duration?	

=> I grouped data by call center to assess the total number of feedback entries, average call duration, and CSAT scores, helping identify top-performing call centers.

![image](https://github.com/user-attachments/assets/94a62a5e-6401-463e-a42c-1d9533954095)


•  What is the distribution of feedback (e.g., Very Positive, Neutral, Negative) across different call centers or cities?	

=> I examined the distribution of feedback types (e.g., Very Positive, Neutral, Negative) for both cities and call centers. This was done using COUNT and GROUP BY queries to give a clear picture of customer sentiment across different regions and centers.

![image](https://github.com/user-attachments/assets/51b2aef4-e189-458b-af1d-2fdd2aef4de3)


# Visualization:

To communicate the insights effectively, I created a Power BI dashboard with the following visualizations. The dashboard includes two slicers for dynamic filtering, allowing users to focus on specific cities, states, or feedback types.


1.	Table chart : Distribution of Call Center Based on Feedback . It displays feedback distribution (e.g., Very Positive, Positive, Neutral, Negative) for each call center.
2.	Pie chart : Call Center Performance by Call Duration within SLA. Visualizes the proportion of call centers meeting SLA (Service Level Agreement) criteria based on call duration.
3.	Bar chart : Billing and Outage Issue by City . Compares the volume of billing and service outage issues across different cities.
4.	Bar chart : Customer Satisfaction by Call Center. Shows average CSAT scores for each call center, providing a clear view of performance.
5.	Bar chart : Billing and Outage Issue by State. Displays the distribution of billing and service outage issues across different states.
   

![image](https://github.com/user-attachments/assets/8f4df8fd-e052-4f34-a9c7-76bde81bdedf)



# Insights:
After completing the analysis, I obtained the following key insights:
1.	Customer Satisfaction by Call Center: Some call centers consistently achieved higher customer satisfaction scores than others.
2.	Problematic Regions: Certain states and cities were found to have a significantly higher volume of billing issues and service outages, which could be areas of focus for service improvement.
3.	Call Center vs. Chatbot Performance: The analysis revealed differences in both customer satisfaction and call duration between the call center and chatbot channels, offering valuable insights into where improvements can be made for each.
4.	Call Center Performance: By examining CSAT scores and call durations, I identified which call centers are performing the best in terms of customer satisfaction and efficiency.
5.	Feedback Distribution: I identified patterns in customer feedback across different call centers and cities, helping the business understand where to focus efforts for improvement.

# Recommendation:
•	Improve Low-Performing Call Centers: Focus on the call centers with consistently lower customer satisfaction (CSAT) scores. Conduct root cause analyses to identify gaps in performance.

•	Address Issues in Problematic Regions: Introduce localized support initiatives, such as dedicated teams or additional resources, to address specific regional challenges more efficiently.

•	Enhance Chatbot Performance: Analyze the gaps in chatbot performance compared to call centers.

•	Leverage Insights from Top-Performing Call Centers: Identify best practices from high-performing call centers with superior CSAT scores and efficiency. Standardize these practices across all centers.


# Challenges faced & lessons learned:

• The data contained some missing values and inconsistencies, which required careful cleaning and handling to avoid skewing the results.

• Determining the right approach for identifying and handling outliers was challenging, especially given that the dataset had a wide spread of values.
