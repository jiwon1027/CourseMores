package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "notification")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Notification extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Long id;

    @NotNull
    @Column
    private int messageType;

    @NotNull
    @Column
    private String message;

    @NotNull
    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user; // 알림을 받은 유저

    @Builder
    public Notification(int messageType, String message, User user) {
        this.messageType = messageType;
        this.message = message;
        this.user = user;
    }

    public void delete() {
        this.deleteTime = LocalDateTime.now();
    }

}