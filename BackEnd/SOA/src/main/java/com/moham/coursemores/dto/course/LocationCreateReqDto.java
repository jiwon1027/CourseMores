package com.moham.coursemores.dto.course;

import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class LocationCreateReqDto {

    private double latitude;
    private double longitude;
    private String name;
    private String title;
    private String content;
    private Long regionId;

    private String roadViewImage;
    private int numberOfImage;

}