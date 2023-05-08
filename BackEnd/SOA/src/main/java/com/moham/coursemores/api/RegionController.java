package com.moham.coursemores.api;

import com.moham.coursemores.dto.token.TokenReissueReqDto;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("region")
@RequiredArgsConstructor
public class RegionController {

    private static final Logger logger = LoggerFactory.getLogger(RegionController.class);

    @GetMapping
    public ResponseEntity<Map<String, Object>> getRegionBigList() {
        logger.info(">> request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.info("<< response : =");

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{regionBig}")
    public ResponseEntity<Map<String, Object>> getRegionSmallList(
            @PathVariable String regionBig) {
        logger.info(">> request : regionBig={}",regionBig);

        Map<String, Object> resultMap = new HashMap<>();

        logger.info("<< response : =");

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}
