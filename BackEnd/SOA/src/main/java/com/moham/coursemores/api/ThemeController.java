package com.moham.coursemores.api;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("theme")
@RequiredArgsConstructor
public class ThemeController {

    private static final Logger logger = LoggerFactory.getLogger(ThemeController.class);

    @GetMapping
    public ResponseEntity<Map<String, Object>> getThemeList() {
        logger.info(">> request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.info("<< response : =");

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}
