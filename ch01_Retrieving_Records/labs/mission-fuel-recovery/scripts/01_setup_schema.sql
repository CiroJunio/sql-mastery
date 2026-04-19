-- 01_setup_schema.sql
CREATE TABLE truck_telemetry (
    truck_id INTEGER PRIMARY KEY,
    driver_name VARCHAR(50),
    fuel_level INTEGER,          
    battery_voltage DECIMAL(4,2), 
    temp_cabin INTEGER,          
    tire_pressure_1 INTEGER,     
    tire_pressure_2 INTEGER,     
    last_oil_change DATE,        
    extra_sensor_data TEXT       
);