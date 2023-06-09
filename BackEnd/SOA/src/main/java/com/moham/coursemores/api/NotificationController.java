package com.moham.coursemores.api;

import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.service.NotificationService;
import com.moham.coursemores.service.UserService;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("notification")
@RequiredArgsConstructor
public class NotificationController {

    private static final Logger logger = LoggerFactory.getLogger(NotificationController.class);

    private final UserService userService;
    private final NotificationService notificationService;

    @PostMapping("token")
    public ResponseEntity<Void> registerFirebaseToken(@AuthenticationPrincipal User user, @RequestBody Map<String, String> requestMap) {
        Long userId = Long.parseLong(user.getUsername());
        String firebaseToken = requestMap.get("firebaseToken");
        logger.debug("[0/2][POST][/notification/token][{}] << request : firebaseToken\n firebaseToken = {}", userId, firebaseToken);

        logger.debug("[1/2][POST][/notification/token][{}] ... ns.saveToken", userId);
        notificationService.saveToken(userId, firebaseToken);

        logger.debug("[2/2][POST][/notification/token][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("setting")
    public ResponseEntity<Map<String, Object>> getUserAlarmSetting(@AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][GET][/notification/setting][{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/notification/setting][{}] ... us.getMyAlarmSetting", userId);
        int myAlarmSetting = userService.getMyAlarmSetting(userId);
        resultMap.put("myAlarmSetting", myAlarmSetting);

        logger.debug("[2/2][GET][/notification/setting][{}] >> response : myAlarmSetting\n myAlarmSetting = {}\n", userId, myAlarmSetting);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PutMapping("setting")
    public ResponseEntity<Void> updateUserAlarmSetting(@AuthenticationPrincipal User user, @RequestBody Map<String, Integer> requestMap) {
        Long userId = Long.parseLong(user.getUsername());
        int updateAlarmSetting = requestMap.get("updateAlarmSetting");
        logger.debug("[0/2][PUT][/notification/setting][{}] << request : updateAlarmSetting\n updateAlarmSetting ={}", userId, updateAlarmSetting);

        logger.debug("[1/2][PUT][/notification/setting][{}] ... us.updateMyAlarmSetting", userId);
        userService.updateMyAlarmSetting(userId, updateAlarmSetting);

        logger.debug("[2/2][PUT][/notification/setting][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getUserNotificationList(@AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][GET][/notification][{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/notification][{}] ... ns.getUserNotificationList", userId);
        List<NotificationResDto> notificationResDtoList = notificationService.getMyNotificationList(userId);
        resultMap.put("myNotificationList", notificationResDtoList);

        logger.debug("[2/2][GET][/notification][{}] >> response : myNotificationList\n myNotificationList = {}\n", userId, notificationResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @DeleteMapping("{notificationId}")
    public ResponseEntity<Void> deleteInterestCourse(@PathVariable Long notificationId, @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][DELETE][/notification/{}][{}] << request : none", notificationId, userId);

        logger.debug("[1/2][DELETE][/notification/{}][{}] ... ns.deleteNotification", notificationId, userId);
        notificationService.deleteNotification(userId, notificationId);

        logger.debug("[2/2][DELETE][/notification/{}][{}] >> response : none\n", notificationId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}