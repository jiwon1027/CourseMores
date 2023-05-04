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
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
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

    @Autowired
    private AuthenticationManagerBuilder authenticationManagerBuilder;

    public OAuthLoginServiceImpl(List<OAuthApiClient> clients) {
        this.clients = clients.stream().collect(
                Collectors.toUnmodifiableMap(OAuthApiClient::oAuthProvider, Function.identity())
        );
    }

    //////////////////////////////////////////////////////////
    // 삭제될 부분입니다
    public OAuthInfoResponse request(OAuthLoginParams params) {
        OAuthApiClient client = clients.get(params.oAuthProvider());
        String accessToken = client.requestAccessToken(params);
        System.out.println("accessToken : "+accessToken);
        return client.requestOauthInfo(accessToken);
    }

    @Override
    public Long login(OAuthLoginParams params) {
        OAuthInfoResponse oAuthInfoResponse = request(params);

        return successLogin(oAuthInfoResponse.getEmail(), oAuthInfoResponse.getOAuthProvider()).getId();
    }
    //////////////////////////////////////////////////////////

    @Override
    public Long kakao(String accessToken) {
        OAuthApiClient client = clients.get(OAuthProvider.KAKAO);
        OAuthInfoResponse oAuthInfoResponse = client.requestOauthInfo(accessToken);

        return successLogin(oAuthInfoResponse.getEmail(), oAuthInfoResponse.getOAuthProvider()).getId();
    }

    @Override
    public Long google(String email) {
        return successLogin(email, OAuthProvider.GOOGLE).getId();
    }

    @Override
    public Map<String, Object> getUserProfile(Long userId, OAuthProvider oAuthProvider) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        Map<String, Object> resultMap = new HashMap<>();
        UserSimpleInfoResDto userSimpleInfo = null;

        // 값이 존재한다면
        if(StringUtils.hasText(user.getNickname())
                && user.getAge() > 0
                && StringUtils.hasText(user.getGender()))
            userSimpleInfo = UserSimpleInfoResDto.builder()
                    .profileImage(user.getProfileImage())
                    .nickname(user.getNickname())
                    .build();

        resultMap.put("userSimpleInfo",userSimpleInfo);

        TokenResDto tokenResDto = generateToken(userId, oAuthProvider);
        resultMap.put("token",tokenResDto);

        return resultMap;
    }

    @Override
    public TokenResDto generateToken(Long userId, OAuthProvider oAuthProvider){
        String accessToken = tokenProvider.generateAccessToken(Long.toString(userId), oAuthProvider);
        String refreshToken = tokenProvider.generateRefreshToken();

        return TokenResDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private User successLogin(String email, OAuthProvider oAuthProvider){
        Optional<User> user = userRepository.findByEmailAndProviderAndDeleteTimeIsNull(email, oAuthProvider);

        // 유저가 존재한다면 로그인 처리
        // 유저가 없다면 회원가입 처리
        return user.orElseGet(() -> userRepository.save(User.builder()
                .email(email)
                .roles("ROLE_USER")
                .provider(oAuthProvider)
                .build()));
    }
}
