package com.moham.coursemores.service;

public interface OAuthLoginService {

    Long kakao(String accessToken);

    Long google(String email);

}