package com.moham.coursemores.service;

import com.moham.coursemores.common.auth.oauth2.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;

public interface OAuthLoginService {
    Long login(OAuthLoginParams params);
    Long login(String accessToken, OAuthProvider oAuthProvider);
    UserSimpleInfoResDto getUserProfile(Long userId);
    TokenResDto generateToken(Long userId);
}
