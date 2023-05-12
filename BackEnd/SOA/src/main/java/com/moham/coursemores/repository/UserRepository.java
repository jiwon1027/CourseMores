package com.moham.coursemores.repository;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByIdAndDeleteTimeIsNull(Long userId);
    Optional<User> findByEmailAndProviderAndDeleteTimeIsNull(String email, OAuthProvider provider);
    boolean existsByNicknameAndDeleteTimeIsNull(String nickname);
}