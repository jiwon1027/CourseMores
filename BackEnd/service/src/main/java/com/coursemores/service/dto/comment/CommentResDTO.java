package com.coursemores.service.dto.comment;

import com.coursemores.service.dto.profile.UserSimpleInfoResDto;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentResDTO {

    Long commentId;
    String content;
    int people;
    int likeCount;
    List<String> imageList;
    UserSimpleInfoResDto writeUser;

}