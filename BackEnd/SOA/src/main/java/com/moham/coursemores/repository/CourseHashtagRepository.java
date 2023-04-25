package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CourseHashtag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CourseHashtagRepository extends JpaRepository<CourseHashtag, Integer> {
    List<CourseHashtag> findByCourseId(int courseId);
}
