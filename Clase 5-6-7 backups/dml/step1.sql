DO $$ 
BEGIN
    -- Bloque PL/pgSQL para insertar 1000 carreras
    FOR i IN 1..1000 LOOP
        -- Insertar una carrera con el nombre 'Carrera ' seguido del número
        INSERT INTO carrera (nombre) VALUES ('Carrera ' || i);
    END LOOP;
END $$;