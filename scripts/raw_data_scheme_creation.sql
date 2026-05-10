DROP SCHEMA IF EXISTS "raw" CASCADE;
CREATE SCHEMA IF NOT EXISTS "raw";

DROP TABLE IF EXISTS "raw".orders;

CREATE TABLE "raw".orders (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(255),
    segment VARCHAR(50),
    city VARCHAR(100),
    "state" VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name TEXT,
    sales NUMERIC(15,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(15,2),
    shipping_cost NUMERIC(15,2),
    order_priority VARCHAR(20)
);
