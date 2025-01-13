package com.example.spring.db2.demo.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.spring.db2.demo.commons.CommonController;
import com.example.spring.db2.demo.dtos.RequestFindByIdDto;
import com.example.spring.db2.demo.dtos.ResponseFindByIdDto;
import com.example.spring.db2.demo.exceptions.ErrorEnum;
import com.example.spring.db2.demo.exceptions.MSControllerException;
import com.example.spring.db2.demo.models.Demo;
import com.example.spring.db2.demo.services.DemoSvc;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import jakarta.validation.Valid;

/**
 * Controlador de la entidad Demo
 * @version 1.0
 * @created OCT-2024
 * @autor Mazariegos
 */

@Api
@RestController
@RequestMapping("/demo")
public class DemoController extends CommonController<Demo, DemoSvc> {

    /**
     * Metodo para buscar por id
     * @param id
     * @return
     * @version 1.0
     * @created OCT-2024
     * @autor Mazariegos
     */
    @GetMapping("/findByIdDemo")
    @ApiOperation(value = "Buscar por id", notes = "Retorna un objeto por id")
    public ResponseEntity<ResponseFindByIdDto> findByIdDemo(@Valid RequestFindByIdDto request,
            BindingResult result) throws MSControllerException {
        
        if (result.hasErrors()) {
            result.getFieldErrors().forEach(err -> {
                throw new MSControllerException(ErrorEnum.I_PARAMETROS_INVALIDADOS, err.getDefaultMessage());
            });
        }
        
        return ResponseEntity.ok(this.service.findById(request.getId()));
    }

}
