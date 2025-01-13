package com.example.spring.db2.demo.exceptions;

public class GeneralResponseException extends RuntimeException {
    private static final long serialVersionUID = 1L;
 
    public GeneralResponseException() {
    }
 
    public GeneralResponseException(String exception) {
       super(exception);
    }
 
    public GeneralResponseException(String exception, String cause) {
       super(exception, new Throwable(cause));
    }
 }
