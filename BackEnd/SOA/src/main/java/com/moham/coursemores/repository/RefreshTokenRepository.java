package com.moham.coursemores.repository;

import com.moham.coursemores.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepository  extends JpaRepository<RefreshToken, Long> {
}
