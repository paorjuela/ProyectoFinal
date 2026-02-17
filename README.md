# Análisis de Movilidad en la Zona Metropolitana del Valle de México.

Estamos trabajando con el dataset **"Número de sistemas de transporte disponibles por manzana"**, para entender la desigualdad en la movilidad urbana.

## 1. Sobre el Dataset 

### Descripción General

Favor de no usar un formato pregunta-respuesta 
- Descripción general de los datos
  Este conjunto de datos cruza la ubicación de la gente (a nivel manzana) con la infraestructura de transporte disponible. Nos dice qué opciones (Metro, Metrobús, Bici, etc.) tiene a la mano una persona dependiendo de dónde vive.
  
- ¿Quién los recolecta?
   Este data set fue generado por el **CentroGeo** (Centro de Investigación en Ciencias de Información Geoespacial) junto con el **IPDP** (Instituto de Planeación Democrática y Prospectiva).
  
- ¿Cuál es el propósito de su recolección?
  Planeación urbana
  
- ¿Dónde se pueden obtener?
  Se encuentra en los portales de Datos Abiertos de la CDMX
  
- ¿Con qué frecuencia se actualizan?
   No es en tiempo real. Se actualiza de forma irregular cuando hay nuevos planes de desarrollo urbano.

## 2. Caracteristicas de los Datos

Favor de no usar un formato pregunta-respuesta
- ¿Cuántas tuplas y cuántos atributos tiene el set de datos?

* **Volumen:** 156,900 registros (Tuplas).
* **Dimensiones:** 14 columnas (Atributos).

## 3. Diccionario de Datos 
Favor de no usar un formato pregunta-respuesta
- ¿Qué significa cada atributo del set?
- ¿Qué atributos son numéricos?
- ¿Qué atributos son categóricos?
- ¿Qué atributos son de tipo texto?
- ¿Qué atributos son de tipo temporal y/o fecha?

desglose de cada columna:

| Atributo | Tipo | ¿Qué es? |
| :--- | :--- | :--- |
| **CVEGEO** | Texto | "Primary Key" geográfica. Identificaa cada manzana  |
| **POB1** | Numérico | Cantidad de personas que viven ahí |
| **OID_1** | Numérico | ID del GIS |
| **Metro, Suburbano, Metrobus, RTP, etc.** | Numérico | "Banderas" que indican la presencia/cercanía de ese transporte en la manzana. |
| **Cobertura** | Categórico | Una clasificación general de qué tan bien conectada está la zona. |

> **Nota:** Las columnas de transporte incluyen: *Metro, Suburbano, Metrobus, Tren_Liger, Trolebus, RTP, Trole_elev, T_Concesio (micros), Ecobici y Cablebus*.

## Tipos de Datos
* **Texto / Strings:** `CVEGEO`.
* **Numéricos:** `POB1` (población) y todas las variables de transporte (que funcionan como booleanos, 1 para true y 0 para false).
* **Categóricos:** `Cobertura` (Nivel de servicio).
* **Temporales:** **Ninguno.** El dataset es estático, no tiene columnas de tipo `Date` o `Timestamp`, pues representa un momento específico en el tiempo.

## 5. Objetivo del Proyecto 
Favor de no usar un formato pregunta-respuesta
- ¿Cuál es el objetivo buscado con el set de datos? ¿Para qué se usará por el
equipo?


## 6. Consideraciones Éticas 
Favor de no usar un formato pregunta-respuesta
¿Qué consideraciones éticas conlleva el análisis y explotación de dichos datos? 

* **El problema del tiempo:** La última actualización de los datos fue en 2022, el mapa podría decir que en una zona no vive nadie, cuando, en la actualidad, ya podría tener gente.
* **Privacidad:** Hay manzanas con muy poquita población (ej. 3 personas). Con la `CVEGEO` se podría ubicar fácilmente a familias específicas, lo cual podría ser un riesgo de privacidad si cruzamos esto con datos socioeconómicos.
* **¿Qué cuenta como transporte?:** La variable `T_Concesio` mete en un mismo saco a muchos tipos de transporte. Además, si el dataset ignora el transporte informal (taxis pirata, bicitaxis), algunas zonas se verán más "aisladas" de lo que realmente están.
