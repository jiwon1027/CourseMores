package com.moham.coursemores.dto.comment;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentResDTO {
    int commentId;
    String content;
    int people;
    int likeCount;
    List<String> imageList;
    UserSimpleInfoResDto writeUser;

}
