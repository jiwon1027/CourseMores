package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;

import java.util.List;

public interface CourseService {
    CourseInfoResDto getCourseInfo(int courseId) throws Exception;
    List<CourseDetailResDto> getCourseDetail(int courseId) throws Exception;
}
