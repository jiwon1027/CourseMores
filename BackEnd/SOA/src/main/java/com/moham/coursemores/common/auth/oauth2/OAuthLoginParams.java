package com.moham.coursemores.common.auth.oauth2;

import com.moham.coursemores.common.util.OAuthProvider;
import org.springframework.util.MultiValueMap;

public interface OAuthLoginParams {
    OAuthProvider oAuthProvider();
    MultiValueMap<String, String> makeBody();
}