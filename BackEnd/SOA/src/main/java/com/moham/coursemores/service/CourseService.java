package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Map;

public interface CourseService {
    Page<CoursePreviewResDto> search(int userId, String word, int regionId, List<Integer> themeIds, int page, String sortby);
    void increaseViewCount(int courseId);
    CourseInfoResDto getCourseInfo(int courseId);
    List<CourseDetailResDto> getCourseDetail(int courseId);
    List<MyCourseResDto> getMyCourseList(int userId);
    void addCourse(int userId, CourseCreateReqDto courseCreateReqDto);
    void setCourse(int userId, int courseId, CourseUpdateReqDto courseUpdateReqDto);
    void deleteCourse(int userId, int courseId);
}
