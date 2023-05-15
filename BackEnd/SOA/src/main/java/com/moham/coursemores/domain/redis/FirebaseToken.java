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
    private String token;

    @Builder
    public FirebaseToken(Long userId, String token) {
        this.userId = userId;
        this.token = token;
    }

}