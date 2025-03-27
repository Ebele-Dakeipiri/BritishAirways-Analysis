--creating ba_flight_routes table
CREATE TABLE ba_flight_routes(
	flight_number VARCHAR(10) PRIMARY KEY,
	departure_city VARCHAR(25),
	arrival_city VARCHAR(25),
	distance_flown INT

);

--creating ba_fuel_efficiency table
CREATE TABLE ba_fuel_efficiency(
	ac_subtype VARCHAR(10) PRIMARY KEY,
	manufacturer VARCHAR(20),	
	fuel_efficiency NUMERIC(11,10),
	capacity INT
);

--creating ba_flights table
CREATE TABLE ba_flights(
	flight_id VARCHAR(20) PRIMARY KEY,	
	flight_number VARCHAR(10) REFERENCES ba_flight_routes(flight_number),
	actual_flight_date DATE,
	airline	VARCHAR(5),
	status VARCHAR(15),
	delayed_flight VARCHAR(5),	
	total_passengers INT,
	baggage_weight INT,
	bike_bags INT,
	revenue_from_baggage NUMERIC(10,0)
);


--creating the ba_aircrafts table
CREATE TABLE ba_aircrafts(
	aircraft_id INT PRIMARY KEY,
	flight_id VARCHAR(20) REFERENCES ba_flights(flight_id),
	ac_subtype VARCHAR(10) REFERENCES ba_fuel_efficiency(ac_subtype),
	manufacturer VARCHAR(20)
	
);

ALTER TABLE ba_flights
ALTER COLUMN revenue_from_baggage TYPE NUMERIC(10,2)

SELECT *
FROM ba_fuel_efficiency;


SELECT*
FROM ba_flights;



--QUESTION 1 Which manufacturer has the best aircrafts in terms of fuel efficiency?
SELECT manufacturer,
	ROUND(AVG(fuel_efficiency),2) AS Avg_fuel_efficiency
FROM ba_fuel_efficiency
GROUP BY manufacturer
ORDER BY Avg_fuel_efficiency 
LIMIT 1;


--QUESTION 2 Does British Airways tend to use aircraft from manufacturers known for their superior fuel efficiency more frequently?
------The fuel efficiency here is in L/KM, hence, the lower the value the higher the superiority.
SELECT fl.manufacturer,
	COUNT(ac.aircraft_id) AS Usage_Freq,
	ROUND(AVG (DISTINCT fl.fuel_efficiency),3) AS Avg_fuel_efficiency
FROM ba_fuel_efficiency AS fl
LEFT JOIN ba_aircrafts AS ac USING(ac_subtype)
GROUP BY fl.manufacturer
ORDER BY Usage_Freq DESC;
---From the aircrafts used by BA, they tend to use Beoing with the superior efficiency more. 
--BA does not use Mitsubishi though they have a better fuel efficiency compared to Beoing.


--QUESTION 3 Which month did passengers cancel flights the most?
SELECT 
	TO_CHAR(actual_flight_date, 'Month') AS Months,
	COUNT(flight_id) AS no_of_flights
FROM ba_flights
WHERE status = 'Cancelled'
GROUP BY TO_CHAR(actual_flight_date, 'Month')
ORDER BY no_of_flights DESC
LIMIT 1;
--APRIL


--QUESTION 4 Which city do passengers travel to the most?
SELECT fr.arrival_city,
		SUM(fl.total_passengers) AS no_of_passengers
FROM ba_flight_routes AS fr
INNER JOIN ba_flights AS fl USING(flight_number)
GROUP BY fr.arrival_city
ORDER BY no_of_passengers DESC
LIMIT 1;


--QUSETION 5 What is the revenue generated from baggage overtime?
SELECT TO_CHAR(actual_flight_date, 'Month') AS Months,
	 ' $ ' || SUM(revenue_from_baggage) AS total_revenue
FROM ba_flights
GROUP BY TO_CHAR(actual_flight_date, 'Month'),EXTRACT(MONTH FROM actual_flight_date)
ORDER BY EXTRACT(MONTH FROM actual_flight_date);


--QUESTION 6 What is the average number of passengers like for each month?
SELECT TO_CHAR(actual_flight_date,'Month') AS Months,
	ROUND(AVG(total_passengers),0) AS avg_no_of_customers
FROM ba_flights
GROUP BY TO_CHAR(actual_flight_date,'Month'),EXTRACT(MONTH FROM actual_flight_date)
ORDER BY EXTRACT(MONTH FROM actual_flight_date);





