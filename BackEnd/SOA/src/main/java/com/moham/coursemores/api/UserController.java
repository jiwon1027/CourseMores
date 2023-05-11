package com.moham.coursemores.api;

import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.token.TokenReissueReqDto;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("user")
@RequiredArgsConstructor
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    private final UserService userService;

    @GetMapping("validation/nickname/{nickname}")
    public ResponseEntity<Map<String,Object>> deleteUser(
            @PathVariable String nickname){
        logger.debug("[0/2][GET][/user/validation/nickname/{}] << request : none",nickname);

        Map<String,Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/user/validation/nickname/{}] ...us.isDuplicatedNickname",nickname);
        boolean isDuplicated = userService.isDuplicatedNickname(nickname);
        resultMap.put("isDuplicated", isDuplicated);

        logger.debug("[2/2][GET][/user/validation/nickname/{}] >> response : isDuplicated\n\n isDuplicated = {}\n",nickname,isDuplicated);
        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping(value = "signup", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Map<String,Object>> addUserInfo(
            @RequestPart UserInfoCreateReqDto userInfoCreateReqDto,
            @RequestPart(required = false) MultipartFile profileImage,
            @AuthenticationPrincipal User user){
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/3][POST][/user/signup] << request : userId, userInfoCreateReqDto, profileImage\n\n userId = {} \n\n userInfoCreateReqDto = {}\n\n profileImage = {}\n",
                userId, userInfoCreateReqDto, profileImage);

        Map<String,Object> resultMap = new HashMap<>();

        logger.debug("[1/3][POST][/user/signup] ...us.addUserInfo");
        userService.addUserInfo(userId,userInfoCreateReqDto,profileImage);
        logger.debug("[2/3][POST][/user/signup] ...us.getUserInfo");
        UserInfoResDto userInfo = userService.getUserInfo(userId);
        resultMap.put("userInfo",userInfo);

        logger.debug("[3/3][POST][/user/signup] >> response : userInfo\n\n userInfo = {}\n", userInfo);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("reissue")
    public ResponseEntity<Map<String, Object>> reissue(
            @RequestBody TokenReissueReqDto tokenReissueReqDto) {
        logger.debug("[0/2][POST][/user/reissue] << request : tokenReissueReqDto\n\n tokenReissueReqDto = {}\n", tokenReissueReqDto);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][POST][/user/reissue] ...us.reissue");
        String accessToken = userService.reissue(tokenReissueReqDto);
        resultMap.put("accessToken", accessToken);

        logger.debug("[2/2][POST][/user/reissue] >> response : accessToken\n\n accessToken = {}\n",accessToken);
        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

}
