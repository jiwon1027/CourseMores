package com.moham.coursemores.service;

import com.moham.coursemores.domain.redis.RefreshToken;

import java.util.Optional;

public interface RefreshService {

    void save(Long userId, String refreshToken);

    Optional<RefreshToken> get(Long userId);

    void delete(RefreshToken refreshToken);

}