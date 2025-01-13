package com.example.spring.db2.demo.repositories;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.example.spring.db2.demo.models.Demo;
import java.util.List;


@Repository
public interface DemoRepository extends CrudRepository<Demo, Object> {
    
    public Optional<Demo> findById(Long id);

}
