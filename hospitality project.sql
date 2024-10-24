create database hospitality ;
use hospitality;
select * from fact_bookings;
use hotel;


-- KPI 1
select concat(format(sum(revenue_realized)/1000000,'n'),' M') as `Total Revenue` 
from fact_bookings;



-- KPI 2
select Concat(format((select sum(successful_bookings) 
from fact_aggregated_bookings) / 
(select sum(capacity) 
from fact_aggregated_bookings)*100,2),' %') 
As 'Occupancy Rate';



-- KPI 3
 Select concat((format((select count(booking_status) 
 from fact_bookings where booking_status = 'cancelled')/ 
 (select count(booking_status) from fact_bookings)*100,2)),' %') 
 As 'Cancellation Rate'; 



-- KPI 4
select format(sum(successful_bookings),'n') as 'Total booking'
from fact_aggregated_bookings;



-- KPI 5
select format(sum(capacity),'n') as 'Total Capacity'
from fact_aggregated_bookings;



-- KPI 6
select `week no`, format(sum(revenue_realized)/(select sum(revenue_realized) from fact_bookings)*100,'2') As `Revenue Percentage`
from dim_date as d inner join fact_bookings as f
on str_to_date(d.date, '%d-%b-%y') = f.check_in_date
group by `week no`;



-- KPI 7
SELECT d.day_type, format(SUM(f.revenue_realized),'no') AS `Total Revenue`
FROM dim_date AS d INNER JOIN fact_bookings AS f
ON STR_TO_DATE(d.date, '%d-%b-%y') = f.check_in_date
GROUP BY d.day_type;

select day_type, format(sum(successful_bookings), 'no')
from dim_date as d inner join fact_aggregated_bookings as f
on d.date = f.check_in_date
group by d.day_type;



-- KPI 8
select city, property_name, format(SUM(f.revenue_realized),'no') AS `Total Revenue`
from dim_hotels as d inner join fact_bookings as f
on d.property_id = f.property_id
group by city, property_name
order by city;

select city as State, concat(format(SUM(f.revenue_realized)/1000000,'no'),' M') AS `Total Revenue`
from dim_hotels as d inner join fact_bookings as f
on d.property_id = f.property_id
group by city
order by city;

select property_name As Hotel, concat(format(SUM(f.revenue_realized)/1000000,'no'),' M') AS `Total Revenue`
from dim_hotels as d inner join fact_bookings as f
on d.property_id = f.property_id
group by property_name;



-- KPI 9
select room_class as Class, format(SUM(f.revenue_realized),'no') AS `Total Revenue`
from dim_rooms as r inner join fact_bookings as f
on r.room_id = f.room_category
group by Class;



-- KPI 10
select booking_status,format(count(booking_status),'n')as Total
from fact_bookings
group by booking_status;




-- KPI 11

create temporary table Revenue
select `week no`, format(sum(revenue_realized)/(select sum(revenue_realized) from fact_bookings)*100,'2') As `Revenue Percentage`
from dim_date as d inner join fact_bookings as f
on str_to_date(d.date, '%d-%b-%y') = f.check_in_date
group by `week no`;
select * from revenue;

create temporary table Booking
select `week no`, format(sum(successful_bookings)/(select sum(successful_bookings) from fact_aggregated_bookings)*100,'2') as `Total Booking`
from dim_date as d inner join fact_aggregated_bookings as g
on d.date = g.check_in_date
group by `week no`;

create temporary table Occupancy
select `week no`, format(sum(successful_bookings/capacity) / (select sum(successful_bookings/capacity) from fact_aggregated_bookings)*100,'2')  as `Occupancy Rate`
from dim_date as d inner join fact_aggregated_bookings as g
on d.date = g.check_in_date
group by `week no`;

select * from revenue;
select * from Booking;
select * from Occupancy;

SELECT r.`week no`, r.`Revenue Percentage`, b.`Total Booking`, o.`Occupancy Rate`
FROM Revenue AS r
JOIN Booking AS b ON r.`week no` = b.`week no`
JOIN Occupancy AS o ON r.`week no` = o.`week no`;




select `week no`, format(sum(successful_bookings/capacity) / (select sum(successful_bookings/capacity) from fact_aggregated_bookings)*100,'2')  as `Occupancy Rate`,
format(sum(successful_bookings)/(select sum(successful_bookings) from fact_aggregated_bookings)*100,'2') as `Total Booking`,
format(sum(revenue_realized)/(select sum(revenue_realized) from fact_bookings)*100,'2') As `Revenue Percentage`
from fact_aggregated_bookings as g inner join dim_date as d inner join fact_bookings as f
on d.dates = g.check_in_date and str_to_date(d.dates, '%d-%b-%y') = f.check_in_date
group by `week no`;







select week(check_in_date) as week_no ,sum(revenue_realized) from tejal.fact_bookings group by week(check_in_date);