package com.moham.coursemores.dto.profile;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class UserInfoResDto {
    String nickname;
    int age;
    String gender;
    String profileImage;
}
