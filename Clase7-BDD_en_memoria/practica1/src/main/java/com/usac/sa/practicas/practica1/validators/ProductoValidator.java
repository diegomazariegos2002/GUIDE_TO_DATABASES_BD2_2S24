package com.usac.sa.practicas.practica1.validators;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.usac.sa.practicas.practica1.commons.CommonValidatorSvc;
import com.usac.sa.practicas.practica1.commons.abs.AbstractValidator;
import com.usac.sa.practicas.practica1.models.Producto;

/**
 * @author DiegoMazariegos
 */
@Component("productoValidator")
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class ProductoValidator extends AbstractValidator implements CommonValidatorSvc<Producto> {

    @Override
    public Producto validate(Producto e) {
        return e;
    }

}
