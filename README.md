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

### Carga inicial de postgres:
  1. Clonar repositorio:
     git clone https://github.com/paorjuela/analisis-comercio-electronico
      cd analisis-comercio-electronico
  2. Crear base de datos:
     DROP DATABASE IF EXISTS superstore;
     CREATE DATABASE superstore;
     \c superstore
  3. Cargar la tabla raw y el CSV
     \i raw_data_scheme_creation.sql

     *nota:* antes de ejecutar el script, se tiene que cambair la ruta a la ubicación local:
             \copy orders FROM '/ruta/a/Global_Superstore2.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
  5. Ejecutar los scripts en orden:
     \i scripts/02_analisis_exploratorio.sql
     \i scripts/03_limpieza.sql
     \i scripts/04_normalizacion.sql
     \i scripts/05_analisis.sql

### Carga Inicial y ánalisis preliminar

### Esqeuma inicial de carga:
    La tala raw "orders" recibe todos los atributos del CSV sin normalizar. Usamos "row_id" como principal natural primary key, ya que cada tupla del dataset tiene una línea de pedido única.

    CREATE TABLE orders (
      row_id         INT PRIMARY KEY,
      order_id       VARCHAR(50),
      order_date     DATE,
      ship_date      DATE,
      ship_mode      VARCHAR(50),
      customer_id    VARCHAR(50),
      customer_name  VARCHAR(255),
      segment        VARCHAR(50),
      city           VARCHAR(100),
      state          VARCHAR(100),
      country        VARCHAR(100),
      postal_code    VARCHAR(20),
      market         VARCHAR(50),
      region         VARCHAR(50),
      product_id     VARCHAR(50),
      category       VARCHAR(100),
      sub_category   VARCHAR(100),
      product_name   TEXT,
      sales          NUMERIC(15,2),
      quantity       INT,
      discount       NUMERIC(5,2),
      profit         NUMERIC(15,2),
      shipping_cost  NUMERIC(15,2),
      order_priority VARCHAR(20)
    );
*nota:* todo el script creación y del ánalisis exploratorios se encuentran en  scripts/02_analisis_exploratorio.sql 
