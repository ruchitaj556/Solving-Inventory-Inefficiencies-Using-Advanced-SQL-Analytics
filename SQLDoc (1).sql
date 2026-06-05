/* 
SOLVING INVENTORY INEFFICIENCIES USING SQL

SQL SCRIPTS AND DOCUMENTATION

TEAM: PLOTTWIST

Pooja Kumari                      240123047
Ruchita Satish Jadhav             240103092
Aanya Verma                       240103003

*/



create database sqlAnalysis;

use sqlAnalysis;

-- Creating the table

CREATE TABLE inventory_forecasting (
    Date DATE,
    Store_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Category VARCHAR(50),
    Region VARCHAR(50),
    Inventory_Level INT,
    Units_Sold INT,
    Units_Ordered INT,
    Demand_Forecast FLOAT,
    Price FLOAT,
    Discount INT,
    Weather_Condition VARCHAR(20),
    Holiday_Promotion BOOLEAN,
    Competitor_Pricing FLOAT,
    Seasonality VARCHAR(20)
);


-- Loading data from csv file

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory_forecasting.csv"
INTO TABLE inventory_forecasting
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE Product (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Category VARCHAR(20)
);


INSERT INTO Product (Product_ID, Category)
SELECT DISTINCT Product_ID, Category
FROM inventory_forecasting;


-- Creating tables for each region and store_id

-- west, S001

CREATE TABLE west1 (
  product_id VARCHAR(10) PRIMARY KEY,
  store_id VARCHAR(10),
  region VARCHAR(20),
  weekly_avg_sale FLOAT,
  weekly_avg_inventory FLOAT,
  inventory_turnover FLOAT,
  weekly_avg_forecast FLOAT,
  forecast_error FLOAT
);


