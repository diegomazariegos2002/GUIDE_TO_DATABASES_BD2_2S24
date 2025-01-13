Estos sos los pasos para eliminar y limpiar todos tus archivos de docker, de modo que algunas cosas anteriores o proyectos que ya no uses ya no te consuman memoria o espacio en tu disco duro y puedas tener un mejor rendimiento en tu computadora.


### detener todos los contenedores
```sh
docker stop $(docker ps -aq)
```
* docker ps -aq lista todos los contenedores (en ejecución o detenidos).
* Con esto nos aseguramos de que no quede ningún contenedor corriendo.

### eliminar todos los contenedores
```sh
docker rm $(docker ps -aq)
```

### eliminar todas las imágenes
```sh
docker rmi $(docker images -aq)
```

### eliminar todos los volúmenes
opción más segura para eliminar todos los volúmenes, solo eliminará los volúmenes que no estén en uso.
```sh
docker volume prune -f
```

### eliminar todas las redes
opción más segura para eliminar redes que no estén en uso.
```sh
docker network prune -f
```

### Limpiar la caché de docker
Borra cachés de construcción usados por Docker para acelerar la creación de imágenes.
```sh
docker builder prune -af
```

### Limpieza general con un solo comando (opcional)
```sh
docker system prune -a --volumes -f
```

* -a (o --all) elimina todas las imágenes no usadas.
* --volumes elimina todos los volúmenes sin uso.
* -f evita que Docker te pregunte confirmaciones.
