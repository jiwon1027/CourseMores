package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
public class MainPreviewResDto {

    private Long courseId; // 코스 id
    private String title; // 제목
    private String content; // 내용
    private String image; // 대표 사진
    private String sido; // 시도
    private String gugun; // 구군

}