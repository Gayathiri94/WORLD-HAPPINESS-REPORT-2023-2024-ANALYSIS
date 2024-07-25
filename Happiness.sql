-- CREATE DATABASE
create database happiness ; 


-- CHOOSE DATABASE
use happiness ; 

-- OVERVIEW OF TABLES
select * from whr_2024 ; 
select * from whr_2023 ; 

-- RENAMING COLUMNS 
alter table whr_2024
change column `country name` country text ; 

alter table whr_2024
change column `ladder score` `happiness_score` double ; 

alter table whr_2024
change column `Perceptions of corruption` corruption double ; 

## COUNTRY WISE ANALYSIS - ON 2024 DATASET 

-- 1. NUMBER OF COUNTRIES CONSIDERED 
select distinct(count(country)) as `total countries` from whr2024 ; 

-- 2. TOP 5 HAPPIEST COUNTRIES
select country,	`regional indicator`, happiness_score from whr_2024 order by `happiness_score` desc limit 5 ; 

-- 3. 5 LEAST HAPPIEST COUNTRIES
select country, happiness_score from whr2024 order by `happiness_score` asc limit 5 ; 

-- 4. AVERAGE HAPPINESS SCORE ACROSS ALL COUNTRIES 
select round(avg(`happiness_score`),2) as `Average Score` from whr_2024 ; 

-- 5. COUNTRIES WITH HAPPINESS SCORE GREATER THAN GLOBAL AVERAGE SCORE. 
-- RETURN COUNTRY, HAPPINESS_SCORE, GLOBAL AVERAGE 

With Country_score as 
(
    select  country, happiness_score 
    from  whr_2024 
),
GlobalAverage as 
(
    Select round(avg(happiness_score),2) AS `Global_avg`
    from whr_2024
)
SELECT c.country, c.happiness_score, g.`Global_avg`
from country_score c , GlobalAverage g
Where c.happiness_score > g.`Global_avg`;

-- 6. FACTORS INFLUENCING HAPPINESS OF A COUNTRY - 

-- i.  RELATION BETWEEN HAPPINESS SCORE AND GDP OF COUNTRIES 
select country, happiness_score, `gdp per capita` from whr_2024 order by happiness_score, `gdp per capita` ;

-- ii. LIFE EXPECTANCY AND HAPPINESS ON EACH COUNTRY
select country, happiness_score, `Healthy life expectancy` from whr_2024 order by happiness_score desc,  `Healthy life expectancy` desc ;

-- iii. SOCIAL SUPPORT AND HAPPINESS SCORE 
select country, happiness_score, `social support` from whr_2024 order by happiness_score desc, `social support` desc ; 

-- iv. FREEDOM TO MAKE LIFE CHOICES AND HAPPINESS SCORE 
select country, happiness_score, `Freedom to make life choices` 
from whr_2024 order by happiness_score desc , `Freedom to make life choices` desc ; 

-- v. GENEROSITY AND HAPPINESS SCORE 
select country, happiness_score, `generosity` from whr_2024 order by happiness_score desc, `generosity` desc ; 

-- vi. CORRUPTION AND HAPPINES SCORE 
select country, happiness_score, corruption from whr_2024 order by happiness_score desc, corruption desc ; 

### REGION WISE ANALYSIS - 2024 DATASET 

-- 7. AVERAGE HAPPINES SCORE FOR EACH REGION
select `regional indicator`, round(avg(`happiness_score`), 2) as `Average Happiness Score` from whr_2024 
group by `regional indicator` order by `Average Happiness Score` desc ; 

-- 8. COUNTRIES WHERE HAPPINESS SCORE IS ABOVE THEIR RESPECTIVE AVERAGE REGIONAL SCORE 
SELECT country, happiness_score, `regional indicator`,
 (
    SELECT ROUND(AVG(happiness_score),2) 
    FROM whr_2024 as inner_table
   WHERE inner_table.`regional indicator` = outer_table.`regional indicator`
) as `avg score of each region` 
FROM whr_2024 as outer_table 
WHERE happiness_score > 
( SELECT ROUND(AVG(happiness_score),2) 
    FROM whr_2024 as inner_table
   WHERE inner_table.`regional indicator` = outer_table.`regional indicator`
) ; 

-- 9. TOP 3 HAPPIEST COUNTRIES IN EACH REGION
select * from ( select w.country,w.`regional indicator` , w.Happiness_score  ,
dense_rank ()
over (partition by `regional indicator` order by happiness_score desc) 
as `Rank of countries` 
from whr_2024 w ) as x 
where x.`rank of countries` < 6 ; 

