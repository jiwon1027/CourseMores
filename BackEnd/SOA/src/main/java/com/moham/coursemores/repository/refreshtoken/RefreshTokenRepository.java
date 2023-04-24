package com.moham.coursemores.repository.refreshtoken;

import com.moham.coursemores.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Integer> {
}
