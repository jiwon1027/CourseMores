package com.moham.coursemores.service.impl;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.domain.redis.FirebaseToken;
import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.repository.FirebaseTokenRedisRepository;
import com.moham.coursemores.repository.NotificationRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.NotificationService;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@EnableAsync
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationServiceImpl implements NotificationService {

    private final FirebaseMessaging firebaseMessaging;
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final FirebaseTokenRedisRepository firebaseTokenRedisRepository;

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

    @Async
    @Override
    @Transactional
    public void makeNotification(Long targetUserId, String nickname, String title, int messageType) {
        User targetUser = userRepository.findByIdAndDeleteTimeIsNull(targetUserId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        notificationRepository.save(com.moham.coursemores.domain.Notification.builder()
                .user(targetUser)
                .messageType(messageType)
                .message(nickname + "님이 " + title + " 코스에 " + (messageType == 0 ? "좋아요를 눌렀" : "댓글을 남겼" + "습니다."))
                .build());
        sendNotification(targetUserId, nickname, title, messageType);
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

    @Async
    public void sendNotification(Long userId, String nickname, String title, int messageType) {
        FirebaseToken fireBaseToken = firebaseTokenRedisRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 FirebaseToken을 찾을 수 없습니다."));
        Message message = Message.builder()
                .setToken(fireBaseToken.getFirebaseToken())
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(nickname + "님이 회원님의 코스에 " + (messageType == 0 ? "좋아요를 눌렀" : "댓글을 남겼" + "습니다."))
                        .build())
                .build();
        try {
            firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException("실시간 알림 보내기에 실패하였습니다.");
        }
    }

}