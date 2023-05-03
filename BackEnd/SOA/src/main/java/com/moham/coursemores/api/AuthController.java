package com.moham.coursemores.api;

import com.moham.coursemores.common.auth.oauth.KakaoLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.service.OAuthLoginService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("test")
@RequiredArgsConstructor
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final OAuthLoginService oAuthLoginService;

    @PostMapping("kakao")
    public ResponseEntity<?> loginKakao(
            @RequestBody KakaoLoginParams params) {
        logger.info(">> request : params={}", params);

        Long userId = oAuthLoginService.login(params);
        logger.info("<< response : userId={}",userId);

        Map<String, Object> resultMap = oAuthLoginService.getUserProfile(userId, OAuthProvider.KAKAO);
        logger.info("<< response : userSimpleInfoResDto={}",resultMap.get("userSimpleInfo"));
        logger.info("<< response : token={}",resultMap.get("token"));

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping("kakao/login")
    public ResponseEntity<?> kakaoLogin(
            @RequestBody String accessToken) {
        logger.info(">> request : accessToken={}", accessToken);

        Long userId = oAuthLoginService.login(accessToken, OAuthProvider.KAKAO);
        logger.info("<< response : userId={}",userId);

        Map<String, Object> resultMap = oAuthLoginService.getUserProfile(userId, OAuthProvider.KAKAO);
        logger.info("<< response : userSimpleInfo={}",resultMap.get("userSimpleInfo"));
        logger.info("<< response : token={}",resultMap.get("token"));

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }
}