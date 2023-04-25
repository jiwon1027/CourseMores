package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.dto.course.MyCourseResDto;

import java.util.List;

public interface CourseService {
    CourseInfoResDto getCourseInfo(int courseId);
    List<CourseDetailResDto> getCourseDetail(int courseId);
    List<MyCourseResDto> getMyCourseList(int userId);
}