-- 10. AVERAGE HAPPINESS SCORE AND AVERAGE GDP SCORE - REGION WISE 
select `regional indicator` , 
(select round(avg(`gdp per capita`),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg GDP Per Capita` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
GROUP BY `regional indicator` 
ORDER BY `Avg GDP Per Capita` DESC, `Avg Happiness Score` DESC;

-- 11. IMPACT OF SOCIAL SUPPORT ON EACH REGION 
select `regional indicator` , 
(select round(avg(`social support`),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg_social support` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
GROUP BY `regional indicator` 
ORDER BY `Avg_social support` DESC, `Avg Happiness Score` DESC;

-- 12 FACTORS INFLUENCING HAPPINESS OF A REGION - 
-- i.FREEDOM AND HAPPINESS SCORE - REGION WISE 
select `regional indicator` , 
(select round(avg(`Freedom to make life choices`),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg_freedom score` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
GROUP BY `regional indicator` 
ORDER BY `Avg Happiness Score` DESC, `Avg_freedom score` DESC;

-- ii.CORRUPTION AND HAPPINESS SCORE - REGION WISE 
select `regional indicator` , 
(select round(avg(corruption),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg_corruption score` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
GROUP BY `regional indicator` 
ORDER BY `Avg Happiness Score` DESC, `Avg_corruption score` DESC;

-- iii. GENEROSITY AND HAPPINESS SCORE - REGION WISE 
select `regional indicator` , 
(select round(avg(generosity),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg_generosity score` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
group by `regional indicator` 
order by `Avg happiness score` desc, `Avg_generosity score` desc;


-- iv. LIFE EXPECTANCY AND HAPPINESS ON EACH REGION 
select `regional indicator` , 
(select round(avg(`Healthy life expectancy`),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg_Life expectancy` ,
(select round(avg(happiness_score),2) from whr_2024 as inner_table
where inner_table.`regional indicator` = outer_table . `regional indicator` ) as `Avg happiness score` 
from whr_2024 as outer_table 
GROUP BY `regional indicator` 
ORDER BY `Avg_Life expectancy` DESC, `Avg Happiness Score` DESC;

-- v.REGION WHERE NO COUNTRY HAS HAPPINESS SCORE IN TOP 50
Select  
    distinct w.`regional indicator`
from
    whr_2024 w
Left join (
    Select country, `regional indicator`
    From whr_2024
    order by happiness_score DESC Limit 50
) 
t ON w.`regional indicator` = t.`regional indicator`
Where 
    t.country is null;
    
-- vi.REGIONS WITH HAPPINESS SCORE GREATER THAN THE GLOBAL AVERAGE OF REGIONS 

With RegionalAverages as 
(
    select  `regional indicator`, round(Avg(happiness_score), 2) as `Avg_regional_score`
    from  whr_2024 group by `regional indicator`
),
GlobalAverage as 
(
    Select avg(`Avg_regional_score`) AS `Global_avg`
    from RegionalAverages
)
SELECT r.`regional indicator`, r.`Avg_regional_score`, g.`Global_avg`
from RegionalAverages r, GlobalAverage g
Where r.`Avg_regional_score` > g.`Global_avg`;

-- 

##  COMPARATIVE ANALYSIS - across 2024, 2023

-- 13. TOP 5 HAPPIEST COUNTRIES - RETURN COUNTRIES OF 2024 AND 2023
select t1.country_2024, t2.country_2023
from (
    select country as country_2024, row_number() over (order by happiness_score desc) AS rn
    FROM whr2024
) AS t1
JOIN (
    SELECT country as country_2023, row_number() over (order by happiness_score desc) AS rn
    FROM whr_2023
) AS t2 ON t1.rn = t2.rn
limit 5 ; 

-- 14.LEAST HAPPIEST COUNTRIES - 2024,2023
select t1.country_2024, t2.country_2023
from (
    select country as country_2024, row_number() over (order by happiness_score) AS rn
    FROM whr2024
) AS t1
JOIN (
    SELECT country as country_2023, row_number() over (order by happiness_score ) AS rn
    FROM whr_2023
) AS t2 ON t1.rn = t2.rn
limit 5 ; 

-- 15.COUNTRIES THAT HAVE IMPROVED COMPARED TO 2023
 with HappinessChange AS (
    SELECT 
        w23.country,
        round(w23.happiness_score,2) AS score_2023,
        round(w24.happiness_score,2) AS score_2024,
		round(((w24.happiness_score - w23.happiness_score) / w23.happiness_score) * 100,2) AS `score_change_percentage`
    FROM 
        whr_2023 w23
    JOIN 
        whr_2024 w24
    ON 
        w23.country = w24.country
)
SELECT 
    country,
    score_2023,
    score_2024,
    `score_change_percentage`
FROM 
    HappinessChange
WHERE 
    `score_change_percentage` > 0
ORDER BY 
   `score_change_percentage` DESC;      

-- 16. COUNTRIES THAT HAVE DECLINED IN SCORE COMPARED TO 2023
with HappinessChange AS (
    select 
        w23.country,
        round(w23.happiness_score,2) AS score_2023,
        round(w24.happiness_score,2) AS score_2024,
		round(((w24.happiness_score - w23.happiness_score) / w23.happiness_score) * 100,2) AS `score_change_percentage`
    from 
        whr_2023 w23
    join 
        whr_2024 w24
    on 
        w23.country = w24.country
)
select 
    country,
    score_2023,
    score_2024,
    `score_change_percentage`
from 
    HappinessChange
where 
    `score_change_percentage` < 0
order by 
   `score_change_percentage` desc;    










 
 
