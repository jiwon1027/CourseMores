package com.moham.coursemores.service;

import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import org.springframework.web.multipart.MultipartFile;

public interface UserService {
    UserInfoResDto getUserProfile(Long userId);
    boolean isDuplicatedNickname(String nickname);
    void addUserInfo(Long userId, UserInfoCreateReqDto userInfoCreateReqDto, MultipartFile profileImage);
}
