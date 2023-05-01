package com.moham.coursemores.repository;

import com.moham.coursemores.domain.HashtagOfCourse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HashtagOfCourseRepository extends JpaRepository<HashtagOfCourse, Long> {
    List<HashtagOfCourse> findByCourseId(Long courseId);
    void deleteByCourseId(Long courseId);
}
