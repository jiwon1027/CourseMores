package com.moham.coursemores.common.auth.oauth;

import com.moham.coursemores.common.util.OAuthProvider;
import org.springframework.util.MultiValueMap;

public interface OAuthLoginParams {

    OAuthProvider oAuthProvider();

    MultiValueMap<String, String> makeBody();

}