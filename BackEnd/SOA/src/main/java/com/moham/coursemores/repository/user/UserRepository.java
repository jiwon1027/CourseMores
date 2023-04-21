package com.moham.coursemores.repository.user;

import com.moham.coursemores.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
}
