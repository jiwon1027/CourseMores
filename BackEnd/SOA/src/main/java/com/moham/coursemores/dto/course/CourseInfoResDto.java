package com.moham.coursemores.dto.course;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@ToString
@Getter
@Builder
public class CourseInfoResDto {
    private String title;
    private String content;
    private int people;
    private int time;
    private boolean visited;
    private int viewCount;
    private int likeCount;
    private int interestCount;
    private int commentCount;
    private String sido;
    private String gugun;
    private LocalDateTime createTime;
    private List<String> hashtagList;
    private List<String> themeList;
    private UserSimpleInfoResDto simpleInfoOfWriter;
}
