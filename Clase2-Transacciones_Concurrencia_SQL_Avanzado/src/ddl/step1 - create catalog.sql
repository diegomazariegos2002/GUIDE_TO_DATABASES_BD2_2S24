-- Notas

-- 1. Crear Supertipo Profesor y Subtipos Titular e Interino
--  En PostgreSQL, no existe una construcción nativa específica para manejar subtipos y supertipos (herencia)
--  de la misma manera que en modelos de bases de datos más teóricos o diagramas ER. Sin embargo, PostgreSQL 
--  soporta la herencia de tablas, lo que puede ser utilizado para modelar subtipos y supertipos. Aunque es una
--  característica avanzada y rara vez utilizada en producción
-- 2. Crear Relaciones Arqueadas
--  Para las relaciones entre múltiples entidades, como la instancia de curso que puede ser impartida
--  tanto en una sala virtual como en un salón de clase, utilizamos claves foráneas y tablas intermedias
--  para manejar estas relaciones.

-- Definir un tipo ENUM para los tipos de profesores
CREATE TYPE tipo_profesor_enum AS ENUM ('TT', 'IN'); 
-- CREATE TYPE: Crea un nuevo tipo de dato
-- tipo_profesor_enum: Nombre del nuevo tipo
-- AS ENUM: Define el tipo como una enumeración con valores 'TT' y 'IN'

-- Crear tabla para catálogo de tipos de profesores con códigos / tabla de tipo catálogo
CREATE TABLE tipo_profesor (
    id_tipo SERIAL PRIMARY KEY, -- SERIAL: Genera un número entero único automáticamente
    codigo tipo_profesor_enum NOT NULL UNIQUE, -- codigo: Utiliza el tipo ENUM definido
    tipo_nombre VARCHAR(50) NOT NULL -- Nombre completo del tipo para referencia
);
