package com.moham.coursemores.api;

import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.dto.elasticsearch.IndexDataResDTO;
import com.moham.coursemores.service.ElasticSearchService;
import com.moham.coursemores.domain.document.HashtagDocument;
import java.io.IOException;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("elasticsearch")
@RequiredArgsConstructor
public class ElasticSearchController {
    private final ElasticSearchService courseSearchService;
    private static final Logger logger = LoggerFactory.getLogger(ElasticSearchController.class);

    @PostMapping("cli")
    public void insertCli(@RequestBody Map<String, String> map) {
        String id = map.get("id");
        String index = map.get("index");
        String value = map.get("value");

        logger.info(">> request : index={}, id={}, value={}", id, index, value);

        if ("course".equals(index)) {
            CourseDocument courseDocument = CourseDocument.builder().id(id).value(value).build();
            courseSearchService.index(courseDocument);
        } else if ("courselocation".equals(index)) {
            CourseLocationDocument courseLocationDocument = CourseLocationDocument.builder().id(id).value(value).build();
            courseSearchService.indexLoction(courseLocationDocument);
        } else if ("hashtag".equals(index)) {
            HashtagDocument hashtagDocument = HashtagDocument.builder().id(id).value(value).build();
            courseSearchService.indexHashtag(hashtagDocument);
        }

    }


    @PostMapping()
    public void insert(@RequestBody IndexDataReqDTO indexDataReqDTO) {

        logger.info(">> request : indexDataReqDTO{}", indexDataReqDTO);

        courseSearchService.addIndex(indexDataReqDTO);

    }
    @PostMapping("search")
    public ResponseEntity<IndexDataResDTO> search(@RequestBody Map<String, String> map) throws IOException {

        logger.info(">> request : value={}", map.get("value"));

        IndexDataResDTO result = courseSearchService.search(map.get("value"));

        logger.info("<< response : result={}",result);

        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PutMapping("cli")
    public ResponseEntity<Map<String, Object>> updateCli(@RequestBody Map<String, String> map) throws IOException {
        String id = map.get("id");
        String index = map.get("index");
        String value = map.get("value");

        logger.info(">> request : id={}, index={}, value={}", id,index,value);
        courseSearchService.updateCli(id, index, value);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("cli")
    public ResponseEntity<Map<String, Object>> deleteCli(@RequestBody Map<String, String> map) throws IOException {
        String id = map.get("id");
        String index = map.get("index");

        logger.info(">> request : id={}, index={}", id,index);
        courseSearchService.deleteCli(id, index);

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
