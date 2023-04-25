package com.moham.coursemores.service;

import com.moham.coursemores.dto.interest.InterestCourseResDto;
import java.util.List;

public interface InterestService {

    List<InterestCourseResDto> getUserInterestCourseList(int userId);

    boolean checkInterest(int userId, int courseId);

}