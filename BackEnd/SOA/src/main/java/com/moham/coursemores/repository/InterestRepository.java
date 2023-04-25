package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Interest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InterestRepository extends JpaRepository<Interest, Integer> {
    List<Interest> findByUserId(int userId);
}
