package com.moham.coursemores.service.impl;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.moham.coursemores.common.exception.CustomErrorCode;
import com.moham.coursemores.common.exception.CustomException;
import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.domain.redis.FirebaseToken;
import com.moham.coursemores.dto.notification.NotificationResDto;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.FirebaseTokenRedisRepository;
import com.moham.coursemores.repository.NotificationRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.NotificationService;
import java.util.List;
import java.util.Objects;
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
    private final CourseRepository courseRepository;

    @Override
    @Transactional
    public void saveToken(Long userId, String firebaseToken) {
        firebaseTokenRedisRepository.save(FirebaseToken.builder()
                .userId(userId)
                .token(firebaseToken)
                .build());
    }

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
    public void makeNotification(Long userId, Long courseId, int messageType) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId, CustomErrorCode.USER_NOT_FOUND));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new CustomException(courseId, CustomErrorCode.COURSE_NOT_FOUND));

        User targetUser = course.getUser();
        String nickname = user.getNickname();
        String title = course.getTitle();

        notificationRepository.save(com.moham.coursemores.domain.Notification.builder()
                .user(targetUser)
                .messageType(messageType)
                .message(nickname + "님이 " + title + " 코스에 " + (messageType == 0 ? "좋아요를 눌렀" : "댓글을 남겼" + "습니다."))
                .build());
        sendNotification(targetUser.getId(), nickname, title, messageType);
    }

    @Override
    @Transactional
    public void deleteNotification(Long userId, Long notificationId) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId, CustomErrorCode.USER_NOT_FOUND));

        com.moham.coursemores.domain.Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new CustomException(notificationId, CustomErrorCode.NOTIFICATION_NOT_FOUND));

        if (!Objects.equals(user.getId(), notification.getUser().getId())) {
            throw new CustomException(CustomErrorCode.NOTIFICATION_NOT_DELETE);
        }

        notification.delete();
    }

    public void sendNotification(Long userId, String nickname, String title, int messageType) {
        FirebaseToken fireBaseToken = firebaseTokenRedisRepository.findById(userId)
                .orElseThrow(() -> new CustomException(CustomErrorCode.FIREBASE_TOKEN_NOT_FOUND));
        Message message = Message.builder()
                .setToken(fireBaseToken.getToken())
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(nickname + "님이 회원님의 코스에 " + (messageType == 0 ? "좋아요를 눌렀" : "댓글을 남겼" + "습니다."))
                        .build())
                .build();
        try {
            firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            throw new CustomException(CustomErrorCode.FAIL_SEND_NOTIFICATION);
        }
    }

}