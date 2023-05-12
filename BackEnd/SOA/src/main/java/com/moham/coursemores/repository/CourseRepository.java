package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.dto.course.NearPreviewResDto;
import com.moham.coursemores.repository.querydsl.CourseCustomRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


public interface CourseRepository extends JpaRepository<Course, Long>, CourseCustomRepository {

    Optional<Course> findByIdAndUserId(Long courseId, Long userId);

    Optional<Course> findByIdAndDeleteTimeIsNull(Long courseId);

    Optional<Course> findByIdAndUserIdAndDeleteTimeIsNull(Long courseId, Long userId);

    boolean existsByIdAndDeleteTimeIsNull(Long courseId);

    @Query("SELECT new com.moham.coursemores.dto.course.NearPreviewResDto(c.id, c.title, c.content, c.image, c.sido, c.gugun, " +
            "(SQRT(POWER(c.latitude - :lat, 2) + POWER(c.longitude - :lng, 2)) * 111.13384)) " +
            "FROM Course c " +
            "ORDER BY (SQRT(POWER(c.latitude - :lat, 2) + POWER(c.longitude - :lng, 2)) * 111.13384)")
    List<NearPreviewResDto> findTop5CoursesByLocation(@Param("lat") double lat, @Param("lng") double lng, Pageable pageable);

}