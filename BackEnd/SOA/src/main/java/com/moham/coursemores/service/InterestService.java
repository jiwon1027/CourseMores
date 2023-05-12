package com.moham.coursemores.service;

import com.moham.coursemores.dto.interest.InterestCourseResDto;
import java.util.List;

public interface InterestService {

    List<InterestCourseResDto> getUserInterestCourseList(Long userId);

    boolean checkInterest(Long userId, Long courseId);

    void addInterestCourse(Long userId, Long courseId);

    void deleteInterestCourse(Long userId, Long courseId);

}