package com.coursemores.service.repository.querydsl;

import com.coursemores.service.domain.Course;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CourseCustomRepository {

    Page<Course> searchAll(String word, Long regionId, List<Long> themeIds, Pageable pageable);
}