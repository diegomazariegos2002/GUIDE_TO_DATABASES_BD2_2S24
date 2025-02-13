package com.usac.sa.practicas.practica1.commons;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

import com.usac.sa.practicas.practica1.exceptions.CustomException;
import com.usac.sa.practicas.practica1.exceptions.ErrorEnum;

public class CommonController<E, S extends CommonSvc<E>, V extends CommonValidatorSvc<E>> {

    protected final S service;
    protected final V validator;

    public CommonController(S service, V validator) {
        this.service = service;
        this.validator = validator;
    }

    @GetMapping
    @Operation(summary = "Consulta el listado de objetos")
    @ApiResponse(responseCode = "200", description = "Lista obtenida con éxito",
    content = @Content(mediaType = "application/json",
        schema = @Schema(type = "array", implementation = Object[].class)))
    public ResponseEntity<Object> findAll(
        @RequestHeader(name = "Accept-Languaje", required = false) Locale locale) {
        return ResponseEntity.ok().body(service.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Consulta un objeto especifico")
    public ResponseEntity<Object> findById(
            @Parameter(description = "id") @PathVariable(required = true) Long id,
            @RequestHeader(name = "Accept-Languaje", required = false) Locale locale) {
        Optional<E> o = service.findById(id);
        if (!o.isPresent()) {
            throw new CustomException(ErrorEnum.N_OBJETO_NO_EXISTE);
        }
        return ResponseEntity.ok(o.get());
    }

    @PostMapping
    @Operation(summary = "Guarda la información de un objeto")
    public ResponseEntity<Object> save(
            @Valid @RequestBody E entity,
            BindingResult result,
            @RequestHeader(name = "Accept-Languaje", required = false) Locale locale) {
        if (result.hasErrors()) {
            return this.validar(result);
        }
        entity = this.validator.validate(entity);
        E entityDb = service.save(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(entityDb);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Elimina la información de un objeto")
    public ResponseEntity<Object> eliminar(
            @Parameter(description = "id") @PathVariable(required = true) Long id,
            @RequestHeader(name = "Accept-Languaje", required = false) Locale locale) {
        service.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    protected ResponseEntity<Object> validar(BindingResult result) {
        Map<String, Object> errores = new HashMap<>();
        result.getFieldErrors().forEach(
            err -> errores.put(err.getField(), 
                " El campo " + err.getField() + " " + err.getDefaultMessage())
        );
        return ResponseEntity.badRequest().body(errores);
    }

    protected void validateResultParams(BindingResult result) {
        if (result.hasErrors()) {
            result.getFieldErrors().forEach(err -> {
                throw new CustomException(ErrorEnum.I_PARAMETROS_INVALIDADOS, err.getDefaultMessage());
            });
        }
    }
}
