package com.moham.coursemores.service;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;
import org.springframework.web.multipart.MultipartFile;

public interface UserService {
    UserInfoResDto getUserInfo(Long userId);
    TokenResDto generateToken(Long userId, OAuthProvider oAuthProvider);
    boolean isDuplicatedNickname(String nickname);
    void addUserInfo(Long userId, UserInfoCreateReqDto userInfoCreateReqDto, MultipartFile profileImage);
}
