# Hospitality-Analytics
------


### Project Overview

This data analysis project aims to provide insights into the revenue performanace of an hotel industry over the week.By analysing various aspects of the revenue
data,we seek to identify trends, make data-driven recommendations, and gain a deeper understanding of the hotel industries performance.

### Data Sources

Fact Bookings table: The primary dataset used for this analysis is the "fact_bookings.csv" file,containing detailed information about each revenue made by the hotels.

### Tools

- Excel - Data Cleaning
- MYSQL - Data Analysis
- PowerBI - Creating reports
- Tableau - Creating reports


### Data Cleaning/Preparation
 
 In  the initial data preparationphase, we performed the following tasks:
 1.Data loading and inspection.
 2.Handling missing values.
 3.Data cleaning and formatting. 

### Exploratory Data Analysis

EDA involved exploring the fact booking data to answer key questions,such as:

-What is the total revenue,bookings and cancellation rate?
-which city and hotels are gained highest revenue?
-which day has given the peak highest revenue?

### Data Analysis

Include some interesting code/features worked with

```SELECT city, property_name, FORMAT(SUM(f.revenue_realized),'no') AS `total revenue`
FROM dim_hotels AS d INNER JOIN fact_bookings AS f
ON d.property_id = f.property_id
GROUP BY city, property_name
OREDR BY city;```


### Results/Findings

The analysis results are summarised as follows:
1.The hotels revenue have been more in weekdays compared to weekends becuase weekday has more number of days compared to weekend.
2.Atliq bay(mumbai) is the best-performing hotels in terms of bookings and revenue.
3.Customers are highly prefering to book Elite Room class compared to any other.

### Recommendations

Based on the analysis, we recommend the following actions:
-Improving Hotel Efficiency and Guest Services in Delh.
-Encourage guests to visit Atliq Grands hotel.
-Reducing Cancellation Rates through Enhanced Booking Practices.











