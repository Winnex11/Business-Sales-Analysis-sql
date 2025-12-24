--- 6) Riders who have taken >10 rides but never paid with cash

WITH rider_payments AS (
  SELECT r.rider_id,
         COUNT(*) AS rides_count,
         BOOL_OR(lower(coalesce(p.method,'')) = 'cash') AS ever_paid_cash
  FROM rides r
  JOIN payments p ON r.ride_id = p.ride_id
  WHERE p.amount > 0
    AND r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
  GROUP BY r.rider_id
)
SELECT rp.rider_id,
       u.name AS rider_name,
       rp.rides_count
FROM rider_payments rp
LEFT JOIN riders u ON rp.rider_id = u.rider_id
WHERE rp.rides_count > 10
  AND rp.ever_paid_cash = false
ORDER BY rp.rides_count DESC;
