package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CourseRepository extends JpaRepository<Course, Integer> {
    Optional<Course> findByIdAndDeleteTimeIsNull(int courseId);
    boolean existsByIdAndDeleteTimeIsNull(int courseId);
}
