package com.example.spring.db2.demo.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * DTO para la respuesta de la busqueda por id
 * @version 1.0
 * @created OCT-2024
 * @autor Mazariegos
 */

@Data
public class RequestFindByIdDto {

    @NotBlank(message = "El id es requerido")
    @Pattern(regexp = "^\\d*$", message = "El id debe ser numerico")
    private Long id;

}
