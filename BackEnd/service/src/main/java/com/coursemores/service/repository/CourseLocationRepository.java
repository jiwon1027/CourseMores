package com.coursemores.service.repository;

import com.coursemores.service.domain.CourseLocation;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseLocationRepository extends JpaRepository<CourseLocation, Long> {

    List<CourseLocation> findByCourseId(Long courseId);
}