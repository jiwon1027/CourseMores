package com.moham.coursemores.service;

import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import org.springframework.web.multipart.MultipartFile;

public interface ProfileService {

    UserInfoResDto getMyProfile(Long userId);

    void alramSetting(Long userId);

    void updateUserInfo(Long userId, UserInfoUpdateReqDto userInfoUpdateReqDto, MultipartFile profileImage);

    void deleteUser(Long userId);

}