--- 7) Top 3 drivers in each pickup city by total revenue (June 2021 – Dec 2024)
WITH driver_city_revenue AS (
  SELECT INITCAP(TRIM(r.pickup_city)) AS city,
         r.driver_id,
         SUM(p.amount) AS total_revenue
  FROM rides r
  JOIN payments p ON r.ride_id = p.ride_id
  WHERE p.amount > 0
    AND r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <  '2025-01-01'::timestamp
  GROUP BY INITCAP(TRIM(r.pickup_city)), r.driver_id
),
ranked AS (
  SELECT dcr.*,
         ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_revenue DESC) AS rn
  FROM driver_city_revenue dcr
)
SELECT r.city, r.rn, r.driver_id, dr.name AS driver_name, r.total_revenue
FROM ranked r
LEFT JOIN drivers dr ON r.driver_id = dr.driver_id
WHERE r.rn <= 3
ORDER BY r.city, r.rn;
