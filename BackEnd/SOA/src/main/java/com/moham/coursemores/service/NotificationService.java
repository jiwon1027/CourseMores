package com.moham.coursemores.service;

import com.moham.coursemores.dto.notification.NotificationResDto;
import java.util.List;

public interface NotificationService {

    List<NotificationResDto> getMyNotificationList(Long userId);

    void makeNotification(Long targetUserId, String nickname, String title, int messageType);

    void deleteNotification(Long userId, Long notificationId);

}