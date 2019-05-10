#Usage Volume Overview
#1.1. The total number of trips for the years of 2016.
SELECT COUNT(*)
FROM trips
WHERE YEAR(start_date)=2016 AND YEAR(end_date)=2016
#3917401

#1.2.The total number of trips for the years of 2017.
SELECT COUNT(*)
FROM trips
WHERE YEAR(start_date)=2017 AND YEAR(end_date)=2017
#4666765

#1.3.The total number of trips for the years of 2016 broken-down by month.
SELECT YEAR(start_date),MONTHNAME(start_date) AS month,COUNT(*)
FROM trips
WHERE YEAR (start_date)=2016 AND YEAR(end_date)=2016
GROUP BY month
ORDER BY COUNT(*) DESC

#1.4.The total number of trips for the years of 2017 broken-down by month .
SELECT YEAR(start_date),MONTHNAME(start_date) AS month,COUNT(*)
FROM trips
WHERE YEAR (start_date)=2017 AND YEAR(end_date)=2017
GROUP BY month
ORDER BY COUNT(*) DESC

#1.5.The average number of trips a day for each year-month combination in the dataset.
CREATE TABLE 2016_cal (2016months CHAR(20),numofdays INT)
CREATE TABLE 2017_cal (2017months CHAR(20),numofdays INT)
INSERT INTO 2016_cal (2016months,numofdays) VALUES ('January',31),('February',29),('March',31),('April',30),('May',31),('June',30),('July',31),('August',31),
                                                     ('September',30),('October',31),('November',30),('December',31)
INSERT INTO 2017_cal (2017months,numofdays) VALUES ('January',31),('February',28),('March',31),('April',30),('May',31),('June',30),('July',31),('August',31),
                                                     ('September',30),('October',31),('November',30),('December',31)
                                                     
SELECT Y,partone.2016months,numofdays,tripspermonth/numofdays AS avgpermonth
FROM 
 (
 		SELECT YEAR(start_date) AS Y,MONTHNAME(start_date) AS 2016months,COUNT(*) AS tripspermonth
		FROM trips
		WHERE YEAR (start_date)=2016 AND YEAR(end_date)=2016
		GROUP BY 2016months
 ) AS partone JOIN 2016_cal ON partone.2016months=2016_cal.2016months


SELECT Y,partone.2017months,numofdays,tripspermonth/numofdays AS avgpermonth
FROM 
 (
 		SELECT YEAR(start_date) AS Y,MONTHNAME(start_date) AS 2017months,COUNT(*) AS tripspermonth
		FROM trips
		WHERE YEAR (start_date)=2017 AND YEAR(end_date)=2017
		GROUP BY 2017months
         ) AS partone JOIN 2017_cal ON partone.2017months=2017_cal.2017months


#2.1 The total number of trips in the year 2017 broken-down by membership status (member/non-member).
SELECT COUNT(*), is_member AS membership
FROM trips
WHERE YEAR(start_date)=2017 AND YEAR(end_date)=2017
GROUP BY membership
#3784682

#2.2 The fraction of total trips that were done by members for the year of 2017 broken-down by month.
SELECT COUNT(*) AS tripspermonth,MONTHNAME(start_date) AS 2017months,COUNT(*)/3784682 AS fraction
FROM trips
WHERE (YEAR(start_date)=2017 AND YEAR(end_date)=2017) AND is_member=1
GROUP BY MONTHNAME(start_date)

#Trip Characteristics
#1.1 Calculate the average trip time across the entire dataset.
SELECT AVG(duration_sec) AS averagetime
FROM trips
#824.491

#2.1Calculate the average trip time broken-down by:Membership status
SELECT is_member AS membership, AVG(duration_sec) AS averagetime
FROM trips
GROUP BY membership

#2.2 Calculate the average trip time broken-down by:Month
SELECT MONTHNAME(start_date) AS month, AVG(duration_sec) AS averagetime
FROM trips
GROUP BY month

#2.3 Calculate the average trip time broken-down by: Day of the week
SELECT WEEKDAY(start_date) AS d, AVG(duration_sec) AS averagetime,
(
	CASE
	WHEN WEEKDAY(start_date)=0 THEN 'Monday'
	WHEN WEEKDAY(start_date)=1 THEN 'Tuesday'
	WHEN WEEKDAY(start_date)=2 THEN 'Wednesday'
	WHEN WEEKDAY(start_date)=3 THEN 'Thursday'
	WHEN WEEKDAY(start_date)=4 THEN 'Fridday'
	WHEN WEEKDAY(start_date)=5 THEN 'Saturday'
	WHEN WEEKDAY(start_date)=6 THEN 'Sunday'

	ELSE 'NODAY' 
	END
			) AS wkd
FROM trips
GROUP BY d



#2.4 Calculate the average trip time broken-down by: station name
#1. & 2.
SELECT stations.name, a.averagetime
FROM
(
	SELECT start_station_code AS code, AVG(duration_sec) AS averagetime
	FROM trips
	GROUP BY code
	) AS a JOIN stations ON a.code=stations.code
ORDER BY averagetime DESC
 
SELECT stations.name, a.averagetime
FROM
(
	SELECT end_station_code AS code, AVG(duration_sec) AS averagetime
	FROM trips
	GROUP BY code
) AS a JOIN stations ON a.code=stations.code
ORDER BY averagetime DESC

