package com.usac.sa.practicas.practica1.exceptions.abs;

public class GeneralResponseException extends RuntimeException{
    private static final long serialVersionUID = 1L;

    public GeneralResponseException() {
    }
 
    public GeneralResponseException(String exception) {
       super(exception);
    }
 
    public GeneralResponseException(String exception, String cause) {
       super(exception, new Throwable(cause));
    }

    public GeneralResponseException(String message, Throwable cause) {
        super(message, cause);
    }
}
