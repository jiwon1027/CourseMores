package com.moham.coursemores.dto.theme;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
public class ThemeResDto {
    Long themeId;
    String name;
}
