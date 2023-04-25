package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
@Getter
@Builder
public class LocationUpdateReqDto {
    private int courseLocationId;
    private String name;
    private String content;
    private List<String> imageList;
}
