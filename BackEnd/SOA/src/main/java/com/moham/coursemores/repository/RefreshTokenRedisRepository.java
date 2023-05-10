package com.moham.coursemores.repository;

import com.moham.coursemores.domain.redis.RefreshToken;
import org.springframework.data.repository.CrudRepository;

public interface RefreshTokenRedisRepository extends CrudRepository<RefreshToken, Long> {
}