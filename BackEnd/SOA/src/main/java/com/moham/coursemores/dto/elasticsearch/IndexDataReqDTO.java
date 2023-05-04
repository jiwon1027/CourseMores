package com.moham.coursemores.dto.elasticsearch;


import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
public class IndexDataReqDTO {
    private String index;
    private String id;
    private String value;
}
