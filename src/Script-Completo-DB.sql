-- DDL solo para ejemplificar el uso de DCL

-- Crear usuario
CREATE USER admin2 WITH PASSWORD 'securepassword';

-- Asignar permisos
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin2;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin2;

-- Asegurar que los futuros objetos también reciban estos permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO admin2;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO admin2;

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

-- Insertar valores en la tabla de tipo de profesor
INSERT INTO tipo_profesor (codigo, tipo_nombre) VALUES 
('TT', 'Titular'), 
('IN', 'Interino');

-- Tabla de Carrera
CREATE TABLE carrera (
    id_carrera SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Curso
CREATE TABLE curso (
    id_curso SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_carrera INT REFERENCES carrera(id_carrera) -- Relación con la tabla Carrera
);

-- Tabla de Estudiante
CREATE TABLE estudiante (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_tipo INT REFERENCES tipo_profesor(id_tipo) -- Relación con la tabla de tipos de profesores
);

-- Crear tabla para Profesor Titular que hereda de Profesor
CREATE TABLE titular (
    especialidad VARCHAR(50), -- Campo adicional específico para profesores titulares
    codigo tipo_profesor_enum REFERENCES tipo_profesor(codigo) DEFAULT 'TT'
) INHERITS (profesor); -- Indica que esta tabla hereda columnas de la tabla 'profesor'

ALTER TABLE titular ADD CONSTRAINT pk_titular PRIMARY KEY (id_profesor); -- Añadir clave primaria específica

-- Crear tabla para Profesor Interino que hereda de Profesor
CREATE TABLE interino (
    contrato_fecha DATE, -- Campo adicional específico para profesores interinos
    codigo tipo_profesor_enum REFERENCES tipo_profesor(codigo) DEFAULT 'IN'
) INHERITS (profesor); -- Indica que esta tabla hereda columnas de la tabla 'profesor'

ALTER TABLE interino ADD CONSTRAINT pk_interino PRIMARY KEY (id_profesor); -- Añadir clave primaria específica

-- Tabla de Instancia de Curso
CREATE TABLE instancia_curso (
    id_instancia SERIAL PRIMARY KEY,
    id_curso INT REFERENCES curso(id_curso), -- Relación con la tabla curso
    ciclo VARCHAR(10) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    seccion VARCHAR(10) NOT NULL
);

-- Tabla de Examen
CREATE TABLE examen (
    id_examen SERIAL PRIMARY KEY,
    id_instancia INT REFERENCES instancia_curso(id_instancia) -- Relación con la tabla instancia_curso
);

-- Tabla de Asignación de Estudiantes a Cursos
CREATE TABLE asignacion (
    id_asignacion SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiante(id_estudiante),
    id_instancia INT REFERENCES instancia_curso(id_instancia)
);

-- Tabla de Examen Nota
CREATE TABLE examen_nota (
    id_examen INT REFERENCES examen(id_examen),
    id_estudiante INT REFERENCES estudiante(id_estudiante),
    nota DECIMAL(5,2),
    PRIMARY KEY (id_examen, id_estudiante)
);

-- Tabla de Sala Virtual
CREATE TABLE sala_virtual (
    id_sala SERIAL PRIMARY KEY,
    link VARCHAR(200) NOT NULL
);

-- Tabla de Salón de Clase
CREATE TABLE salon_clase (
    id_salon SERIAL PRIMARY KEY,
    numero VARCHAR(50) NOT NULL
);

-- Tabla para relacionar Instancia de Curso con Sala Virtual
CREATE TABLE instancia_sala_virtual (
    id_instancia INT REFERENCES instancia_curso(id_instancia),
    id_sala INT REFERENCES sala_virtual(id_sala),
    PRIMARY KEY (id_instancia, id_sala)
);

-- Tabla para relacionar Instancia de Curso con Salón de Clase
CREATE TABLE instancia_salon_clase (
    id_instancia INT REFERENCES instancia_curso(id_instancia),
    id_salon INT REFERENCES salon_clase(id_salon),
    PRIMARY KEY (id_instancia, id_salon)
);

-- Insertar valores en la tabla Carrera
INSERT INTO carrera (nombre) VALUES ('Ingeniería en Sistemas'), ('Ingeniería Civil');

-- Insertar valores en la tabla Curso
INSERT INTO curso (nombre, id_carrera) VALUES ('Bases de Datos', 1), ('Estructuras de Datos', 1);

-- Insertar valores en la tabla Estudiante
INSERT INTO estudiante (nombre) VALUES ('Juan Pérez'), ('María López');

-- Insertar valores en la tabla Profesor
INSERT INTO profesor (nombre, id_tipo) VALUES ('Carlos Sánchez', 1), ('Ana González', 2);

-- Insertar valores en la tabla Instancia de Curso
INSERT INTO instancia_curso (id_curso, ciclo, semestre, seccion) VALUES (1, '2024', '1', 'A');

-- Insertar valores en la tabla Examen
INSERT INTO examen (id_instancia) VALUES (1);

-- Insertar valores en la tabla Asignación
INSERT INTO asignacion (id_estudiante, id_instancia) VALUES (1, 1), (2, 1);

-- Insertar valores en la tabla Examen Nota
INSERT INTO examen_nota (id_examen, id_estudiante, nota) VALUES (1, 1, 85.5), (1, 2, 92.0);

-- Insertar valores en la tabla Sala Virtual
INSERT INTO sala_virtual (link) VALUES ('http://virtualclassroom.com/123'), ('http://virtualclassroom.com/456');

-- Insertar valores en la tabla Salón de Clase
INSERT INTO salon_clase (numero) VALUES ('101A'), ('102B');

-- Insertar valores en la tabla instancia_sala_virtual
INSERT INTO instancia_sala_virtual (id_instancia, id_sala) VALUES (1, 1);

-- Insertar valores en la tabla instancia_salon_clase
INSERT INTO instancia_salon_clase (id_instancia, id_salon) VALUES (1, 1);

CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY, -- SERIAL: Genera un número entero único automáticamente para cada registro en la tabla.
    tabla VARCHAR(255) NOT NULL, -- tabla: Almacena el nombre de la tabla en la que se realizó la operación (máximo 255 caracteres).
    operacion VARCHAR(50) NOT NULL, -- operacion: Almacena el tipo de operación realizada ('INSERT', 'DELETE', 'UPDATE').
    datos_anteriores JSONB, -- datos_anteriores: Almacena los datos anteriores al cambio en formato JSONB (para operaciones 'DELETE' y 'UPDATE').
    datos_nuevos JSONB, -- datos_nuevos: Almacena los datos nuevos después del cambio en formato JSONB (para operaciones 'INSERT' y 'UPDATE').
    usuario VARCHAR(255) NOT NULL, -- usuario: Almacena el nombre del usuario que realizó la operación (máximo 255 caracteres).
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- fecha: Registra la fecha y hora en que se realizó la operación, con valor por defecto al momento actual.
);

