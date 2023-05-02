package com.coursemores.service.repository;

import com.coursemores.service.domain.ThemeOfCourse;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ThemeOfCourseRepository extends JpaRepository<ThemeOfCourse, Long> {

    List<ThemeOfCourse> findByCourseId(Long courseId);

    void deleteByCourseId(Long courseId);
}