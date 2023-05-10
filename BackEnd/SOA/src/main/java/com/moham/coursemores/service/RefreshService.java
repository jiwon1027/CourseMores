package com.moham.coursemores.service;

import com.moham.coursemores.domain.redis.RefreshToken;

public interface RefreshService {
    void save(Long userId, String refreshToken);
    RefreshToken get(Long userId);
    void delete(RefreshToken refreshToken);
}