CREATE OR REPLACE FUNCTION auditoria_insert() RETURNS TRIGGER AS $$ -- Crea una función que retorna un trigger. Si ya existe, la reemplaza.
BEGIN
    INSERT INTO auditoria(tabla, operacion, datos_nuevos, usuario) -- Inserta un nuevo registro en la tabla de auditoría.
    VALUES (TG_TABLE_NAME, 'INSERT', row_to_json(NEW), session_user); -- Inserta el nombre de la tabla, la operación 'INSERT', los datos nuevos (en formato JSON), y el usuario que hizo la operación.
    RETURN NEW; -- Retorna la nueva fila que fue insertada, permitiendo que la operación continue.
END;
$$ LANGUAGE plpgsql; -- Define el lenguaje de la función como PL/pgSQL.

CREATE OR REPLACE FUNCTION auditoria_delete() RETURNS TRIGGER AS $$ -- Crea una función que retorna un trigger. Si ya existe, la reemplaza.
BEGIN
    INSERT INTO auditoria(tabla, operacion, datos_anteriores, usuario) -- Inserta un nuevo registro en la tabla de auditoría.
    VALUES (TG_TABLE_NAME, 'DELETE', row_to_json(OLD), session_user); -- Inserta el nombre de la tabla, la operación 'DELETE', los datos antes del borrado (en formato JSON), y el usuario que hizo la operación.
    RETURN OLD; -- Retorna la fila que fue eliminada.
