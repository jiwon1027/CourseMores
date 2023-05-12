package com.moham.coursemores.dto.course;

import java.util.List;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CourseUpdateReqDto {

    @NotBlank(message = "제목은 필수 입력 값입니다.")
    private String title;
    @Size(max = 5000, message = "내용은 공백 포함 5000자 이하여야 합니다.")
    private String content;
    private int people;
    private int time;
    @NotNull(message = "방문 여부는 필수 입력 값입니다.")
    private Boolean visited;
    private List<LocationUpdateReqDto> locationList;
    private List<String> hashtagList;
    private List<Long> themeIdList;

}