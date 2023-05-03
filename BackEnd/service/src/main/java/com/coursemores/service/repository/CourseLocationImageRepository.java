package com.coursemores.service.repository;

import com.coursemores.service.domain.CourseLocationImage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseLocationImageRepository extends JpaRepository<CourseLocationImage, Long> {

    void deleteByCourseLocationId(Long courseLocationId);
}