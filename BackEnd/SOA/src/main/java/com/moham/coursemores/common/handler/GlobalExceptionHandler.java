package com.moham.coursemores.common.handler;

import java.util.HashMap;
import java.util.Map;

import com.moham.coursemores.common.exception.CustomException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice(basePackages = "com.moham.coursemores.api")
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<Map<String, Object>> handleCustomException(CustomException e) {
        log.warn("ErrorCode : {}, Message : {}", e.getCustomErrorCode(), e.getDetailMessage());
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
        resultMap.put("errorCode", e.getCustomErrorCode());
        resultMap.put("errorMessage", e.getDetailMessage());
        return new ResponseEntity<>(resultMap, status);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleAllException(Exception e) {
        log.warn("ErrorCode : {}, Message : {}", e.getCause(), e.getMessage());
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
        resultMap.put("errorCause", e.getCause());
        resultMap.put("errorMessage", e.getMessage());
        return new ResponseEntity<>(resultMap, status);
    }

}