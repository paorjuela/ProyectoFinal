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
* **Sesgos:** La mayoría de los datos corresponden a Estados Unidos, por lo que nuestro análisis tendrá cierto sesgo geográfico. En consecuencia, no se considerarán los patrones de compra en los mercados que no están representados en este dataset.

## Documentación

### Estructura del repositorio

```
├── README.md                                         <- Documentación para desarrolladores de este proyecto (i.e., reporte escrito)

```

### Requerimientos para replicación del proyecto

1. Descargar los datos en bruto del proyecto (véase [Fuente de datos](#fuente-de-datos)).
2. Contar con `postgres 17.5` o superior instalado en la computadora o en el servidor donde se replicará el proyecto.
3. Contar con una base de datos exclusiva para este proyecto. Todas las instrucciones del proyecto asumen que la sesión está conectada a la misma base de datos.
4. ...
5. El resto de las instrucciones asume que el directorio de trabajo de `psql` es la raíz de este proyecto.


## Carga inicial

En primer lugar, se deberá crear una base de datos exclusiva para este proyecto. Para ello se puede ejecutar el siguiente 
comando en `psql`:

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
\copy raw.orders FROM 'ruta_csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```


## Análisis Preliminar

> **Nota:** Todas las consultas utilizadas para este análisis preliminar están en el archivo [analisis_preliminar.sql](https://github.com/paorjuela/analisis-comercio-electronico/blob/limpieza-datos/analisis_preliminar.sql). Cada consulta está clasificada y nombrada según la observación.

Lo primero que se puede observar es que la columna de `postal_code` esta conformada por más de 40k `null`, lo que supone un 80% de las tuplas del data set. Así, podemos clasificas a esta columna como redundante y no aportaría información alguna a un análisis más profundo.
Consulta `1` en `analisis_preliminar`.

A través de los máximos y mínimos de las fechas `order_date` y `ship_date` podemos confirmar que el data set abarca un periodo de entre el 1 de enero del 2011 (primera orden) y el 7 de enero del 2015 (último envío).
Consulta `2` en `analisis_preliminar`.

Lo primero que notamos al analisar las ganancias y los costos es la falta de una moneda como forma de medida. Para efectos de facilitar el análisis (y porque es la moneda más probable) vamos a suponer que los precios están en dólares.

Así, podemos observar (a través de las columnas `sales`, `profit` y `shipping_cost`) que las ventas totales, la ganancia total y el costo de envio total es de 12,642,507.25$, 1,467,456.55$ y 1,352,820.69$ respectivamente. La razón por la que no se puede analisar el promedio por orden es por un error en los datos del que hablaré al final.
Consulta `3` en `analisis_preliminar`.

Además, el total de productos vendidos (a través de la columna `quantity`) es de 178,312 productos. En cuanto el promedio por orden, no se puede calcular por el mismo error del que hablé antes.
Consulta `4` en `analisis_preliminar`.

En cuanto a atributos categóricos, hay varios, pero los interesantes son `category`, `order_priority`, `ship_mode` y `segment`:
- Hay tres tipos de productos: muebles, insumos de oficina y tacnología.
- Hay cuatro niveles de prioridad por orden: bajo, medio, alto y crítico.
- Hay cuatro modos de envío: clase estandar, segunda clase, primera clase y mismo día.
- Hay tres tipos de clientes: consumidor, corporativo y _home office_.

Consulta `5` en `analisis_preliminar`.

Por último, están los valores únicos: `order_id`, `product_id` y `customer_id`. Aquí es donde se presenta el problema (del que hable antes) más grande del data set. A pesar de ser _id's_, no determinan funcionalmente los atributos que representan. `customer_id` es el único que no presenta problemas. `product_id` tiene más de 500 tuplas donde el _id_ es el mismo, pero el nombre del producto es diferente (y una con una sub categoría). El peor, sin embargo, es `order_id` donde presenta problemas en multiples atributos, principalmente en  `order_date` y `customer_id`, donde más de 780 tuplas aparecen con el mismo _id_ pero fecha o cliente diferente. Da la impresión de que son ordenes completamente diferentes, pero asignadas al mismo _id_ por algún error.
Consulta `6` en `analisis_preliminar`.


## Limpieza de datos

Gracias al análisis preliminar, se puede observar que el data set está en su mayoría limpio. Sin embargo, es cierto que presenta dos columnas redudantes (`row_id` y `postal_code`), las cuales podemos eliminar sin perdida de datos relevantes para el análisis futuro. En cuanto el problema con los _id's_, eso se va a resolver durante el proceso de normalización (donde sustituiremos los _id's_ originales con los artificiales generados al separar las tablas).

El código para limpiar el data set esta en [limpieza.sql](https://github.com/paorjuela/analisis-comercio-electronico/blob/limpieza-datos/limpieza.sql).


## Normalización de tablas
Con el encabezado

$E=\{\text{order-id, customer-id, order-date, city, state, country, market, region, order-priority, customer-name, segment, product-id, category, sub-category, product-name, ship-date, ship-mode, shipping-cost, sales, cuantity, discount, profit}\}$

intuitivamente (o idealmente) las dependencias funcionales encontradas en el data set son,

$$\{\text{order-id}\}\rightarrow\{\text{customer-id, order-date, city, state, country, market, region, order-priority}\}$$
$$\{\text{customer-id}\}\rightarrow\{\text{customer-name, segment}\}$$
$$\{\text{product-id}\}\rightarrow\{\text{category, sub-category, product-name}\}$$
$$\{\text{order-id, product-id}\}\rightarrow\{\text{ship-date, ship-mode, shipping-cost, sales, cuantity, discount, profit}\}$$

Sin embargo, la realidad es que estás no se cumplen debido al error en los _id's_ que se comentó en la sección de **análisis preliminar**. Si movemos algunos de los elementos de la derecha a la izquierda, podemos encontrar $\text{DF}$ que sí se cumplan en el data set y no afecten a la separación de tablas:

$$\{\text{order-id, customer-id, order-date}\}\rightarrow\{\text{city, state, country, market, region, order-priority}\}$$
$$\{\text{customer-id}\}\rightarrow\{\text{customer-name, segment}\}$$
$$\{\text{product-id, product-name}\}\rightarrow\{\text{category, sub-category}\}$$
$$\{\text{order-id, customer-id, order-date, product-id, product-name, shipping-cost}\}\rightarrow\{\text{ship-date, ship-mode, sales, cuantity, discount, profit}\}$$


### Forma normal Boyce-Codd (FNBC)
Gracias a estás nuevas dependencias funcionales podemos separar $E$ en cuatro $\text{Relvars}$ nuevas.

$$E_{order}=\text{order-id, customer-id, order-date, city, state, country, market, region, order-priority}$$
$$E_{customer}=\text{customer-id, customer-name, segment}$$
$$E_{product}=\text{product-id, product-name, category, sub-category}$$
$$E_{order-product}=\text{order-id, customer-id, order-date, product-id, product-name, shipping-cost, ship-date, ship-mode, sales, cuantity, discount, profit}$$

Si consideramos los _id's_ artificiales de `sql` y los definimos como

$$\text{order-id'}=\text{order-id, customer-id, order-date}$$
$$\text{customer-id'}=\text{customer-id}$$
$$\text{product-id'}=\text{product-id, product-name}$$
$$\text{order-product-id'}=\text{order-id', product-id', shipping-cost}$$

obtenemos (finalmente) los encabezados

$$E_{order}=\text{order-id', customer-id', order-date, city, state, country, market, region, order-priority}$$
$$E_{customer}=\text{customer-id', customer-name, segment}$$
$$E_{product}=\text{product-id', product-name, category, sub-category}$$
$$E_{order-product}=\text{order-product-id', order-id', product-id', shipping-cost, ship-date, ship-mode, sales, cuantity, discount, profit}$$

El esquema_erd que representa estas $\text{Relvars}$ está en [esquema_erd_fnbc.jpeg](https://github.com/paorjuela/analisis-comercio-electronico/blob/normalizacion-tablas/esquema_erd_fnbc.jpeg).
