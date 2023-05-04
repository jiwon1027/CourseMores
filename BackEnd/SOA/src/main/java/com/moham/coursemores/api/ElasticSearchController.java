package com.moham.coursemores.api;

import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.dto.elasticsearch.IndexDataResDTO;
import com.moham.coursemores.dto.elasticsearch.IndexSimpleDataReqDTO;
import com.moham.coursemores.service.ElasticSearchService;
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
    private final ElasticSearchService courseSearchService;
    private static final Logger logger = LoggerFactory.getLogger(ElasticSearchController.class);

    @PostMapping()
    public void insert(@RequestBody IndexDataReqDTO indexDataReqDTO) {
        String id = indexDataReqDTO.getId();
        String index = indexDataReqDTO.getIndex();
        String value = indexDataReqDTO.getValue();

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
    public ResponseEntity<IndexDataResDTO> search(@RequestBody Map<String, String> map) throws IOException {

        logger.info(">> request : value={}", map.get("value"));

        IndexDataResDTO result = courseSearchService.search(map.get("value"));

        logger.info("<< response : result={}",result);

        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PutMapping()
    public ResponseEntity<Map<String, Object>> updateIndexData(@RequestBody IndexDataReqDTO indexDataReqDTO) throws IOException {
        String id = indexDataReqDTO.getId();
        String index = indexDataReqDTO.getIndex();
        String value = indexDataReqDTO.getValue();

        logger.info(">> request : index={}, id={}, value={}", id, index, value);
        courseSearchService.updateCourseDocument(index, id, value);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping()
    public ResponseEntity<Map<String, Object>> deleteIndexData(@RequestBody IndexSimpleDataReqDTO indexSimpleDataReqDTO) throws IOException {
        String index = indexSimpleDataReqDTO.getIndex();
        String id = indexSimpleDataReqDTO.getId();

        logger.info(">> request : index={}, id={}", id, index);
        courseSearchService.deleteCoureDocument(index, id);

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
