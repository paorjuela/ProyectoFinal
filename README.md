# Análisis del Comercio Global por Internet.

Estamos trabajando con el dataset **"Global Super Store"**, con el que analizaremos transacciones de comercio en línea para identificar patrones de compra y métricas útiles para vendedores y consumidores.

## 1. Sobre el Dataset 

### Descripción General

El Dataset contiene información sobre miles de transacciones comerciales hechas por usuarios a través de la red entre el 1 de enero de 2011 y el 31 de diciembre de 2014. La información de las transacciones contiene datos importantes de los compradores, lugares de residencia, montos monetarios, información del producto, entre otras cosas.

Los datos fueron extraidos de Kaggle con el url "https://www.kaggle.com/datasets/apoorvaappz/global-super-store-dataset/data" y recolectados en 2020 por Apoorva Mahalingappa (estudiante de Ciencia de Datos en Great Lakes Institute of Management, India) con el proposito de analizar las compras de productos en internet y extraer tendencias comerciales; como lo es el producto con más ventas, los países con mayor cantidad de transacciones, a qué sector pertenecen la mayor cantidad de compradores, etc.

El dataset es estático, pues tiene cierto carácter histórico, pero abarca un periodo de 4 años, lo que nos da una ventana de tiempo lo suficientemente amplia para identificar tendencias. Hay bastantes datos con los que se puede trabajar, además de que están relativamente en buena forma (i.e. no hay muchas inconsistencias), aunque hay renglones con datos faltantes (sobre todo en la columna "Postal Code").

## 2. Características de los datos

El archivo csv que se obtiene al descargar el Dataset cuenta con 24 columnas (4 id's) y aproximadamente 51.3K tuplas.

## 3. Diccionario de datos

Los datos y su tipo son:

| Atributo | Tipo | ¿Qué es? |
| :--- | :--- | :--- |
| **Row ID** | Numérico | Id de la tupla |
| **Order ID** | Texto | Id del pedido |
| **Order Date** | Temporal | Fecha del pedido |
| **Ship Date** | Temporal | Fecha de envío |
| **Ship Mode** | Categorico | Forma de envio |
| **Customer ID** | Texto | Id del comprador |
| **Customer Name** | Texto | Nombre del comprador |
| **Segment** | Categorico | Tipo del comprador |
| **City** | Categorico | Ciudad del comprador |
| **State** | Categorico | Estado (lugar) del comprador |
| **Country** | Categorico | Pais del comprador |
| **Postal Code** | Numérico | Código Postal del comprador |
| **Market** | Categorico | Región del mercado |
| **Region** | Categorico | Región del mercado |
| **Product ID** | Texto | Id del producto |
| **Category** | Categorico | Categoría del producto |
| **Sub-Category** | Categorico | Subcategoría del producto |
| **Product Name** | Texto | Nombre del producto |
| **Sales** | Numérico | Monto transaccionado por la venta |
| **Quantity** | Numérico | Cantidad del producto que se vendió |
| **Discount** | Numérico | Descuento aplicado a la venta |
| **Profit** | Numérico | Ganancia por la venta |
| **Shipping Cost** | Numérico | Costo de envío |
| **Order Priority** | Categorico | Prioridad de envío |

> **Nota:** Todos los datos de tipo "Categorico" y de tipo "Temporal" están almacenados como de tipo "Texto" en el Dataset.

## 4. Objetivo del proyecto 
El objetivo principal de este proyecto es analizar un conjunto de datos para identificar patrones de comportamiento en el comercio electrónico a nivel global. Nuestro equipo busca identificar cuáles son los productos más rentables, qué regiones hacen más transacciones, los tiempos promedio de envío y los clientes más activos, simulando la toma de decisiones en un entorno empresarial.


## 5. Consideraciones éticas 
* **Privacidad de los clientes** Aunque es un dataset público y probablemente anónimo o sintético, tiene columnas como "Customer Name" ligadas a ubicaciones geográficas (City, State, Postal Code). En un entorno real, exponer esta información significaría violar la privacidad de los usuarios y romper múltiples leyes.
* **Sesgos** La mayoría de los datos parecen ser de Estados Unidos, por lo que nuestro análisis tendrá cierto sesgo geográfico. Estaremos ignorando patrones de compra en mercados que no se ven representados en este dataset.
