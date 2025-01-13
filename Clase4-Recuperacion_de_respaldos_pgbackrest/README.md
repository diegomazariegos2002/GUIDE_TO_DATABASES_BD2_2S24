# Clase #4 - Recuperación de respaldos con pgbackrest 

En esta clase se abordarán los siguientes temas: 

- Introducción a las estrategias de recuperación de datos
- Recuperación de bases de datos utilizando respaldos completos
- Recuperación con respaldos incrementales y diferenciales
- Técnicas avanzadas de recuperación de datos
- Simulación de pérdida de datos: escenarios de recuperación
- Herramientas y utilidades para la recuperación de bases de datos
- Caso práctico: recuperación de una base de datos tras un fallo simulado, generado diversos backups con pgbackrest y restaurando en frío la base  de datos.

## Pgbackrest y su relación con postgresql

Pgbackrest es una herramienta de respaldo y restauración de bases de datos PostgreSQL que se enfoca en la simplicidad y velocidad. Proporciona una solución de respaldo de alto rendimiento para entornos de producción críticos donde el tiempo de respaldo y restauración es importante.

De forma nativa postgresql no cuenta con herramientas de respaldo y restauración de tipo diferencial o incremental, por lo que pgbackrest se convierte en una herramienta muy útil para realizar respaldos de este tipo.

Tomar en cuenta los siguientes conceptos a la hora de trabajar con pgbackrest:

- **Stanza**: Es un conjunto de configuraciones que se utilizan para respaldar una base de datos. Cada stanza tiene su propio conjunto de configuraciones y directorios de respaldo.

- **WALL (Write-Ahead Logging)**: Es un mecanismo de registro de transacciones que garantiza la integridad de los datos en caso de fallo del sistema. Los archivos de registro de transacciones (WAL) contienen todos los cambios realizados en la base de datos.

- **Archive**: Es el proceso de almacenar los archivos de registro de transacciones (WAL) en un repositorio de respaldo.

- **Replikation**: Es el proceso de copiar los archivos de registro de transacciones (WAL) de un servidor a otro para mantener una copia de seguridad en tiempo real.

-- **pgbackrest.conf**: Es el archivo de configuración principal de pgbackrest. Contiene las configuraciones de cada stanza, como la ubicación del repositorio de respaldo, la configuración de compresión, la configuración de retención de respaldo, etc.

## Backups y Respaldos PostgreSQL (Método 2: pgbackrest)

### Creación de la imagen de Docker con pgbackrest

```sh
# Crear la imagen de Docker con pgbackrest
docker build -t postgres-pgbackrest .
```

### Creación de contenedor de Docker con pgbackrest

```sh
# Crear contenedor de Docker con pgbackrest
docker run -d `
  --name postgres `
  -v rutaDB:/var/lib/postgresql/data `
  -v rutaBackups:/backups `
  -p 5432:5432 `
  postgres-pgbackrest
```

Ejemplo de creación de contenedor de Docker con pgbackrest

```sh
# Crear contenedor de Docker con pgbackrest
docker run -d `
  --name postgres `
  -v C:\proyectos\GUIDE_TO_DATABASES_BD2_2S24\Clase4-Recuperacion_de_respaldos_pgbackrest\src\pg1-path:/var/lib/postgresql/data `
  -v C:\proyectos\GUIDE_TO_DATABASES_BD2_2S24\Clase4-Recuperacion_de_respaldos_pgbackrest\src\backups:/backups `
  -p 5432:5432 `
  postgres-pgbackrest
```

### Configuración inicial de pgbackrest.conf (opcional)
Instrucciones para crear stanza en pgbackrest (Aunque también existe el .sh que se manda a llamar desde el Dockerfile para crear la stanza de forma automática).

Ejecución de comandos en el contenedor de postgres (opcional)

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