package com.moham.coursemores.dto.elasticsearch;


import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
public class IndexDataReqDTO {
    private String id;
    private String title;
    private List<String> courselocationList;
    private List<String> hashtagList;

}
