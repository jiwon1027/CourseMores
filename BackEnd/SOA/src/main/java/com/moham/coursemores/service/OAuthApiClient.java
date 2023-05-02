package com.moham.coursemores.service;

import com.moham.coursemores.common.auth.oauth2.OAuthInfoResponse;
import com.moham.coursemores.common.auth.oauth2.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;

public interface OAuthApiClient {
    OAuthProvider oAuthProvider();
    String requestAccessToken(OAuthLoginParams params);
    OAuthInfoResponse requestOauthInfo(String accessToken);
}