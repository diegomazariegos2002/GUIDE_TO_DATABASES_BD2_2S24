# MONGODB CON DOCKER

## Prerequisitos (Windows - opcional)

1. Instalar Docker Desktop
2. Habilitar WSL2
3. Instalar WSL2
4. Instalar Mongosh (MongoDb Shell)

### Pasos para instalar Mongosh (Opcional)

#### 1. Descargar el instalador (MSI) de la página oficial de MongoDB

![](images/image_2024-09-18-09-21-26.png)

https://www.mongodb.com/docs/mongodb-shell/install/

https://www.mongodb.com/try/download/shell

#### 2. Ejecutar el instalador y seguir los pasos

![](images/image_2024-09-18-09-22-38.png)

![](images/image_2024-09-18-09-26-24.png)

## Pasos para instalar MongoDB con Docker (2 formas)

### 1. Forma 1

#### 1.1. Pull the MongoDB Docker Image
````bash
docker pull mongodb/mongodb-community-server:latest
````

#### 1.2. Run the Image as a Container

````bash
docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest
````

#### 1.3. Verify the Container is Running

````bash
docker ps
````

### 2. Forma 2

#### 2.1. Using Docker-Compose

*Nota: * siempre tomar en cuenta modificar la ruta del volumen si se desea otra.

```bash
docker-compose up -d
```

### 3 Verificar que el contenedor está corriendo

```bash
docker ps
```

### 4.1. Connect to the MongoDB Container (Mongosh)

````bash
mongosh --port 27017
````

### 4.2. Connect to the MongoDB Container (Docker/Dbeaver)

#### 4.2.1. Si no aparece MongoDb en la lista de conexiones, hay que instalar el driver correspondiente.

![](images/image_2024-09-18-09-40-51.png)

![](images/image_2024-09-18-09-41-41.png)

![](images/image_2024-09-18-09-42-31.png)

![](images/image_2024-09-18-09-42-43.png)

#### 4.2.2. Introducir la siguiente url de driver en "Location" y hacer clic en "Download"

![](images/image_2024-09-18-09-45-27.png)

#### 4.2.2. Otra opción es descargar e instalar la versión pro o academica de Dbeaver.

https://dbeaver.com/academic-license/

![](images/image_2024-09-18-10-36-09.png)

### 4.2.1. Conectar a la base de datos

![](images/image_2024-09-18-10-56-02.png)

![](images/image_2024-09-18-11-05-04.png)

![](images/image_2024-09-18-11-05-17.png)


## Fuentes

https://www.mongodb.com/docs/manual/tutorial/install-mongodb-community-with-docker/?msockid=1c89de47c56c69132c7eca8bc470688f