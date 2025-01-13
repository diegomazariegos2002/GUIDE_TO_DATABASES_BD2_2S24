package com.example.spring.db2.demo.services;

import com.example.spring.db2.demo.commons.CommonSvc;
import com.example.spring.db2.demo.dtos.ResponseFindByIdDto;
import com.example.spring.db2.demo.models.Demo;

/**
 * Interfaz de servicios de la entidad Demo
 * @version 1.0
 * @created OCT-2024
 * @autor Mazariegos
 */

public interface DemoSvc extends CommonSvc<Demo>{
    
    public ResponseFindByIdDto findById(Long id);

}
