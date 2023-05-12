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

    Long commentId;
    String content;
    int people;
    int likeCount;
    List<String> imageList;
    LocalDateTime createTime;
    Long courseId;
    String courseTitle;

}