package com.moham.coursemores.common.exception;

import lombok.Getter;

@Getter
public class CustomException extends RuntimeException{
    private final CustomErrorCode customErrorCode;
    private final String detailMessage;

    public CustomException(CustomErrorCode customErrorCode){
        super(customErrorCode.getStatusMessage());
        this.customErrorCode = customErrorCode;
        this.detailMessage = customErrorCode.getStatusMessage();
    }

    public CustomException(Long id, CustomErrorCode customErrorCode){
        super(customErrorCode.getStatusMessage());
        this.customErrorCode = customErrorCode;
        this.detailMessage = "(ID : " + id + ") " + customErrorCode.getStatusMessage();
    }

    public CustomException(Long id1, Long id2, CustomErrorCode customErrorCode){
        super(customErrorCode.getStatusMessage());
        this.customErrorCode = customErrorCode;
        this.detailMessage = "(ID : " + id1 + ", "+ id2+") " + customErrorCode.getStatusMessage();
    }

    public CustomException(String value, CustomErrorCode customErrorCode){
        super(customErrorCode.getStatusMessage());
        this.customErrorCode = customErrorCode;
        this.detailMessage = "(value : " + value + ") " + customErrorCode.getStatusMessage();
    }
}
