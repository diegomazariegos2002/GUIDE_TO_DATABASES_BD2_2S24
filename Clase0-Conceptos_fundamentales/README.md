# Clase 0 - Conceptos fundamentales de las bases de datos

Bienvenidos al curso de **bases de datos**. En esta primera clase, nos enfocaremos en establecer una base sólida en **bases de datos relacionales** y **no relacionales**. Revisaremos los conceptos fundamentales, las estructuras básicas y las herramientas necesarias para interactuar con bases de datos.

Básicamente, este apartado funcionará como un **glosario** para todos los conceptos existentes y por existir en el mundo de las bases de datos. Ten en cuenta que este apartado se irá actualizando conforme se vayan viendo los temas en las clases. Si no entiendes del todo un concepto, no te preocupes, ya que se explicará a medida que avanzamos. La idea es que leas los conceptos y te despierte la curiosidad de saber más.

---

## Conceptos fundamentales

### Categorías de bases de datos

#### 1. **Bases de datos distribuidas vs centralizadas**

| Tipo                         | Descripción | Ejemplos de bases de datos |
|------------------------------|-------------|----------------------------|
| **Bases de datos centralizadas** | Almacenan la información en un solo servidor o nodo. Todos los datos y operaciones se realizan en un único lugar, lo que puede limitar la escalabilidad y la disponibilidad. | MySQL, Oracle, PostgreSQL |
| **Bases de datos distribuidas** | Almacenan la información en varios servidores o nodos interconectados. Los datos se distribuyen para mejorar la escalabilidad, disponibilidad y rendimiento. | Cassandra, Google BigQuery, Amazon Aurora |

#### 2. **Bases de datos relacionales vs no relacionales**

| Tipo                         | Descripción | Ejemplos de bases de datos |
|------------------------------|-------------|----------------------------|
| **Bases de datos relacionales** | Almacenan la información en tablas, compuestas por filas y columnas. Las relaciones entre las tablas se establecen mediante claves primarias y claves foráneas. | MySQL, PostgreSQL, Oracle |
| **Bases de datos no relacionales** | Almacenan la información en estructuras no tabulares (documentos, grafos, pares clave-valor). Son más flexibles y escalables. | MongoDB, Cassandra, Redis |

#### 3. **Bases de datos en memoria vs en disco**

| Tipo                         | Descripción | Ejemplos de bases de datos |
|------------------------------|-------------|----------------------------|
| **Bases de datos en memoria** | Almacenan la información en la memoria RAM, lo que permite un acceso más rápido, pero limita la cantidad de datos que se pueden almacenar. | Redis, H2, Apache Ignite |
| **Bases de datos en disco**   | Almacenan la información en el disco duro, permitiendo almacenar grandes cantidades de datos, aunque con un acceso más lento. | MySQL, PostgreSQL, SQLite |

#### 4. **Bases de datos transaccionales vs analíticas (OLTP vs OLAP)**

| Tipo                         | Descripción | Ejemplos de bases de datos |
|------------------------------|-------------|----------------------------|
| **Bases de datos transaccionales (OLTP)** | Diseñadas para gestionar transacciones de forma eficiente. Se utilizan para operaciones de inserción, actualización, eliminación y consulta de datos en tiempo real. | MySQL, PostgreSQL, Oracle |
| **Bases de datos analíticas (OLAP)** | Diseñadas para análisis de datos complejos. Se utilizan para consultas complejas y análisis históricos. Son más lentas que las bases de datos transaccionales. | Amazon Redshift, Google BigQuery, Snowflake |

> **Concepto importante**:  
> - **ETL (Extract, Transform, Load)**: Proceso de extracción, transformación y carga de datos desde múltiples fuentes a un almacén de datos o **Data Warehouse**.

#### 5. **Bases de datos ACID vs BASE**

| Tipo                         | Descripción | Ejemplos de bases de datos |
|------------------------------|-------------|----------------------------|
| **Bases de datos ACID**       | Garantizan las propiedades **ACID** (Atomicidad, Consistencia, Aislamiento, Durabilidad) en las transacciones. Ejemplos: MySQL, PostgreSQL, Oracle. | MySQL, PostgreSQL, Oracle |
| **Bases de datos BASE**       | Prioriza la **disponibilidad** y la **tolerancia a fallos** sobre la consistencia estricta. BASE significa **Basically Available**, **Soft state**, **Eventual consistency**. | Cassandra, DynamoDB, Couchbase |

#### 6. **Otras Clasificaciones** - **Bases de datos según el modelo de datos**

| Modelo de datos               | Descripción | Ejemplos de bases de datos |
|-------------------------------|-------------|----------------------------|
| **Modelo relacional**         | Almacena la información en tablas relacionadas entre sí. | MySQL, PostgreSQL, Oracle |
| **Modelo de documentos**      | Almacena la información en documentos JSON, XML o similares. | MongoDB, Couchbase, Firebase |
| **Modelo de datos jerárquicos** | Almacena la información en estructuras jerárquicas. | XML, JSON, LDAP |
| **Modelo de grafos**          | Almacena la información en nodos y relaciones entre ellos. | Neo4j, Amazon Neptune, ArangoDB |
| **Modelo clave-valor**        | Almacena la información en pares clave-valor. | Redis, DynamoDB, Riak |
| **Modelo de columnas**        | Almacena la información en columnas en lugar de filas. | Cassandra, Google Bigtable, HBase |
| **Modelo de tiempo real**     | Almacena la información en tiempo real, con baja latencia. | Apache Kafka, Apache Pulsar, Amazon Kinesis |
| **Modelo multidimensional**   | Almacena la información en cubos OLAP para análisis multidimensional. | Microsoft Analysis Services, SAP HANA, Snowflake |
| **Modelo de búsqueda**        | Almacena la información para búsquedas rápidas y eficientes. | Elasticsearch, Apache Solr, Algolia |
| **Modelo de series temporales** | Almacena la información en series temporales (fechas y valores). | InfluxDB, TimescaleDB, Prometheus |
| **Modelo de eventos**         | Almacena la información en eventos y flujos de datos. | Apache Flink, Apache Kafka, Amazon Kinesis |
| **Modelo de datos geoespaciales** | Almacena la información geoespacial (ubicaciones, mapas). | PostGIS, Google BigQuery GIS, MongoDB Atlas |
| **Modelo de datos semiestructurados** | Almacena la información con estructuras flexibles. | Firebase, Couchbase, Amazon DynamoDB |
| **Modelo de datos en memoria** | Almacena la información en la memoria RAM. | Redis, Memcached, Hazelcast |
| **Modelo de datos distribuidos** | Almacena la información en múltiples nodos interconectados. | Cassandra, Google Spanner, Amazon Aurora |
| **Modelo de datos federados** | Almacena la información en múltiples fuentes de datos. | Apache Drill, Presto, Google BigQuery |
| **Modelo de datos híbridos**  | Combina múltiples modelos de datos en un sistema. | Google Firestore, Amazon Redshift, Microsoft Azure Cosmos DB |
| **Modelo de datos políglota**  | Utiliza múltiples bases de datos para diferentes necesidades. | Netflix, Twitter, LinkedIn |
| **Modelo de datos sin esquema** | Almacena la información sin un esquema fijo. | MongoDB, Couchbase, Firebase |
| **Modelo de datos en la nube** | Almacena la información en la nube. | Amazon RDS, Google Cloud SQL, Microsoft Azure SQL Database |


---

**Nota:** Recuerda que cada sección aquí es solo un punto de partida para estudiar más en profundidad. A medida que avancemos, veremos cada tema con más detalle y ejemplos.

---