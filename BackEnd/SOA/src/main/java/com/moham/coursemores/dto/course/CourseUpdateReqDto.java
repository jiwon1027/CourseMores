package com.moham.coursemores.dto.course;

import java.util.List;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
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