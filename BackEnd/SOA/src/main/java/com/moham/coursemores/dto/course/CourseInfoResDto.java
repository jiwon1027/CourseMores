package com.moham.coursemores.dto.course;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import lombok.*;

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
    private String mainImage;
    private List<String> hashtagList;
    private List<Integer> themeIdList;
    private UserSimpleInfoResDto simpleInfoOfWriter;
}
