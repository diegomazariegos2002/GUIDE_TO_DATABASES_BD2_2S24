#!/bin/bash

# Hace que el script termine inmediatamente si cualquier comando retorna un valor de error distinto de cero.
set -e

# Esperar a que PostgreSQL inicie completamente (cuando reciba conexionese es la bandera)
until pg_isready -U $POSTGRES_USER
do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Crear la extensión pgAgent

# -v ON_ERROR_STOP=1: Hace que psql (comando postgresql) termine inmediatamente si ocurre algún error.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pgagent;
EOSQL

# DUDAS EXTRAS

## ¿Qué es psql?

### psql es un programa cliente de PostgreSQL que permite conectarse a una base de datos y ejecutar comandos SQL.

## ¿Qué es una extensión en PostgreSQL?

### Las extensiones en PostgreSQL son módulos que permiten agregar funcionalidades a la base de datos.

## ¿Qué es pgAgent?

### pgAgent es una herramienta de programación de trabajos (jobs) para PostgreSQL que permite automatizar tareas
### como backups, mantenimiento de la base de datos y otras operaciones repetitivas. La extensión pgAgent necesita
### estar instalada en la base de datos para poder utilizar estas funcionalidades.