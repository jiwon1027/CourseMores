package com.moham.coursemores.dto.course;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import java.time.LocalDateTime;
import java.util.List;

import com.moham.coursemores.dto.theme.ThemeResDto;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

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
    private List<ThemeResDto> themeList;
    private UserSimpleInfoResDto simpleInfoOfWriter;
    private boolean isWrite;
}