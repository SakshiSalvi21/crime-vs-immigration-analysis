--Total 'Actual incidents' per Year for 5 cities

SELECT 
    cd.CRIME_YEAR,
    SUM(cd.VALUE) AS Total_Actual_Crimes
FROM CRIME_DATA cd
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE s.STATISTICS = 'Actual incidents'
GROUP BY cd.CRIME_YEAR
ORDER BY cd.CRIME_YEAR;

--Total Immigration Count per Year for Ontario

SELECT 
    IMM_YEAR,
    SUM(VALUE) AS Total_Immigrants
FROM IMMIGRATION
GROUP BY IMM_YEAR
ORDER BY IMM_YEAR;

--Most Frequent Violation Yearwise

SELECT 
    cd.CRIME_YEAR,
    v.VIOLATIONS,
    COUNT(*) AS Violation_Count
FROM CRIME_DATA cd
INNER JOIN VIOLATIONS v ON cd.VIO_UNI_ID = v.VIO_UNI_ID
GROUP BY cd.CRIME_YEAR, v.VIOLATIONS
ORDER BY cd.CRIME_YEAR, Violation_Count DESC;

--Cities with Highest Crime in 2023

SELECT 
    cs.CITY,
    SUM(cd.VALUE) AS Total_Crime_2023
FROM CRIME_DATA cd
INNER JOIN CRIME_SCENE cs ON cd.C_GUID = cs.C_GUID
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE cd.CRIME_YEAR = 2023 AND s.STATISTICS = 'Actual incidents'
GROUP BY cs.CITY
ORDER BY Total_Crime_2023 DESC;

--Unfounded Crime Reports per City--Geography Chart

SELECT 
    cs.CITY,
    COUNT(*) AS Unfounded_Reports
FROM CRIME_DATA cd
INNER JOIN CRIME_SCENE cs ON cd.C_GUID = cs.C_GUID
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE s.STATISTICS = 'Unfounded incidents'
GROUP BY cs.CITY;

--Categorize Cities by Crime Volume using CASE 

SELECT 
    cs.CITY,
    cd.CRIME_YEAR,
    SUM(cd.VALUE) AS Total_Crimes,
    CASE 
        WHEN SUM(cd.VALUE) >= 150000 THEN 'High'
        WHEN SUM(cd.VALUE) BETWEEN 100000 AND 149999 THEN 'Medium'
        ELSE 'Low'
    END AS Crime_Level
FROM CRIME_DATA cd
INNER JOIN CRIME_SCENE cs ON cd.C_GUID = cs.C_GUID
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE s.STATISTICS = 'Actual incidents'
GROUP BY cs.CITY, cd.CRIME_YEAR
ORDER BY Total_Crimes DESC;

--Number of Distinct Violation Types per Year

SELECT 
    CRIME_YEAR,
    COUNT(DISTINCT VIO_UNI_ID) AS Violation_Count
FROM CRIME_DATA
GROUP BY CRIME_YEAR;

--View: Yearly Crime and Immigration Summary

CREATE VIEW yearly_crime_immigration_summary AS
SELECT 
    y.YEAR,
    (SELECT SUM(cd.VALUE)
     FROM CRIME_DATA cd
     INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
     WHERE cd.CRIME_YEAR = y.YEAR AND s.STATISTICS = 'Actual incidents') AS Total_Crime,
    (SELECT SUM(VALUE)
     FROM IMMIGRATION i
     WHERE i.IMM_YEAR = y.YEAR) AS Total_Immigration
FROM YEAR_TABLE y;

SELECT * FROM yearly_crime_immigration_summary;

--Compare 'Rate per 100,000' vs 'Actual incidents' for a Year

SELECT 
    s.STATISTICS,
    SUM(cd.VALUE) AS Total
FROM CRIME_DATA cd
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE cd.CRIME_YEAR = 2023 AND s.STATISTICS IN ('Rate per 100,000 population', 'Actual incidents')
GROUP BY s.STATISTICS;

--Cumulative Crimes per Year (Actual + Rate)

SELECT 
    cd.CRIME_YEAR,
    s.STATISTICS,
    SUM(cd.VALUE) AS Yearly_Total,
    SUM(SUM(cd.VALUE)) OVER (
        PARTITION BY s.STATISTICS ORDER BY cd.CRIME_YEAR
    ) AS Cumulative_Total
FROM CRIME_DATA cd
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE s.STATISTICS IN ('Actual incidents', 'Rate per 100,000 population')
GROUP BY cd.CRIME_YEAR, s.STATISTICS
ORDER BY cd.CRIME_YEAR, s.STATISTICS;

--Violations Present in the Most Recent Year Only

SELECT DISTINCT v.VIOLATIONS
FROM CRIME_DATA cd
INNER JOIN VIOLATIONS v ON cd.VIO_UNI_ID = v.VIO_UNI_ID
WHERE cd.CRIME_YEAR = (SELECT MAX(CRIME_YEAR) FROM CRIME_DATA)
AND v.VIO_UNI_ID NOT IN (
    SELECT VIO_UNI_ID
    FROM CRIME_DATA
    WHERE CRIME_YEAR < (SELECT MAX(CRIME_YEAR) FROM CRIME_DATA)
);

--Crimes by Violation Type and City (Top Violations View)

CREATE VIEW top_violations_by_city AS
SELECT 
    cs.CITY,
    v.VIOLATIONS,
    SUM(cd.VALUE) AS Total_Crimes
FROM CRIME_DATA cd
INNER JOIN VIOLATIONS v ON cd.VIO_UNI_ID = v.VIO_UNI_ID
INNER JOIN CRIME_SCENE cs ON cd.C_GUID = cs.C_GUID
INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
WHERE s.STATISTICS = 'Actual incidents'
GROUP BY cs.CITY, v.VIOLATIONS
HAVING SUM(cd.VALUE) > 0
ORDER BY cs.CITY, Total_Crimes DESC;

SELECT * FROM top_violations_by_city;

--Crime Volume Contribution by City (as % of Total)

WITH city_totals AS (
    SELECT 
        cs.CITY,
        SUM(cd.VALUE) AS city_total
    FROM CRIME_DATA cd
    INNER JOIN STATISTICS s ON cd.STATS_UNI_ID = s.STATS_UNI_ID
    INNER JOIN CRIME_SCENE cs ON cd.C_GUID = cs.C_GUID
    WHERE s.STATISTICS = 'Actual incidents'
    GROUP BY cs.CITY
),
overall_total AS (
    SELECT SUM(city_total) AS total_crimes FROM city_totals
)
SELECT 
    ct.CITY,
    ct.city_total,
    ROUND((ct.city_total::NUMERIC / ot.total_crimes) * 100, 2) AS percent_contribution
FROM city_totals ct
CROSS JOIN overall_total ot
ORDER BY percent_contribution DESC;



