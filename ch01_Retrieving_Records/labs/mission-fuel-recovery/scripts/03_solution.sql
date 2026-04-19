SELECT truck_id,  
       COALESCE(battery_voltage, 10) AS SCORE,
    CASE 
        WHEN fuel_level < 15 THEN 'CRITICAL'
        WHEN fuel_level > 15 THEN 'MONITORING'
        ELSE 'OK'
    END AS SITUATION
FROM truck_telemetry 
where COALESCE(fuel_level, 0) <= 20
LIMIT 5;


SELECT *
FROM truck_telemetry
