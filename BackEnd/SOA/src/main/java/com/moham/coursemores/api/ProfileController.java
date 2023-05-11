package com.moham.coursemores.api;

import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import com.moham.coursemores.service.ProfileService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("profile")
@RequiredArgsConstructor
public class ProfileController {

    private static final Logger logger = LoggerFactory.getLogger(ProfileController.class);

    private final ProfileService profileService;

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> myProfile(
            @PathVariable Long userId) {
        logger.debug("[0/2][GET][/profile/{}] >> request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/profile/{}] ...ps.getMyProfile", userId);
        UserInfoResDto userInfoResDto = profileService.getMyProfile(userId);
        resultMap.put("userInfo", userInfoResDto);

        logger.debug("[2/2][GET][/profile/{}] << response : userInfo\n userInfo = {}", userId, userInfoResDto);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PutMapping("{userId}/alram")
    public ResponseEntity<Void> alarmSetting(
            @PathVariable Long userId){
        logger.debug("[0/?][PUT][/profile/{}/alram] >> request : none", userId);
        
        // 알림 셋팅

        logger.debug("[?/?][PUT][/profile/{}/alram] << response : none", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("{userId}")
    public ResponseEntity<Void> putUserInfo(
            @PathVariable Long userId,
            @RequestPart UserInfoUpdateReqDto userInfoUpdateReqDto,
            @RequestPart(required = false) MultipartFile profileImage){
        logger.debug("[0/2][PUT][/profile/{}] >> request : userInfoUpdateReqDto, profileImage\n userInfoUpdateReqDto = {}\n profileImage = {}",
                userId, userInfoUpdateReqDto, profileImage);

        logger.debug("[1/2][PUT][/profile/{}] ...ps.updateUserInfo",userId);
        profileService.updateUserInfo(userId, userInfoUpdateReqDto, profileImage);

        logger.debug("[2/2][PUT][/profile/{}] << response : none", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("logout")
    public ResponseEntity<Void> logout() {
        logger.debug("[0/2][GET][/profile/logout] >> request : none");
        // 로그아웃 처리
        logger.debug("[1/2][GET][/profile/logout] ...");

        logger.debug("[2/2][GET][/profile/logout] << response : none");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("{userId}")
    public ResponseEntity<Void> deleteUser(
            @PathVariable Long userId){
        logger.debug("[0/2][DELETE][/profile/{}] >> request : none", userId);

        logger.debug("[1/2][DELETE][/profile/{}] ...ps.deleteUser", userId);
        profileService.deleteUser(userId);

        logger.debug("[2/2][DELETE][/profile/{}] << response : none",userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
