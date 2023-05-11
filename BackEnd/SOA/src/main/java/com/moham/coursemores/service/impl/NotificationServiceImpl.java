package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.repository.NotificationRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.NotificationService;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    @Override
    public List<NotificationResDto> getMyNotificationList(Long userId) {
        return notificationRepository.findByUserIdAndDeleteTimeIsNull(userId).stream()
                .map(notification -> NotificationResDto.builder()
                        .notificationId(notification.getId())
                        .messageType(notification.getMessageType())
                        .message(notification.getMessage())
                        .build()
                ).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void deleteNotification(Long userId, Long notificationId) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        com.moham.coursemores.domain.Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("해당 알림을 찾을 수 없습니다."));

        notification.delete();
    }


}