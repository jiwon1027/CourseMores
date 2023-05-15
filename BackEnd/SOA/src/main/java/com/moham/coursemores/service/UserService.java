package com.moham.coursemores.service;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.token.TokenReissueReqDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public interface UserService {

    UserInfoResDto getUserInfo(Long userId);

    String generateToken(Long userId, OAuthProvider oAuthProvider);

    boolean isDuplicatedNickname(String nickname);

    void addUserInfo(Long userId, UserInfoCreateReqDto userInfoCreateReqDto, MultipartFile profileImage);

    Map<String, Object> reissue(TokenReissueReqDto tokenReissueReqDto);

}