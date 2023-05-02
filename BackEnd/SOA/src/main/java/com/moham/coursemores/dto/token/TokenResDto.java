package com.moham.coursemores.dto.token;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class TokenResDto {
    String accessToken;
    String refreshToken;
}
