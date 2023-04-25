package com.moham.coursemores.dto.interest;

import com.moham.coursemores.dto.course.CoursePreviewResDto;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
public class InterestCourseResDto {

    private int interestCourseId;
    private CoursePreviewResDto CoursePreviewResDto;

}