package com.moham.coursemores.dto.profile;

import lombok.*;

@ToString
@Getter
@Builder
public class UserSimpleInfoResDto {
    private String nickname;
    private String profileImage;
}
