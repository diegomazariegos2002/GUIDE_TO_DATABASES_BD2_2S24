-- Crear una tabla SIN ÍNDICES
CREATE TABLE transacciones_sin_indices (
    id_transaccion SERIAL PRIMARY KEY,
    id_cuenta INT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(15) CHECK (tipo IN ('deposito', 'retiro', 'transferencia')),
    descripcion TEXT
);

-- Crear una tabla CON ÍNDICES OPTIMIZADOS
CREATE TABLE transacciones_con_indices (
    id_transaccion SERIAL PRIMARY KEY,
    id_cuenta INT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(15) CHECK (tipo IN ('deposito', 'retiro', 'transferencia')),
    descripcion TEXT
);

-- Crear índices en la tabla con índices
CREATE INDEX idx_transacciones_cuenta ON transacciones_con_indices(id_cuenta);
CREATE INDEX idx_transacciones_fecha ON transacciones_con_indices(fecha);
CREATE INDEX idx_transacciones_cuenta_fecha ON transacciones_con_indices(id_cuenta, fecha);

-- analizar la inserción.
DELETE FROM indices.transacciones_con_indices ;
DELETE FROM indices.transacciones_sin_indices ;

-- Insertar 100,000 registros en ambas tablas para pruebas
EXPLAIN ANALYZE INSERT INTO transacciones_sin_indices (id_cuenta, fecha, monto, tipo, descripcion)
SELECT
    (random() * 10000)::INT,  -- ID de cuenta aleatorio entre 0 y 10,000
    NOW() - (random() * INTERVAL '365 days'), -- Fecha aleatoria en el último año
    (random() * 10000)::DECIMAL(10,2), -- Monto aleatorio
    (ARRAY['deposito', 'retiro', 'transferencia'])[floor(random() * 3) + 1], -- Tipo aleatorio
    'Transacción de prueba'
FROM generate_series(1, 100000);

EXPLAIN ANALYZE INSERT INTO transacciones_con_indices (id_cuenta, fecha, monto, tipo, descripcion)
SELECT id_cuenta, fecha, monto, tipo, descripcion
FROM transacciones_sin_indices;

-- Consultas con EXPLAIN ANALYZE para comparar rendimiento

-- Buscar todas las transacciones de una cuenta específica
EXPLAIN ANALYZE
SELECT * FROM transacciones_sin_indices WHERE id_cuenta = 1234;

EXPLAIN ANALYZE
SELECT * FROM transacciones_con_indices WHERE id_cuenta = 1234;

-- Buscar transacciones de una cuenta en los últimos 3 meses
EXPLAIN ANALYZE
SELECT * FROM transacciones_sin_indices WHERE id_cuenta = 1234 AND fecha > NOW() - INTERVAL '3 months';

EXPLAIN ANALYZE
SELECT * FROM transacciones_con_indices WHERE id_cuenta = 1234 AND fecha > NOW() - INTERVAL '3 months';

-- Contar transacciones en un rango de fechas
EXPLAIN ANALYZE
SELECT COUNT(*) FROM transacciones_sin_indices WHERE fecha BETWEEN '2024-01-01' AND '2024-02-01';

EXPLAIN ANALYZE
SELECT COUNT(*) FROM transacciones_con_indices WHERE fecha BETWEEN '2024-01-01' AND '2024-02-01';

-- Buscar transacciones de gran monto
EXPLAIN ANALYZE
SELECT * FROM transacciones_sin_indices WHERE monto > 5000 AND tipo = 'retiro';

EXPLAIN ANALYZE
SELECT * FROM transacciones_con_indices WHERE monto > 5000 AND tipo = 'retiro';