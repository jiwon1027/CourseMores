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
        logger.info(">> request : accessToken={}", accessToken);

        Long userId = oAuthLoginService.kakao(accessToken);
        logger.info("<< response : userId={}",userId);

        if(userId == -1L)
            return new ResponseEntity<>(HttpStatus.OK);

        Map<String, Object> resultMap = new HashMap<>();

        UserInfoResDto userInfo = userService.getUserInfo(userId);
        logger.info("<< response : userInfo={}",userInfo);

        TokenResDto tokenResDto = userService.generateToken(userId, OAuthProvider.KAKAO);
        refreshService.save(userId, tokenResDto.getRefreshToken());
        logger.info("<< response : token={}",tokenResDto);

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping("google/login")
    public ResponseEntity<Map<String, Object>> googleLogin(
            @RequestBody Map<String,Object> requestMap) {
        String email = (String)requestMap.get("email");
        logger.info(">> request : email={}", email);

        Long userId = oAuthLoginService.google(email);
        logger.info("<< response : userId={}",userId);

        Map<String, Object> resultMap = new HashMap<>();

        UserInfoResDto userInfo = userService.getUserInfo(userId);
        logger.info("<< response : userInfo={}",userInfo);

        TokenResDto tokenResDto = userService.generateToken(userId, OAuthProvider.GOOGLE);
        refreshService.save(userId, tokenResDto.getRefreshToken());
        logger.info("<< response : token={}",tokenResDto);

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

}