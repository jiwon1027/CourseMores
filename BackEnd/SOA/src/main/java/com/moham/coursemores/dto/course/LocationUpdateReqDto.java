package com.moham.coursemores.dto.course;

import java.util.List;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class LocationUpdateReqDto {

    private Long courseLocationId;
    private String name;
    private String title;
    private String content;

    private List<Long> deleteImageList;
    private int numberOfImage;

}