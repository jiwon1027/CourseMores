package com.coursemores.service.dto.course;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CourseUpdateReqDto {

    private String title;
    private String content;
    private int people;
    private int time;
    private boolean visited;
    private List<LocationUpdateReqDto> locationList;
    private List<String> hashtagList;
    private List<Long> themeIdList;
}