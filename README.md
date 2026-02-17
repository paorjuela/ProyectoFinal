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
- 
Para entender qué estamos manipulando, aquí está el desglose de cada columna:

| Atributo | Tipo | ¿Qué es? |
| :--- | :--- | :--- |
| **CVEGEO** | Texto | Es la "Primary Key" geográfica. Identifica única a cada manzana (Estado+Municipio+Localidad+AGEB). |
| **POB1** | Numérico | Cantidad de personas que viven ahí (según Censo 2010). |
| **OID_1** | Numérico | ID interno del software GIS (nos sirve de referencia). |
| **Metro, Suburbano, Metrobus, RTP, etc.** | Numérico | Son contadores o "banderas". Indican la presencia/cercanía de ese transporte en la manzana. |
| **Cobertura** | Categórico | Una clasificación general de qué tan bien conectada está la zona. |

> **Nota:** Las columnas de transporte incluyen: *Metro, Suburbano, Metrobus, Tren_Liger, Trolebus, RTP, Trole_elev, T_Concesio (micros), Ecobici y Cablebus*.

## Tipos de Datos
* **Texto / Strings:** Solo `CVEGEO`.
* **Numéricos:** `POB1` (población) y todas las variables de transporte (que funcionan como booleanos o contadores discretos).
* **Categóricos:** `Cobertura` (Nivel de servicio).
* **Temporales:** **Ninguno.** El dataset es estático, no tiene columnas de tipo `Date` o `Timestamp`. Representa un momento específico en el tiempo.

## 5. Objetivo del Proyecto 
Favor de no usar un formato pregunta-respuesta
- ¿Cuál es el objetivo buscado con el set de datos? ¿Para qué se usará por el
equipo?

El dataset original es un "flat file" (una tabla gigante desnormalizada), lo cual es normal en GIS pero pésimo para bases de datos transaccionales.

**Nuestra misión es:**
1.  **Normalizar la BD:** Romper la tabla original en al menos 3 entidades lógicas (Ubicación, Catálogo de Transportes, Disponibilidad).
2.  **Eliminar redundancia:** En lugar de tener 10 columnas vacías para transportes que no existen en una manzana, vamos a relacionar solo lo que sí hay.
3.  **Optimizar:** Dejar la base lista para consultas SQL complejas sobre cobertura y equidad.

## 6. Consideraciones Éticas 
Favor de no usar un formato pregunta-respuesta
¿Qué consideraciones éticas conlleva el análisis y explotación de dichos datos? 

* **El problema del tiempo:** Estamos cruzando infraestructura nueva (como el Cablebús o Trolebús Elevado) con datos de población del 2010. Esto puede invisibilizar a comunidades enteras que se asentaron en la periferia en los últimos 10-15 años. El mapa podría decir "aquí no vive nadie" cuando en realidad ya está lleno de gente.
* **Privacidad:** Aunque son datos agregados, hay manzanas con muy poquita población (ej. 3 personas). Con la `CVEGEO` se podría ubicar fácilmente a familias específicas, lo cual es un riesgo de privacidad si cruzamos esto con datos socioeconómicos.
* **¿Qué cuenta como transporte?:** La variable `T_Concesio` mete en un mismo saco a muchos tipos de transporte. Además, si el dataset ignora el transporte informal (taxis pirata, bicitaxis), estamos subestimando la movilidad real de las zonas populares, haciéndolas ver más "aisladas" de lo que realmente están.
