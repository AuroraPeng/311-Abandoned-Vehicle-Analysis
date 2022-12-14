USE survey;

# Sub-query of service numbers to exclude (these are reported later therefore, they are dups)
SELECT 
	DISTINCT (service_B)
    #service_B,
    #A.Creation_Date AS DATE1,
    #B.Creation_Date AS DATE2,
    #DATEDIFF(A.Creation_Date, B.Creation_Date) AS diff #if negative Service A gets reported first
FROM duplicates
JOIN service AS A
ON A.service_id = duplicates.service_A
JOIN service AS B
ON B.service_id = duplicates.service_B
WHERE DATEDIFF(A.Creation_Date, B.Creation_Date) > 0;
########################################################################

# Frequency of requests by ZIP Code (Duplicates not removed)
DROP TABLE IF EXISTS temp_survey_dupe;
CREATE TABLE temp_survey_dupe AS

SELECT 
	GEOG, #L.ZIP_Code AS ZIP,
    COUNT(service_id) AS request_num,
    COUNT(service_id) / TOT_ACRES AS report_per_acre,
    2010_POP,
    WHITE,
    WHITE / 2010_POP * 100 AS white_perc,
    BLACK,
    BLACK / 2010_POP * 100 AS black_perc,
    HISP,
    HISP / 2010_POP * 100 AS hisp_perc,
    ASIAN,
    ASIAN / 2010_POP * 100 AS asian_perc
FROM service AS S
JOIN location AS L
	ON L.Location_id = S.Location_id
JOIN survey_data AS sd
	ON sd.GEOID = L.Community_area
GROUP BY GEOID
ORDER BY request_num DESC;

# Frequency of requests, average time to complete, days before first report by ZIP Code (Duplicates removed)
DROP TABLE IF EXISTS temp_survey_no_dupe_no_year;
CREATE TABLE temp_survey_no_dupe_no_year AS
SELECT 
	GEOG, 
    GEOID,
    #L.ZIP_Code AS ZIP,
    COUNT(service_id) AS tot_request_ct,
    COUNT(service_id) / TOT_POP * 100 AS tot_requests_per_cap, # Total requests per capita
    COUNT(service_id) / TOT_ACRES AS tot_requests_per_acre,
    AVG(time_to_complete) as average_time_to_comp,
    AVG(total_days_parked) AS days_b4_report,
    TOT_POP,
    MED_RENT,
    MED_AGE,
    MED_HV AS med_home_val,
    WHITE,
    WHITE / TOT_POP * 100 AS white_perc,
    BLACK,
    BLACK / TOT_POP * 100 AS black_perc,
    HISP,
    HISP / TOT_POP * 100 AS hisp_perc,
    ASIAN,
    ASIAN / TOT_POP * 100 AS asian_perc,
    MEDINC,
    HS / TOT_POP * 100 as high_school_perc,
    SOME_COLL / TOT_POP * 100 as some_college_perc,
    BACH / TOT_POP * 100 as bachelors_perc,
    GRAD_PROF / TOT_POP * 100 as gradschool_perc
FROM service AS S
JOIN location AS L
	ON L.Location_id = S.Location_id
JOIN survey_data AS sd
	ON sd.GEOID = L.Community_area
WHERE service_id NOT IN (
	SELECT 
		DISTINCT (service_B)
	FROM duplicates
	JOIN service AS A
	ON A.service_id = duplicates.service_A
	JOIN service AS B
	ON B.service_id = duplicates.service_B
	WHERE DATEDIFF(A.Creation_Date, B.Creation_Date) > 0
)
GROUP BY GEOID;



# Frequency of requests by year (Duplicates removed)

DROP TABLE IF EXISTS temp_survey_no_dupe_year;
CREATE TABLE temp_survey_no_dupe_year AS

SELECT 
	GEOG, 
    GEOID,
    YEAR(Creation_Date) AS Year,
    #L.ZIP_Code AS ZIP,
    COUNT(service_id) AS tot_request_ct,
    COUNT(service_id) / TOT_POP * 100 AS tot_requests_per_cap, # Total requests per capita
    COUNT(service_id) / TOT_ACRES AS tot_requests_per_acre,
    AVG(time_to_complete) as average_time_to_comp,
    AVG(total_days_parked) AS days_b4_report,
    TOT_POP,
    MED_RENT,
    MED_AGE,
    MED_HV AS med_home_val,
    WHITE,
    WHITE / TOT_POP * 100 AS white_perc,
    BLACK,
    BLACK / TOT_POP * 100 AS black_perc,
    HISP,
    HISP / TOT_POP * 100 AS hisp_perc,
    ASIAN,
    ASIAN / TOT_POP * 100 AS asian_perc,
    MEDINC,
    HS / TOT_POP * 100 as high_school_perc,
    SOME_COLL / TOT_POP * 100 as some_college_perc,
    BACH / TOT_POP * 100 as bachelors_perc,
    GRAD_PROF / TOT_POP * 100 as gradschool_perc
FROM service AS S
JOIN location AS L
	ON L.Location_id = S.Location_id
JOIN survey_data AS sd
	ON sd.GEOID = L.Community_area
WHERE service_id NOT IN (
	SELECT 
		DISTINCT (service_B)
	FROM duplicates
	JOIN service AS A
	ON A.service_id = duplicates.service_A
	JOIN service AS B
	ON B.service_id = duplicates.service_B
	WHERE DATEDIFF(A.Creation_Date, B.Creation_Date) > 0
)
GROUP BY GEOID,Year;

# Map table - no dupe, year, zip
DROP TABLE IF EXISTS temp_survey_map;
CREATE TABLE temp_survey_map AS
SELECT 
    YEAR(Creation_Date) AS Year,
    L.ZIP_Code AS ZIP,
    COUNT(service_id) AS tot_request_ct,
    AVG(time_to_complete) as average_time_to_comp,
    AVG(total_days_parked) AS days_b4_report
FROM service AS S
JOIN location AS L
	ON L.Location_id = S.Location_id
WHERE service_id NOT IN (
	SELECT 
		DISTINCT (service_B)
	FROM duplicates
	JOIN service AS A
	ON A.service_id = duplicates.service_A
	JOIN service AS B
	ON B.service_id = duplicates.service_B
	WHERE DATEDIFF(A.Creation_Date, B.Creation_Date) > 0
)
GROUP BY ZIP_Code,Year;

# Community and Zip Look-up

DROP TABLE IF EXISTS temp_zip_lookup;
CREATE TABLE temp_zip_lookup AS
SELECT 
    DISTINCT(Community_Area),
    ZIP_Code
FROM location
WHERE ZIP_Code IS NOT NULL
ORDER BY 1
;
 
