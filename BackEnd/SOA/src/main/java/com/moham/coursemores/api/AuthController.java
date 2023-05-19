package com.moham.coursemores.api;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.service.OAuthLoginService;
import com.moham.coursemores.service.UserService;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("auth")
@RequiredArgsConstructor
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final OAuthLoginService oAuthLoginService;
    private final UserService userService;

    private static final String ACCESS_TOKEN = "accessToken";

    @PostMapping("kakao/login")
    public ResponseEntity<Map<String, Object>> kakaoLogin(
            @RequestBody Map<String, Object> requestMap) {
        String kakaoAccessToken = (String) requestMap.get(ACCESS_TOKEN);
        logger.debug("[0/5][POST][/auth/kakao/login] << request : accessToken\n accessToken = {}", kakaoAccessToken);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/5][POST][/auth/kakao/login] ... ols.kakao");
        Long userId = oAuthLoginService.kakao(kakaoAccessToken);

        logger.debug("[2/5][POST][/auth/kakao/login] ... userId = {}", userId);
        if (userId == -1L) {
            resultMap.put("agree", false);
            logger.debug("[3/5][POST][/auth/kakao/login] >> response : agree\n agree = {}\n", false);
            return new ResponseEntity<>(resultMap, HttpStatus.OK);
        } else {
            resultMap.put("agree", true);
        }

        logger.debug("[3/5][POST][/auth/kakao/login] ... us.getUserInfo");
        UserInfoResDto userInfo = userService.getUserInfo(userId);
        resultMap.put("userInfo", userInfo);

        logger.debug("[4/5][POST][/auth/kakao/login] ... us.generateToken");
        String accessToken = userService.generateToken(userId, OAuthProvider.KAKAO);
        resultMap.put(ACCESS_TOKEN, accessToken);

        logger.debug("[5/5][POST][/auth/kakao/login] >> response : agree, userInfo, token\n agree = {}\n userInfo = {}\n accessToken = {}\n",
                true, userInfo, accessToken);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("google/login")
    public ResponseEntity<Map<String, Object>> googleLogin(
            @RequestBody Map<String, Object> requestMap) {
        String email = (String) requestMap.get("email");
        logger.debug("[0/6][POST][/auth/google/login] << request : email\n email = {}", email);

        logger.debug("[1/6][POST][/auth/google/login] ... ols.google");
        Long userId = oAuthLoginService.google(email);
        logger.debug("[2/6][POST][/auth/google/login] ... userId = {}", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[3/6][POST][/auth/google/login] ... us.getUserInfo");
        UserInfoResDto userInfo = userService.getUserInfo(userId);
        resultMap.put("userInfo", userInfo);

        logger.debug("[4/6][POST][/auth/google/login] ... us.generateToken");
        String accessToken = userService.generateToken(userId, OAuthProvider.GOOGLE);
        resultMap.put(ACCESS_TOKEN, accessToken);

        logger.debug("[6/6][POST][/auth/google/login] >> response : userInfo, token\n userInfo = {}\n accessToken = {}\n",
                userInfo, accessToken);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

}