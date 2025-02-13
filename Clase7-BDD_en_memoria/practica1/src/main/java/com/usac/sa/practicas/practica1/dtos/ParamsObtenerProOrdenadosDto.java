package com.usac.sa.practicas.practica1.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * @author DiegoMazariegos
 * @date 12/02/2025
 * @description DTO para los parametros del endpoint invocado.
 */
@Data
public class ParamsObtenerProOrdenadosDto {
    @NotBlank(message = "El ordenPrecio es requerido")
    @Pattern(regexp = "asc|desc", message = "El ordenPrecio debe ser 'asc' o 'desc'")
    private String ordenPrecio;
    @NotBlank(message = "El ordenCantidad es requerido")
    @Pattern(regexp = "asc|desc", message = "El ordenCantidad debe ser 'asc' o 'desc'")
    private String ordenCantidad;
}
