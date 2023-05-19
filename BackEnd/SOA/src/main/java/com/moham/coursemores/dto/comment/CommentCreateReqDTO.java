package com.moham.coursemores.dto.comment;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class CommentCreateReqDTO {

    @NotBlank(message = "내용은 필수 입력 값입니다.")
    @Size(max = 5000, message = "내용은 공백 포함 5000자 이하여야 합니다.")
    private String content;
    private int people;
}