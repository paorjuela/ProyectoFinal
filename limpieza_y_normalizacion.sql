ALTER TABLE "raw".orders DROP COLUMN postal_code;
ALTER TABLE "raw".orders DROP COLUMN row_id;

--DROP SCHEMA IF EXISTS norm CASCADE;
CREATE SCHEMA IF NOT EXISTS norm;

--crear tabla customer
--DROP TABLE IF EXISTS norm.customer;
CREATE TABLE norm.customer (
	id BIGSERIAL PRIMARY KEY,
	customer_id VARCHAR(50),
	customer_name VARCHAR(255),
    	segment VARCHAR(50),

	CONSTRAINT unique_customer_id UNIQUE (customer_id)
);

--poblar tabla de customer
INSERT INTO norm.customer (customer_id, customer_name, segment)
	SELECT DISTINCT customer_id, customer_name, segment
	FROM "raw".orders;

--crear atributo customer_id_alt
ALTER TABLE "raw".orders ADD COLUMN customer_id_alt BIGINT;
ALTER TABLE "raw".orders ADD FOREIGN KEY (customer_id_alt) REFERENCES norm.customer(id);

UPDATE "raw".orders
SET customer_id_alt = (
	SELECT norm.customer.id
	FROM norm.customer
	WHERE norm.customer.customer_id = "raw".orders.customer_id
)
WHERE "raw".orders.customer_id_alt IS NULL;

--borrar atributo raw.orders.customer_id
ALTER TABLE "raw".orders DROP COLUMN customer_id;
--borrar atributo raw.orders.customer_name
ALTER TABLE "raw".orders DROP COLUMN customer_name;
--borrar atributo raw.orders.segment
ALTER TABLE "raw".orders DROP COLUMN segment;

--borrar atributo norm.customer.customer_id
ALTER TABLE norm.customer DROP COLUMN customer_id;

--actualizo el nombre customer_id_alt a customer_id
ALTER TABLE "raw".orders RENAME COLUMN customer_id_alt TO customer_id;

/*
SELECT *
FROM raw.orders;

SELECT *
FROM norm.customer;

SELECT raw.orders.*,
	   norm.customer.*
FROM raw.orders
JOIN norm.customer ON raw.orders.customer_id = norm.customer.id;*/


--crear tabla product
--DROP TABLE IF EXISTS norm.product;
CREATE TABLE norm.product (
	id BIGSERIAL PRIMARY KEY,
	product_id VARCHAR(50),
	category VARCHAR(100),
    	sub_category VARCHAR(100),
    	product_name TEXT,

	CONSTRAINT unique_product_id_product_name UNIQUE (product_id, product_name)
);

--poblar tabla de product
INSERT INTO norm.product (product_id, category, sub_category, product_name)
	SELECT DISTINCT product_id, category, sub_category, product_name
	FROM "raw".orders;

--crear atributo product_id_alt
ALTER TABLE "raw".orders ADD COLUMN product_id_alt BIGINT;
ALTER TABLE "raw".orders ADD FOREIGN KEY (product_id_alt) REFERENCES norm.product(id);

UPDATE "raw".orders
SET product_id_alt = (
	SELECT norm.product.id
	FROM norm.product
	WHERE norm.product.product_id = "raw".orders.product_id
		  AND norm.product.product_name = "raw".orders.product_name
)
WHERE "raw".orders.product_id_alt IS NULL;


--borrar atributo raw.orders.product_id
ALTER TABLE "raw".orders DROP COLUMN product_id;
--borrar atributo raw.orders.category
ALTER TABLE "raw".orders DROP COLUMN category;
--borrar atributo raw.orders.sub_category
ALTER TABLE "raw".orders DROP COLUMN sub_category;
--borrar atributo raw.orders.product_name
ALTER TABLE "raw".orders DROP COLUMN product_name;

--borrar atributo norm.product.product_id
ALTER TABLE norm.product DROP COLUMN product_id;

--actualizo el nombre product_id_alt a product_id
ALTER TABLE "raw".orders RENAME COLUMN product_id_alt TO product_id;

