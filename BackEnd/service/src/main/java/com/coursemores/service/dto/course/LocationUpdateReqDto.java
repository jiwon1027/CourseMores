package com.coursemores.service.dto.course;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class LocationUpdateReqDto {

    private Long courseLocationId;
    private String name;
    private String title;
    private String content;
    private List<String> imageList;
}