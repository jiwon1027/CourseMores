package com.moham.coursemores.dto.comment;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentResDTO {
    private Long commentId;
    private String content;
    private int people;
    private int likeCount;
    private List<CommentImageResDTO> imageList;
    private LocalDateTime createTime;
    private UserSimpleInfoResDto writeUser;
}