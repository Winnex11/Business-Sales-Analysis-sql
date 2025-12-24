--- 5) Cancellation rate per city; which city has the highest cancellation rate?
SELECT city, cancelled_count, total_rides,
       ROUND((cancelled_count::numeric / NULLIF(total_rides,0)) * 100, 2) AS cancellation_rate_pct
FROM (
  SELECT INITCAP(TRIM(r.pickup_city)) AS city,
         COUNT(*) FILTER (WHERE lower(trim(r.status)) = 'cancelled')::int AS cancelled_count,
         COUNT(*)::int AS total_rides
  FROM rides r
  WHERE r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
  GROUP BY 1
) t
ORDER BY cancellation_rate_pct DESC
LIMIT 10;
