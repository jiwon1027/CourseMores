package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Interest;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InterestRepository extends JpaRepository<Interest, Long> {

    List<Interest> findByUserIdAndFlag(Long userId, boolean flag);
    Optional<Interest> findByUserIdAndCourseId(Long userId, Long courseId);
    List<Interest> findByFlagIsTrueAndRegisterTimeAfter(LocalDateTime localDateTime);

}