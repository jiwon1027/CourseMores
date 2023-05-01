package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CourseLike;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseLikeRepository extends JpaRepository<CourseLike, Long> {

    Optional<CourseLike> findByUserIdAndCourseId(Long userId, Long courseId);


}