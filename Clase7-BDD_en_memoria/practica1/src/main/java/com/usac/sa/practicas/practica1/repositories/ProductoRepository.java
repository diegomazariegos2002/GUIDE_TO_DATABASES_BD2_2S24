package com.usac.sa.practicas.practica1.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.stereotype.Repository;

import com.usac.sa.practicas.practica1.models.Producto;

/**
 * @author DiegoMazariegos
 */

@Repository
@RepositoryRestResource(exported = false)
public interface ProductoRepository extends CrudRepository<Producto, Object>{
    
    List<Producto> findAllByOrderByPrecioAsc();
    
    List<Producto> findAllByOrderByPrecioDesc();

    List<Producto> findAllByOrderByCantidadAsc();
    
    List<Producto> findAllByOrderByCantidadDesc();

    List<Producto> findAllByOrderByPrecioAscCantidadAsc();
    
    List<Producto> findAllByOrderByPrecioDescCantidadDesc();

    List<Producto> findByNombre(String nombre);
}
