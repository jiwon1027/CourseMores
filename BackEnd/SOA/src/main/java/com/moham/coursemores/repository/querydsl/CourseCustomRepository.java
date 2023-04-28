package com.moham.coursemores.repository.querydsl;

import com.moham.coursemores.domain.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CourseCustomRepository {
    Page<Course> searchAll(String word, int regionId, List<Integer> themeIds, Pageable pageable);
}
