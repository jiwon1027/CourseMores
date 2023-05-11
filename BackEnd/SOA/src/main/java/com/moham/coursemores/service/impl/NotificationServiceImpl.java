package com.moham.coursemores.service.impl;

import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.repository.NotificationRepository;
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

}