END;
$$ LANGUAGE plpgsql; -- Define el lenguaje de la función como PL/pgSQL.

CREATE OR REPLACE FUNCTION auditoria_update() RETURNS TRIGGER AS $$ -- Crea una función que retorna un trigger. Si ya existe, la reemplaza.
BEGIN
    INSERT INTO auditoria(tabla, operacion, datos_anteriores, datos_nuevos, usuario) -- Inserta un nuevo registro en la tabla de auditoría.
    VALUES (TG_TABLE_NAME, 'UPDATE', row_to_json(OLD), row_to_json(NEW), session_user); -- Inserta el nombre de la tabla, la operación 'UPDATE', los datos anteriores al cambio (OLD), los datos nuevos (NEW), y el usuario que hizo la operación.
    RETURN NEW; -- Retorna la nueva fila que fue actualizada, permitiendo que la operación continue.
END;
$$ LANGUAGE plpgsql; -- Define el lenguaje de la función como PL/pgSQL.


-- NOTAS EXTRAS:
    -- Triggers en procedimientos o funciones?
        -- Un procedimiento en PostgreSQL no devuelve un valor. Los procedimientos son más adecuados para operaciones
        -- que no forman parte de un ciclo de vida de registros como los que se manejan en triggers (INSERT, UPDATE, DELETE).
        -- Por lo tanto, un procedimiento sería inapropiado en este contexto, donde se requiere que el ciclo de vida del
        -- registro continúe o sea modificado de acuerdo con la lógica del trigger.

        -- BEFORE triggers: Se ejecutan antes de que la operación (INSERT, UPDATE, DELETE) se haya realizado. En estos casos,
        -- la función de trigger necesita devolver el registro que se va a insertar o actualizar. Esto permite que la operación
        -- continúe y se aplique al registro.

        -- AFTER triggers: Se ejecutan después de que la operación se haya completado. La función de trigger puede devolver
        -- el registro para mantener la consistencia, pero no afecta la operación ya completada.

        -- Al devolver NEW o OLD, se asegura que la operación continúe sin problemas, preservando la integridad y consistencia
        -- de los datos en la base de datos.

        -- * CANCELAR una operación (BEFORE Trigger)
            -- RETURN NULL: Cancela la operación actual (INSERT, UPDATE, DELETE) y no se realiza ningún cambio en la tabla.

DO $$  -- Inicia un bloque anónimo de código PL/pgSQL, que permite ejecutar código procedimental sin necesidad de definir una función permanente.
DECLARE 
    r RECORD;  -- Declara una variable 'r' de tipo RECORD, que se usará para almacenar los nombres de las tablas mientras se itera sobre ellas.
