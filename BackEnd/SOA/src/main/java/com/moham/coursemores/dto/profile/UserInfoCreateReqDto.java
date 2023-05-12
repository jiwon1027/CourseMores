package com.moham.coursemores.dto.profile;

import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class UserInfoCreateReqDto {

    String nickname;
    int age;
    String gender;

}