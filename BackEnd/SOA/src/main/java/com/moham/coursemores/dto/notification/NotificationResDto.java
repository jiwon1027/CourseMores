package com.moham.coursemores.dto.notification;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
public class NotificationResDto {

    private Long notificationId;
    private int messageType;
    private String message;

}