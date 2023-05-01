package com.moham.coursemores.service;

import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;

public interface ProfileService {
    UserInfoResDto getMyProfile(Long userId);
    void alramSetting(Long userId);
    void updateUserInfo(Long userId, UserInfoUpdateReqDto userInfoUpdateReqDto);
    void deleteUser(Long userId);
}
