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
│   ├── analisis_preliminar.sql                       <- 
│   ├── limpieza_y_normalizacion.sql                  <- Script de limpieza de datos y normalización de relaciones
│   └── creacion_atributos_analiticos.sql             <- Script de creación de atributos analíticos
├── ERD.png                                           <- Entity-Relationship Diagram

```

### Requerimientos para replicación del proyecto

1. Descargar los datos en bruto del proyecto (véase [Fuente de datos](#fuente-de-datos)).
2. Contar con `postgres 17.5` o superior instalado en la computadora o en el servidor donde se replicará el proyecto.
3. Contar con una base de datos exclusiva para este proyecto. Todas las instrucciones del proyecto asumen que la sesión está conectada a la misma base de datos.
4. ...
5. El resto de las instrucciones asume que el directorio de trabajo de `psql` es la raíz de este proyecto.


## Carga inicial

En primer lugar, se deberá crear una base de datos exclusiva para este proyecto. Para ello se puede ejecutar el siguiente comando en `psql`:

```{psql}
CREATE DATABASE comercio_electronico;
```

Posteriormente, debemos conectarnos a dicha base de datos empleando:

```{psql}
\c comercio_electronico
```

Ahora, en nuestro IDE, ejecutamos el script [raw_data_scheme_creation.sql](https://github.com/paorjuela/analisis-comercio-electronico/blob/carga-datos/raw_data_scheme_creation.sql).

Finalmente, ejecutamos el siguiente comando en una sesión de línea de comandos `psql`, donde `ruta_csv` es la ruta donde descargamos el archivo con los datos en bruto:

```{psql}
\copy "raw".orders FROM 'ruta_csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```


## Análisis Preliminar

> **Nota:** Todas las consultas ejecutadas para este análisis se encuentran en el archivo [analisis_preliminar.sql](https://github.com/paorjuela/analisis-comercio-electronico/blob/limpieza-datos/analisis_preliminar.sql). Cada consulta está clasificada y nombrada según la observación correspondiente.

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
El script para estas operaciones se encuentra en [limpieza-y-normalizacion.sql](https://github.com/paorjuela/analisis-comercio-electronico/blob/limpieza-datos/analisis_preliminar.sql).

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

### Implementación SQL
El script de normalización parte de la tabla `raw.orders` y construye el esquema `norm` tabla por tabla. El patrón que se repite en cada bloque es siempre el mismo: crear la nueva tabla, poblarla con los valores únicos de `raw.orders`, agregar una columna auxiliar `*_id_alt` en `raw.orders` que apunte al nuevo `id` generado, actualizar esa columna con un `UPDATE` y, finalmente, eliminar las columnas que ya migraron. A continuación se explican las operaciones no triviales.
 
#### `SELECT DISTINCT`
```sql
INSERT INTO norm.customer (customer_id, customer_name, segment)
    SELECT DISTINCT customer_id, customer_name, segment
    FROM raw.orders;
```
 
En la tabla `raw.orders` cada producto comprado genera una fila. Eso significa que un mismo cliente aparece repetido en tantas filas como productos haya comprado. `DISTINCT` colapsa todas esas repeticiones y se queda con una sola fila por combinación única de atributos. Sin esto se insertarían miles de duplicados.
 
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
 
El problema es que 348 filas de Austria y Mongolia tienen dos valores distintos de `(market, region)` para la misma ciudad, lo que hace que un `SELECT DISTINCT` normal devuelva múltiples filas por ciudad y rompa el `UNIQUE (city, state, country)` de `norm.geography`.
 
Nuestra solución fue:
- `GROUP BY city, state, country, market, region` agrupa por la combinación completa para poder contar cuántas filas respaldan cada par `(market, region)`.
- `ORDER BY city, state, country, COUNT(*) DESC` ordena los resultados poniendo primero, dentro de cada ciudad, el par `(market, region)` más frecuente.
El resultado es que cada ciudad queda asociada a un único `(market, region)` que corresponde al valor más común en los datos, descartando la clasificación minoritaria, que se consideró como un error de captura.
 
#### `DROP COLUMN` de la clave natural
 
```sql
ALTER TABLE norm.customer DROP COLUMN customer_id;
```
 
Después de que `raw.orders` ya apunta al `id` artificial, el `customer_id` de texto en `norm.customer` deja de ser necesario como columna, pues su función era servir de puente durante la migración. Eliminarlo evita redundancia y deja la tabla con únicamente los atributos que le corresponden según la $\text{DF}$.
 
---

El esquema ERD que representa estas $\text{Relvars}$ en forma de tablas está en [esquema_erd_fnbc.jpeg](https://github.com/paorjuela/analisis-comercio-electronico/blob/normalizacion-tablas/esquema_erd_fnbc.jpeg).

