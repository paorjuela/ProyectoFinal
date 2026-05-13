SELECT *
FROM "raw".orders;

/*Consulta 1: Conteo y observación de nulls en la columna postal_code.*/--------------------------------

SELECT postal_code
FROM "raw".orders;

SELECT COUNT(postal_code)
FROM "raw".orders;


/*Consulta 2: Máximos y mínimos de fechas.*/------------------------------------------------------------

--máximos y mínimos de la fecha de oreden.
SELECT MAX(order_date)
FROM "raw".orders;

SELECT MIN(order_date)
FROM "raw".orders;

--máximos y mínimos de la fecha de envío.
SELECT MAX(ship_date)
FROM "raw".orders;

SELECT MIN(ship_date)
FROM "raw".orders;


/*Consulta 3: Promedios de costos y ganancias.*/--------------------------------------------------------

--promedio de ingresos.
SELECT SUM(sales)
FROM "raw".orders;

--promedio de ganancia.
SELECT SUM(profit)
FROM "raw".orders;

--promedio de costo de envio.
SELECT SUM(shipping_cost)
FROM "raw".orders;


/*Consulta 4: Total de productos vendidos.*/------------------------------------------------------------

SELECT SUM(quantity)
FROM "raw".orders;


/*Consulta 5: Datos categoricos.*/----------------------------------------------------------------------

--categorias de producto.
SELECT DISTINCT(category)
FROM "raw".orders
ORDER BY category;

SELECT DISTINCT(sub_category)
FROM "raw".orders
ORDER BY sub_category;

--categorias de localización.
SELECT DISTINCT(country)
FROM "raw".orders
ORDER BY country;

SELECT DISTINCT("state")
FROM "raw".orders
ORDER BY "state";

SELECT DISTINCT(city)
FROM "raw".orders
ORDER BY city;

SELECT DISTINCT(market)
FROM "raw".orders
ORDER BY market;

SELECT DISTINCT(region)
FROM "raw".orders
ORDER BY region;

--categorias de orden.
SELECT DISTINCT(order_priority)
FROM "raw".orders
ORDER BY order_priority;

--categorias de envío.
SELECT DISTINCT(ship_mode)
FROM "raw".orders
ORDER BY ship_mode;

--categorias de cliente.
SELECT DISTINCT(segment)
FROM "raw".orders
ORDER BY segment;


/*Consulta 6: Valores únicos.*/-------------------------------------------------------------------------

--dependencia funcional en cutomer_id (se cumple si no aparece nada).
WITH unicos AS (
	SELECT DISTINCT customer_id,
		   customer_name,
		   segment
	FROM "raw".orders
	ORDER BY customer_id
)
SELECT *
FROM unicos AS t1
JOIN unicos AS t2 ON t1.customer_id = t2.customer_id
	              AND (t1.customer_name != t2.customer_name
	              OR t1.segment != t2.segment);

--dependencia funcional en product_id (se cumple si no aparece nada).
WITH unicos AS (
	SELECT DISTINCT product_id,
		   category,
		   sub_category,
		   product_name
	FROM "raw".orders
	ORDER BY product_id
)
SELECT *
FROM unicos AS t1
JOIN unicos AS t2 ON t1.product_id = t2.product_id
	              AND (t1.category != t2.category
	              OR t1.sub_category != t2.sub_category
	              OR t1.product_name != t2.product_name);

--dependencia funcional en order_id (se cumple si no aparece nada).
WITH unicos AS (
	SELECT DISTINCT order_id,
		   order_date,
		   customer_id
	FROM "raw".orders
	ORDER BY order_id
)
SELECT *
FROM unicos AS t1
JOIN unicos AS t2 ON t1.order_id = t2.order_id
	              AND (t1.order_date != t2.order_date
	              OR t1.customer_id != t2.customer_id);
