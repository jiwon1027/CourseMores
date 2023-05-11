package com.moham.coursemores.api;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.token.TokenResDto;
import com.moham.coursemores.service.OAuthLoginService;
import com.moham.coursemores.service.RefreshService;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("auth")
@RequiredArgsConstructor
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final OAuthLoginService oAuthLoginService;
    private final UserService userService;
    private final RefreshService refreshService;

    @PostMapping("kakao/login")
    public ResponseEntity<Map<String, Object>> kakaoLogin(
            @RequestBody Map<String,Object> requestMap) {
        String accessToken = (String)requestMap.get("accessToken");
        logger.debug("[0/6][POST][/auth/kakao/login] << request : accessToken\n accessToken = {}", accessToken);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/6][POST][/auth/kakao/login] ... ols.kakao");
        Long userId = oAuthLoginService.kakao(accessToken);

        logger.debug("[2/6][POST][/auth/kakao/login] ... userId = {}", userId);
        if(userId == -1L){
            resultMap.put("agree",false);
            logger.debug("[3/6][POST][/auth/kakao/login] >> response : agree\n agree = {}\n", false);
            return new ResponseEntity<>(resultMap,HttpStatus.OK);
        }
        else{
            resultMap.put("agree",true);
        }

        logger.debug("[3/6][POST][/auth/kakao/login] ... us.getUserInfo");
        UserInfoResDto userInfo = userService.getUserInfo(userId);
        resultMap.put("userInfo",userInfo);

        logger.debug("[4/6][POST][/auth/kakao/login] ... us.generateToken");
        TokenResDto tokenResDto = userService.generateToken(userId, OAuthProvider.KAKAO);

        logger.debug("[5/6][POST][/auth/kakao/login] ... rs.save");
        refreshService.save(userId, tokenResDto.getRefreshToken());
        resultMap.put("token",tokenResDto);

        logger.debug("[6/6][POST][/auth/kakao/login] >> response : agree, userInfo, token\n agree = {}\n userInfo = {}\n token = {}\n",
                false, userInfo, tokenResDto);
        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping("google/login")
    public ResponseEntity<Map<String, Object>> googleLogin(
            @RequestBody Map<String,Object> requestMap) {
        String email = (String)requestMap.get("email");
        logger.debug("[0/6][POST][/auth/google/login] << request : email\n email = {}", email);

        logger.debug("[1/6][POST][/auth/google/login] ... ols.google");
        Long userId = oAuthLoginService.google(email);
        logger.debug("[2/6][POST][/auth/google/login] ... userId = {}", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[3/6][POST][/auth/google/login] ... us.getUserInfo");
        UserInfoResDto userInfo = userService.getUserInfo(userId);
        resultMap.put("userInfo",userInfo);

        logger.debug("[4/6][POST][/auth/google/login] ... us.generateToken");
        TokenResDto tokenResDto = userService.generateToken(userId, OAuthProvider.GOOGLE);

        logger.debug("[5/6][POST][/auth/google/login] ... rs.save");
        refreshService.save(userId, tokenResDto.getRefreshToken());
        resultMap.put("token",tokenResDto);

        logger.debug("[6/6][POST][/auth/google/login] >> response : userInfo, token\n userInfo = {}\n token = {}\n",
                userInfo, tokenResDto);
        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

}