package com.moham.coursemores.repository;

import com.moham.coursemores.domain.redis.FirebaseToken;
import org.springframework.data.repository.CrudRepository;

public interface FirebaseTokenRedisRepository extends CrudRepository<FirebaseToken, Long> {

}