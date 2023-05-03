package com.coursemores.service.dto.course;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class LocationCreateReqDto {

    private double latitude;
    private double longitude;
    private String name;
    private String title;
    private String content;
    private Long regionId;
    private List<String> imageList;
}