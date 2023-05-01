package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CourseLocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CourseLocationRepository extends JpaRepository<CourseLocation, Long> {
    List<CourseLocation> findByCourseId(Long courseId);
}
