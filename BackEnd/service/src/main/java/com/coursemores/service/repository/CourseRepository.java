package com.coursemores.service.repository;

import com.coursemores.service.domain.Course;
import com.coursemores.service.repository.querydsl.CourseCustomRepository;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CourseRepository extends JpaRepository<Course, Long>, CourseCustomRepository {

    Optional<Course> findByIdAndUserId(Long courseId, Long userId);

    Optional<Course> findByIdAndDeleteTimeIsNull(Long courseId);

    Optional<Course> findByIdAndUserIdAndDeleteTimeIsNull(Long courseId, Long userId);

    boolean existsByIdAndDeleteTimeIsNull(Long courseId);
}