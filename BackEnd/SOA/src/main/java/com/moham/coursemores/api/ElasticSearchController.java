package com.moham.coursemores.api;

import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.service.CourseSearchService;
import com.moham.coursemores.domain.document.HashtagDocument;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
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
    private final CourseSearchService courseSearchService;
    private static final Logger logger = LoggerFactory.getLogger(ElasticSearchController.class);

    @PostMapping()
    public void insert(@RequestBody Map<String, String> map) {
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
    @PostMapping("search")
    public ResponseEntity<Map<String, Object>> search(@RequestBody Map<String, String> map) throws IOException {

        logger.info(">> request : value={}", map.get("value"));

        Map<String, List<String>> result = courseSearchService.search(map.get("value"));

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result);
        logger.info("<< response : result={}",result);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PutMapping()
    public ResponseEntity<Map<String, Object>> updateIndexData(@RequestBody Map<String, String> map) throws IOException {
        String index = map.get("index");
        String id = map.get("id");
        String value = map.get("value");

        logger.info(">> request : index={}, id={}, value={}", id, index, value);
        courseSearchService.updateCourseDocument(index, id, value);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping()
    public ResponseEntity<Map<String, Object>> deleteIndexData(@RequestBody Map<String, String> map) throws IOException {
        String index = map.get("index");
        String id = map.get("id");

        logger.info(">> request : index={}, id={}", id, index);
        courseSearchService.deleteCoureDocument(index, id);

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
