package com.moham.coursemores.repository.course;

import com.moham.coursemores.domain.Course;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseRepository extends JpaRepository<Course, Integer> {

}
