package com.example.spring.db2.demo.services.impl;

import org.springframework.stereotype.Service;

import com.example.spring.db2.demo.commons.CommonSvcImpl;
import com.example.spring.db2.demo.dtos.ResponseFindByIdDto;
import com.example.spring.db2.demo.exceptions.ErrorEnum;
import com.example.spring.db2.demo.exceptions.MSControllerException;
import com.example.spring.db2.demo.models.Demo;
import com.example.spring.db2.demo.repositories.DemoRepository;
import com.example.spring.db2.demo.services.DemoSvc;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DemoSvcImpl extends CommonSvcImpl<Demo, DemoRepository> implements DemoSvc {
    @Override

    public ResponseFindByIdDto findById(Long id) {
        Demo demoRes = this.repository.findById(id)
                .orElseThrow(() -> new MSControllerException(ErrorEnum.I_FALLO_SERVICIO));

        return new ResponseFindByIdDto(demoRes.getName());
    }

}
