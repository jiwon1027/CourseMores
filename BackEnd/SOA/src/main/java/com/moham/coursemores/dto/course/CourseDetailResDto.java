package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

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
