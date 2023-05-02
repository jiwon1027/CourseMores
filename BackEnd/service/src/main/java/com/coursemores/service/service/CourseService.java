package com.coursemores.service.service;

import com.coursemores.service.dto.course.CourseCreateReqDto;
import com.coursemores.service.dto.course.CourseDetailResDto;
import com.coursemores.service.dto.course.CourseInfoResDto;
import com.coursemores.service.dto.course.CoursePreviewResDto;
import com.coursemores.service.dto.course.CourseUpdateReqDto;
import com.coursemores.service.dto.course.MyCourseResDto;
import java.util.List;
import org.springframework.data.domain.Page;

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