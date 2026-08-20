package com.hackathon.financeai.exception;

import com.hackathon.financeai.dto.ErrorDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorDTO> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String mensajeError = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
        ErrorDTO errorDTO = new ErrorDTO(true, "ERROR_VALIDACION", mensajeError);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorDTO);
    }

    @ExceptionHandler(FintechException.class)
    public ResponseEntity<ErrorDTO> handleFintechException(FintechException ex) {
        ErrorDTO errorDTO = new ErrorDTO(true, ex.getCodigo(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorDTO);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorDTO> handleGenericException(Exception ex) {
        ErrorDTO errorDTO = new ErrorDTO(
                true,
                "ERROR_INTERNO_SERVIDOR",
                "Ocurrió un error inesperado. Por favor contacte a soporte."
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorDTO);
    }
}