/*
SELECT *
FROM raw.orders;

SELECT *
FROM norm.product;

SELECT raw.orders.*,
	   norm.product.*
FROM raw.orders
JOIN norm.product ON raw.orders.product_id = norm.product.id;

WITH unicos AS (
SELECT DISTINCT product_id_alt,
	   category,
	   sub_category,
	   product_name
FROM raw.orders
ORDER BY product_id_alt
)
SELECT *
FROM unicos AS t1
JOIN unicos AS t2 ON t1.product_id_alt = t2.product_id_alt
			  	AND (t1.category != t2.category
			  	OR t1.sub_category != t2.sub_category
			  	OR t1.product_name != t2.product_name);*/


-- geography se crea antes que order porque order referencia geography_id
--crear tabla geography
--DROP TABLE IF EXISTS norm.geography;
CREATE TABLE norm.geography (
	id BIGSERIAL PRIMARY KEY,
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	market VARCHAR(50),
	region VARCHAR(50),

	CONSTRAINT unique_city_state_country UNIQUE (city, state, country)
);

--poblar tabla de geography
--se toma el (market, region) mas frecuente por (city, state, country)
--para corregir las 348 filas sucias de Austria y Mongolia
INSERT INTO norm.geography (city, state, country, market, region)
SELECT DISTINCT ON (city, state, country)
	city, state, country, market, region
FROM "raw".orders
GROUP BY city, state, country, market, region
ORDER BY city, state, country, COUNT(*) DESC;

--crear atributo geography_id_alt
ALTER TABLE "raw".orders ADD COLUMN geography_id_alt BIGINT;
ALTER TABLE "raw".orders ADD FOREIGN KEY (geography_id_alt) REFERENCES norm.geography(id);

UPDATE "raw".orders
SET geography_id_alt = (
	SELECT norm.geography.id
	FROM norm.geography
	WHERE norm.geography.city = "raw".orders.city
	  AND norm.geography.state = "raw".orders.state
	  AND norm.geography.country = "raw".orders.country
)
WHERE "raw".orders.geography_id_alt IS NULL;

--borrar atributo raw.orders.city
ALTER TABLE "raw".orders DROP COLUMN city;
--borrar atributo raw.orders.state
ALTER TABLE "raw".orders DROP COLUMN state;
--borrar atributo raw.orders.country
ALTER TABLE "raw".orders DROP COLUMN country;
--borrar atributo raw.orders.market
ALTER TABLE "raw".orders DROP COLUMN market;
--borrar atributo raw.orders.region
ALTER TABLE "raw".orders DROP COLUMN region;

--actualizo el nombre geography_id_alt a geography_id
ALTER TABLE "raw".orders RENAME COLUMN geography_id_alt TO geography_id;

/*
SELECT *
FROM raw.orders;

SELECT *
FROM norm.geography;

SELECT raw.orders.*,
	   norm.geography.*
FROM raw.orders
JOIN norm.geography ON raw.orders.geography_id = norm.geography.id;*/


--crear tabla order
--DROP TABLE IF EXISTS norm."order";
CREATE TABLE norm."order" (
	id BIGSERIAL PRIMARY KEY,
	order_id VARCHAR(50),
	customer_id BIGINT,
    	order_date DATE,
    	geography_id BIGINT, -- reemplaza city, state, country, market, region
    	order_priority VARCHAR(20),

	FOREIGN KEY (customer_id)  REFERENCES norm.customer(id)  ON DELETE RESTRICT,
	FOREIGN KEY (geography_id) REFERENCES norm.geography(id) ON DELETE RESTRICT,

	CONSTRAINT unique_order_id_customer_id_order_date UNIQUE (order_id, customer_id, order_date)
);

--poblar tabla order
INSERT INTO norm."order" (order_id, customer_id, order_date, geography_id, order_priority)
	SELECT DISTINCT order_id, customer_id, order_date, geography_id, order_priority
	FROM "raw".orders;

--crear atributo order_id_alt
ALTER TABLE "raw".orders ADD COLUMN order_id_alt BIGINT;
ALTER TABLE "raw".orders ADD FOREIGN KEY (order_id_alt) REFERENCES norm."order"(id);

UPDATE "raw".orders
SET order_id_alt = (
	SELECT norm."order".id
	FROM norm."order"
	WHERE norm."order".order_id = "raw".orders.order_id
		  AND norm."order".customer_id = "raw".orders.customer_id
		  AND norm."order".order_date  = "raw".orders.order_date
)
WHERE "raw".orders.order_id_alt IS NULL;


