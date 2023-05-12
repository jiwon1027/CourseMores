package com.moham.coursemores.dto.comment;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class MyCommentResDto {
    private Long commentId;
    private String content;
    private int people;
    private int likeCount;
    private List<String> imageList;
    private LocalDateTime createTime;
    private Long courseId;
    private String courseTitle;
}