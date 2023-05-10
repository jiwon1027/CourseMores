package com.moham.coursemores.dto.elasticsearch;


import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import java.util.Set;

@ToString
@Getter
@Builder
public class IndexDataResDTO {
    private Set<String> courses;
    private Set<String> courselocations;
    private Set<String> hashtags;
}
