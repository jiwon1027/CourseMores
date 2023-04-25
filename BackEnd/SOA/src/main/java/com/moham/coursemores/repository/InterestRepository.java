package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Interest;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InterestRepository extends JpaRepository<Interest, Integer> {

    List<Interest> findByUserId(int userId);

    boolean existsByUserIdAndCourseId(int userId, int courseId);

}