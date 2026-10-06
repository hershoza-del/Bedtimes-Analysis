SELECT * FROM data.bedtimes2_ascii LIMIT 10;

SELECT user_id, occupation_type FROM data.bedtimes2_ascii LIMIT 10;

SELECT user_id, age, chronotype, bedtime_phone_minutes FROM data.bedtimes2_ascii
WHERE age BETWEEN 20 AND 29 LIMIT 10;

SELECT user_id, age, occupation_type, total_sleep_hours FROM data.bedtimes2_ascii
ORDER BY total_sleep_hours DESC LIMIT 50;

SELECT DISTINCT caffeine_band FROM data.bedtimes2_ascii;
SELECT COUNT(*) FROM data.bedtimes2_ascii WHERE caffeine_band = "0 mg";

SELECT ROUND(AVG(caffeine_post_5pm_mg), 2) FROM data.bedtimes2_ascii;

SELECT occupation_type, COUNT(*) AS number_of_people
FROM data.bedtimes2_ascii
GROUP BY occupation_type
HAVING COUNT(*) > 1000;

SELECT user_id, total_sleep_hours,
CASE
WHEN total_sleep_hours < 5 THEN "Not enough sleep"
WHEN total_sleep_hours BETWEEN 6 AND 7 THEN "Somewhat okay sleep"
ELSE "Good amount of sleep"
END AS sleep_category
FROM data.bedtimes2_ascii LIMIT 50;

WITH category AS (
SELECT occupation_type, COUNT(*) AS number_of_people
FROM data.bedtimes2_ascii
GROUP BY occupation_type
)
SELECT * FROM category

SELECT user_id, chronotype, bedtime_phone_minutes,
RANK() OVER (
PARTITION BY chronotype
ORDER BY bedtime_phone_minutes DESC
) AS rank_category
FROM data.bedtimes2_ascii;
