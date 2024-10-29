USE project_hospitality;

SET SQL_SAFE_UPDATES = 0;

select * from dim_date;
select * from fact_aggregated_bookings;
select * from fact_bookings;






-- Total Revenue Realized
SELECT 
     CONCAT(FORMAT(SUM(revenue_realized)/1000000,'n'),' M') AS 'Total Revenue'
FROM 
     fact_bookings_original;




-- Occupation Rate
SELECT 
   CONCAT(FORMAT((SELECT SUM(successful_bookings) FROM fact_aggregated_bookings)/(SELECT SUM(capacity) FROM fact_aggregated_bookings)*100,2), '%') 
   AS occupation_rate;
   
   


-- Cancellation Rate
SELECT 
	  CONCAT(FORMAT((SELECT COUNT(booking_status)
FROM 
	  fact_bookings_original
WHERE 
      booking_status = 'cancelled') / (SELECT COUNT(booking_status) FROM fact_bookings_original) * 100,2), '%') AS "cancellation rate";  
   
   
-- Total Bookings 
SELECT 
      FORMAT(SUM(successful_bookings),'n') AS 'total bookings'
FROM 
      fact_aggregated_bookings;
   
   
-- Utilize Capacity
SELECT 
      FORMAT(SUM(capacity),'n') AS 'Total Capacity'
FROM 
      fact_aggregated_bookings;



-- Trend Analysis
SELECT 
    d.`week no`, 
    CONCAT(FORMAT(SUM(f.revenue_realized) / (SELECT SUM(revenue_realized) FROM fact_bookings_original) * 100, 2), '%') AS `Revenue Percentage`
FROM 
    dim_date AS d 
INNER JOIN 
    fact_bookings_original AS f 
ON 
    d.`date` = f.check_in_date  
GROUP BY 
    d.`week no`;
    
    
 
 
-- Weekday  & Weekend Total Revenue 
SELECT 
     d.day_type, 
     CONCAT(FORMAT(SUM(f.revenue_realized)/1000000,'n0'),'M') AS `Total Revenue`
FROM 
     dim_date AS d 
INNER JOIN 
     fact_bookings_original AS f
ON 
	 d.`date`= f.check_in_date
GROUP BY 
     d.day_type;
 

-- Weekday  & Weekend Total Bookings     
SELECT 
      day_type, 
      FORMAT(SUM(COALESCE(successful_bookings, 0)), 'n0') AS 'successful_bookings'
FROM 
      dim_date AS d 
INNER JOIN 
      fact_aggregated_bookings AS f
ON 
      d.`date` = f.check_in_date
GROUP BY 
      d.day_type;

  
  
-- Revenue by hotel and city
SELECT 
      city,
	  property_name, FORMAT(SUM(f.revenue_realized),'n0') AS `Total Revenue`
FROM 
      dim_hotels AS d 
INNER JOIN 
      fact_bookings_original AS f
ON 
	  d.property_id = f.property_id
GROUP BY 
      city, property_name
ORDER BY 
      city;


-- Revenue by State 
SELECT  
       city AS State, 
       CONCAT(FORMAT(SUM(f.revenue_realized)/1000000,'n1'), 'M') AS `Total Revenue`
FROM 
       dim_hotels AS d 
INNER JOIN 
       fact_bookings_original AS f
ON 
       d.property_id = f.property_id
GROUP BY 
       city
ORDER BY 
       SUM(F.revenue_realized) ASC;
       
       

-- Revenue by hotel   
   SELECT 
    property_name AS Hotel, 
    CONCAT(FORMAT(SUM(f.revenue_realized) / 1000000, 'n0'), ' M') AS `Total Revenue`
FROM 
    dim_hotels AS d 
INNER JOIN 
    fact_bookings_original AS f
ON 
    d.property_id = f.property_id
GROUP BY 
    property_name 
ORDER BY 
    SUM(f.revenue_realized) ASC;
    
    
-- Class Wise Revenue
SELECT  
      room_class AS Class,
      FORMAT(SUM(f.revenue_realized),'n0') AS `Total Revenue`
FROM 
      dim_rooms AS r 
INNER JOIN 
      fact_bookings_original AS f
ON 
      r.room_id = f.room_category
GROUP BY 
      Class
ORDER BY 
       SUM(revenue_realized); 
       
 

-- Checked out cancel No show
SELECT 
      booking_status,
      FORMAT(COUNT(booking_status),'n') AS Total
FROM 
     fact_bookings
GROUP BY 
	 booking_status;
     
     
 
-- Weekly trend Key trend (Revenue, Total booking, Occupancy) 
-- REVENUE
CREATE TEMPORARY TABLE 
      Revenue
SELECT `week no`,
	  concat(FORMAT(SUM(revenue_realized) / (SELECT SUM(revenue_realized) FROM fact_bookings) * 100, '2'),'%') AS `Revenue Percentage`
FROM 
	  dim_date AS d
INNER JOIN 
      fact_bookings AS f 
ON 
      STR_TO_DATE(d.date, '%d-%m-%Y') = f.check_in_date
GROUP BY 
      `week no`;
      


-- BOOKING
CREATE TEMPORARY TABLE 
     Booking
SELECT `week no`,
     CONCAT(FORMAT(SUM(successful_bookings)/(SELECT SUM(successful_bookings) FROM fact_aggregated_bookings)*100,'2'),'%') AS `Total Booking`
FROM 
     dim_date AS d 
INNER JOIN 
     fact_aggregated_bookings AS g
ON 
     d.DATE = g.check_in_date
GROUP BY 
     `week no`;
     
     
-- Occupancy
CREATE TEMPORARY TABLE 
     Occupancy
SELECT
     `week no`, 
	  CONCAT(FORMAT(SUM(successful_bookings/capacity) / (SELECT SUM(successful_bookings/capacity) FROM fact_aggregated_bookings)*100,'2'), '%')  AS `Occupancy Rate`
FROM 
      dim_date AS d 
INNER JOIN 
      fact_aggregated_bookings AS g
ON 
      d.`date` = g.check_in_date
GROUP by 
      `week no`;

SELECT * FROM revenue;
SELECT * FROM Booking;
SELECT * FROM Occupancy;

SELECT 
    r.`week no`,
    r.`Revenue Percentage`,
    b.`Total Booking`, 
    o.`Occupancy Rate`
FROM 
	Revenue AS r
JOIN 
    Booking AS b 
ON 
    r.`week no` = b.`week no`
JOIN 
    Occupancy AS o 
ON 
    r.`week no` = o.`week no`;
    
    




