package com.moham.coursemores.api;

import com.moham.coursemores.dto.region.GugunResDto;
import com.moham.coursemores.service.RegionService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("region")
@RequiredArgsConstructor
public class RegionController {

    private static final Logger logger = LoggerFactory.getLogger(RegionController.class);

    private final RegionService regionService;

    @GetMapping("dummy")
    public ResponseEntity<Void> saveDummyData() throws Exception {
        logger.debug("[0/1][GET][/region/dummy] << request : none");

        logger.debug("[1/2][GET][/region/dummy] ...rs.saveDummy");
        regionService.saveDummy();

        logger.debug("[2/2][GET][/region/dummy] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getSidoList() {
        logger.debug("[0/2][GET][/region] << request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/region] ...rs.getSidoList");
        List<String> sidoList = regionService.getSidoList();
        resultMap.put("sidoList", sidoList);

        logger.debug("[2/2][GET][/region] >> response : sidoList\n sidoList = {}\n", sidoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{sido}")
    public ResponseEntity<Map<String, Object>> getGugunList(
            @PathVariable String sido) {
        logger.debug("[0/2][GET][/region/{}] << request : none", sido);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/region/{}] ...rs.getGugunList", sido);
        List<GugunResDto> gugunList = regionService.getGugunList(sido);
        resultMap.put("gugunList", gugunList);

        logger.debug("[2/2][GET][/region/{}] >> response : gugunList\n gugunList = {}\n", sido, gugunList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

}