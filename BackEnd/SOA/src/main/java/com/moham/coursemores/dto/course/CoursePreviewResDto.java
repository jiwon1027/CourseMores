package com.moham.coursemores.dto.course;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
public class CoursePreviewResDto {

    private int courseId; // 코스 id
    private String title; // 제목
    private String content; // 내용
    private int people; // 인원수
    private boolean visited; // 방문 여부
    private int likeCount; // 좋아요 수
    private int commentCount; // 댓글 수
    private String mainImageUrl; // 대표 사진
    private String sido; // 시,도
    private String gugun; // 구,군
    private String locationName; // 장소 이름("장소 이름" 외 n개의 장소)
    private boolean isInterest; // 관심 여부

}