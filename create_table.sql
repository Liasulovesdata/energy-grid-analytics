CREATE DATABASE energy_grid_analytics_and_data_modeling;

CREATE TABLE facilities (
    facility_id INT PRIMARY KEY,
    facility_name VARCHAR(50),
    region VARCHAR(50),
    facility_type VARCHAR(50)
);
INSERT INTO facilities (facility_id, facility_name, region, facility_type) VALUES
(1, 'Lagos HQ', 'South West', 'Office'),
(2, 'Ibadan Warehouse', 'South West', 'Logistics'),
(3, 'Abuja Branch', 'North Central', 'Office'),
(4, 'Kano Plant', 'North West', 'Manufacturing');



CREATE TABLE grid_pricing (
    reading_date DATE PRIMARY KEY,
    price_per_kwh DECIMAL(5,2)
);
INSERT INTO grid_pricing (reading_date, price_per_kwh) VALUES
('2024-01-01', 65.50), ('2024-01-02', 68.00), ('2024-01-03', 70.20),
('2024-01-04', 69.00), ('2024-01-05', 65.00), ('2024-01-06', 64.50),
('2024-01-07', 66.00);



CREATE TABLE daily_readings (
    reading_id INT PRIMARY KEY,
    facility_id INT,
    reading_date DATE,
    grid_power_kwh DECIMAL(10,2),
    solar_power_kwh DECIMAL(10,2)
);
INSERT INTO daily_readings (reading_id, facility_id, reading_date, grid_power_kwh, solar_power_kwh) VALUES
(101, 1, '2024-01-01', 450.5, 120.0), (102, 1, '2024-01-02', 480.0, 110.5), (103, 1, '2024-01-03', 440.2, 130.0),
(104, 2, '2024-01-01', 800.0, 0.0),   (105, 2, '2024-01-02', 820.5, 0.0),   (106, 2, '2024-01-03', 790.0, 0.0),
(107, 3, '2024-01-01', 300.0, 200.0), (108, 3, '2024-01-02', 310.0, 190.0), (109, 3, '2024-01-03', 290.0, 210.0),
(110, 4, '2024-01-01', 1500.0, 50.0), (111, 4, '2024-01-02', 1550.0, 45.0), (112, 4, '2024-01-03', 1480.0, 60.0),
(113, 1, '2024-01-04', 460.0, 115.0), (114, 1, '2024-01-05', 470.0, 100.0), (115, 1, '2024-01-06', 455.0, 125.0),
(116, 1, '2024-01-07', 430.0, 140.0);













