package com.example.spring.db2.demo.exceptions;

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
    I_PARAMETROS_INVALIDADOS(1007, EstadoHttp.UNPROCESSABLE_ENTITY, "Parámetros enviados son inválidos");

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
