package com.coursemores.service.service;

import com.coursemores.service.dto.profile.UserInfoResDto;
import com.coursemores.service.dto.profile.UserInfoUpdateReqDto;

public interface ProfileService {

    UserInfoResDto getMyProfile(Long userId);

    void alramSetting(Long userId);

    void updateUserInfo(Long userId, UserInfoUpdateReqDto userInfoUpdateReqDto);

    void deleteUser(Long userId);
}