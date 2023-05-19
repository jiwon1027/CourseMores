package com.moham.coursemores.service;

import com.moham.coursemores.dto.theme.ThemeResDto;
import java.util.List;

public interface ThemeService {

    List<ThemeResDto> getThemeList();
    List<ThemeResDto> getHomeThemeList();
}