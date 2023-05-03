package com.coursemores.service.dto.profile;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class UserInfoUpdateReqDto {

    String nickname;
    int age;
    String gender;
    String profileImage;
}