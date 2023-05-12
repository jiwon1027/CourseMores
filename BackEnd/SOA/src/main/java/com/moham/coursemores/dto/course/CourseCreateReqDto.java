package com.moham.coursemores.dto.course;

import java.util.List;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CourseCreateReqDto {

    private String title;
    private String content;
    private int people;
    private int time;
    private boolean visited;
    private List<LocationCreateReqDto> locationList;
    private List<String> hashtagList;
    private List<Long> themeIdList;

}