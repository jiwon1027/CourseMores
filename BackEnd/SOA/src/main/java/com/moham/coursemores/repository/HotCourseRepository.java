package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.HotCourse;
import com.moham.coursemores.repository.querydsl.CourseCustomRepository;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;


public interface HotCourseRepository extends JpaRepository<HotCourse, Long> {

}