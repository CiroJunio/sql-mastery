SELECT truck_id AS ID,  
       critical_score AS SCORE,
    CASE 
        WHEN critical_score < 15 THEN 'CRITICAL'
        ELSE 'MONITOR'
    END AS SITUATION
FROM (
    SELECT
        truck_id,
        COALESCE(fuel_level, 0) + COALESCE(battery_voltage, 10) AS critical_score
        FROM truck_telemetry
) AS subquery_graxa
WHERE critical_score < 20
ORDER BY critical_score ASC
LIMIT 10;