package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CourseLocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CourseLocationRepository extends JpaRepository<CourseLocation, Integer> {
    List<CourseLocation> findByCourseId(int courseId);
}
