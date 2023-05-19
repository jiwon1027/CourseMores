package com.moham.coursemores.dto.course;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CourseDetailResDto {

    private Long courseLocationId;
    private String name;
    private String title;
    private String content;
    private double latitude;
    private double longitude;
    private String sido;
    private String gugun;
    private String roadViewImage;
    private List<String> locationImageList;

}