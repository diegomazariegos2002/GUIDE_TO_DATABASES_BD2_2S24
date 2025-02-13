package com.usac.sa.practicas.practica1.commons.abs;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.util.CollectionUtils;

import com.usac.sa.practicas.practica1.exceptions.CustomException;
import com.usac.sa.practicas.practica1.exceptions.ErrorEnum;

/**
 * @author DiegoMazariegos
 */
public class AbstractValidator {
 /**
     * <p>Metodo que valida que el valor no sea nulo o espacios en blanco.</p>
     * 
     * @param valor Valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor es nulo o cadena en blanco
     */
    protected void blanks(String valor, ErrorEnum error) throws CustomException {
        if(StringUtils.isBlank(valor)){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si un valor es nulo.</p>
     * 
     * @param valor Valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor es nulo
     */
    protected void nulls(Object valor, ErrorEnum error) throws CustomException {
        if(valor == null){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si un valor es nulo.</p>
     * 
     * @param valor Valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor es nulo
     */
    protected void collectionNulls(Collection<?> valor, ErrorEnum error) throws CustomException {
        if(CollectionUtils.isEmpty(valor)){
            throw  new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si un valor cumple con cierta expresion regular.</p>
     * 
     * @param valor Valor a verificar
     * @param regex Expresion regular que debe cumplir el valor
     * @param error Codigo de error que se debe de lanzar
     * @throws CustomException Si el valor no cumple con la expresion regular
     */
    protected void matches(String valor, String regex, ErrorEnum error) throws CustomException {
        if(StringUtils.isNotBlank(valor) && !valor.matches(regex)){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si una cadena excede una longitud determinada.</p>
     * 
     * @param valor Valor a verificar
     * @param longitud Longitud maxima aceptada
     * @param error Codigo de error que se debe de lanzar
     * @throws CustomException Si el valor excede la longitud indicada
     */
    protected void lengths(String valor, int longitud, ErrorEnum error) 
            throws CustomException {
        
        String str = StringUtils.trim(valor);
        if(StringUtils.isNotBlank(str) && (str.length() > longitud)) {
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si una cadena se encuentra en un rango de longitud
     * determinado.</p>
     * 
     * @param valor Valor a verificar
     * @param longitudMin Longitud minima aceptada
     * @param longitudMax Longitud maxima aceptada
     * @param pError Codigo de error que se debe de lanzar
     * @throws CustomException Si el valor excede la longitud indicada
     */
    protected void lengths(String valor, int longitudMin, int longitudMax, 
            ErrorEnum pError) throws CustomException {
        
        String str = StringUtils.trim(valor);
        boolean bandera = StringUtils.isNotBlank(str) 
                && ((str.length() < longitudMin)
                || (str.length() > longitudMax));
        if(bandera) {
            throw new CustomException(pError);
        }
    }
    
    /**
     * <p>Metodo que valida que la primer fecha sea menor a la segunda fecha.</p>
     * 
     * @param fecha1 Fecha a verificar
     * @param fecha2 Fecha que no se debe sobrepasar
     * @param error Codigo de error que se debe de lanzar
     * @throws CustomException Si la fecha 1 es mayor a la fecha 2
     */
    protected void future(Date fecha1, Date fecha2, ErrorEnum error) 
            throws CustomException {
        if(DateUtils.truncatedCompareTo(fecha1, fecha2, Calendar.DAY_OF_MONTH) > 0) {
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida que la primer fecha sea menor a la segunda fecha tomando en cuenta el tiempo.</p>
     * 
     * @param fecha1 Fecha a verificar
     * @param fecha2 Fecha que no se debe sobrepasar
     * @param error Codigo de error que se debe de lanzar
     * @throws CustomException Si la fecha 1 es mayor a la fecha 2 tomando en cuenta el tiempo
     */
    protected void futureTime(Date fecha1, Date fecha2, ErrorEnum error) 
            throws CustomException {
        if(fecha1.getTime() > fecha2.getTime()) {
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si la cadena cumple con un formato de fecha
     * especifico.</p>
     * 
     * @param fecha Cadena a verificar
     * @param pattern Formato de fecha que debe cumplir la cadena
     * @param error Codigo de error que se debe de lanzar
     * @return Date Objeto creado a partir de la cadena o nulo si la cadena es
     *         vacia o nulo
     * @throws CustomException Si la cadena no cumple con el formato
     */
    protected Date matchesDate(String fecha, String pattern, ErrorEnum error) 
            throws CustomException {
        if(StringUtils.isNotBlank(fecha)) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                sdf.setLenient(false);
                return sdf.parse(fecha);
            } catch (ParseException e) {
                throw new CustomException(error, e);
            }
        } else {
            return null;
        }
    }
            
    /**
     * <p>Metodo que valida si una coleccion contiene un determinado item.</p>
     * 
     * @param collection Coleccion a verificar
     * @param valor Valor a buscar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor no esta en la coleccion.
     */
    protected void contains(Collection<?> collection, Object valor, ErrorEnum error) throws CustomException {
        if(!collection.contains(valor)){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si existe un elemento.</p>
     * 
     * @param valor Valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor existe.
     */
    protected void exists(Optional<?> valor, ErrorEnum error) throws CustomException {
        if(valor.isPresent()){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si existe un elemento.</p>
     * 
     * @param collection Coleccion a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si la coleccion no esta vacia.
     */
    protected void collectionExists(Collection<?> collection, ErrorEnum error) throws CustomException {
        if(!CollectionUtils.isEmpty(collection)){
           throw new CustomException(error); 
        }
    }
    
    /**
     * <p>Metodo que valida si una lista solo contiene un determinado item y sus excepciones.</p>
     * 
     * @param list
     * @param target
     * @param exceptions
     * @return
     *         true si existe solo el item y sus excepciones
     *         false si la lista contiene otros items o no contiene el item
     */
    public <T> boolean onlyItemExistsCollection(List<T> list, List<T> targets) {
        return list.stream().allMatch(targets::contains);
    }
    
    /**
     * <p>Metodo que valida si los valores son iguales.</p>
     * 
     * @param valor1 primer valor a verificar
     * @param valor2 segundo valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si los valores son iguales
     */
    protected void equals(Object valor1, Object valor2, ErrorEnum error) throws CustomException{
        if(Objects.equals(valor1, valor2)){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si los valores no son iguales.</p>
     * 
     * @param valor1 primer valor a verificar
     * @param valor2 segundo valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si los valores no son iguales
     */
    protected void notEquals(Object valor1, Object valor2, ErrorEnum error) throws CustomException{
        if(!Objects.equals(valor1, valor2)){
            throw new CustomException(error);
        }
    }
    
    /**
     * <p>Metodo que valida si un valor es diferente a null.</p>
     * 
     * @param valor Valor a verificar
     * @param error Codigo de error que se debe lanzar
     * @throws CustomException Si el valor es diferente a null
     */
    protected void notNull(Object valor, ErrorEnum error) throws CustomException {
        if(valor != null){
            throw new CustomException(error);
        }
    }
    
    protected void userValidator(String user, ArrayList<String> users) throws CustomException {
        boolean exist = false;
        for (String user1 : users) {
            if (user.equals(user1)) {
                exist = true;
            }
        }
        if (!exist) {
            throw new CustomException(ErrorEnum.S_USUARIO_NO_EXISTENTE);
        }
    }
    
    protected void mensajeDeError(ErrorEnum error) throws CustomException {
        throw new CustomException(error);
    }
}
