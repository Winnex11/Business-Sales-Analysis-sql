--- 2) How many riders who signed up in 2021 still took rides in 2024?
  WITH riders_2021 AS (
  SELECT rider_id
  FROM riders
  WHERE signup_date::date >= '2021-01-01'::date
    AND signup_date::date <  '2022-01-01'::date
),
riders_active_2024 AS (
  SELECT DISTINCT r.rider_id
  FROM rides r
  JOIN payments p ON r.ride_id = p.ride_id
  WHERE p.amount > 0
    AND r.pickup_time >= '2024-01-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
)
SELECT COUNT(*) AS riders_2021_who_ran_in_2024
FROM riders_2021 a
JOIN riders_active_2024 b ON a.rider_id = b.rider_id;