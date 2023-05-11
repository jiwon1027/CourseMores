package com.moham.coursemores.api;

import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.service.NotificationService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("notification")
@RequiredArgsConstructor
public class NotificationController {

    private static final Logger logger = LoggerFactory.getLogger(NotificationController.class);
    private final NotificationService notificationService;

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getUserNotificationList(@PathVariable Long userId) {
        logger.debug("[0/2][GET][/notification/{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/notification/{}] ... ns.getUserNotificationList", userId);
        List<NotificationResDto> notificationResDtoList = notificationService.getMyNotificationList(userId);
        resultMap.put("myNotificationList", notificationResDtoList);

        logger.debug("[2/2][GET][/notification/{}] >> response : myNotificationList\n myNotificationList = {}\n", userId, notificationResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @DeleteMapping("{notificationId}/{userId}")
    public ResponseEntity<Void> deleteInterestCourse(@PathVariable Long notificationId, @PathVariable Long userId) {
        logger.debug("[0/2][DELETE][/notification/{}/{}] << request : none", notificationId, userId);

        logger.debug("[1/2][DELETE][/notification/{}/{}] ... ns.deleteNotification", notificationId, userId);
        notificationService.deleteNotification(userId, notificationId);

        logger.debug("[2/2][DELETE][/notification/{}/{}] >> response : none\n", notificationId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}