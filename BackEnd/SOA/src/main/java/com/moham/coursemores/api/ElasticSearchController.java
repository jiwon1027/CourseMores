package com.moham.coursemores.api;

import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.domain.document.HashtagDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.service.ElasticSearchService;
import java.io.IOException;
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

    private static final Logger logger = LoggerFactory.getLogger(ElasticSearchController.class);

    private final ElasticSearchService courseSearchService;
    private static final String VALUE = "value";
    private static final String INDEX = "index";
    private static final String ID = "id";

    @PostMapping("search")
    public ResponseEntity<Map<String, List<Integer>>> search(
            @RequestBody Map<String, String> map) throws IOException {
        logger.debug("[0/2][POST][/elasticsearch/search] << request : value\n value = {}", map.get(VALUE));

        logger.debug("[1/2][POST][/elasticsearch/search] ... css.search");
        Map<String, List<Integer>> result = courseSearchService.search(map.get(VALUE));

        logger.debug("[2/2][POST][/elasticsearch/search] >> response : result\n result = {}\n", result);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping("cli")
    public ResponseEntity<Void> insertCli(@RequestBody Map<String, String> map) {
        String id = map.get(ID);
        String index = map.get(INDEX);
        String value = map.get(VALUE);
        logger.debug("[0/2][POST][/elasticsearch/cli] << request : id, index, value\n id = {}\n index = {}\n value = {}", id, index, value);

        if ("course".equals(index)) {
            logger.debug("[1/2][POST][/elasticsearch/cli] ... css.index");
            courseSearchService.index(CourseDocument.builder()
                    .id(id)
                    .value(value)
                    .build());
        } else if ("courselocation".equals(index)) {
            logger.debug("[1/2][POST][/elasticsearch/cli] ... css.indexLoction");
            courseSearchService.indexLoction(CourseLocationDocument.builder()
                    .id(id)
                    .value(value)
                    .build());
        } else if ("hashtag".equals(index)) {
            logger.debug("[1/2][POST][/elasticsearch/cli] ... css.indexHashtag");
            courseSearchService.indexHashtag(HashtagDocument.builder()
                    .id(id)
                    .value(value)
                    .build());
        }

        logger.debug("[2/2][POST][/elasticsearch/cli] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @PostMapping
    public ResponseEntity<Void> insert(@RequestBody IndexDataReqDTO indexDataReqDTO) {
        logger.debug("[0/2][POST][/elasticsearch] << request : indexDataReqDTO\n indexDataReqDTO = {}", indexDataReqDTO);

        logger.debug("[1/2][POST][/elasticsearch] ... css.addIndex");
        courseSearchService.addIndex(indexDataReqDTO);

        logger.debug("[2/2][POST][/elasticsearch] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @PutMapping("cli")
    public ResponseEntity<Map<String, Object>> updateCli(@RequestBody Map<String, String> map) throws IOException {
        String id = map.get(ID);
        String index = map.get(INDEX);
        String value = map.get(VALUE);
        logger.debug("[0/2][PUT][/elasticsearch/cli] << request : id, index, value\n id = {}\n index = {}\n value = {}", id, index, value);

        logger.debug("[1/2][PUT][/elasticsearch/cli] ... css.updateCli");
        courseSearchService.updateCli(id, index, value);

        logger.debug("[2/2][PUT][/elasticsearch/cli] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("cli")
    public ResponseEntity<Map<String, Object>> deleteCli(@RequestBody Map<String, String> map) throws IOException {
        String id = map.get(ID);
        String index = map.get(INDEX);
        logger.debug("[0/2][DELETE][/elasticsearch/cli] << request : id, index\n id = {}\n index = {}", id, index);

        logger.debug("[1/2][DELETE][/elasticsearch/cli] ... css.deleteCli");
        courseSearchService.deleteCli(id, index);

        logger.debug("[2/2][DELETE][/elasticsearch/cli] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }

}