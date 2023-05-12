package com.moham.coursemores.service.impl;

import com.moham.coursemores.dto.theme.ThemeResDto;
import com.moham.coursemores.repository.ThemeRepository;
import com.moham.coursemores.service.ThemeService;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ThemeServiceImpl implements ThemeService {

    private final ThemeRepository themeRepository;

    @Override
    public List<ThemeResDto> getThemeList() {
        return themeRepository.findAll()
                .stream()
                .map(theme -> ThemeResDto.builder()
                        .themeId(theme.getId())
                        .name(theme.getName())
                        .build())
                .collect(Collectors.toList());
    }

}