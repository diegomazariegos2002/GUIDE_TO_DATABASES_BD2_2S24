package com.usac.sa.practicas.practica1.exceptions;

import java.util.List;

import com.usac.sa.practicas.practica1.exceptions.abs.GeneralResponseException;

import lombok.extern.slf4j.Slf4j;

/**
 * @author DiegoMazariegos
 * @description Clase que maneja las excepciones personalizadas de la aplicacion
 */
@Slf4j
public class CustomException extends GeneralResponseException {

    private final ErrorEnum error;
    private final transient List<ErrorDetail> errores;
    private final transient Object[] paramError;
    private final String messageOverwrite;

    public CustomException(ErrorEnum pError) {
        super(pError.toString());
        this.error = pError;
        this.errores = null;
        this.paramError = null;
        this.messageOverwrite = null;
    }

    public CustomException(ErrorEnum pError, Object[] pParamError) {
        super(pError.toString());
        this.error = pError;
        this.errores = null;
        this.paramError = pParamError;
        this.messageOverwrite = null;
    }

    public CustomException(ErrorEnum pError, List<ErrorDetail> pErrores) {
        super(pError.toString());
        this.error = pError;
        this.errores = pErrores;
        this.paramError = null;
        this.messageOverwrite = null;
    }

    public CustomException(ErrorEnum pError, Throwable pCause) {
        super(pError.toString(), pCause);
        this.error = pError;
        this.errores = null;
        this.paramError = null;
        this.messageOverwrite = null;
        log.error(pError.getDescripcion(), pCause);
    }

    public CustomException(ErrorEnum pError, String message) {
        super(pError.toString());
        this.error = pError;
        this.errores = null;
        this.paramError = null;
        this.messageOverwrite = message;
    }

    public CustomException(ErrorEnum pError, String message, Throwable pCause) {
        super(pError.toString(), pCause);
        this.error = pError;
        this.errores = null;
        this.paramError = null;
        this.messageOverwrite = message;
        log.error(message, pCause);
    }

    public ErrorEnum getError() {
        return error;
    }

    public List<ErrorDetail> getErrores() {
        return errores;
    }

    public Object[] getParamError() {
        return paramError;
    }

    public String getMessageOverwrite() {
        return messageOverwrite;
    }
}
