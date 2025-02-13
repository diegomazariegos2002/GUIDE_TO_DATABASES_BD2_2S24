/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.usac.sa.practicas.practica1.commons;

import java.util.Optional;

/**
 *
 * @author DiegoMazariegos
 * @param <E>
 */
public interface CommonSvc<E> {
    
    public Iterable<E> findAll();
	
    public Optional<E> findById(Object id);

    public E save(E entity);

    public void deleteById(Object id);
    
    public Iterable<E> saveAll(Iterable<E> listEntity);
    
    
}
