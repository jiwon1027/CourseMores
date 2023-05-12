package com.moham.coursemores.dto.token;

import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class TokenReissueReqDto {

    String accessToken;
    String refreshToken;

}