package com.moham.coursemores.common.auth.oauth2;

import com.moham.coursemores.common.util.OAuthProvider;

public interface OAuthInfoResponse {
    String getEmail();
    OAuthProvider getOAuthProvider();
}