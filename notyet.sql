USE california
GO
-- data exploring
SELECT * FROM ['Wildfire $']

--removing null columns
ALTER TABLE ['Wildfire $']
DROP COLUMN column12

ALTER TABLE ['Wildfire $']
DROP COLUMN column13, column14, column15

SELECT * FROM ['Wildfire $']

-- adding new columns for year, month, day
ALTER TABLE ['Wildfire $'] ADD year INT;
ALTER TABLE ['Wildfire $'] ADD month INT;
ALTER TABLE ['Wildfire $'] ADD day INT;

UPDATE ['Wildfire $'] 
SET 
    year = YEAR(date),
    month = MONTH(date),
    day = DAY(date)

SELECT * FROM ['Wildfire $']  -- changes done


ALTER TABLE ['Wildfire $'] 
ADD Season VARCHAR(10);

UPDATE ['Wildfire $']
SET Season = 
    CASE 
        WHEN (month = 12 AND day >= 21) OR (month IN (1, 2)) OR (month = 3 AND day < 20) THEN 'Winter'
        WHEN (month = 3 AND day >= 20) OR (month IN (4, 5)) OR (month = 6 AND day < 21) THEN 'Spring'
        WHEN (month = 6 AND day >= 21) OR (month IN (7, 8)) OR (month = 9 AND day < 23) THEN 'Summer'
        ELSE 'Fall'
    END;

SELECT * FROM ['Wildfire $']

--Business Questions:
--1.  Temporal Analysis:

-- What is the range of years we are analysing?
SELECT MIN(YEAR) FROM ['Wildfire $']
SELECT MAX(YEAR) FROM ['Wildfire $']

-- What are the specific locations in California we are analyzing?
SELECT DISTINCT Location FROM ['Wildfire $']

-- incidents over years
SELECT year, COUNT(*) AS num_of_incidents
FROM ['Wildfire $']
GROUP BY year
ORDER BY year; -- ASC is the default

-- financial_loss over years
SELECT *
FROM ['Wildfire $']


SELECT year ,SUM(['Wildfire $'].[Estimated_Financial_Loss (Million $)]) AS Financial_loss_in_millions
FROM ['Wildfire $']
GROUP BY year
ORDER BY year;

-- homes_destroyed over years
SELECT year, SUM(['Wildfire $'].Homes_Destroyed) AS Homes_Destroyed
FROM ['Wildfire $']
GROUP BY year
ORDER BY year;

-- Businesses_destroyed over years
SELECT year, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM ['Wildfire $']
GROUP BY year
ORDER BY year;

-- Area_burnt over years
SELECT year, SUM(['Wildfire $'].[Area_Burned (Acres)]) AS Area_Burned_Acres
FROM ['Wildfire $']
GROUP BY year
ORDER BY year;
****************************************************************************
--2. Geographical Impact

--Which counties experience the highest number of wildfire incidents?
SELECT Location, COUNT(Incident_ID) AS number_of_incidents
FROM ['Wildfire $']
GROUP BY Location
ORDER BY number_of_incidents DESC

--Which counties suffer the most damage in terms of area burned?
SELECT Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Area_Burned_Acres DESC

--How do financial losses vary across different counties?
SELECT Location, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Financial_Loss_Million DESC

--What is the geographical distribution of injuries caused by wildfires?
SELECT Location, SUM(Injuries) AS Injuries
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Injuries DESC

--What is the geographical distribution of fatalities caused by wildfires?
SELECT Location, SUM(Fatalities) AS Fatalities
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Fatalities DESC

--How many homes are destroyed in each location?
SELECT Location, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Homes_Destroyed DESC

--How many vehicles are damaged in each location?
SELECT Location, SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM ['Wildfire $']
GROUP BY Location
ORDER BY Vehicles_Damaged DESC

--3. Geographical Impact over time

-- injuries per counties over years
SELECT year, Location, SUM(Injuries) AS injuries
FROM ['Wildfire $']
GROUP BY year, Location

-- fatalities per counties over years
SELECT year, Location, SUM(Fatalities) AS Fatalities
FROM ['Wildfire $']
GROUP BY year, Location

-- Businesses_Destroyed per counties over years
SELECT year, Location, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM ['Wildfire $']
GROUP BY year, Location

-- homes_Destroyed per counties over years
SELECT year, Location, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM ['Wildfire $']
GROUP BY year, Location

-- area_burnt per counties over years
SELECT year, Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM ['Wildfire $']
GROUP BY year, Location


--3. Cause Analysis

--How do financial losses vary by the cause of the wildfire?
SELECT Location, Cause, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM ['Wildfire $']
GROUP BY Cause, Location

--What is the relationship between the cause of a wildfire and the area burned?
SELECT Cause, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Financial_Loss_Million DESC

--What is the relationship between the cause of a wildfire and the area burned?
SELECT Cause, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Area_Burned_Acres DESC

--How does the cause of a wildfire impact the number of homes destroyed?
SELECT Cause, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Homes_Destroyed DESC

--How does the cause of a wildfire impact the number of businesses destroyed?
SELECT Cause, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Businesses_Destroyed DESC

--How does the cause of a wildfire impact the number of vehicles damaged?
SELECT Cause, SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Vehicles_Damaged DESC

--How does the cause of a wildfire impact the number of injuries?
SELECT Cause, SUM(Injuries) AS Injuries
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY Injuries DESC

--How does the cause of a wildfire impact the number of fatalities?
SELECT Cause, SUM(Fatalities) AS fatalities
FROM ['Wildfire $']
GROUP BY Cause
ORDER BY fatalities DESC




--4. Seasonal Trends

--How do wildfire incidents vary by season?
SELECT Season, COUNT(['Wildfire $'].Incident_ID) AS Incident_Count
FROM ['Wildfire $']
GROUP BY	Season
ORDER BY Incident_Count

--How do different wildfire causes contribute to seasonal incident counts?
SELECT Cause, Season, COUNT(Incident_ID) AS Incident_Count
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;

--What is the seasonal distribution of wildfire-related fatalities by cause?
SELECT Cause, Season, SUM(['Wildfire $'].Fatalities) AS Total_Fatalities 
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;

--How do injuries caused by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Injuries) AS Total_Injuries
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;

--How do homes destroyed by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Homes_Destroyed) AS Total_Homes
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;

--How do businesses destroyed by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Businesses_Destroyed) AS Total_Businesses_Destroyed
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;

--How do financial losses caused by wildfires vary by season and cause?
SELECT Cause, Season, SUM(['Wildfire $'].[Estimated_Financial_Loss (Million $)]) AS Total_Financial_Loss
FROM ['Wildfire $']
GROUP BY Cause, Season
ORDER BY Cause, Season;
