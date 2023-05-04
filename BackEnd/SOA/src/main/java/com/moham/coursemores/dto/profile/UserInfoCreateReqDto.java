package com.moham.coursemores.dto.profile;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class UserInfoCreateReqDto {
    String nickname;
    int age;
    String gender;
}
