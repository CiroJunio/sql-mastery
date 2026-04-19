SELECT truck_id, driver_name, COALESCE(fuel_level, 0) AS fuel_level, 
                              COALESCE(battery_voltage, 10) AS battery_voltage
FROM truck_telemetry limit 5
where fuel_level <= 20


SELECT *
FROM truck_telemetry
