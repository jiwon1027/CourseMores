package com.coursemores.service.dto.interest;

import com.coursemores.service.dto.course.CoursePreviewResDto;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class InterestCourseResDto {

    private Long interestCourseId;
    private CoursePreviewResDto coursePreviewResDto;

}