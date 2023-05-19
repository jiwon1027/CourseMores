package com.moham.coursemores.api;

import com.moham.coursemores.dto.theme.ThemeResDto;
import com.moham.coursemores.service.ThemeService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("theme")
@RequiredArgsConstructor
public class ThemeController {

    private static final Logger logger = LoggerFactory.getLogger(ThemeController.class);

    private final ThemeService themeService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> getThemeList() {
        logger.debug("[0/2][GET][/theme] << request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/theme] ...ts.getThemeList");
        List<ThemeResDto> themeList = themeService.getThemeList();
        resultMap.put("themeList", themeList);

        logger.debug("[2/2][GET][/theme] >> response : themeList\n themeList = {}\n", themeList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("home")
    public ResponseEntity<Map<String, Object>> getHomeThemeList() {
        logger.debug("[0/2][GET][/theme/home] << request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/theme/home] ...ts.getHomeThemeList");
        List<ThemeResDto> themeList = themeService.getHomeThemeList();
        resultMap.put("themeList", themeList);

        logger.debug("[2/2][GET][/theme/home] >> response : themeList\n themeList = {}\n", themeList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}