INSERT INTO west1 (
  product_id,
  store_id,
  region,
  weekly_avg_sale,
  weekly_avg_inventory,
  inventory_turnover,
  weekly_avg_forecast,
  forecast_error
)
SELECT 
  product_id,

  store_id,

  region,

  -- Weekly average sale  
  ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

  -- Average inventory
  ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

  -- Inventory turnover
  ROUND(
    (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) / 
    NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
  ) AS inventory_turnover,

  -- Weekly forecast
  ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

  -- Forecast error
  ROUND(
    (SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) - 
    (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
  ) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S001' and Region='West'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE west1
ADD COLUMN stock_status VARCHAR(20);



UPDATE west1
JOIN (
  SELECT AVG(inventory_turnover) AS avg_turnover
  FROM west1
) AS stats
SET stock_status = 
  CASE
    WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
    WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
    ELSE 'Balanced'
  END;




-- west, S002


CREATE TABLE west2 (
  product_id VARCHAR(10) PRIMARY KEY,
  store_id VARCHAR(10),
  region VARCHAR(20),
  weekly_avg_sale FLOAT,
  weekly_avg_inventory FLOAT,
  inventory_turnover FLOAT,
  weekly_avg_forecast FLOAT,
  forecast_error FLOAT
);


INSERT INTO west2 (
  product_id,
  store_id,
  region,
  weekly_avg_sale,
  weekly_avg_inventory,
  inventory_turnover,
  weekly_avg_forecast,
  forecast_error
)
SELECT
  product_id,

  store_id,

  region,

-- Weekly average sale
  ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
  ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
  ROUND(
    (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
    NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
  ) AS inventory_turnover,

-- Weekly forecast
  ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
  ROUND(
    (SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
    (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
  ) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S002' and Region='West'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE west2
ADD COLUMN stock_status VARCHAR(20);



UPDATE west2
JOIN (
  SELECT AVG(inventory_turnover) AS avg_turnover
  FROM west2
) AS stats
SET stock_status =
  CASE
    WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
    WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
    ELSE 'Balanced'
  END;



-- west, S003

CREATE TABLE west3 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO west3 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
  (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
  NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
  (SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
  (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S003' and Region='West'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE west3
ADD COLUMN stock_status VARCHAR(20);



UPDATE west3
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM west3
) AS stats
SET stock_status =
CASE
  WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
  WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
  ELSE 'Balanced'
END;





-- west, S004


CREATE TABLE west4 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO west4 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S004' and Region='West'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE west4
ADD COLUMN stock_status VARCHAR(20);



UPDATE west4
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM west4
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;


-- west, S005



CREATE TABLE west5 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO west5 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S005' and Region='West'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE west5
ADD COLUMN stock_status VARCHAR(20);



UPDATE west5
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM west5
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- east, S001



CREATE TABLE east1 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO east1 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S001' and Region='East'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE east1
ADD COLUMN stock_status VARCHAR(20);



UPDATE east1
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM east1
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- east, S002


CREATE TABLE east2 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO east2 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S002' and Region='East'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE east2
ADD COLUMN stock_status VARCHAR(20);



UPDATE east2
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM east2
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;




-- east, S003



CREATE TABLE east3 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO east3 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S003' and Region='East'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE east3
ADD COLUMN stock_status VARCHAR(20);



UPDATE east3
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM east3
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- east, S004



CREATE TABLE east4 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO east4 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S004' and Region='East'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE east4
ADD COLUMN stock_status VARCHAR(20);



UPDATE east4
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM east4
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;




-- east, S005


CREATE TABLE east5 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO east5 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S005' and Region='East'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE east5
ADD COLUMN stock_status VARCHAR(20);



UPDATE east5
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM east5
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- north, S001


CREATE TABLE north1 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO north1 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S001' and Region='North'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE north1
ADD COLUMN stock_status VARCHAR(20);



UPDATE north1
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM north1
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- north, S002


CREATE TABLE north2 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO north2 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S002' and Region='North'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE north2
ADD COLUMN stock_status VARCHAR(20);



UPDATE north2
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM north2
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;




-- north, S003


CREATE TABLE north3 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO north3 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S003' and Region='North'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE north3
ADD COLUMN stock_status VARCHAR(20);



UPDATE north3
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM north3
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- north, S004


CREATE TABLE north4 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO north4 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S004' and Region='North'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE north4
ADD COLUMN stock_status VARCHAR(20);



UPDATE north4
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM north4
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;




-- north, S005


CREATE TABLE north5 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO north5 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S005' and Region='North'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE north5
ADD COLUMN stock_status VARCHAR(20);



UPDATE north5
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM north5
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;




-- south, S001


CREATE TABLE south1 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO south1 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S001' and Region='South'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE south1
ADD COLUMN stock_status VARCHAR(20);



UPDATE south1
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM south1
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- south, S002


CREATE TABLE south2 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO south2 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S002' and Region='South'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE south2
ADD COLUMN stock_status VARCHAR(20);



UPDATE south2
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM south2
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;



-- south, S003


CREATE TABLE south3 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO south3 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S003' and Region='South'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE south3
ADD COLUMN stock_status VARCHAR(20);



UPDATE south3
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM south3
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;





-- south, S004


CREATE TABLE south4 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO south4 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S004' and Region='South'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE south4
ADD COLUMN stock_status VARCHAR(20);



UPDATE south4
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM south4
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;





-- south, S005


CREATE TABLE south5 (
product_id VARCHAR(10) PRIMARY KEY,
store_id VARCHAR(10),
region VARCHAR(20),
weekly_avg_sale FLOAT,
weekly_avg_inventory FLOAT,
inventory_turnover FLOAT,
weekly_avg_forecast FLOAT,
forecast_error FLOAT
);


INSERT INTO south5 (
product_id,
store_id,
region,
weekly_avg_sale,
weekly_avg_inventory,
inventory_turnover,
weekly_avg_forecast,
forecast_error
)
SELECT
product_id,

store_id,

region,

-- Weekly average sale
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale,

-- Average inventory
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory,

-- Inventory turnover
ROUND(
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) /
NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover,

-- Weekly forecast
ROUND(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_forecast,

-- Forecast error
ROUND(
(SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) -
(SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error

FROM inventory_forecasting
WHERE Store_ID='S005' and Region='South'
GROUP BY product_id;




-- adding column stock_status
ALTER TABLE south5
ADD COLUMN stock_status VARCHAR(20);



UPDATE south5
JOIN (
SELECT AVG(inventory_turnover) AS avg_turnover
FROM south5
) AS stats
SET stock_status =
CASE
WHEN inventory_turnover > stats.avg_turnover + 0.01 THEN 'Understocked'
WHEN inventory_turnover < stats.avg_turnover - 0.01 THEN 'Overstocked'
ELSE 'Balanced'
END;





-- Competitive Pricing Positioning

SELECT 
    Category,
    AVG(Price * (1 - Discount/100)) AS our_effective_price,
    AVG(Competitor_Pricing) AS avg_competitor_price,
    CASE 
        WHEN AVG(Price * (1 - Discount/100)) < AVG(Competitor_Pricing) THEN 'Underpriced'
        WHEN AVG(Price * (1 - Discount/100)) > AVG(Competitor_Pricing) THEN 'Overpriced'
        ELSE 'Aligned'
    END AS pricing_position
FROM inventory_forecasting
GROUP BY Category;




-- Outlier Detection (High Discount/Low Sales)

SELECT FLOOR(COUNT(*) * 0.25) AS offset_value
FROM inventory_forecasting
WHERE Units_Sold IS NOT NULL;

SELECT Units_Sold
FROM inventory_forecasting
WHERE Units_Sold IS NOT NULL
ORDER BY Units_Sold
LIMIT 1 OFFSET 27375;  

SELECT 
  Product_ID,
  Discount,
  Category
  Units_Sold,
  Competitor_Pricing
FROM inventory_forecasting
WHERE Discount > 15
  AND Units_Sold < 71;

SELECT 
  Category,
  COUNT(*) AS entries_per_category
FROM inventory_forecasting
WHERE Discount > 15 AND Units_Sold < 71
GROUP BY Category
ORDER BY entries_per_category DESC;


