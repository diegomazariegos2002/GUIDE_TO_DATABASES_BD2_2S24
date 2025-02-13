package com.usac.sa.practicas.practica1.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class ParamsBuscarPorNombreDto {
    @NotBlank(message = "El nombre no puede estar vacío.")
    @Pattern(regexp = "^[a-zA-Z0-9 ]+$", message = "El nombre contiene caracteres inválidos.")
    private String nombre;
}
