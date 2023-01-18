select *
from bird_data
limit 5;

SELECT * 
FROM city_weather
LIMIT 5;

select *
from bird_data
order by bird_data.nearest_city
limit 10;

SELECT * 
FROM city_weather
order by city_weather.CITY
LIMIT 5;

SELECT * 
FROM city_weather
order by city_weather.avg_temp
LIMIT 5;

select *
from bird_data
order by bird_data.date
limit 10;

SELECT * 
FROM city_weather
order by city_weather.date;

SELECT bird.id, bird.altitude, bird.date_time, city.DATE, 
bird.device_info_serial, bird.direction, bird.latitude, bird.longitude, 
bird.nearest_city, bird.country,
		city.avg_temp
FROM bird_data as bird
LEFT JOIN city_weather as city
ON bird.nearest_city = city.CITY;
-- above code correctly joins city but not date

ALTER TABLE bird_data
MODIFY COLUMN id int AUTO_INCREMENT; 
-- could not alter id column through code written above

-- instead had to add new column as primary and auto incremental
ALTER TABLE bird_data
ADD id2 int NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (id2); 

-- then dropped old id column
ALTER TABLE bird_data
DROP COLUMN id;

-- renamed id2 to id so that it takes place of old id
ALTER TABLE bird_data
RENAME COLUMN id2 TO id;

-- create a temp table to join bird data and weather data (because CTE does not work)
-- both date and city columns need to join

DROP TEMPORARY TABLE location;

CREATE TEMPORARY TABLE location
(SELECT bird.id, bird.bird_name, bird.speed_2d, bird.altitude, bird.direction, 
bird.latitude, bird.longitude, 
bird.date_time, bird.date,
bird.device_info_serial, 
bird.nearest_city, city.CITY, bird.country
FROM bird_data as bird
LEFT JOIN city_weather as city ON city.city = bird.nearest_city
Group by bird.id);

SELECT * FROM location
LIMIT 40;

SELECT l.id, l.bird_name, l.speed_2d, l.altitude, l.direction, 
l.latitude, l.longitude, 
l.date_time, city2.DATE,
l.device_info_serial, 
l.nearest_city, l.city, l.country, city2.avg_temp
FROM location as l
LEFT JOIN city_weather as city2 ON l.date = city2.date
ORDER BY l.id;


-- create CTE to join tables
-- cannot perform query below, yields ERROR CODE 2013

WITH location as
(SELECT bird.id, bird.speed_2d, bird.altitude, bird.direction, 
bird.latitude, bird.longitude, bird.bird_name,
bird.date_time, bird.date,
bird.device_info_serial, 
bird.nearest_city, city.CITY, bird.country
FROM bird_data as bird
INNER JOIN city_weather as city ON city.city = bird.nearest_city
)
-- SELECT * FROM location LIMIT 10;

SELECT l.id, 
l.bird_name, 
l.speed_2d, 
l.altitude,
l.date_time, 
l.device_info_serial as device_info, 
l.direction, 
l.latitude, 
l.longitude, 
l.nearest_city, 
l.country, 
city2.avg_temp
FROM location as l
LEFT JOIN city_weather as city2 ON l.date = city2.date
ORDER by l.id;

SELECT l.id, 
city2.avg_temp
FROM location as l
LEFT JOIN city_weather as city2 ON l.date = city2.date
WHERE avg_temp != -99
ORDER by city2.avg_temp;

