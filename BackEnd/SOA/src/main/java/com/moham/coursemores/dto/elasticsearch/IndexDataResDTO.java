package com.moham.coursemores.dto.elasticsearch;


import java.util.Set;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class IndexDataResDTO {

    private Set<String> courses;
    private Set<String> courselocations;
    private Set<String> hashtags;

}