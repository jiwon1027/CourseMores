package com.coursemores.service.repository;

import com.coursemores.service.domain.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByIdAndDeleteTimeIsNull(Long userId);

//    Optional<User> findByProviderAndProviderId(String provider, String providerId);
}