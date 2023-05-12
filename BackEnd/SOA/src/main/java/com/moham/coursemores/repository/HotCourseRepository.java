package com.moham.coursemores.repository;

import com.moham.coursemores.domain.HotCourse;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


public interface HotCourseRepository extends JpaRepository<HotCourse, Long> {

    @Query(value = "SELECT * FROM hot_course order by RAND() limit :number", nativeQuery = true)
    List<HotCourse> findRandomHotCourse(@Param("number") int number);

}