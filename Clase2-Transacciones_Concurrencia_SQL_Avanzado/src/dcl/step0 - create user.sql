-- DDL solo para ejemplificar el uso de DCL
-- Básicamente se crean dos roles y dos usuarios, y se les asignan permisos
-- esto es útil para tener un control más fino sobre los permisos de los usuarios
-- y para evitar que se les otorguen permisos de más por error.

-- Cabe resaltar que los permisos son algo común en todos los motores de bases de datos
-- pero la sintaxis puede variar un poco, por lo que es importante revisar la documentación.

-- Crear usuario
CREATE USER admin2 WITH PASSWORD 'securepassword';

-- Asignar permisos
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin2;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin2;

-- Asegurar que los futuros objetos también reciban estos permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO admin2;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO admin2;
