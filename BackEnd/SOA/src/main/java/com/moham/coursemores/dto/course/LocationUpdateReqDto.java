package com.moham.coursemores.dto.course;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class LocationUpdateReqDto {

    @NotNull(message = "장소의 id는 필수 입력 값입니다.")
    private Long courseLocationId;
    @NotBlank(message = "장소명은 필수 입력 값입니다.")
    @Size(max = 50, message = "장소명은 공백 포함 50자 이하여야 합니다.")
    private String name;
    @Size(max = 50, message = "요약 정보는 공백 포함 50자 이하여야 합니다.")
    private String title;
    @Size(max = 5000, message = "내용은 공백 포함 5000자 이하여야 합니다.")
    private String content;
    @NotNull(message = "사진의 개수는 필수 입력 값입니다.")
    private Integer numberOfImage;

}