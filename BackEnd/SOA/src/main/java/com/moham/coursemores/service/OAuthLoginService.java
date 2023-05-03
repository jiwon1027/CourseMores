package com.moham.coursemores.service;

import com.moham.coursemores.common.auth.oauth.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;
import org.springframework.security.core.Authentication;

import java.util.Map;

public interface OAuthLoginService {
    Long login(OAuthLoginParams params);
    Long login(String accessToken, OAuthProvider oAuthProvider);
    Map<String, Object> getUserProfile(Long userId, OAuthProvider oAuthProvider);
    TokenResDto generateToken(Long userId, OAuthProvider oAuthProvider);
}
