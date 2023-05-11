package com.moham.coursemores.domain.redis;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

@Getter
@ToString
@RedisHash(value = "firebaseToken")
public class FirebaseToken {

    @Id
    private Long userId;
    private String firebaseToken;

    @Builder
    public FirebaseToken(Long userId, String firebaseToken) {
        this.userId = userId;
        this.firebaseToken = firebaseToken;
    }

}