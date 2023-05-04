package com.moham.coursemores.dto.elasticsearch;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class IndexSimpleDataReqDTO {
    private String index;
    private String id;
}
