--E) Análisis de datos mediante consultas

-- 1era consulta
-- Ventas anuales y rentabilidad
-- Para ver cuánto dinero entra y cuánto queda de ganancia cada año
SELECT
    EXTRACT(YEAR FROM ordenes.order_date) AS anio,
    COUNT(DISTINCT ordenes.id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    ROUND(SUM(detalles.profit) / SUM(detalles.sales) * 100, 2) AS margen_porcentual --el margen de ganancia porcentual
FROM norm.order_product AS detalles
JOIN norm."order" AS ordenes ON detalles.order_id = ordenes.id
GROUP BY anio
ORDER BY anio;

-- 2da consulta
-- Rentabilidad por categoría de producto
-- Para identificar qué tipos de productos dejan más margen
SELECT
    productos.category AS categoria,
    productos.sub_category AS subcategoria,
    COUNT(DISTINCT detalles.order_id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    ROUND(SUM(detalles.profit) / SUM(detalles.sales) * 100, 2) AS margen_porcentual
FROM norm.order_product AS detalles
JOIN norm.product AS productos ON detalles.product_id = productos.id
GROUP BY categoria, subcategoria
ORDER BY margen_porcentual DESC;

-- 3era consulta
-- Análisis de mercados y regiones
SELECT
    geografia.market AS mercado,
    geografia.region AS region,
    COUNT(DISTINCT ordenes.id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    ROUND(SUM(detalles.profit) / SUM(detalles.sales) * 100, 2) AS margen_porcentual
FROM norm.order_product AS detalles
JOIN norm."order" AS ordenes ON detalles.order_id = ordenes.id
JOIN norm.geography AS geografia ON ordenes.geography_id = geografia.id
GROUP BY mercado, region
ORDER BY ventas_totales DESC;

-- 4ta consulta
-- Análisis de segmentos de clientes
SELECT
    clientes.segment AS segmento,
    COUNT(DISTINCT ordenes.id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    ROUND(SUM(detalles.profit) / SUM(detalles.sales) * 100, 2) AS margen_porcentual,
    ROUND(SUM(detalles.sales) / COUNT(DISTINCT ordenes.id), 2) AS valor_pedido_promedio
FROM norm.order_product AS detalles
JOIN norm."order" AS ordenes ON detalles.order_id = ordenes.id
JOIN norm.customer AS clientes ON ordenes.customer_id = clientes.id
GROUP BY segmento
ORDER BY margen_porcentual DESC;

-- 5ta consulta
-- "Mejores" clientes por segmento
SELECT
    clientes.id AS id_cliente,
    clientes.segment AS segmento,
    COUNT(DISTINCT ordenes.id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    -- Ranking de rentabilidad dentro de cada segmento de mercado
    RANK() OVER (
        PARTITION BY clientes.segment
        ORDER BY SUM(detalles.profit) DESC
    ) AS ranking_en_segmento
FROM norm.order_product AS detalles
JOIN norm."order" AS ordenes ON detalles.order_id = ordenes.id
JOIN norm.customer AS clientes ON ordenes.customer_id = clientes.id
GROUP BY clientes.id, segmento
ORDER BY ganancia_total DESC
LIMIT 10;

-- 6ta consulta
-- "Peores" clientes por segmento
SELECT
    clientes.id AS id_cliente,
    clientes.segment AS segmento,
    COUNT(DISTINCT ordenes.id) AS total_pedidos,
    ROUND(SUM(detalles.sales)::NUMERIC, 2) AS ventas_totales,
    ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
    -- Ranking de rentabilidad dentro de cada segmento de mercado
    RANK() OVER (
        PARTITION BY clientes.segment
        ORDER BY SUM(detalles.profit) DESC
    ) AS ranking_en_segmento
FROM norm.order_product AS detalles
JOIN norm."order" AS ordenes ON detalles.order_id = ordenes.id
JOIN norm.customer AS clientes ON ordenes.customer_id = clientes.id
GROUP BY clientes.id, segmento
ORDER BY ganancia_total ASC
LIMIT 10;

-- 7ma consulta
-- "Mejores" tipos de envío
-- Cuánto se tarda en enviar? y cuánto cuesta según el tipo de envío?
SELECT
    ventas.ship_mode AS metodo_envio,
    ROUND(AVG(ventas.ship_date - pedidos.order_date), 2) AS promedio_dias_envio,
    MIN(ventas.ship_date - pedidos.order_date) AS dias_minimo,
    MAX(ventas.ship_date - pedidos.order_date) AS dias_maximo,
    ROUND(SUM(ventas.shipping_cost)::NUMERIC, 2) AS gasto_total_envio,
    ROUND(SUM(ventas.profit) / SUM(ventas.sales) * 100, 2) AS margen_porcentual
FROM norm.order_product AS ventas
JOIN norm."order" AS pedidos ON ventas.order_id = pedidos.id
GROUP BY metodo_envio
ORDER BY promedio_dias_envio;

--8va consulta
-- top 3 productos más rentables por categoria
WITH ProductosCalculados AS (
    SELECT
        productos.category AS categoria,
        productos.product_name AS nombre_producto,
        ROUND(SUM(detalles.profit)::NUMERIC, 2) AS ganancia_total,
        ROUND(SUM(detalles.profit) / SUM(detalles.sales) * 100, 2) AS margen_porcentual,

        RANK() OVER (
            PARTITION BY productos.category
            ORDER BY SUM(detalles.profit) DESC
        ) AS posicion

    FROM norm.order_product AS detalles
    JOIN norm.product AS productos ON detalles.product_id = productos.id
    GROUP BY productos.category, productos.product_name
)
SELECT
    categoria,
    nombre_producto,
    ganancia_total,
    margen_porcentual,
    posicion AS rank_en_categoria
FROM ProductosCalculados
WHERE posicion <= 3
ORDER BY categoria, posicion;
