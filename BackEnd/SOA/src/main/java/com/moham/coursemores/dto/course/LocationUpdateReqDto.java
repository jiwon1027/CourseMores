package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

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
