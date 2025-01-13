#!/bin/bash

# Esperar hasta que PostgreSQL esté completamente levantado antes de crear la stanza
until pg_isready -U $POSTGRES_USER; do
  echo "Esperando a que PostgreSQL esté listo..."
  sleep 2
done

# Crear la stanza de pgBackRest
#   --stanza: Nombre de la stanza
#   --log-level-console: Nivel de log en consola
#   stanza-create: Comando para crear la stanza
pgbackrest --stanza=bd2_2s24 --log-level-console=info stanza-create

echo "Stanza creada exitosamente"
