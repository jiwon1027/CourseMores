package com.moham.coursemores.dto.comment;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;

@ToString
@Getter
@Builder
public class MyCommentResDto {

    Long commentId;
    String content;
    int people;
    int likeCount;
    List<String> imageList;
    LocalDateTime createTime;
    Long courseId;
    String courseTitle;
}