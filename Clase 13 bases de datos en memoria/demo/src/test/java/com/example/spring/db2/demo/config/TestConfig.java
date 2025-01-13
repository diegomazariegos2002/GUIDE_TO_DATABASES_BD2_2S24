package com.example.spring.db2.demo.config;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Profile;

@TestConfiguration
@Profile({"test", "integration"})
public class TestConfig {
    
}