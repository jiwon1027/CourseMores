package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CourseLocation;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseLocationRepository extends JpaRepository<CourseLocation, Long> {

    List<CourseLocation> findByCourseId(Long courseId);

}