package com.moham.coursemores.common.auth.oauth;

import com.moham.coursemores.common.util.OAuthProvider;

public interface OAuthInfoResponse {
    String getEmail();
    OAuthProvider getOAuthProvider();
}