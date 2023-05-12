package com.moham.coursemores.domain.redis;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.TimeToLive;

@Getter
@ToString
@RedisHash(value = "refreshToken")
public class RefreshToken {

    @Id
    private Long userId;
    private String refreshToken;
    @TimeToLive
    private Long expiration;

    @Builder
    public RefreshToken(Long userId, String refreshToken, Long expiration) {
        this.userId = userId;
        this.refreshToken = refreshToken;
        this.expiration = expiration;
    }
}