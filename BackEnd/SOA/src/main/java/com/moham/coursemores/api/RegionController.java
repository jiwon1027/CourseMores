package com.moham.coursemores.api;

import com.moham.coursemores.service.RegionService;
import com.moham.coursemores.dto.region.GugunResDto;
import com.moham.coursemores.repository.RegionRepository;
import com.moham.coursemores.service.RegionService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("region")
@RequiredArgsConstructor
public class RegionController {

    private static final Logger logger = LoggerFactory.getLogger(RegionController.class);

    private final RegionService regionService;

    @GetMapping("dummy")
    public ResponseEntity<Void> saveDummyData() throws Exception {
        logger.info(">> request : none");

        regionService.saveDummy();

        logger.info("<< response : none");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getSidoList() {
        logger.info(">> request : none");

        Map<String, Object> resultMap = new HashMap<>();

        List<String> sidoList = regionService.getSidoList();
        resultMap.put("sidoList",sidoList);
        logger.info("<< response : sidoList={}",sidoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{sido}")
    public ResponseEntity<Map<String, Object>> getGugunList(
            @PathVariable String sido) {
        logger.info(">> request : sido={}",sido);

        Map<String, Object> resultMap = new HashMap<>();

        List<GugunResDto> gugunList = regionService.getGugunList(sido);
        resultMap.put("gugunList",gugunList);
        logger.info("<< response : gugunList={}",gugunList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}