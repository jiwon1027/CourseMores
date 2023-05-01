package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.*;
import org.springframework.data.domain.Page;

import java.util.List;

public interface CourseService {
    Page<CoursePreviewResDto> search(Long userId, String word, Long regionId, List<Long> themeIds, int page, String sortby);
    void increaseViewCount(Long courseId);
    CourseInfoResDto getCourseInfo(Long courseId);
    List<CourseDetailResDto> getCourseDetail(Long courseId);
    List<MyCourseResDto> getMyCourseList(Long userId);
    void addCourse(Long userId, CourseCreateReqDto courseCreateReqDto);
    void setCourse(Long userId, Long courseId, CourseUpdateReqDto courseUpdateReqDto);
    void deleteCourse(Long userId, Long courseId);
}
