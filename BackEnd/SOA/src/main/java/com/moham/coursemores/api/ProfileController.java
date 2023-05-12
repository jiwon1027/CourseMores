package com.moham.coursemores.api;

import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import com.moham.coursemores.service.ProfileService;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("profile")
@RequiredArgsConstructor
public class ProfileController {

    private static final Logger logger = LoggerFactory.getLogger(ProfileController.class);

    private final ProfileService profileService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> myProfile(
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][GET][/profile][{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/profile][{}] ...ps.getMyProfile", userId);
        UserInfoResDto userInfoResDto = profileService.getMyProfile(userId);
        resultMap.put("userInfo", userInfoResDto);

        logger.debug("[2/2][GET][/profile][{}] >> response : userInfo\n userInfo = {}\n", userId, userInfoResDto);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PutMapping("alram")
    public ResponseEntity<Void> alarmSetting(
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/?][PUT][/profile/alram][{}] << request : none", userId);

        // 알림 셋팅

        logger.debug("[?/?][PUT][/profile/alram][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<Void> putUserInfo(
            @AuthenticationPrincipal User user,
            @RequestPart UserInfoUpdateReqDto userInfoUpdateReqDto,
            @RequestPart(required = false) MultipartFile profileImage) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][PUT][/profile][{}] << request : userInfoUpdateReqDto, profileImage\n userInfoUpdateReqDto = {}\n profileImage = {}",
                userId, userInfoUpdateReqDto, profileImage);

        logger.debug("[1/2][PUT][/profile][{}] ...ps.updateUserInfo", userId);
        profileService.updateUserInfo(userId, userInfoUpdateReqDto, profileImage);

        logger.debug("[2/2][PUT][/profile][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("logout")
    public ResponseEntity<Void> logout(
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][GET][/profile/logout][{}] << request : none", userId);
        // 로그아웃 처리
        logger.debug("[1/2][GET][/profile/logout][{}] ...",userId);

        logger.debug("[2/2][GET][/profile/logout][{}] >> response : none\n",userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteUser(
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][DELETE][/profile][{}] << request : none", userId);

        logger.debug("[1/2][DELETE][/profile][{}] ...ps.deleteUser", userId);
        profileService.deleteUser(userId);

        logger.debug("[2/2][DELETE][/profile][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}