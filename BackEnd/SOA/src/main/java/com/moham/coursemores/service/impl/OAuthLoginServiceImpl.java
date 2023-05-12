package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.common.auth.oauth.OAuthInfoResponse;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.OAuthApiClient;
import com.moham.coursemores.service.OAuthLoginService;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.stereotype.Service;

@Service
public class OAuthLoginServiceImpl implements OAuthLoginService {

    private final Map<OAuthProvider, OAuthApiClient> clients;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenProvider tokenProvider;

    @Autowired
    private AuthenticationManagerBuilder authenticationManagerBuilder;

    public OAuthLoginServiceImpl(List<OAuthApiClient> clients) {
        this.clients = clients.stream().collect(
                Collectors.toUnmodifiableMap(OAuthApiClient::oAuthProvider, Function.identity())
        );
    }

    @Override
    public Long kakao(String accessToken) {
        System.out.println("kakao 입장 " + accessToken);
        OAuthApiClient client = clients.get(OAuthProvider.KAKAO);
        System.out.println("client 가져옴 : " + client);
        OAuthInfoResponse oAuthInfoResponse = client.requestOauthInfo(accessToken);
        System.out.println("oAuthInfoResponse : " + oAuthInfoResponse.getEmail() + ", " + oAuthInfoResponse.getOAuthProvider());

        // 이메일 수집 동의를 하지 않은 경우 -> 에러처리
        if (oAuthInfoResponse.getEmail() == null) {
            return -1L;
        }

        return successLogin(oAuthInfoResponse.getEmail(), oAuthInfoResponse.getOAuthProvider()).getId();
    }

    @Override
    public Long google(String email) {
        return successLogin(email, OAuthProvider.GOOGLE).getId();
    }

    private User successLogin(String email, OAuthProvider oAuthProvider) {
        Optional<User> user = userRepository.findByEmailAndProviderAndDeleteTimeIsNull(email, oAuthProvider);
        System.out.println("user 가져옴");
        // 유저가 존재한다면 로그인 처리
        // 유저가 없다면 회원가입 처리
        return user.orElseGet(() -> userRepository.save(User.builder()
                .email(email)
                .roles("ROLE_USER")
                .provider(oAuthProvider)
                .build()));
    }

}