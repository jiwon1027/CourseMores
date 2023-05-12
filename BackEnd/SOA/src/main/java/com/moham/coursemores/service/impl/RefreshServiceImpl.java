package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.redis.RefreshToken;
import com.moham.coursemores.repository.RefreshTokenRedisRepository;
import com.moham.coursemores.service.RefreshService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RefreshServiceImpl implements RefreshService {

    private final RefreshTokenRedisRepository repository;
    @Value("${token.refresh.expire}")
    private long REFRESH_TOKEN_EXPIRE_TIME;

    @Override
    @Transactional
    public void save(Long userId, String refreshToken) {
        repository.save(RefreshToken.builder()
                .userId(userId)
                .refreshToken(refreshToken)
                .expiration(REFRESH_TOKEN_EXPIRE_TIME / 1000)
                .build());
    }

    @Override
    public RefreshToken get(Long userId) {
        return repository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 리프레쉬 토큰을 찾을 수 없습니다."));
    }

    @Override
    @Transactional
    public void delete(RefreshToken refreshToken) {
        repository.delete(refreshToken);
    }

}