--- 8) Top 10 drivers eligible for bonuses 
WITH completed AS (
  SELECT r.driver_id,
         COUNT(*) AS completed_rides
  FROM rides r
  JOIN payments p ON r.ride_id = p.ride_id
  WHERE p.amount > 0
    AND r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
  GROUP BY r.driver_id
),
driver_cancels AS (
  SELECT driver_id,
         COUNT(*) FILTER (WHERE lower(trim(status)) = 'cancelled') AS cancelled_count,
         COUNT(*) AS total_rides
  FROM rides
  WHERE pickup_time >= '2021-06-01'::timestamp
    AND pickup_time <  '2025-01-01'::timestamp
  GROUP BY driver_id
),
metrics AS (
  SELECT c.driver_id,
         c.completed_rides,
         COALESCE(dc.cancelled_count,0) AS cancelled_count,
         COALESCE(dc.total_rides,0) AS total_rides,
         (COALESCE(dc.cancelled_count,0)::numeric / NULLIF(COALESCE(dc.total_rides,0),0)) * 100 AS cancel_rate_pct
  FROM completed c
  LEFT JOIN driver_cancels dc ON c.driver_id = dc.driver_id
)
SELECT m.driver_id,
       d.name AS driver_name,
       m.completed_rides,
       d.rating AS avg_rating,
       ROUND(m.cancel_rate_pct,2) AS cancellation_rate_pct
FROM metrics m
LEFT JOIN drivers d ON m.driver_id = d.driver_id
WHERE m.completed_rides >= 30
  AND COALESCE(d.rating,0) >= 4.5
  AND m.cancel_rate_pct < 5
ORDER BY m.completed_rides DESC
LIMIT 10;