-- 4) The top 5 drivers average monthly rides since signup

WITH driver_monthly AS (
  SELECT r.driver_id,
         DATE_TRUNC('month', r.pickup_time)::date AS month_start,
         COUNT(*) AS rides_in_month
  FROM rides r
  JOIN payments p ON r.ride_id = p.ride_id
  WHERE p.amount > 0
    AND r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
  GROUP BY r.driver_id, DATE_TRUNC('month', r.pickup_time)
),
driver_activity AS (
  SELECT driver_id,
         COUNT(*) AS active_months,
         SUM(rides_in_month) AS total_rides
  FROM driver_monthly
  GROUP BY driver_id
)
SELECT da.driver_id,
       d.name AS driver_name,
       da.total_rides,
       da.active_months,
       ROUND((da.total_rides::numeric / NULLIF(da.active_months,0)), 2) AS avg_rides_per_active_month
FROM driver_activity da
LEFT JOIN drivers d ON da.driver_id = d.driver_id
ORDER BY avg_rides_per_active_month DESC
LIMIT 5;
