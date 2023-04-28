package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
@Getter
@Builder
public class LocationCreateReqDto {
    private double latitude;
    private double longitude;
    private String name;
    private String title;
    private String content;
    private int regionId;
    private List<String> imageList;
}
