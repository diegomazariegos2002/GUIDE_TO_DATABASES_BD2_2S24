-- DDL solo para ejemplificar el uso de DCL

-- Crear usuario
CREATE USER admin2 WITH PASSWORD 'securepassword';

-- Asignar permisos
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin2;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin2;

-- Asegurar que los futuros objetos también reciban estos permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO admin2;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO admin2;