#Trip Characteristics
#Q.3.1. Let's call trips that start and end in the same station "round trips". Calculate the fraction of trips that were round trips and break it down by:
#Membership status
SELECT COUNT(*)
FROM trips
WHERE start_station_code=end_station_code
#178173

SELECT is_member AS membership,COUNT(*) AS numofroundtrips, COUNT(*)/178173 AS fraction
FROM trips
WHERE start_station_code=end_station_code
GROUP BY membership


#Q.3.2. day of week
SELECT WEEKDAY(start_date) as wd,COUNT(*) AS numofroundtrips,COUNT(*)/178173 AS fraction,
(
	CASE
	WHEN WEEKDAY(start_date)=0 THEN 'Monday'
	WHEN WEEKDAY(start_date)=1 THEN 'Tuesday'
	WHEN WEEKDAY(start_date)=2 THEN 'Wednesday'
	WHEN WEEKDAY(start_date)=3 THEN 'Thursday'
	WHEN WEEKDAY(start_date)=4 THEN 'Fridday'
	WHEN WEEKDAY(start_date)=5 THEN 'Saturday'
 WHEN WEEKDAY(start_date)=6 THEN 'Sunday'

	ELSE 'NODAY' 
	END
			) AS wkd
FROM trips
WHERE start_station_code=end_station_code
GROUP BY wd

#Popular Stations
#1.What are the names of the 5 most popular starting stations?
SELECT name, a.numoftrips
FROM
(
	SELECT start_station_code AS code, COUNT(*) AS numoftrips
	FROM trips
	GROUP BY code ) AS a JOIN stations ON a.code=stations.code

ORDER BY a.numoftrips DESC
LIMIT 5


#2. What are the names of the 5 most popular ending stations?
SELECT name, a.numoftrips
FROM
(
	SELECT end_station_code AS code, COUNT(*) AS numoftrips
	FROM trips
	GROUP BY code ) AS a JOIN stations ON a.code=stations.code
ORDER BY a.numoftrips DESC
LIMIT 5


#3.1.How is the number of starts and ends distributed for the station Mackay / de Maisonneuve throughout the day?

SELECT COUNT(*) AS start_trips, 
    CASE 
    WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "morning"
    WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "afternoon"
    WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "evening"
  
    ELSE 'night'
     END AS time_of_day 
FROM 
   (
	SELECT trips.start_date,trips.id
	FROM
	(
		SELECT code,name
		FROM stations
		WHERE name='Mackay / de Maisonneuve') AS a JOIN trips ON a.code=trips.start_station_code) AS b
GROUP BY time_of_day




SELECT COUNT(*) AS end_trips, 
    CASE 
    WHEN HOUR(end_date) BETWEEN 7 AND 11 THEN "morning"
    WHEN HOUR(end_date) BETWEEN 12 AND 16 THEN "afternoon"
    WHEN HOUR(end_date) BETWEEN 17 AND 21 THEN "evening"
  
    ELSE 'night'
   END AS time_of_day 
FROM 
   (
	SELECT trips.end_date,trips.id
	FROM
			(
			SELECT code,name
			FROM stations
			WHERE name='Mackay / de Maisonneuve'
			) AS a JOIN trips ON a.code=trips.end_station_code
			
	) AS b
GROUP BY time_of_day

#4.Which station has proportionally the least number of member trips? How about the most? To damper variance, consider only stations for which there were at least 10 trips starting and ending from it.

      CREATE VIEW A AS
		SELECT COUNT(*) AS totalstarttrips, start_station_code,is_member AS membership
		FROM trips
		WHERE is_member=1 
		GROUP BY start_station_code
		
      CREATE VIEW B AS
      SELECT COUNT(*) AS totalendtrips, end_station_code,is_member AS membership
		FROM trips
		WHERE is_member=1 
		GROUP BY end_station_code
		
	SELECT name, c.s_code, c.total
	FROM  	
	(
		SELECT A.start_station_code AS s_code, B.end_station_code,A.totalstarttrips,B.totalendtrips,A.totalstarttrips+B.totalendtrips AS total
		FROM A JOIN B ON A.start_station_code=B.end_station_code
		WHERE (A.totalstarttrips>=10) AND (B.totalendtrips>=10) 
   ) AS C JOIN stations ON C.s_code=stations.code
   ORDER BY c.total DESC

#5.List all stations for which at least 10% of trips are round trips. Recall round trips are those that start and end in the same station. This time we will only consider stations with at least 50 starting trips.

CREATE VIEW total_trips AS
SELECT start_station_code, COUNT(*)
FROM trips
GROUP BY start_station_code 

CREATE VIEW total_round-trips AS
SELECT start_station_code, COUNT(*)
FROM trips
WHERE start_station_code=end_station_code
GROUP BY start_station_code


CREATE VIEW fraction AS
SELECT total_trips.start_station_code AS code, total_round_trips.totalroundtrips/total_trips.totaltrips AS fractionoftrips
FROM total_trips JOIN total_round_trips ON total_trips.start_station_code=total_round_trips.start_station_code
WHERE total_trips.totaltrips >=50

SELECT stations.name,fraction.fractionoftrips
FROM fraction JOIN stations ON fraction.code=stations.code
WHERE fraction.fractionoftrips >=0.1
ORDER BY fraction.fractionoftrips DESC
