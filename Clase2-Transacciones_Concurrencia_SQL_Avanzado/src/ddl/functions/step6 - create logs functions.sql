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
