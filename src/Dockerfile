# Imagen oficial de PostgreSQL
FROM postgres:latest

# Variables de entorno para la configuración de PostgreSQL
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=root1234
ENV POSTGRES_DB=bd2_2s24

# Crear directorio en el contenedor para los backups
RUN mkdir -p /backups

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

## * ARCHIVE_COMMAND = 'test ! -f /backups/%f && cp %p /backups/%f': Define el comando para archivar
##      los WAL logs. Este comando verifica si el archivo ya existe en /backups y, si no existe, copia el archivo.

RUN echo "wal_level = replica" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "archive_mode = on" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "archive_command = 'test ! -f /backups/%f && cp %p /backups/%f'" >> /usr/share/postgresql/postgresql.conf.sample

# Instalar pgBackRest (Herramienta para gestión de backups en posgreSQL)
RUN apt-get update && apt-get install -y pgbackrest

# Crear directorio para la configuración de pgBackRest
RUN mkdir -p /etc/pgbackrest

# Copiar el archivo de configuración local al contenedor
COPY pgbackrest.conf /etc/pgbackrest/pgbackrest.conf

# INICIO FIX

## Instalar pgAgent para evitar error de extensión no encontrada
RUN apt-get update && apt-get install -y pgagent

## Script para crear la extensión pgAgent después de iniciar PostgreSQL
COPY create_pgagent_extension.sh /docker-entrypoint-initdb.d/create_pgagent_extension.sh
### Dar permisos de ejecución al script
RUN chmod +x /docker-entrypoint-initdb.d/create_pgagent_extension.sh

# FIN FIX

# Crear un directorio para scripts de inicialización (opcional)
# COPY init.sql /docker-entrypoint-initdb.d/

# Exponer el puerto PostgreSQL
EXPOSE 5432

# Comando para ejecutar PostgreSQL
CMD ["postgres"]
 