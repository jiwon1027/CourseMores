package com.coursemores.service.dto.course;

import com.coursemores.service.dto.profile.UserSimpleInfoResDto;
import java.util.List;
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
    private String mainImage;
    private List<String> hashtagList;
    private List<Long> themeIdList;
    private UserSimpleInfoResDto simpleInfoOfWriter;
}