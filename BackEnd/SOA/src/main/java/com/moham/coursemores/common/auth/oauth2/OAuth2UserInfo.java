package com.moham.coursemores.common.auth.oauth2;

public interface OAuth2UserInfo {
    String getProviderId();
    String getProvider();
    String getEmail();
}
