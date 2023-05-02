package com.moham.coursemores.api;

import com.moham.coursemores.common.auth.oauth2.KakaoLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;
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

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final OAuthLoginService oAuthLoginService;

    @PostMapping("/kakao")
    public ResponseEntity<?> loginKakao(
            @RequestBody KakaoLoginParams params) {

        logger.info(">> request : params={}", params);

        Map<String, Object> resultMap = new HashMap<>();

        Long userId = oAuthLoginService.login(params);
        logger.info("<< response : userId={}",userId);

        UserSimpleInfoResDto userSimpleInfoResDto = oAuthLoginService.getUserProfile(userId);
        resultMap.put("userSimpleInfo",userSimpleInfoResDto);
        logger.info("<< response : userSimpleInfoResDto={}",userSimpleInfoResDto);

        boolean isSignUp = userSimpleInfoResDto==null ? false : true;
        resultMap.put("isSignUp",isSignUp);
        logger.info("<< response : isSignUp={}",isSignUp);

        TokenResDto tokenResDto = oAuthLoginService.generateToken(userId);
        resultMap.put("token",tokenResDto);
        logger.info("<< response : token={}",tokenResDto);

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping("/kakao/login")
    public ResponseEntity<?> kakaoLogin(
            @RequestBody String accessToken) {

        logger.info(">> request : accessToken={}", accessToken);

        Map<String, Object> resultMap = new HashMap<>();

        Long userId = oAuthLoginService.login(accessToken, OAuthProvider.KAKAO);
        logger.info("<< response : userId={}",userId);

        UserSimpleInfoResDto userSimpleInfoResDto = oAuthLoginService.getUserProfile(userId);
        resultMap.put("userSimpleInfo",userSimpleInfoResDto);
        logger.info("<< response : userSimpleInfoResDto={}",userSimpleInfoResDto);

        boolean isSignUp = userSimpleInfoResDto==null ? false : true;
        resultMap.put("isSignUp",isSignUp);
        logger.info("<< response : isSignUp={}",isSignUp);

        TokenResDto tokenResDto = oAuthLoginService.generateToken(userId);
        resultMap.put("token",tokenResDto);
        logger.info("<< response : token={}",tokenResDto);

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }
}