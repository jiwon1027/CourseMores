package com.moham.coursemores.service;

import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;

public interface ProfileService {
    UserInfoResDto getMyProfile(int userId);
    void alramSetting(int userId);

    void updateUserInfo(int userId, UserInfoUpdateReqDto userInfoUpdateReqDto);
    void deleteUser(int userId);


}
