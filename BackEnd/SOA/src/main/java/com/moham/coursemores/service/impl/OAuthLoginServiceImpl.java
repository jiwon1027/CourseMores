package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.common.auth.oauth.OAuthInfoResponse;
import com.moham.coursemores.common.auth.oauth.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.OAuthApiClient;
import com.moham.coursemores.service.OAuthLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class OAuthLoginServiceImpl implements OAuthLoginService {

    private final Map<OAuthProvider, OAuthApiClient> clients;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenProvider tokenProvider;

    public OAuthLoginServiceImpl(List<OAuthApiClient> clients) {
        this.clients = clients.stream().collect(
                Collectors.toUnmodifiableMap(OAuthApiClient::oAuthProvider, Function.identity())
        );
    }

    public OAuthInfoResponse request(OAuthLoginParams params) {
        OAuthApiClient client = clients.get(params.oAuthProvider());
        String accessToken = client.requestAccessToken(params);
        System.out.println("accessToken : "+accessToken);
        return client.requestOauthInfo(accessToken);
    }

    @Override
    public Long login(OAuthLoginParams params) {
        OAuthInfoResponse oAuthInfoResponse = request(params);
        System.out.println("email : "+oAuthInfoResponse.getEmail());
        System.out.println("provider : "+oAuthInfoResponse.getOAuthProvider());

        return successLogin(oAuthInfoResponse).getId();
    }

    @Override
    public Long login(String accessToken, OAuthProvider oAuthProvider) {
        OAuthApiClient client = clients.get(oAuthProvider);
        OAuthInfoResponse oAuthInfoResponse = client.requestOauthInfo(accessToken);

        return successLogin(oAuthInfoResponse).getId();
    }

    @Override
    public UserSimpleInfoResDto getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        if(user.getNickname() == null || user.getAge() == 0 || user.getGender() == null)
            return null;

        return UserSimpleInfoResDto.builder()
                .profileImage(user.getProfileImage())
                .nickname(user.getNickname())
                .build();
    }

    private User successLogin(OAuthInfoResponse oAuthInfo){
        Optional<User> user = userRepository.findByEmailAndProviderAndDeleteTimeIsNull(oAuthInfo.getEmail(), oAuthInfo.getOAuthProvider());

        // 유저가 존재한다면 로그인 처리
        // 유저가 없다면 회원가입 처리
        return user.orElseGet(() -> userRepository.save(User.builder()
                .email(oAuthInfo.getEmail())
                .roles("ROLE_USER")
                .provider(oAuthInfo.getOAuthProvider())
                .build()));
    }

    @Override
    public TokenResDto generateToken(Long userId){
        String accessToken = tokenProvider.generateAccessToken(Long.toString(userId));
        String refreshToken = tokenProvider.generateRefreshToken();

        return TokenResDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }
}
