# Imagen oficial de PostgreSQL
FROM postgres:latest

# Variables de entorno para la configuración de PostgreSQL
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=root1234
ENV POSTGRES_DB=bd2_2s24

# Crear directorio en el contenedor para los backups
# Permisos de lectura para el usuario comunmente postgres que es el que ejecuta el servicio de pgbackrest.
# Nota: Se recomienda montar un volumen para almacenar los backups en el host
RUN mkdir -p /backups \
    && chmod 750 /backups \
    && chown postgres:postgres /backups

# Configurar PostgreSQL para habilitar los logs detallados
RUN echo "log_min_messages = info" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "client_min_messages = notice" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "log_statement = 'all'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "log_duration = on" >> /usr/share/postgresql/postgresql.conf.sample

# Configurar el archivo postgresql.conf para habilitar el modo WAL y el archivado.
#   Con el fin de tener respaldo continuo.

## * WAL_LEVEL = replica: Establece el nivel de detalle en los logs de WAL. 
##      El nivel replica incluye suficiente información para soportar la replicación de la base de datos
##      y los backups incrementales. WAL (Write-Ahead Logging) asegura que todos los cambios realizados 
##      en la base de datos se registren primero en un log antes de aplicarse. Esto permite recuperar 
##      la base de datos hasta el último estado consistente en caso de fallos.

## * ARCHIVE_MODE = on: Activa el modo de archivado, permitiendo que los WAL logs sean archivados.

## * ARCHIVE_COMMAND = pgbackrest --stanza=bd2_2s24 archive-push %p:
##      Comando que se ejecuta para archivar los WAL logs.
##      %p: Ruta del archivo WAL log a archivar.
##      --stanza=bd2_2s24: Nombre de la stanza a la que pertenecen los WAL logs.
##      archive-push: Comando de pgBackRest para archivar los WAL logs.

## * MAX_WAL_SENDERS = 3: Número máximo de conexiones de replicación simultáneas permitidas.

RUN echo "wal_level = replica" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "archive_mode = on" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "archive_command = 'pgbackrest --stanza=bd2_2s24 archive-push %p'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "max_wal_senders = 3" >> /usr/share/postgresql/postgresql.conf.sample

# Instalar pgBackRest (Herramienta para gestión de backups en posgreSQL)
RUN apt-get update && apt-get install -y pgbackrest

# Crear directorio para la configuración de pgBackRest
RUN mkdir -p /etc/pgbackrest

# Copiar el archivo de configuración local al contenedor
COPY ./scripts/pgbackrest.conf /etc/pgbackrest/pgbackrest.conf

# Script para inicializar pgBackRest y crear la stanza automáticamente
COPY ./scripts/initialize_pgbackrest.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/initialize_pgbackrest.sh

# INICIO FIX

## Instalar pgAgent para evitar error de extensión no encontrada
RUN apt-get update && apt-get install -y pgagent

## Script para crear la extensión pgAgent después de iniciar PostgreSQL
COPY ./scripts/create_pgagent_extension.sh /docker-entrypoint-initdb.d/create_pgagent_extension.sh
### Dar permisos de ejecución al script
RUN chmod +x /docker-entrypoint-initdb.d/create_pgagent_extension.sh

# FIN FIX

# Crear un directorio para scripts de inicialización (opcional)
# COPY init.sql /docker-entrypoint-initdb.d/

# Exponer el puerto PostgreSQL
EXPOSE 5432

# Comando para ejecutar PostgreSQL
CMD ["postgres"]
 