package com.moham.coursemores.dto.comment;

import java.util.List;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CommentUpdateReqDTO {
    private String content;
    private int people;
    private List<Long> deleteImageList;
}