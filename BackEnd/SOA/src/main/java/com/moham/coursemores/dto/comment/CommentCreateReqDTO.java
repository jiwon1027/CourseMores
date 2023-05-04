package com.moham.coursemores.dto.comment;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentCreateReqDTO {

    String content;
    int people;

}