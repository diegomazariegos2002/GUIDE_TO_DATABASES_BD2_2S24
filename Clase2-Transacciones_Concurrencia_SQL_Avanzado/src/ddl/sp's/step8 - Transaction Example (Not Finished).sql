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