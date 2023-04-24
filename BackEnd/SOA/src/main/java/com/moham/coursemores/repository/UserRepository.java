package com.moham.coursemores.repository;

import com.moham.coursemores.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
}
