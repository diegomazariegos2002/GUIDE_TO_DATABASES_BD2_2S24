package com.usac.sa.practicas.practica1.services.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.usac.sa.practicas.practica1.commons.CommonSvcImpl;
import com.usac.sa.practicas.practica1.dtos.ParamsObtenerProOrdenadosDto;
import com.usac.sa.practicas.practica1.exceptions.CustomException;
import com.usac.sa.practicas.practica1.models.Producto;
import com.usac.sa.practicas.practica1.repositories.ProductoRepository;
import com.usac.sa.practicas.practica1.services.ProductoSvc;

/**
 * @author DiegoMazariegos
 */
@Service
public class ProductoSvcImpl extends CommonSvcImpl<Producto, ProductoRepository>
        implements ProductoSvc {

    public ProductoSvcImpl(ProductoRepository repository) {
        super(repository);
    }

    @Override
    public List<Producto> obtenerProductosOrdenados(ParamsObtenerProOrdenadosDto params) {
        String ordenPrecio = params.getOrdenPrecio();
        String ordenCantidad = params.getOrdenCantidad();
        if ("asc".equalsIgnoreCase(ordenPrecio) && "asc".equalsIgnoreCase(ordenCantidad)) {
            return repository.findAllByOrderByPrecioAscCantidadAsc();
        } else if ("desc".equalsIgnoreCase(ordenPrecio) && "desc".equalsIgnoreCase(ordenCantidad)) {
            return repository.findAllByOrderByPrecioDescCantidadDesc();
        } else if ("asc".equalsIgnoreCase(ordenPrecio)) {
            return repository.findAllByOrderByPrecioAsc();
        } else if ("desc".equalsIgnoreCase(ordenPrecio)) {
            return repository.findAllByOrderByPrecioDesc();
        } else if ("asc".equalsIgnoreCase(ordenCantidad)) {
            return repository.findAllByOrderByCantidadAsc();
        } else if ("desc".equalsIgnoreCase(ordenCantidad)) {
            return repository.findAllByOrderByCantidadDesc();
        } 
        return (List<Producto>) repository.findAll();
    }

    @Override
    public List<Producto> buscarPorNombre(String nombre) throws CustomException {
        return repository.findByNombre(nombre);
    }
}
