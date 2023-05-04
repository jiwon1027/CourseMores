package com.moham.coursemores.dto.comment;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentImageResDTO {

    private long commentImageId;

    private String image;

}