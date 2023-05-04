package com.moham.coursemores.api;

import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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
        logger.info(">> request : nickname={}", nickname);

        Map<String,Object> resultMap = new HashMap<>();

        boolean isDuplicated = userService.isDuplicatedNickname(nickname);
        resultMap.put("isDuplicated", isDuplicated);
        logger.info("<< response : isDuplicated={}",isDuplicated);

        return new ResponseEntity<>(resultMap,HttpStatus.OK);
    }

    @PostMapping(value = "signup/{userId}", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Void> addUserInfo(
            @RequestPart UserInfoCreateReqDto userInfoCreateReqDto,
            @RequestPart(required = false) MultipartFile profileImage,
            @PathVariable Long userId){
        logger.info(">> request : userInfoCreateReqDto={}", userInfoCreateReqDto);

        userService.addUserInfo(userId,userInfoCreateReqDto,profileImage);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
