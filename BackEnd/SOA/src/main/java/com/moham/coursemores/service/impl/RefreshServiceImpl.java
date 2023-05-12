package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.redis.RefreshToken;
import com.moham.coursemores.repository.RefreshTokenRedisRepository;
import com.moham.coursemores.service.RefreshService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

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
    public Optional<RefreshToken> get(Long userId) {
        return repository.findById(userId);
    }

    @Override
    @Transactional
    public void delete(RefreshToken refreshToken) {
        repository.delete(refreshToken);
    }

}