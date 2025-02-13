package com.usac.sa.practicas.practica1.exceptions;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * @author DiegoMazariegos
 * @description Clase que maneja las excepciones personalizadas de la aplicacion
 *              sirviendo como interceptor de errores para los controladores.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<Object> handleCustomException(CustomException ex) {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("timestamp", Instant.now().toString());
        errorResponse.put("status", ex.getError().getEstadoHttp());
        errorResponse.put("error", ex.getMessage());

        if (ex.getMessageOverwrite() != null) {
            errorResponse.put("detailMessage", ex.getMessageOverwrite());
        }

        return ResponseEntity.status(ex.getError().getEstadoHttp()).body(errorResponse);
    }
}