package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
@Getter
@Builder
public class CourseCreateReqDto {
    private String title;
    private String content;
    private int people;
    private int time;
    private boolean visited;
    private List<LocationCreateReqDto> locationList;
    private List<String> hashtagList;
    private List<Integer> themeIdList;
}