BEGIN  -- Comienza el bloque ejecutable del código.
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP  -- Inicia un bucle FOR que iterará sobre cada tabla en el esquema 'public'.

        -- Verifica si el trigger de INSERT ya existe antes de crearlo
        IF NOT EXISTS (
            SELECT 1 FROM pg_trigger 
            WHERE tgname = format('trg_auditoria_insert_%I', r.tablename)
        ) THEN
            EXECUTE format('  -- Utiliza la función EXECUTE para ejecutar SQL dinámico. Aquí, la función format se usa para construir la cadena SQL.
                CREATE TRIGGER trg_auditoria_insert_%I  -- Define el nombre del trigger de auditoría para operaciones INSERT, con un sufijo basado en el nombre de la tabla.
                AFTER INSERT ON %I  -- Especifica que el trigger se activará después de una operación INSERT en la tabla.
                FOR EACH ROW EXECUTE FUNCTION auditoria_insert();', r.tablename, r.tablename);  -- Indica que el trigger ejecutará la función 'auditoria_insert' para cada fila afectada por el INSERT, utilizando el nombre de la tabla actual.
        END IF;

        -- Verifica si el trigger de DELETE ya existe antes de crearlo
        IF NOT EXISTS (
            SELECT 1 FROM pg_trigger 
            WHERE tgname = format('trg_auditoria_delete_%I', r.tablename)
        ) THEN
            EXECUTE format('  -- Repite el proceso para crear un trigger para las operaciones DELETE.
                CREATE TRIGGER trg_auditoria_delete_%I  -- Define el nombre del trigger de auditoría para operaciones DELETE, con un sufijo basado en el nombre de la tabla.
                AFTER DELETE ON %I  -- Especifica que el trigger se activará después de una operación DELETE en la tabla.
                FOR EACH ROW EXECUTE FUNCTION auditoria_delete();', r.tablename, r.tablename);  -- Indica que el trigger ejecutará la función 'auditoria_delete' para cada fila afectada por el DELETE, utilizando el nombre de la tabla actual.
        END IF;

        -- Verifica si el trigger de UPDATE ya existe antes de crearlo
        IF NOT EXISTS (
            SELECT 1 FROM pg_trigger 
            WHERE tgname = format('trg_auditoria_update_%I', r.tablename)
        ) THEN
            EXECUTE format('  -- Repite el proceso para crear un trigger para las operaciones UPDATE.
                CREATE TRIGGER trg_auditoria_update_%I  -- Define el nombre del trigger de auditoría para operaciones UPDATE, con un sufijo basado en el nombre de la tabla.
                AFTER UPDATE ON %I  -- Especifica que el trigger se activará después de una operación UPDATE en la tabla.
                FOR EACH ROW EXECUTE FUNCTION auditoria_update();', r.tablename, r.tablename);  -- Indica que el trigger ejecutará la función 'auditoria_update' para cada fila afectada por el UPDATE, utilizando el nombre de la tabla actual.
        END IF;

    END LOOP;  -- Finaliza el bucle FOR, habiendo aplicado los triggers a todas las tablas en el esquema 'public'.

    -- Elimina los triggers de auditoría creados para evitar bucles infinitos en la base de datos
    EXECUTE 'DROP TRIGGER IF EXISTS trg_auditoria_insert_auditoria ON public.auditoria;';
    EXECUTE 'DROP TRIGGER IF EXISTS trg_auditoria_delete_auditoria ON public.auditoria;';
    EXECUTE 'DROP TRIGGER IF EXISTS trg_auditoria_update_auditoria ON public.auditoria;';

END $$ LANGUAGE plpgsql;  -- Termina el bloque de código PL/pgSQL, indicando que el lenguaje usado es PL/pgSQL.

-- DATOS EXTRA:
    -- ¿Qué es un bloque?
    --     Un bloque es una sección de código que agrupa instrucciones relacionadas. En PL/pgSQL, los bloques se inician con
    --     la palabra clave DO o con la declaración de una función o procedimiento. Los bloques pueden contener declaraciones
    --     de variables, instrucciones de control de flujo, llamadas a funciones, y más. Los bloques permiten organizar y
    --     estructurar el código de manera más legible y mantenible.
    
    -- ¿Por Qué Utilizar Bloques?
    --     Modularidad: Permiten agrupar lógica compleja y fragmentarla en secciones manejables.
    --     Reutilización: El código dentro de un bloque puede ser reutilizado en múltiples lugares, especialmente cuando se usa dentro de funciones o procedimientos.
    --     Control de Flujo Avanzado: Los bloques permiten el uso de estructuras de control como bucles (FOR, WHILE) y condiciones (IF, CASE), que no son posibles en el SQL estándar.
    --     Manejo de Excepciones: Puedes manejar errores de manera sofisticada, asegurando que tu aplicación o consulta pueda responder adecuadamente a los problemas sin fallar abruptamente.

    -- Bloques en Funciones y Triggers
    --     Cuando creas una función o un trigger en PL/pgSQL, en realidad estás creando un bloque de código 
    --     que se ejecutará cuando la función o el trigger sea invocado. Este bloque puede incluir lógica 
    --     para realizar cálculos, procesar datos, o interactuar con otras partes de la base de datos.

-- Tabla Carrera
INSERT INTO carrera (nombre) VALUES ('Ingeniería Mecánica');
UPDATE carrera SET nombre = 'Ingeniería en Software' WHERE id_carrera = 1;
DELETE FROM carrera WHERE id_carrera = 2;

-- Tabla Curso
INSERT INTO curso (nombre, id_carrera) VALUES ('Matemáticas Discretas', 1);
UPDATE curso SET nombre = 'Algoritmos' WHERE id_curso = 2;

-- Tabla Examen Nota (Debido a la relación con Examen, primero eliminamos las notas)
DELETE FROM examen_nota WHERE id_examen = 1 AND id_estudiante = 2;

-- Tabla Asignación (Para eliminar relaciones de estudiante y curso)
DELETE FROM asignacion WHERE id_estudiante = 2 AND id_instancia = 1;

-- Tabla Instancia Sala Virtual (Para eliminar la relación con Instancia de Curso)
UPDATE instancia_sala_virtual SET id_sala = 2 WHERE id_instancia = 1;
DELETE FROM instancia_sala_virtual WHERE id_instancia = 1;
 
-- Tabla Instancia Salón de Clase (Para eliminar la relación con Instancia de Curso)
UPDATE instancia_salon_clase SET id_salon = 2 WHERE id_instancia = 1;
DELETE FROM instancia_salon_clase WHERE id_instancia = 1;

-- Tabla Estudiante
INSERT INTO estudiante (nombre) VALUES ('Luis Gómez');
UPDATE estudiante SET nombre = 'Juan Pérez García' WHERE id_estudiante = 1;
DELETE FROM estudiante WHERE id_estudiante = 2;

-- Tabla Profesor
INSERT INTO profesor (nombre, id_tipo) VALUES ('Marta Díaz', 1);
UPDATE profesor SET nombre = 'Carlos Sánchez López' WHERE id_profesor = 1;
DELETE FROM profesor WHERE id_profesor = 2;

-- Tabla Sala Virtual
INSERT INTO sala_virtual (link) VALUES ('http://virtualclassroom.com/789');
UPDATE sala_virtual SET link = 'http://virtualclassroom.com/123456' WHERE id_sala = 1;

-- Tabla Salón de Clase
INSERT INTO salon_clase (numero) VALUES ('103C');
UPDATE salon_clase SET numero = '104D' WHERE id_salon = 1;

-- Tabla Instancia Sala Virtual 
INSERT INTO instancia_sala_virtual (id_instancia, id_sala) VALUES (1, 1);
INSERT INTO instancia_salon_clase (id_instancia, id_salon) VALUES (1, 1);

CREATE OR REPLACE PROCEDURE insertar_carrera(
    p_nombre VARCHAR(100)
)
AS $$
DECLARE
    carrera_record RECORD;
BEGIN
    -- Mostrar encabezado de la tabla
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'Tabla carrera antes del INSERT:';
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'ID | Nombre';
    RAISE NOTICE '---------------------------------------';
    FOR carrera_record IN SELECT * FROM carrera LOOP
        RAISE NOTICE '% | %', LPAD(carrera_record.id_carrera::TEXT, 3, ' '), carrera_record.nombre;
    END LOOP;
    RAISE NOTICE '---------------------------------------';

    -- Insertar la nueva carrera
    INSERT INTO carrera (nombre)
    VALUES (p_nombre);

    -- Mostrar encabezado de la tabla después del INSERT
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'Tabla carrera después del INSERT:';
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'ID | Nombre';
    RAISE NOTICE '---------------------------------------';
    FOR carrera_record IN SELECT * FROM carrera LOOP
        RAISE NOTICE '% | %', LPAD(carrera_record.id_carrera::TEXT, 3, ' '), carrera_record.nombre;
    END LOOP;
    RAISE NOTICE '---------------------------------------';

    -- Deshacer todos los cambios realizados en la transacción
    ROLLBACK;
    RAISE NOTICE 'Rollback exitoso, todos los cambios han sido revertidos.';

    -- Mostrar encabezado de la tabla después del ROLLBACK
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'Tabla carrera después del ROLLBACK:';
    RAISE NOTICE '---------------------------------------';
    RAISE NOTICE 'ID | Nombre';
    RAISE NOTICE '---------------------------------------';
    FOR carrera_record IN SELECT * FROM carrera LOOP
        RAISE NOTICE '% | %', LPAD(carrera_record.id_carrera::TEXT, 3, ' '), carrera_record.nombre;
    END LOOP;
    RAISE NOTICE '---------------------------------------';

END;
$$ LANGUAGE plpgsql;


CALL insertar_carrera('Ingeniería en Sistemas');