package com.moham.coursemores.dto.comment;

import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CommentCreateReqDTO {

    String content;
    int people;

}