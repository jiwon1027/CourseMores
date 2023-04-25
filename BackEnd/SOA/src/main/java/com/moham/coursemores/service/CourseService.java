package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.CourseInfoResDto;

public interface CourseService {
    CourseInfoResDto getCourseInfo(int courseId) throws Exception;
}
