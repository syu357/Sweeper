package com.sweeper.car.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public String handleException(Exception ex) {
        // 여기에서 예외 처리 로직을 추가합니다.
        // 예를 들어, 로깅을 하거나 에러 페이지로 리다이렉트하거나 에러 메시지를 반환할 수 있습니다.
        return "error"; // 에러 페이지로 리다이렉트 또는 에러 메시지 표시
    }
}
