package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.common.auth.oauth.OAuthInfoResponse;
import com.moham.coursemores.common.auth.oauth.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.RefreshToken;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenReissueReqDto;
import com.moham.coursemores.dto.token.TokenResDto;
import com.moham.coursemores.repository.RefreshTokenRepository;
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

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

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
        System.out.println("kakao 입장 "+accessToken);
        OAuthApiClient client = clients.get(OAuthProvider.KAKAO);
        System.out.println("client 가져옴 : "+client);
        OAuthInfoResponse oAuthInfoResponse = client.requestOauthInfo(accessToken);
        System.out.println("oAuthInfoResponse : "+oAuthInfoResponse.getEmail()+", "+oAuthInfoResponse.getOAuthProvider());
        return successLogin(oAuthInfoResponse.getEmail(), oAuthInfoResponse.getOAuthProvider()).getId();
    }

    @Override
    public Long google(String email) {
        return successLogin(email, OAuthProvider.GOOGLE).getId();
    }

    @Override
    public String reissue(TokenReissueReqDto tokenReissueReqDto) {
        // 1. Refresh Token 검증
        if (!tokenProvider.validate(tokenReissueReqDto.getRefreshToken())) {
            throw new RuntimeException("해당 Refresh Token이 유효하지 않습니다.");
        }

        // 2. Access Token 에서 Member ID 가져오기
        Long userId = tokenProvider.extractMemberId(tokenReissueReqDto.getAccessToken());
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 사용자를 찾을 수 없습니다."));

        // 3. 저장소에서 Member ID 를 기반으로 Refresh Token 값 가져옴
        RefreshToken originRefreshToken = refreshTokenRepository.findByKey(userId)
                .orElseThrow(() -> new RuntimeException("로그아웃 된 사용자입니다.")); // 로그아웃 시 DB에서 리프레쉬 토큰을 제거한다는 가정하에

        // 4. Refresh Token 일치하는지 검사
        if (!originRefreshToken.getValue().equals(tokenReissueReqDto.getRefreshToken())) {
            throw new RuntimeException("해당 Refresh Token이 일치하지 않습니다.");
        }

        // 5. 새로운 accessToken 생성
        String newAccessToken = tokenProvider.generateAccessToken(Long.toString(userId),user.getProvider());

        // 토큰 발급
        return newAccessToken;
    }

    @Override
    public Map<String, Object> getLoginUserInfo(Long userId, OAuthProvider oAuthProvider) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        Map<String, Object> resultMap = new HashMap<>();
        UserInfoResDto userInfo = null;

        // 값이 존재한다면
        if(StringUtils.hasText(user.getNickname())
                && user.getAge() > 0
                && StringUtils.hasText(user.getGender()))
            userInfo = UserInfoResDto.builder()
                    .nickname(user.getNickname())
                    .gender(user.getGender())
                    .age(user.getAge())
                    .profileImage(user.getProfileImage())
                    .build();

        resultMap.put("userInfo",userInfo);

        TokenResDto tokenResDto = generateToken(userId, oAuthProvider);
        resultMap.put("token",tokenResDto);

        return resultMap;
    }

    private TokenResDto generateToken(Long userId, OAuthProvider oAuthProvider){
        String accessToken = tokenProvider.generateAccessToken(Long.toString(userId), oAuthProvider);
        String refreshToken = tokenProvider.generateRefreshToken();

        return TokenResDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private User successLogin(String email, OAuthProvider oAuthProvider){
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