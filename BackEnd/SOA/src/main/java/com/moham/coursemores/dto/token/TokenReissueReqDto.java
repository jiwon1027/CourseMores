package com.moham.coursemores.dto.token;

import javax.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class TokenReissueReqDto {

    @NotBlank(message = "accessToken은 필수 입력 값입니다.")
    String accessToken;
    @NotBlank(message = "refreshToken은 필수 입력 값입니다.")
    String refreshToken;

}