--borrar atributo raw.orders.order_id
ALTER TABLE "raw".orders DROP COLUMN order_id;
--borrar atributo raw.orders.customer_id
ALTER TABLE "raw".orders DROP COLUMN customer_id;
--borrar atributo raw.orders.order_date
ALTER TABLE "raw".orders DROP COLUMN order_date;
--borrar atributo raw.orders.geography_id
ALTER TABLE "raw".orders DROP COLUMN geography_id;
--borrar atributo raw.orders.order_priority
ALTER TABLE "raw".orders DROP COLUMN order_priority;

--borrar atributo norm."order".order_id
ALTER TABLE norm."order" DROP COLUMN order_id;

--actualizo el nombre order_id_alt a order_id
ALTER TABLE "raw".orders RENAME COLUMN order_id_alt TO order_id;

/*
SELECT *
FROM raw.orders;

SELECT *
FROM norm."order";

SELECT raw.orders.*,
	   norm."order".*
FROM raw.orders
JOIN norm."order" ON raw.orders.order_id = norm."order".id;

WITH unicos AS (
SELECT DISTINCT order_id_alt, customer_id, order_date, geography_id, order_priority
FROM raw.orders
ORDER BY order_id_alt
)
SELECT *
FROM unicos AS t1
JOIN unicos AS t2 ON t1.order_id_alt = t2.order_id_alt
			  	AND (t1.customer_id != t2.customer_id
			  	OR t1.order_date != t2.order_date
			  	OR t1.geography_id != t2.geography_id
			  	OR t1.order_priority != t2.order_priority
);*/


--crear tabla order_product
--DROP TABLE IF EXISTS norm.order_product;
CREATE TABLE norm.order_product (
	id BIGSERIAL PRIMARY KEY,
	order_id BIGINT,
	product_id BIGINT,
	ship_date DATE,
	ship_mode VARCHAR(50),
    	shipping_cost NUMERIC(15,2),
    	sales NUMERIC(15,2),
    	quantity INT,
    	discount NUMERIC(5,2),
    	profit NUMERIC(15,2),

    	FOREIGN KEY (order_id)   REFERENCES norm."order"(id)  ON DELETE RESTRICT,
    	FOREIGN KEY (product_id) REFERENCES norm.product(id)  ON DELETE RESTRICT,

	-- shipping_cost es una metrica, no parte de la clave natural
	CONSTRAINT unique_order_id_product_id UNIQUE (order_id, product_id)
);

--poblar tabla order_product
INSERT INTO norm.order_product (order_id, product_id, ship_date, ship_mode, shipping_cost, sales, quantity, discount, profit)
	SELECT DISTINCT order_id, product_id, ship_date, ship_mode, shipping_cost, sales, quantity, discount, profit
	FROM "raw".orders;

--borrar atributo raw.orders.order_id
ALTER TABLE "raw".orders DROP COLUMN order_id;
--borrar atributo raw.orders.product_id
ALTER TABLE "raw".orders DROP COLUMN product_id;
--borrar atributo raw.orders.ship_date
ALTER TABLE "raw".orders DROP COLUMN ship_date;
--borrar atributo raw.orders.ship_mode
ALTER TABLE "raw".orders DROP COLUMN ship_mode;
--borrar atributo raw.orders.ahipping_cost
ALTER TABLE "raw".orders DROP COLUMN shipping_cost;
--borrar atributo raw.orders.sales
ALTER TABLE "raw".orders DROP COLUMN sales;
--borrar atributo raw.orders.quantity
ALTER TABLE "raw".orders DROP COLUMN quantity;
--borrar atributo raw.orders.discount
ALTER TABLE "raw".orders DROP COLUMN discount;
--borrar atributo raw.orders.profit
ALTER TABLE "raw".orders DROP COLUMN profit;

/*
SELECT *
FROM raw.orders;

SELECT *
FROM norm.order_product;*/


DROP TABLE IF EXISTS "raw".orders;


/*
SELECT *
FROM norm.customer;

SELECT *
FROM norm.product;

SELECT *
FROM norm.geography;

SELECT *
FROM norm."order";

SELECT *
FROM norm.order_product;
*/