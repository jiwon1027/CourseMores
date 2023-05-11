package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CourseImportResDto {
    double latitude;
    double longitude;
    String name;
    String sido;
    String gugun;
}
