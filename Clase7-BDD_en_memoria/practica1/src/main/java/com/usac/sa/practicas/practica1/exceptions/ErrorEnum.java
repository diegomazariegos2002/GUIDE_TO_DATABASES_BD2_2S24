package com.usac.sa.practicas.practica1.exceptions;

/**
 * @author DiegoMazariegos
 * @description Enumeracion que contiene los errores que se pueden presentar en la
 *              aplicacion
 */
public enum ErrorEnum {
    // errores internos
    I_DESCONOCIDO(1000, EstadoHttp.INTERNAL_SERVER_ERROR,
            "Error desconocido, comuniquese con el administrador del sitio"),
    I_PRIMARY_KEY(1001, EstadoHttp.INTERNAL_SERVER_ERROR, "No se pudo crear la llave primaria para el nuevo registro"),
    I_OBJETO_NO_CREADO(1002, EstadoHttp.INTERNAL_SERVER_ERROR, "Error en la creación del objeto"),
    I_OBJETO_NULO(1003, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al obtener la información para el objeto solicitado"),
    I_OBJETO_NO_ACTUALIZADO(1004, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al actualizar el objeto"),
    I_OBJETO_INVALIDO(1005, EstadoHttp.INTERNAL_SERVER_ERROR, "El objeto es invalido"),
    I_FALLO_SERVICIO(1006, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al ejecutar servicio"),
    I_FALLO_SUBIDA_S3(1007, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al subir el documento a S3"),
    I_FALLO_SUBIDA_ACS(1008, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al subir el documento a ACS"),
    I_FALLO_S3_DESCONOCIDO(1009, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al utilizar el servicio de S3"),
    I_FALLO_ACS_DESCONOCIDO(1010, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al utilizar el servicio de ACS"),
    I_PARAMETROS_INVALIDADOS(1011, EstadoHttp.UNPROCESSABLE_ENTITY, "Parámetros enviados son inválidos"),
    I_ERROR_ENVIO_CORREO(1012, EstadoHttp.INTERNAL_SERVER_ERROR, "Error al enviar correo de notificación"),

    // errores de recursos que no existen
    N_NO_EXISTE(2000, EstadoHttp.NOT_FOUND, "El servicio solicitado no existe"),
    N_OBJETO_NO_EXISTE(2001, EstadoHttp.NOT_FOUND, "El objeto solicitado no existe"),
    N_OBJETO_CONSULTA_NO_EXISTE(2002, EstadoHttp.BAD_REQUEST, "El parámetro ingresado no existe en base de datos"),
    N_REFERENCIA_NO_EXISTE(2003, EstadoHttp.NOT_FOUND, "Los parámetros ingresados no existen en base de valor"),
    N_NO_GENERABLE(2003, EstadoHttp.NOT_FOUND, "No es posible Generar Documento"),
    N_REFEERENCIA_INEXISTENTE(2005, EstadoHttp.INTERNAL_SERVER_ERROR, "No Existen Referencias buscadas"),
    N_DOCUMENTO_NO_EXISTE(2006, EstadoHttp.NOT_FOUND, "No Existe el numero de documento"),
    N_EVALUACION_NO_EXISTE(2006, EstadoHttp.NOT_FOUND, "No Existe Evaluación para el código de referencia"),
    // errores de seguridad
    S_DESCONOCIDO(3000, EstadoHttp.UNAUTHORIZED, "Credenciales de usuario inválidas."),
    S_USUARIO_NO_EXISTENTE(3001, EstadoHttp.USUARIO_NO_ENCONTRADO,
            "Usuario no cuenta con accesos a asignaciones (No registrado en Mantenimiento de Usuarios)."),
    S_USUARIO_NO_VALIDO(3002, EstadoHttp.USUARIO_NO_ENCONTRADO,
            "Usuario no existe o se encuentra inactivo en el mantenimiento de usuarios."),
    // errores de reglas de negocio
    ;

    // ______________________________________________________________________________
    /**
     * <p>
     * Codigo de error.
     * </p>
     */
    private final int codigo;
    // ______________________________________________________________________________
    /**
     * <p>
     * Codigo de estado Http.
     * </p>
     */
    private final int estadoHttp;
    // ______________________________________________________________________________
    /**
     * <p>
     * Descripcion del error.
     * </p>
     */
    private final String descripcion;

    // ______________________________________________________________________________
    /**
     * <p>
     * Constructor de la enumeracion, establece el valor de los atributos.
     * </p>
     * 
     * @param pCodigo     Codigo de error
     * @param pEstadoHttp Codigo de estado de Http.
     * @param pMensaje    Descripcion de error
     */
    private ErrorEnum(int pCodigo, int pEstadoHttp, String pMensaje) {
        this.codigo = pCodigo;
        this.estadoHttp = pEstadoHttp;
        this.descripcion = pMensaje;
    }

    // ______________________________________________________________________________
    /**
     * <p>
     * Codigo que identifica el error de forma unica.
     * </p>
     * 
     * @return int Codigo de error
     */
    public int getCodigo() {
        return codigo;
    }

    // ______________________________________________________________________________
    /**
     * <p>
     * Codigo de estado Http.
     * </p>
     * 
     * @return int Estado Http
     */
    public int getEstadoHttp() {
        return estadoHttp;
    }

    // ______________________________________________________________________________
    /**
     * <p>
     * Descripcion del error, proporciona un punto de inicio para que el
     * usuario sepa que correcciones realizar.
     * </p>
     * 
     * @return String Descripcion del error
     */
    public String getDescripcion() {
        return descripcion;
    }

    // ______________________________________________________________________________
    /**
     * <p>
     * Devuelve un texto indicando el tipo, codigo y descripcion del error.
     * </p>
     * 
     * @return String Representacion textual del error
     */
    @Override
    public String toString() {
        return "Error-"
                .concat(String.valueOf(this.estadoHttp))
                .concat("-")
                .concat(String.valueOf(this.codigo))
                .concat(": ")
                .concat(this.descripcion);
    }
}
