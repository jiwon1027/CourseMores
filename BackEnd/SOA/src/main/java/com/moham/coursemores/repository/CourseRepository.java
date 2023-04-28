package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import java.util.Optional;

import com.moham.coursemores.repository.querydsl.CourseCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;


public interface CourseRepository extends JpaRepository<Course, Integer>, CourseCustomRepository {
    Optional<Course> findByIdAndUserId(int courseId, int userId);
    Optional<Course> findByIdAndDeleteTimeIsNull(int courseId);
    boolean existsByIdAndDeleteTimeIsNull(int courseId);
}
