package com.coursemores.service.dto.course;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CourseDetailResDto {

    private String name;
    private String title;
    private String content;
    private double latitude;
    private double longitude;
    private String sido;
    private String gugun;
    private List<String> locationImage;
}