/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.usac.sa.practicas.practica1.commons;

import java.util.Optional;
import org.springframework.transaction.annotation.Transactional;

import com.usac.sa.practicas.practica1.exceptions.CustomException;
import com.usac.sa.practicas.practica1.exceptions.ErrorEnum;

import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.repository.CrudRepository;

/**
 *
 * @author DiegoMazariegos
 * @param <E>
 * @param <R>
 */
public class CommonSvcImpl<E, R extends CrudRepository<E, Object>> implements CommonSvc<E> {

    protected final R repository;

    public CommonSvcImpl(R repository) {
        this.repository = repository;
    }

    @Override
    @Transactional(readOnly = true)
    public Iterable<E> findAll() {
        return repository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<E> findById(Object id) {
        return repository.findById(id);
    }

    @Override
    @Transactional
    public E save(E entity) {
        try {
            return repository.save(entity);
        } catch (DataAccessException e) {
            throw new CustomException(ErrorEnum.I_OBJETO_INVALIDO, "Error de integridad en la base de datos.", e);
        } 
        catch (Exception e) {
            throw new CustomException(ErrorEnum.I_DESCONOCIDO, "Error inesperado al guardar la entidad.", e);
        }
    }

    @Override
    @Transactional
    public void deleteById(Object id) {
        if (!repository.existsById(id)) {
            throw new CustomException(ErrorEnum.N_OBJETO_NO_EXISTE);
        }
        try {
           repository.deleteById(id);
        } catch (DataIntegrityViolationException e) {
            throw new CustomException(ErrorEnum.I_OBJETO_NO_ACTUALIZADO, "Error de integridad en la base de datos.", e);
        } catch (Exception e) {
            throw new CustomException(ErrorEnum.I_DESCONOCIDO, "Error inesperado al guardar la entidad.", e);
        }
    }

    @Override
    @Transactional
    public Iterable<E> saveAll(Iterable<E> entities) {
        return repository.saveAll(entities);
    }
}
