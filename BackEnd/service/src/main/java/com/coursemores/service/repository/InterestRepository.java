package com.coursemores.service.repository;

import com.coursemores.service.domain.Interest;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InterestRepository extends JpaRepository<Interest, Long> {

    List<Interest> findByUserIdAndFlag(Long userId, boolean flag);

    Optional<Interest> findByUserIdAndCourseId(Long userId, Long courseId);
}