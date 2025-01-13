CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY, -- SERIAL: Genera un número entero único automáticamente para cada registro en la tabla.
    tabla VARCHAR(255) NOT NULL, -- tabla: Almacena el nombre de la tabla en la que se realizó la operación (máximo 255 caracteres).
    operacion VARCHAR(50) NOT NULL, -- operacion: Almacena el tipo de operación realizada ('INSERT', 'DELETE', 'UPDATE').
    datos_anteriores JSONB, -- datos_anteriores: Almacena los datos anteriores al cambio en formato JSONB (para operaciones 'DELETE' y 'UPDATE').
    datos_nuevos JSONB, -- datos_nuevos: Almacena los datos nuevos después del cambio en formato JSONB (para operaciones 'INSERT' y 'UPDATE').
    usuario VARCHAR(255) NOT NULL, -- usuario: Almacena el nombre del usuario que realizó la operación (máximo 255 caracteres).
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- fecha: Registra la fecha y hora en que se realizó la operación, con valor por defecto al momento actual.
);


-- NOTA EXTRA:

-- ¿Qué es JSONB?
--     JSONB es un tipo de datos en PostgreSQL que permite almacenar datos en formato JSON (JavaScript Object Notation) de manera estructurada.
--     JSONB es similar a JSON, pero con la diferencia de que los datos se almacenan en un formato binario optimizado para búsquedas y consultas.
--     Esto permite realizar operaciones más eficientes en comparación con el tipo de datos JSON, especialmente en tablas con muchos registros.
--     JSONB es útil para almacenar datos semi-estructurados o no relacionales, como configuraciones, registros de auditoría, o datos de aplicaciones web.
--     Al usar JSONB, puedes almacenar, consultar y manipular datos JSON de manera flexible y eficiente en PostgreSQL.

-- ¿Por qué usar JSONB y un VARCHAR o TEXT?
--     JSONB es preferible a VARCHAR o TEXT cuando necesitas almacenar datos JSON de manera estructurada y realizar operaciones de búsqueda o filtrado
--     basadas en los valores de las claves o campos JSON. JSONB permite indexar y consultar datos JSON de manera eficiente, lo que puede mejorar
--     significativamente el rendimiento de las consultas en tablas con muchos registros o con datos JSON complejos.

--     En general, JSONB podría ocupar más espacio que almacenar los mismos datos en un campo TEXT,
--     pero el beneficio en términos de flexibilidad y rendimiento en consultas complejas generalmente compensa este aumento.