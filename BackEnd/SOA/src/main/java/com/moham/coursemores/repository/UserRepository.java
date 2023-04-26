package com.moham.coursemores.repository;

import com.moham.coursemores.domain.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByIdAndDeleteTimeIsNull(int userId);
    Optional<User> findByProviderAndProviderId(String provider, String providerId);
}
