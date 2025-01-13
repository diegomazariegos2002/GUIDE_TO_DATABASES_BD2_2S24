package com.example.spring.db2.demo.controllers;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import com.example.spring.db2.demo.config.TestConfig;
import com.example.spring.db2.demo.dtos.ResponseFindByIdDto;
import com.example.spring.db2.demo.services.impl.DemoSvcImpl;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@ActiveProfiles("test")
@SpringBootTest(classes = TestConfig.class)
class DemoControllerTest {
    
    @Autowired
    private DemoSvcImpl demoSvcImpl;
    
    @Test
    @Transactional
    void testFindByIdDemo() {
        log.info("Start testFindByIdDemo");

        Long idMock = 1L;

        ResponseFindByIdDto result = demoSvcImpl.findById(idMock);
        log.info("result {}", result);

        log.info("End testFindByIdDemo");
    }


}
