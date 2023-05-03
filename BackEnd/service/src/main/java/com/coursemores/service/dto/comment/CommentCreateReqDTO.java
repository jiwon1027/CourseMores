package com.coursemores.service.dto.comment;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class CommentCreateReqDTO {

    String content;
    int people;
    List<String> imageList;

}