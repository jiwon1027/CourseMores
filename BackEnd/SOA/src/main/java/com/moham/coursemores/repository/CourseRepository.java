package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CourseRepository extends JpaRepository<Course, Integer> {
    Optional<Course> findByIdAndDeleteTimeIsNull(int courseId);
}
