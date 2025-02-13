package com.usac.sa.practicas.practica1.exceptions;

/**
 *
 * @author DiegoMazariegos
 */
public class EstadoHttp {
    /**
     * <p>Codigo estandar para respuestas de exito.</p>
     */
    public static final int OK = 200;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de exito que crearon un nuevo recurso.</p>
     */
    public static final int CREATED = 201;
//______________________________________________________________________________
    /**
     * <p>Codigo de respuesta cuando el servicio solicitado no puede atender la
     * peticion pero existe otro servicio que si puede.</p>
     */
    public static final int SEE_OTHER = 303;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por sintaxis incorrecta.</p>
     */
    public static final int BAD_REQUEST = 400;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por fallo en la autenticacion y
     * autorizacion de usuarios.</p>
     */
    public static final int UNAUTHORIZED = 401;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por condiciones ajenas a las controladas
     * por el sistema.</p>
     */
    public static final int USUARIO_NO_ENCONTRADO = 402;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por solicitud de recursos que no
     * existen.</p>
     */
    public static final int NOT_FOUND = 404;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error al recibir un metodo no permitido.</p>
     */
    public static final int METHOD_NOT_ALLOWED = 405;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error al recibir un peticion no soportada.</p>
     */
    public static final int UNSUPPORTED_MEDIA_TYPE = 415;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por no cumplir con reglas semanticas
     * (de negocio) definidas en la operacion solicitada.</p>
     */
    public static final int UNPROCESSABLE_ENTITY = 422;
//______________________________________________________________________________
    /**
     * <p>Codigo para respuestas de error por condiciones ajenas a las controladas
     * por el sistema.</p>
     */
    public static final int INTERNAL_SERVER_ERROR = 500;
//______________________________________________________________________________
    /**
     * <p>Constructor privado para evitar instanciar la clase.</p>
     */
    private EstadoHttp() {
    }
}

