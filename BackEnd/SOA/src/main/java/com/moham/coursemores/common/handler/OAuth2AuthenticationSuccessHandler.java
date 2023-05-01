package com.moham.coursemores.common.handler;

import com.moham.coursemores.common.auth.PrincipalDetails;
import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.domain.RefreshToken;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.repository.RefreshTokenRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;
import java.io.IOException;

@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(OAuth2AuthenticationSuccessHandler.class);

    private final TokenProvider tokenProvider;
    private final RefreshTokenRepository refreshTokenRepository;

    @Override
    @Transactional
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {

        // redirect 할 url을 지정해준다
        String targetUrl = determineTargetUrl(request, response, authentication);

        if (response.isCommitted()) {
            logger.info("Response has already been committed. Unable to redirect to " + targetUrl);
            return;
        }

        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }

    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {

        PrincipalDetails principalDetails = (PrincipalDetails)authentication.getPrincipal();
        User user = principalDetails.getUser();

        // 소셜 로그인 성공 후 이동할 페이지 -> 추후 변경해야함
        String targetUrl = "/oauth";

        // 추가 정보가 입력되어 있다면 로그인 처리
        if(user.getAge()>0 &&
                ("W".equals(user.getGender()) || "M".equals(user.getGender())) &&
                user.getNickname()!=null &&
                user.getProfileImage()!=null){

            // 토큰 정보 저장하는 페이지로 이동
            targetUrl = "/oauth2";

            // 3. 인증 정보를 기반으로 JWT 토큰 생성
            String accessToken = tokenProvider.generateAccessToken(authentication);
            String refreshToken = tokenProvider.generateRefreshToken();

            // 4. RefreshToken 저장
            // (rf 토큰의 key값은 user의 id로 할껀지? 아니면 provider + providerId로 할껀지??)
            RefreshToken rfToken = RefreshToken.builder()
                    .key(Long.toString(user.getId()))
                    .value(refreshToken)
                    .build();

            refreshTokenRepository.save(rfToken);

            // 타겟 URL로 토큰 정보를 함께 보내줌
            return UriComponentsBuilder.fromUriString(targetUrl
                            +"?accessToken="+accessToken)
                    .build().toUriString();
        }

        // 추가 정보가 입력되어 있지 않다면 추가 정보 입력창으로 보냄
        return UriComponentsBuilder.fromUriString(targetUrl
                        +"?userId="+user.getId())
                .build().toUriString();
    }
}