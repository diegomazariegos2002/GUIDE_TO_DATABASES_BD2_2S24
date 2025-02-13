package com.usac.sa.practicas.practica1.controllers;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.usac.sa.practicas.practica1.commons.CommonController;
import com.usac.sa.practicas.practica1.dtos.ParamsBuscarPorNombreDto;
import com.usac.sa.practicas.practica1.dtos.ParamsObtenerProOrdenadosDto;
import com.usac.sa.practicas.practica1.models.Producto;
import com.usac.sa.practicas.practica1.services.ProductoSvc;
import com.usac.sa.practicas.practica1.validators.ProductoValidator;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

/**
 * @author DiegoMazariegos
 */
@RestController
@RequestMapping("/producto")
@Tag(name = "Productos", description = "API para gestionar productos")
public class ProductoController extends CommonController<Producto, ProductoSvc, ProductoValidator> {

    public ProductoController(ProductoSvc service, ProductoValidator validator) {
        super(service, validator);
    }

    /**
     * @author DiegoMazariegos
     * @date 12/02/2025
     * @description Obtiene la lista de productos ordenados por precio y/o cantidad
     * @param params
     * @param result
     * @return lista de productos
     */
    @GetMapping("/ordenados")
    @Operation(summary = "Obtiene la lista de productos ordenados por precio y/o cantidad")
    public ResponseEntity<List<Producto>> obtenerProductosOrdenados(
            @Valid @RequestBody ParamsObtenerProOrdenadosDto params,
            BindingResult result) {
        this.validateResultParams(result);
        List<Producto> productos = service.obtenerProductosOrdenados(params);
        return ResponseEntity.ok(productos);
    }

    /**
     * @author DiegoMazariegos
     * @date 12/02/2025
     * @description Busca un producto por su nombre
     * @param param
     * @return Lista de Productos que coinciden con el nombre
     */
    @GetMapping("/buscar-por-nombre")
    @Operation(summary = "Busca un producto por su nombre")
    public ResponseEntity<List<Producto>> buscarPorNombre(
        @Valid @RequestBody ParamsBuscarPorNombreDto params,
        BindingResult result
    ) {
        this.validateResultParams(result);
        List<Producto> productos = service.buscarPorNombre(params.getNombre());
        return ResponseEntity.ok(productos);
    }
}
