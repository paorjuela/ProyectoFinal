# Análisis del comercio global por internet

## Integrantes
- [Alberto Alessandro Gómez Blanno](https://github.com/alezzanders-ctrl) — Clave: 218823
- [María de Lourdes Gaul Vargas](https://github.com) — Clave: 218758
- [Paola María Orjuela Gaytán](https://github.com/paorjuela) — Clave: 216867

## Introducción 
### Fuente de datos
Para este proyecto se utilizan datos obtenidos de Kaggle, específicamente del conjunto [Global Super Store Dataset](https://www.kaggle.com/datasets/apoorvaappz/global-super-store-dataset/data). Este dataset fue recopilado en 2020 por Apoorva Mahalingappa, estudiante de Ciencia de Datos en el Great Lakes Institute of Management (India), con el propósito de analizar las compras en línea y extraer tendencias comerciales.


### Descripción general
El Dataset contiene información sobre miles de transacciones comerciales realizadas por usuarios a través de la red, entre el 1 de enero de 2011 y el 31 de diciembre de 2014. Incluye datos relevantes, como la información de los compradores, su lugar de residencia, los montos y detalles de los productos, etcétera.

El dataset es estático, pues tiene cierto carácter histórico, pero abarca un periodo de 4 años, lo que nos otorga una ventana de tiempo lo suficientemente amplia para identificar tendencias. Hay bastantes datos con los que se puede trabajar, además de que están relativamente en buena forma (i.e. no hay muchas inconsistencias), aunque hay renglones con datos faltantes (sobre todo en la columna "Postal Code"). 

### Características de los datos
El Dataset cuenta con 24 columnas (4 IDs) y aproximadamente 51.3K tuplas.

A continuación, se describen los datos y su tipo:

| Atributo | Tipo | ¿Qué es? |
| :--- | :--- | :--- |
| **Customer ID** | Texto | ID del comprador |
| **Order ID** | Texto | ID del pedido |
| **Product ID** | Texto | ID del producto |
| **Row ID** | Numérico | ID de la tupla |
| **Category** | Categórico | Categoría del producto |
| **City** | Categórico | Ciudad del comprador |
| **Country** | Categórico | País del comprador |
| **Customer Name** | Texto | Nombre del comprador |
| **Discount** | Numérico | Descuento aplicado a la venta |
| **Market** | Categórico | Región del mercado |
| **Order Date** | Temporal | Fecha del pedido |
| **Order Priority** | Categórico | Prioridad de envío |
| **Postal Code** | Numérico | Código postal del comprador |
| **Product Name** | Texto | Nombre del producto |
| **Profit** | Numérico | Ganancia por la venta |
| **Quantity** | Numérico | Cantidad del producto que se vendió |
| **Región** | Categórico | Región del mercado |
| **Sales** | Numérico | Monto transaccionado por la venta |
| **Segment** | Categórico | Tipo del comprador |
| **Ship Date** | Temporal | Fecha de envío |
| **Ship Mode** | Categórico | Forma de envío |
| **Shipping Cost** | Numérico | Costo de envío |
| **State** | Categórico | Estado (lugar) del comprador |
| **Sub-Category** | Categórico | Subcategoría del producto |

> **Nota:** Todos los datos de tipo "Categórico" y "Temporal" están almacenados como "Texto" en el Dataset.

### Objetivo del proyecto 
El objetivo principal de este proyecto es analizar un conjunto de datos para identificar patrones de comportamiento en el comercio electrónico a nivel global. Nuestro equipo busca identificar qué productos son los más rentables, qué regiones realizan más transacciones, los tiempos promedio de envío y los clientes más activos, simulando la toma de decisiones en un entorno empresarial.

### Consideraciones éticas 
* **Privacidad de los clientes:** Aunque es un dataset público y probablemente anónimo o sintético, incluye columnas como "Customer Name", que están vínculadas a ubicaciones geográficas (City, State, Postal Code). En un entorno real, exponer esta información implicaría violar la privacidad de los usuarios e infringir múltiples leyes.
* **Sesgos:** La mayoría de los datos corresponden a Estados Unidos, por lo que nuestro análisis tendrá cierto sesgo geográfico. En consecuencia, no se considerarán los patrones de compra de los mercados que no están representados en este dataset.

## Documentación

### Estructura del repositorio

```
├── README.md                                         <- Documentación para desarrolladores de este proyecto (i.e., reporte escrito)
├── .gitignore
├── scripts                                           <- Scripts de SQL para ejecución del pipeline de datos
│   ├── raw_data_scheme_creation.sql                  <- Script de carga inicial
│   ├── analisis_preliminar.sql                       <- Consultas de exploración para detectar nulos, inconsistencias en los IDs, etc.
│   ├── limpieza_y_normalizacion.sql                  <- Script de limpieza de datos y normalización de tablas
│   └── creacion_atributos_analiticos.sql             <- Script de creación de atributos analíticos y análisis de los datos normalizados
├── ERD.png                                           <- Entity-Relationship Diagram (diagrama entidad-relación)

```

### Requerimientos para replicación del proyecto

1. Descargar los datos en bruto del proyecto (véase [Fuente de datos](#fuente-de-datos)).
2. Contar con `postgres 17.5` o superior instalado en la computadora o en el servidor donde se replicará el proyecto.
3. Contar con una base de datos exclusiva para este proyecto. Todas las instrucciones del proyecto asumen que la sesión está conectada a la misma base de datos.
4. Crear el esquema `raw ` siguiendo las instrucciones de [Carga inicial](#carga-inicial).
5. Ejecuta las consultas de [Análisis preliminar](#análisis-preliminar).
6. Ejecuta el script dado en [Limpieza y normalización](#limpieza-de-datos-y-normalización-de-tablas).
7. Ejecuta las consultas de [Atributos analíticos](#atributos-analíticos).


## Carga inicial

En primer lugar, se deberá crear una base de datos exclusiva para este proyecto. Para ello se puede ejecutar el siguiente comando en `psql`:

```{psql}
CREATE DATABASE comercio_electronico;
```

Posteriormente, debemos conectarnos a dicha base de datos empleando:

```{psql}
\c comercio_electronico
```

Ahora, en nuestro IDE, ejecutamos el script [raw_data_scheme_creation.sql](/scripts/raw_data_scheme_creation.sql).

Finalmente, ejecutamos el siguiente comando en una sesión de línea de comandos `psql`, donde `ruta_csv` es la ruta donde descargamos el archivo con los datos en bruto:

```{psql}
\copy "raw".orders FROM 'ruta_csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```

## Análisis Preliminar

> **Nota:** Todas las consultas ejecutadas para este análisis se encuentran en el archivo [analisis_preliminar.sql](/scripts/analisis_preliminar.sql). Cada consulta está clasificada y nombrada según la observación correspondiente.

### Consulta `1` en `analisis_preliminar`
Se identificó que la columna `postal_code` contiene más de 40,000 valores `null`, lo que representa aproximadamente el 80% de las tuplas del dataset. Debido a esta falta de representatividad, clasificamos esta columna como redundante, ya que no aporta información relevante para un análisis más profundo.

### Consulta `2` en `analisis_preliminar`
A través del análisis de los valores máximos y mínimos en `order_date` y `ship_date`, sabemos que el dataset abarca un periodo de entre el 1 de enero de 2011 (primera orden) y el 7 de enero de 2015 (último envío registrado).

### Consultas `3` y `4` en `analisis_preliminar`
Ante la ausencia de una unidad de medida explícita en las columnas de costos y ganancias, se ha tomado el supuesto de que los montos están expresados en dólares (USD) para facilitar la interpretación de los resultados.
* Ventas totales: $12,642,507.25
* Ganancia total: $1,467,456.55
* Costo de envío total: $1,352,820.69
* Volumen de productos vendidos: 178,312 unidades.
> **Nota:** Debido a inconsistencias en la estructura de las claves primarias (detalladas en el punto 5), no es posible calcular promedios precisos por orden de compra en esta etapa.

### Consulta `5` en `analisis_preliminar`
En cuanto a atributos categóricos, hay varios, pero los interesantes son `category`, `order_priority`, `ship_mode` y `segment`:
- Hay tres tipos de productos: muebles, insumos de oficina y tecnología.
- Hay cuatro niveles de prioridad por orden: bajo, medio, alto y crítico.
- Hay cuatro modos de envío: clase estándar, segunda clase, primera clase y mismo día.
- Hay tres tipos de clientes: consumidor, corporativo y _home office_.

### Consulta `6` en `analisis_preliminar`
Por último, están los valores únicos: `order_id`, `product_id` y `customer_id`. Aquí es donde se presenta el problema (del que hablé antes) más grande del data set. A pesar de ser _id's_, no determinan funcionalmente los atributos que representan. `customer_id` es el único que no presenta problemas. `product_id` tiene más de 500 tuplas donde el _id_ es el mismo, pero el nombre del producto es diferente (y una con una subcategoría). El peor, sin embargo, es `order_id` donde presenta problemas en múltiples atributos, principalmente en  `order_date` y `customer_id`, donde más de 780 tuplas aparecen con el mismo _id_ pero fecha o cliente diferente. Da la impresión de que son órdenes completamente diferentes, pero asignadas al mismo _id_ por algún error.


## Limpieza de datos y normalización de tablas
El script para estas operaciones se encuentra en [limpieza-y-normalizacion.sql](/scripts/limpieza_y_normalizacion.sql).

Tras el análisis preliminar, se identificaron dos columnas redundantes, `row_id` y `postal_code`, cuya eliminación no supone una pérdida de información relevante. El problema detectado con la duplicidad de IDs (donde un mismo ID puede referirse a entidades distintas) se resuelve durante la normalización mediante la generación de claves artificiales.

A continuación, se describe el proceso de normalización.

El dataset tiene los siguientes atributos:
$E=\{\text{order-id, customer-id, order-date, city, state, country, market, region, order-priority, customer-name, segment, product-id, category, sub-category, product-name, ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}\}$

### Dependencias funcionales
Lo primero que uno haría intuitivamente es asumir que los _id's_ identifican de forma única a cada entidad, por lo que las $\text{DF}$ "ideales" serían:
 
$$\{\text{order-id}\}\rightarrow\{\text{customer-id, order-date, city, state, country, market, region, order-priority}\}$$
$$\{\text{customer-id}\}\rightarrow\{\text{customer-name, segment}\}$$
$$\{\text{product-id}\}\rightarrow\{\text{category, sub-category, product-name}\}$$
$$\{\text{order-id, product-id}\}\rightarrow\{\text{ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}\}$$
 
El problema es que ninguna de las dos primeras se cumple realmente en el dataset. Como se vio en el **análisis preliminar**, el mismo `order-id` puede corresponder a clientes distintos, y el mismo `product-id` puede corresponder a productos distintos.

Para encontrar $\text{DF}$ que sí se sostengan, hay que mover atributos al lado izquierdo hasta tener algo que funcione como super llave:
$$\{\text{order-id, customer-id, order-date}\}\rightarrow\{\text{city, state, country, market, region, order-priority}\}$$
$$\{\text{customer-id}\}\rightarrow\{\text{customer-name, segment}\}$$
$$\{\text{product-id, product-name}\}\rightarrow\{\text{category, sub-category}\}$$
$$\{\text{order-id, customer-id, order-date, product-id, product-name}\}\rightarrow\{\text{ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}\}$$

Sin embargo, al verificar la primera contra el dataset aparece otro problema: $\{\text{city, state, country}\}\rightarrow\{\text{market, region}\}$ es una $\text{DF}$ que vive dentro de $E_{order}$, y como $\{\text{city, state, country}\}$ no es super llave de esa relvar, esto viola la **FNBC**.

Además, se encontraron 348 filas de Austria y Mongolia con clasificaciones de mercado inconsistentes (`EU`/`EMEA` y `APAC`/`EMEA` respectivamente), que corresponden a un error de captura en el dataset original. Para corregirlo se conservó el valor mayoritario por ciudad.

El conjunto de $\text{DF}$ que finalmente se verifica en el dataset es:
$$\{\text{order-id, customer-id, order-date}\}\rightarrow\{\text{city, state, country, order-priority}\}$$
$$\{\text{city, state, country}\}\rightarrow\{\text{market, region}\}$$
$$\{\text{customer-id}\}\rightarrow\{\text{customer-name, segment}\}$$
$$\{\text{product-id, product-name}\}\rightarrow\{\text{category, sub-category}\}$$
$$\{\text{order-id, customer-id, order-date, product-id, product-name}\}\rightarrow\{\text{ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}\}$$


### Forma normal Boyce-Codd (FNBC)
Cada $\text{DF}$ da lugar a una relvar distinta, por lo que $E$ se descompone en **cinco** $\text{Relvars}$:
$$E_{customer}=\text{customer-id, customer-name, segment}$$
$$E_{product}=\text{product-id, product-name, category, sub-category}$$
$$E_{order}=\text{order-id, customer-id, order-date, city, state, country, order-priority}$$
$$E_{geography}=\text{city, state, country, market, region}$$
$$E_{order\text{-}product}=\text{order-id, customer-id, order-date, product-id, product-name, ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}$$

En cada una de estas relvars, el lado izquierdo de su $\text{DF}$ es superclave, así, la descomposición cumple la **FNBC**.
 
Para implementarlo en SQL, las claves naturales se reemplazan por ids artificiales (`BIGSERIAL`): 
| Clave natural | Identificador artificial |
|---|---|
| `customer-id` | `customer-id'` |
| `(product-id, product-name)` | `product-id'` |
| `(city, state, country)` | `geography-id'` |
| `(order-id, customer-id, order-date)` | `order-id'` |
| `(order-id', product-id')` | `order-product-id'` |
 
Con esto, los encabezados finales quedan:
$$E_{customer}=\text{customer-id', customer-name, segment}$$
$$E_{product}=\text{product-id', category, sub-category}$$
$$E_{geography}=\text{geography-id', market, region}$$
$$E_{order}=\text{order-id', customer-id', geography-id', order-priority}$$
$$E_{order\text{-}product}=\text{order-product-id', order-id', product-id', ship-date, ship-mode, shipping-cost, sales, quantity, discount, profit}$$

### Explicación de operaciones no triviales
El script de normalización parte de la tabla `raw.orders`, y construye el esquema `norm` tabla por tabla. El patrón que se repite en cada bloque es siempre el mismo: crear la nueva tabla, poblarla con los valores únicos de `raw.orders`, agregar una columna auxiliar `*_id_alt` en `raw.orders` que apunte al nuevo `id` generado, actualizar esa columna con un `UPDATE` y, finalmente, eliminar las columnas que ya migraron. A continuación se explican en detalle las operaciones no triviales.
 
#### `SELECT DISTINCT`
```sql
INSERT INTO norm.customer (customer_id, customer_name, segment)
    SELECT DISTINCT customer_id, customer_name, segment
    FROM raw.orders;
```
En la tabla `raw.orders` cada producto comprado genera una fila. Eso significa que un mismo cliente se repite tantas veces como productos haya comprado. `DISTINCT` colapsa todas esas repeticiones y se queda con una sola fila por combinación única de atributos. Sin esto se insertarían miles de duplicados.
 
#### `UPDATE` con subconsulta
```sql
UPDATE raw.orders
SET customer_id_alt = (
    SELECT norm.customer.id
    FROM norm.customer
    WHERE norm.customer.customer_id = raw.orders.customer_id
)
WHERE raw.orders.customer_id_alt IS NULL;
```
Una vez que `norm.customer` tiene sus propios `id`'s autogenerados, por cada fila de `raw.orders`, busca en `norm.customer` el `id` cuyo `customer_id` coincida. Ponemos `WHERE customer_id_alt IS NULL` para evitar sobreescribir filas que ya estuvieran actualizadas (por si el script se corriera parcialmente).
Este mismo patrón se repite para `product`, `geography` y `order`, adaptando las columnas según la clave natural de cada tabla.

#### `DISTINCT ON` con `GROUP BY` y `ORDER BY COUNT(*) DESC`
```sql
INSERT INTO norm.geography (city, state, country, market, region)
SELECT DISTINCT ON (city, state, country)
    city, state, country, market, region
FROM raw.orders
GROUP BY city, state, country, market, region
ORDER BY city, state, country, COUNT(*) DESC;
```
El problema es que 348 filas de Austria y Mongolia tienen dos valores distintos de `(market, region)` para la misma ciudad, lo que hace que un `SELECT DISTINCT` devuelva múltiples filas por ciudad y rompa el `UNIQUE (city, state, country)` de `norm.geography`.
 
Nuestra solución fue:
- `GROUP BY city, state, country, market, region` agrupa por la combinación completa para poder contar cuántas filas respaldan cada par de `(market, region)`.
- `ORDER BY city, state, country, COUNT(*) DESC` ordena los resultados poniendo primero, dentro de cada ciudad, el par `(market, region)` más frecuente.
El resultado es que cada ciudad queda asociada a un único `(market, region)` que corresponde al valor más común en los datos, descartando la clasificación minoritaria, que se consideró como un error de captura.
 
#### `DROP COLUMN` de la clave natural
```sql
ALTER TABLE norm.customer DROP COLUMN customer_id;
```
Después de que `raw.orders` ya apunta al `id` artificial, el `customer_id` de texto en `norm.customer` deja de ser necesario como columna, pues su función era servir de puente durante la migración. Eliminarlo evita redundancia y deja la tabla con únicamente los atributos que le corresponden según la $\text{DF}$.
 
---
Después de ejecutar el script [limpieza-y-normalizacion.sql](/scripts/limpieza_y_normalizacion.sql), se tiene el esquema `norm`:

![ERD](/ERD.png)

## Atributos analíticos
> El código de esta sección se encuentra en [creacion_atributos_analiticos.sql](/scripts/creacion_atributos_analiticos.sql).

El objetivo de este análisis es identificar patrones de rentabilidad, comportamiento de clientes y eficiencia logística a partir de los datos normalizados. Para ello se construyeron atributos enriquecidos mediante agrupaciones, filtros, composiciones y funciones de ventana sobre el esquema `norm`.

---

### 1. Tendencia anual de ventas y rentabilidad
 
La primera pregunta que nos hacemos es si el negocio está creciendo y si ese crecimiento es rentable.
 
| Año | Órdenes | Ventas totales | Ganancia total | Margen |
|---|---|---|---|---|
| 2011 | 4,516 | $2,259,451.64 | $248,940.41 | 11.02% |
| 2012 | 5,480 | $2,677,439.91 | $307,415.3 | 11.48% |
| 2013 | 6,890 | $3,405,748.03 | $406,934.84 | 11.95% |
| 2014 | 8,868 | $4,299,867.67 | $504,166 | 11.73% |
 
**Hallazgo:** Las ventas crecieron un 90% entre 2011 y 2014, y el volumen de órdenes casi se duplicó. El margen se mantuvo estable alrededor del 11–12%, lo que indica que el crecimiento no se logró a costa de la rentabilidad. La leve caída de margen en 2014 (11.95% → 11.73%) podría ser señal de presión competitiva o de mayor uso de descuentos.
 
---

### 2. Rentabilidad por subcategoría
 
Para decidir en qué productos enfocarse (o dejar de invertir), calculamos el margen por subcategoría.
 
| Categoría | Subcategoría | Pedidos | Ventas | Ganancia | Margen (%) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Office Supplies | Paper | 3,238 | $244,291.85 | $59,207.25 | 24.24% |
| Office Supplies | Labels | 2,465 | $73,404.31 | $15,010.35 | 20.45% |
| Office Supplies | Envelopes | 2,318 | $170,904.37 | $29,600.85 | 17.32% |
| Technology | Accessories | 2,893 | $749,237.28 | $129,626.44 | 17.30% |
| Technology | Copiers | 2,125 | $1,509,436.51 | $258,567.62 | 17.13% |
| Office Supplies | Binders | 5,438 | $461,912.20 | $72,449.60 | 15.68% |
| Office Supplies | Art | 4,411 | $372,092.52 | $57,953.92 | 15.58% |
| Office Supplies | Appliances | 1,689 | $1,011,064.54 | $141,680.65 | 14.01% |
| Office Supplies | Fasteners | 2,307 | $83,242.47 | $11,525.25 | 13.85% |
| Technology | Phones | 3,141 | $1,706,824.65 | $216,717.49 | 12.70% |
| Furniture | Furnishings | 2,971 | $385,578.44 | $46,967.55 | 12.18% |
| Furniture | Bookcases | 2,285 | $1,466,572.55 | $161,924.32 | 11.04% |
| Office Supplies | Storage | 4,574 | $1,127,086.68 | $108,461.74 | 9.62% |
| Furniture | Chairs | 3,199 | $1,501,682.16 | $140,396.24 | 9.35% |
| Office Supplies | Supplies | 2,292 | $243,074.23 | $22,583.13 | 9.29% |
| Technology | Machines | 1,426 | $779,060.32 | $58,867.70 | 7.56% |
| Furniture | Tables | 836 | $757,042.17 | -$64,083.55 | -8.46% |
 
**Hallazgo:** `Tables` es la única subcategoría con margen **negativo** (-8.46%), generando pérdidas de $64K sobre $757K en ventas. Por el otro lado, `Paper`, `Labels` y `Copiers` son las subcategorías más rentables. En la categoría `Technology`, sus subcategorías `Copiers` y `Accessories` son muy rentables, mientras que `Machines` apenas supera el 7%.
 
---
 
### 3. Rentabilidad por región
 
¿Dónde está el dinero geográficamente?
 
| Mercado | Región | Pedidos | Ventas Totales | Ganancia Total | Margen (%) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| EU | Central | 2,995 | $1,731,871.47 | $218,416.90 | 12.61% |
| APAC | Oceania | 1,744 | $1,100,185.69 | $120,089.63 | 10.92% |
| APAC | Southeast Asia | 1,517 | $884,423.95 | $17,852.36 | 2.02% |
| APAC | North Asia | 1,149 | $848,269.78 | $165,595.18 | 19.52% |
| EMEA | EMEA | 2,511 | $794,884.11 | $40,997.74 | 5.16% |
| Africa | Africa | 2,289 | $783,773.37 | $88,871.13 | 11.34% |
| APAC | Central Asia | 1,026 | $752,826.94 | $132,479.89 | 17.60% |
| US | West | 1,611 | $725,457.93 | $108,418.79 | 14.94% |
| US | East | 1,401 | $678,781.36 | $91,522.84 | 13.48% |
| EU | North | 1,107 | $625,575.75 | $91,779.15 | 14.67% |
| LATAM | North | 1,329 | $622,590.78 | $102,818.26 | 16.51% |
| LATAM | South | 1,460 | $617,223.64 | $28,090.48 | 4.55% |
| LATAM | Central | 1,504 | $600,510.01 | $56,163.55 | 9.35% |
| EU | South | 1,053 | $591,961.63 | $65,515.75 | 11.07% |
| US | Central | 1,175 | $501,239.88 | $39,706.45 | 7.92% |
| US | South | 822 | $391,721.90 | $46,749.71 | 11.93% |
| LATAM | Caribbean | 856 | $324,280.89 | $34,571.35 | 10.66% |
| Canada | Canada | 205 | $66,928.17 | $17,817.39 | 26.62% |
 
**Hallazgo:** EU Central es el mercado más grande en ventas, pero no el más rentable. Canada tiene el margen más alto (26.62%), aunque con un volumen muy pequeño. APAC North Asia y Central Asia combinan volumen considerable con márgenes superiores al 17%, lo que los posiciona como mercados clave de crecimiento. EMEA y LATAM South son los de menor rentabilidad proporcional, lo que sugiere revisar la estrategia de precios o descuentos en esas regiones.
 
---
 
### 4. Rentabilidad por segmento de cliente
 
| Segmento | Pedidos | Ventas Totales | Ganancia Total | Margen (%) | Ticket Promedio |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Home Office | 4,717 | $2,309,855.98 | $277,009.28 | 11.99% | $489.69 |
| Corporate | 7,732 | $3,824,698.96 | $441,208.09 | 11.54% | $494.66 |
| Consumer | 13,305 | $6,507,952.31 | $749,239.18 | 11.51% | $489.14 |
 
**Hallazgo:** Los tres segmentos tienen márgenes prácticamente idénticos (~11.5–12%), lo que indica que la estrategia de precios es consistente entre tipos de cliente. El segmento `Consumer` domina en volumen (más del doble de órdenes que `Corporate`), pero `Home Office` logra el margen marginalmente más alto. El ticket promedio es casi igual en los tres, lo que sugiere que no hay diferenciación real de precios por segmento.
 
---
 
### 5. Clientes más valiosos (por ganancia generada)
 
Identificar a los clientes más valiosos para estrategias de retención.
 
| ID Cliente | Segmento | Pedidos | Ventas Totales | Ganancia Total | Rank en Segmento |
| :--- | :--- | :---: | :---: | :---: | :---: |
| 108 | Corporate | 28 | $34,218.28 | $8,787.48 | 1 |
| 285 | Consumer | 25 | $29,197.65 | $8,523.95 | 1 |
| 1292 | Consumer | 28 | $25,602.62 | $8,106.22 | 2 |
| 427 | Home Office | 37 | $27,158.02 | $7,790.71 | 1 |
| 629 | Consumer | 20 | $29,664.26 | $7,657.50 | 3 |
| 656 | Consumer | 33 | $22,966.79 | $6,912.60 | 4 |
| 1585 | Consumer | 28 | $28,124.21 | $6,649.63 | 5 |
| 753 | Corporate | 37 | $27,434.18 | $6,544.86 | 2 |
| 1482 | Home Office | 25 | $35,668.14 | $6,275.02 | 2 |
| 1104 | Consumer | 36 | $29,532.63 | $5,863.62 | 6 |
 
**Hallazgo:** Algunos clientes tienen márgenes superiores al 50%, lo que sugiere que compran productos de alto margen con pocos descuentos. 
 
---

### 6. Clientes que dejan mayores pérdidas

En un entorno empresarial, valdría la pena revisar los casos con mayor déficit acumulado. Identificar estos perfiles serviría para tomar decisiones estratégicas, como revisar políticas de descuento o la optimización de rutas logísticas para reducir costos operativos.

| ID Cliente | Segmento | Pedidos | Ventas Totales | Ganancia Total | Rank en Segmento |
| :--- | :--- | :---: | :---: | :---: | :---: |
| 531 | Consumer | 16 | $11,535.27 | -$6,437.34 | 818 |
| 1541 | Corporate | 6 | $4,998.43 | -$5,474.60 | 476 |
| 360 | Corporate | 20 | $19,080.36 | -$3,790.10 | 475 |
| 1357 | Consumer | 22 | $12,864.77 | -$3,700.18 | 817 |
| 102 | Home Office | 7 | $6,851.93 | -$2,991.61 | 296 |
| 476 | Consumer | 9 | $3,475.77 | -$2,891.34 | 816 |
| 471 | Corporate | 23 | $14,362.81 | -$2,881.66 | 474 |
| 1452 | Corporate | 6 | $3,914.95 | -$2,601.41 | 473 |
| 646 | Home Office | 19 | $12,721.26 | -$2,544.71 | 295 |
| 365 | Home Office | 25 | $12,738.72 | -$2,527.14 | 294 |

---
 
### 7. Eficiencia logística por modo de envío
 
| Modo de Envío | Días Promedio | Días Mínimo | Días Máximo | Gasto Total Envío | Margen (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Same Day | 0.04 | 0 | 1 | $115,974.06 | 11.42% |
| First Class | 2.18 | 1 | 3 | $308,103.25 | 11.37% |
| Second Class | 3.23 | 2 | 5 | $314,112.62 | 11.40% |
| Standard Class | 5.00 | 4 | 7 | $614,630.76 | 11.75% |
 
**Hallazgo:** El margen es casi igual en todos los modos de envío (~11.4–11.75%), lo que sugiere que el costo de envío se transfiere al cliente de forma consistente. `Standard Class` concentra el 60% de las órdenes y es marginalmente el más rentable. `Same Day` tiene el menor volumen pero no penaliza el margen, lo que sugiere que su sobrecosto se recupera por el precio. El tiempo de envío es bastante predecible dentro de cada modo.
 
---
 
### 8. Productos más rentables
 
Para identificar los mejores productos dentro de cada categoría:
 
| Categoría | Producto | Ganancia Total | Margen (%) | Rank en Categoría |
| :--- | :--- | :---: | :---: | :---: |
| **Furniture** | Sauder Classic Bookcase, Traditional | $10,672.06 | 27.29% | 1 |
| **Furniture** | Harbour Creations Executive Leather Armchair, Adjustable | $10,427.33 | 20.80% | 2 |
| **Furniture** | SAFCO Executive Leather Armchair, Black | $7,154.28 | 17.07% | 3 |
| **Office Supplies** | Hoover Stove, Red | $11,807.96 | 37.29% | 1 |
| **Office Supplies** | Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind | $7,753.06 | 28.24% | 2 |
| **Office Supplies** | Rogers Lockers, Single Width | $6,755.20 | 32.96% | 3 |
| **Technology** | Canon imageCLASS 2200 Advanced Copier | $25,199.94 | 40.91% | 1 |
| **Technology** | Cisco Smart Phone, Full Size | $17,238.52 | 22.55% | 2 |
| **Technology** | Motorola Smart Phone, Full Size | $17,027.14 | 23.28% | 3 |
 
**Hallazgo:** El `Canon imageCLASS 2200 Advanced Copier` es el producto más rentable de todo el catálogo, generando $25K de ganancia con un margen de casi 41%. En `Office Supplies`, las estufas Hoover dominan en rentabilidad con márgenes superiores al 37%. En `Furniture`, los libros y sillas de oficina lideran, pero con márgenes más modestos (20–29%) en comparación con las otras categorías.
 
