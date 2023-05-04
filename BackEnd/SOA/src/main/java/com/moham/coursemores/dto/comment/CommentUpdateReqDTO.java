package com.moham.coursemores.dto.comment;

import java.util.List;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CommentUpdateReqDTO {

    String content;
    int people;
    List<Long> deleteImageList;

}