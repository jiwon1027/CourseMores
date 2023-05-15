package com.moham.coursemores.common.exception;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CustomErrorResponse {
    CustomErrorCode customErrorCode;
    String statusMessage;
}
