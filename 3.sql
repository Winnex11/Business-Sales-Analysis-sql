--- 3) Quarterly revenue between 2021, 2022, 2023, and 2024. 
SELECT EXTRACT(YEAR FROM r.request_time)::INT AS year,
EXTRACT(QUARTER FROM r.request_time)::INT AS quarter,
SUM(r.fare) AS total_revenue
FROM rides r
GROUP BY year, quarter
ORDER BY year, quarter;