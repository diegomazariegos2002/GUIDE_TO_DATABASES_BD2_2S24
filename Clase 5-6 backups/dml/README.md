# Clase 5-6 Backups (pgdump y pgbackrest)
## Full Backup PostgreSQL (Método 1: pgdump)

### Creación Full Backup

Plantilla Comando (**Recordar que estos comandos son ejecutados en powershell** por lo que la función de las fechas puede varias si se ejecuta en cmd, unix/linux/bash, etc...):

```sh
docker exec `
-t postgres `
pg_dumpall `
-c `
-U tu_usuario > /ruta/local/backups/backup_full_$(Get-Date -Format yyyy-MM-dd).sql
```

ejemplo:
```sh
docker exec `
-t postgres `
pg_dumpall `
-c `
-U admin > C:\proyectos\BD2_2S24_PRIVADO\src\backup\backup_full_$(Get-Date -Format yyyy-MM-dd).sql
```

*Nota: también existe el comando **pgdump** pero esto no hace respaldo de roels y tablaspace, pero puede ser utilizado para respaldar un único esquema o base de datos en el servidor postgreSQL*

### Restauración Full Backup

**Nota:** para que la restauración del backup funcione como tal, debe hacerse un drop y luego un create de la base de datos de la cual se hizo el backup.

Plantilla Comando (**Recordar que estos comandos son ejecutados en powershell** por lo que la función de las fechas puede varias si se ejecuta en cmd, unix/linux/bash, etc...):

```sh
Get-Content -Raw -Path "/ruta/local/backups/backup_full_yyyy-MM-dd.sql" | docker exec -i postgres psql -U username -d postgres
```

Ejemplo:

```sh
Get-Content -Raw -Path "C:\proyectos\BD2_2S24_PRIVADO\src\backup\backup_full_2024-07-28.sql" | docker exec -i postgres psql -U admin -d postgres
```

#### Comandos extras para hacer pruebas

```sh
docker exec -i postgres psql -U admin -d postgres -c "DROP DATABASE IF EXISTS bd2_2s24;"
```

```sh
docker exec -i postgres psql -U admin -d postgres -c "CREATE DATABASE bd2_2s24;"
```

## Backups y Respaldos PostgreSQL (Método 2: pgbackrest)

### Configuración inicial de pgbackrest.conf
Instrucciones para crear stanza en pgbackrest. Aunque también existe el .sh que se manda a llamar desde el Dockerfile para crear la stanza de forma automática.


Ejecución de comandos en el contenedor de postgres

```sh
docker exec -it postgres /bin/bash

# Cambiar contraseña de usuario root por sino se sabe la contraseña
passwd

# Entrar al usuario postgres
su - postgres

# ejecutar pgbackrest para ver que todo bien
pgbackrest

# sudo pg_ctlcluster 15 demo restart # reiniciar el cluster de postgres para que se apliquen los cambios

# Crear el stanza para realmente inicializar repositorio de backups en pgbackrest
pgbackrest --stanza=bd2_2s24 --log-level-console=info stanza-create

# Verificar que se haya creado la stanza
pgbackrest --stanza=bd2_2s24 --log-level-console=info check
```
El comando check de pgBackRest valida la configuración del repositorio, fuerza un cambio de archivo WAL en PostgreSQL, y verifica que el nuevo archivo WAL se archive correctamente en el repositorio de backups, asegurando así la integridad del sistema. Para más información ver la documentación.

```sh
# Para ver el contenido de los WALS generados previamente
#   se hace uso de postgresql y se ejecuta el siguiente comando

# Copiar el archivo de WAL a un directorio temporal
cp backups/archive/bd2_2s24/16-1/000000010000000000000002-3cad2728711cf03238922727f0828b0dcb571918.gz /tmp/

# Descomprimir el archivo de WAL
gunzip /tmp/000000010000000000000002-3cad2728711cf03238922727f0828b0dcb571918.gz

# Eliminar el sufijo hash del archivo de WAL descomprimido
mv /tmp/000000010000000000000002-3cad2728711cf03238922727f0828b0dcb571918 /tmp/000000010000000000000002

# Ver el contenido del archivo de WAL
pg_waldump /tmp/000000010000000000000002
```

### Creación de backups en pgbackrest

```sh
# Crear un backup completo (como no se especifica el tipo de backup, se asume incremental pero como no hay backups anteriores, se hace un full backup)
pgbackrest --stanza=bd2_2s24 --log-level-console=info backup

# si se quiere hacer un backup completo se puede hacer de la siguiente manera
pgbackrest --stanza=bd2_2s24 --type=full --log-level-console=info backup

# Crear un backup diferencial
pgbackrest --stanza=bd2_2s24 --type=diff --log-level-console=info backup

# Crear un backup incremental
pgbackrest --stanza=bd2_2s24 --type=incr --log-level-console=info backup

# Verificar que se haya creado el backup
pgbackrest info
```
Insertar datos en la base de datos para hacer pruebas de restauración y verificación de los backups.

### Restauración de backups en pgbackrest

#### Simulación local/Docker de error en la base de datos
```sh
# Sino se sabe el nombre de cluster de postgres (si se ejecuta local. En Contenderores es diferente)
pg_lsclusters

# Parar el servidor de postgres (local)
pg_ctlcluster version cluster stop
# Para el contenedor de postgres (docker)
docker stop postgres

# Causar una simulación de pérdida de datos (local)
rm /var/lib/postgresql/15/demo/global/pg_control
# Eliminar el file directamente del bind volumen (docker)

# Intentar iniciar el servidor de postgres (local)
pg_ctlcluster version cluster start
# Iniciar el contenedor de postgres (docker)

# Verificar que el servidor/contenedor de postgres no inicie (local/docker)

```
#### Restauración de base de datos con pgbackrest
```sh
# se necesita el servidor de postgres abajo y vaciar el directorio de datos (el directorio de datos es el directorio donde se almacenan los datos de la base de datos)

# Eliminar el contenido del directorio de datos
# (local) 
find /var/lib/postgresql/data -mindepth 1 -delete
# (docker) 
# *Detener contenedor original
# *Ejecutar contenedor temporal con directorio de la base de datos vacío
docker run -d `
  --name temporal-postgres `
  -v C:\proyectos\BD2_2S24_PRIVADO\src\pg1-path:/var/lib/postgresql/data `
  -v C:\proyectos\BD2_2S24_PRIVADO\src\backup:/backups `
  -p 5432:5432 `
  custom-postgres `
  bash -c "chown -R postgres:postgres /backups && su - postgres -c 'pgbackrest --stanza=bd2_2s24 --log-level-console=info restore'"


# Restaurar la base de datos comando (local)
pgbackrest --stanza=bd2_2s24 --log-level-console=info restore

# Iniciar el servidor de postgres (local)
pg_ctl start
```