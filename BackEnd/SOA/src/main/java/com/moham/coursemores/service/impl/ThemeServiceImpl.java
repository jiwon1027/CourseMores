package com.moham.coursemores.service.impl;

import com.moham.coursemores.service.ThemeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ThemeServiceImpl implements ThemeService {

}
