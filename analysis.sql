-- ============================================================
-- Energy Grid Analytics & Data Modeling
-- ============================================================

-- Phase 1: Foundational Analytics

-- Task 1: Total Consumption
SELECT 
    fc.facility_id, 
    fc.facility_name,
    SUM(grid_power_kwh) AS total_grid_power_consumption,
    SUM(solar_power_kwh) AS total_solar_power_consumption
FROM facilities AS fc
INNER JOIN daily_readings AS d
    ON fc.facility_id = d.facility_id
GROUP BY fc.facility_id, fc.facility_name;


-- Task 2: Top Consumer
SELECT
    f.facility_name,
    SUM(grid_power_kwh + solar_power_kwh) AS total_energy_consumed
FROM daily_readings AS d
INNER JOIN facilities AS f
    ON d.facility_id = f.facility_id
GROUP BY f.facility_id
ORDER BY total_energy_consumed DESC
LIMIT 1;


-- Task 3: Solar Efficiency (corrected order of operations)
-- Original bug: SUM(solar) / ROUND(SUM(solar+grid)*100,2) divided by (total * 100)
-- Fix: divide solar by total, then multiply by 100
SELECT
    f.facility_id,
    f.facility_name,
    ROUND(
        SUM(solar_power_kwh) / SUM(solar_power_kwh + grid_power_kwh) * 100,
    2) AS solar_efficiency_pct
FROM facilities AS f
INNER JOIN daily_readings AS d
    ON f.facility_id = d.facility_id
GROUP BY f.facility_id, f.facility_name
ORDER BY solar_efficiency_pct DESC;


-- Phase 2: Advanced Analytics (CTEs & Window Functions)

-- Task 4: Financial Cost
WITH temp_table AS (   
    SELECT 
        d.facility_id,
        d.reading_date,
        d.grid_power_kwh,
        g.price_per_kwh
    FROM daily_readings AS d
    INNER JOIN grid_pricing AS g
        ON d.reading_date = g.reading_date
)
SELECT 
    facility_id,
    reading_date,
    ROUND(SUM(grid_power_kwh * price_per_kwh), 2) AS total_grid_cost
FROM temp_table
GROUP BY facility_id, reading_date
ORDER BY total_grid_cost DESC;


-- Task 5: Rolling Average (3-day, Lagos HQ only)
SELECT
    reading_date,
    facility_id,
    grid_power_kwh,
    AVG(grid_power_kwh) OVER (
        PARTITION BY facility_id
        ORDER BY reading_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_3_day
FROM daily_readings
WHERE facility_id = 1
ORDER BY reading_date;


-- Phase 3: Data Engineering (Modeling)

-- Task 6: Reporting View for BI team
CREATE VIEW vw_daily_energy_financials AS 
SELECT 
    d.reading_date,
    f.facility_name,
    f.region,
    (grid_power_kwh + solar_power_kwh) AS total_energy_kwh,
    (grid_power_kwh * price_per_kwh) AS grid_cost_naira,
    CASE
        WHEN solar_power_kwh > 0 THEN 'YES'
        ELSE 'NO' 
    END AS is_solar_active
FROM daily_readings AS d
INNER JOIN facilities AS f
    ON d.facility_id = f.facility_id
INNER JOIN grid_pricing AS g
    ON d.reading_date = g.reading_date;

SELECT * FROM vw_daily_energy_financials;
