package com.moham.coursemores.dto.elasticsearch;


import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
@Getter
@Builder
public class IndexDataResDTO {
    private List<String> courses;
    private List<String> hashtags;
}
