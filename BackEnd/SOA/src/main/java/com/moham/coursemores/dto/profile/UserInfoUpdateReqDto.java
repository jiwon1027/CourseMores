package com.moham.coursemores.dto.profile;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class UserInfoUpdateReqDto {

    @NotBlank(message = "닉네임은 필수 입력 값입니다.")
    @Size(max = 20, message = "닉네임은 20글자 이하여야 합니다.")
    private String nickname;
    @NotNull(message = "나이는 필수 입력 값입니다.")
    private Integer age;
    @NotBlank(message = "성별은 필수 입력 값입니다.")
    private String gender;

}