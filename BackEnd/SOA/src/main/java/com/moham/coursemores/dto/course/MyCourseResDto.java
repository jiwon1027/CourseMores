package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class MyCourseResDto {

    private Long courseId;
    private String title;
    private String content;
    private int people;
    private boolean visited;
    private int likeCount;
    private int commentCount;
    private String sido;
    private String gugun;
    private String image;
    private String locationName;

}