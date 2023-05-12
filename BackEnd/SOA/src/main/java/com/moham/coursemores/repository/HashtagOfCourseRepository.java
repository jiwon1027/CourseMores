package com.moham.coursemores.repository;

import com.moham.coursemores.domain.HashtagOfCourse;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HashtagOfCourseRepository extends JpaRepository<HashtagOfCourse, Long> {

    List<HashtagOfCourse> findByCourseId(Long courseId);

    void deleteByCourseId(Long courseId);

}