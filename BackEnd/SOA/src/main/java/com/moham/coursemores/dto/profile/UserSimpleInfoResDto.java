package com.moham.coursemores.dto.profile;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class UserSimpleInfoResDto {

    private String nickname;
    private String profileImage;

}