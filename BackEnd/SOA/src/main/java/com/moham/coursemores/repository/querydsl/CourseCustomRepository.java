package com.moham.coursemores.repository.querydsl;

import com.moham.coursemores.domain.Course;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CourseCustomRepository {

    Page<Course> searchAll(String word, Long regionId, List<Long> themeIds, int isVisited, Pageable pageable);
    Map<String, List<Integer>> testES();
}