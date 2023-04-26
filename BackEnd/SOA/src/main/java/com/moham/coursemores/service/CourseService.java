package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.*;

import java.util.List;

public interface CourseService {
    CourseInfoResDto getCourseInfo(int courseId);
    List<CourseDetailResDto> getCourseDetail(int courseId);
    List<MyCourseResDto> getMyCourseList(int userId);
    void addCourse(int userId, CourseCreateReqDto courseCreateReqDto);
    void setCourse(int userId, int courseId, CourseUpdateReqDto courseUpdateReqDto);
    void deleteCourse(int userId, int courseId);
}
