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