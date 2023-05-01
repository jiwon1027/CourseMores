package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import java.util.Optional;

import com.moham.coursemores.repository.querydsl.CourseCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CourseRepository extends JpaRepository<Course, Long>, CourseCustomRepository {
    Optional<Course> findByIdAndUserId(Long courseId, Long userId);
    Optional<Course> findByIdAndDeleteTimeIsNull(Long courseId);
    Optional<Course> findByIdAndUserIdAndDeleteTimeIsNull(Long courseId, Long userId);
    boolean existsByIdAndDeleteTimeIsNull(Long courseId);
}
