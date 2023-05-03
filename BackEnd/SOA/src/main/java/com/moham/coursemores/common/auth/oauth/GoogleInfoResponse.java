package com.moham.coursemores.common.auth.oauth;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.moham.coursemores.common.util.OAuthProvider;
import lombok.Getter;

@Getter
@JsonIgnoreProperties(ignoreUnknown = true)
public class GoogleInfoResponse implements OAuthInfoResponse {

    // 지정해줘야함
    @JsonProperty("google")
    private GoogleAccount googleAccount;

    @Getter
    @JsonIgnoreProperties(ignoreUnknown = true)
    static class GoogleAccount {
        private String email;
    }

    @Override
    public String getEmail() {
        return googleAccount.email;
    }

    @Override
    public OAuthProvider getOAuthProvider() {
        return OAuthProvider.KAKAO;
    }
}