package com.usac.sa.practicas.practica1.services;

import java.util.List;

import com.usac.sa.practicas.practica1.commons.CommonSvc;
import com.usac.sa.practicas.practica1.dtos.ParamsObtenerProOrdenadosDto;
import com.usac.sa.practicas.practica1.exceptions.CustomException;
import com.usac.sa.practicas.practica1.models.Producto;

/**
 * @author adamazari
 */
public interface ProductoSvc extends CommonSvc<Producto>{
    public List<Producto> obtenerProductosOrdenados(ParamsObtenerProOrdenadosDto params);
    public List<Producto> buscarPorNombre(String nombre) throws CustomException;
}
