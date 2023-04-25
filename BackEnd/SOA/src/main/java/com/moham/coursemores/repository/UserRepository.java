package com.moham.coursemores.repository;

import com.moham.coursemores.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByIdAndDeleteTimeIsNull(int userId);
}
