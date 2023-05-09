package com.moham.coursemores.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.moham.coursemores.common.util.Indices;
import com.moham.coursemores.common.util.SearchUtil;
import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.domain.document.HashtagDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.dto.elasticsearch.IndexDataResDTO;
import com.moham.coursemores.service.ElasticSearchService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.DocWriteResponse;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.action.update.UpdateResponse;

import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.rest.RestStatus;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.xcontent.XContentType;
import org.springframework.stereotype.Service;
import org.elasticsearch.action.search.SearchRequest;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ElasticSearchServiceImpl implements ElasticSearchService {
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private final RestHighLevelClient client;

    public Boolean index(CourseDocument courseDocument) {
        try {
            String value = MAPPER.writeValueAsString(courseDocument);

            IndexRequest request = new IndexRequest(Indices.COURSE_INDEX);

            request.id(courseDocument.getId());
            request.source(value, XContentType.JSON);

            IndexResponse response = client.index(request, RequestOptions.DEFAULT);

            return response != null && response.status().equals(RestStatus.OK);
        } catch (final Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Boolean indexLoction(CourseLocationDocument courseLocationDocument) {
        try {
            String value = MAPPER.writeValueAsString(courseLocationDocument);

            IndexRequest request = new IndexRequest(Indices.COURSELOCATION_INDEX);
            request.id(courseLocationDocument.getId());
            request.source(value, XContentType.JSON);

            IndexResponse response = client.index(request, RequestOptions.DEFAULT);

            return response != null && response.status().equals(RestStatus.OK);
        } catch (final Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Boolean indexHashtag(HashtagDocument hashtagDocument) {
        try {
            String value = MAPPER.writeValueAsString(hashtagDocument);

            IndexRequest request = new IndexRequest(Indices.HASHTAG_INDEX);
            request.id(hashtagDocument.getId());
            request.source(value, XContentType.JSON);

            IndexResponse response = client.index(request, RequestOptions.DEFAULT);

            return response != null && response.status().equals(RestStatus.OK);
        } catch (final Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    public void addIndex(IndexDataReqDTO indexDataReqDTO) {
        try {
            // CourseDocument index
            CourseDocument courseDocument = CourseDocument.builder()
                    .id(indexDataReqDTO.getId())
                    .value(indexDataReqDTO.getTitle())
                    .build();

            String value = MAPPER.writeValueAsString(courseDocument);

            IndexRequest requestCourse = new IndexRequest(Indices.COURSE_INDEX);

            requestCourse.id(courseDocument.getId());
            requestCourse.source(value, XContentType.JSON);

            IndexResponse responseCourse = client.index(requestCourse, RequestOptions.DEFAULT);

            // HashtagDocument index
            indexDataReqDTO.getHashtagList().forEach(hashtag -> {
                HashtagDocument hashtagDocument = HashtagDocument.builder()
                        .id(indexDataReqDTO.getId())
                        .value(hashtag).build();
                try {
                    String temp = MAPPER.writeValueAsString(hashtagDocument);

                    IndexRequest request = new IndexRequest(Indices.HASHTAG_INDEX);
                    request.id(hashtagDocument.getId());
                    request.source(temp, XContentType.JSON);

                    IndexResponse response = client.index(request, RequestOptions.DEFAULT);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            });
        } catch (final Exception e) {
            e.printStackTrace();
        }
    }

    public IndexDataResDTO search(String value) throws IOException {
        SearchRequest requestCourse = SearchUtil.buildSearchRequest(Indices.COURSE_INDEX, value);
        SearchRequest requestHashtag = SearchUtil.buildSearchRequest(Indices.HASHTAG_INDEX, value);

        SearchResponse responseCourse = client.search(requestCourse, RequestOptions.DEFAULT);
        SearchResponse responseHashtag = client.search(requestHashtag, RequestOptions.DEFAULT);

        SearchHit[] searchHitsCourse = responseCourse.getHits().getHits();
        SearchHit[] searchHitsHashtag = responseHashtag.getHits().getHits();

        List<String> courses = new ArrayList<>();

        Map<String, Object> sourceAsMap;
        for (SearchHit hit : searchHitsCourse) {
            sourceAsMap = hit.getSourceAsMap();
            courses.add((String) sourceAsMap.get("value"));
        }

        List<String> hashtags = new ArrayList<>();
        for (SearchHit hit : searchHitsHashtag) {
            sourceAsMap = hit.getSourceAsMap();
            hashtags.add((String) sourceAsMap.get("value"));
        }


        IndexDataResDTO indexDataResDTO = IndexDataResDTO.builder()
                .courses(courses)
                .hashtags(hashtags)
                .build();
        return indexDataResDTO;

    }

    public void updateIndex(IndexDataReqDTO indexDataReqDTO) throws IOException {

        UpdateRequest requestCourse = new UpdateRequest(Indices.COURSE_INDEX, indexDataReqDTO.getId());
        UpdateRequest requestHashtag = new UpdateRequest(Indices.HASHTAG_INDEX, indexDataReqDTO.getId());

        Map<String, Object> jsonMapCourse = new HashMap<>();
        jsonMapCourse.put("value",indexDataReqDTO.getTitle());
        requestCourse.doc(jsonMapCourse);

        Map<String, Object> jsonMapHashtag = new HashMap<>();
        jsonMapHashtag.put("value",indexDataReqDTO.getHashtagList());
        requestCourse.doc(jsonMapHashtag);

        UpdateResponse responseCourse = client.update(requestCourse, RequestOptions.DEFAULT);
        UpdateResponse responseHashtag = client.update(requestHashtag, RequestOptions.DEFAULT);

    }

    @Override
    public void updateCli(String id, String index, String value) throws IOException {
        UpdateRequest request = null;

        if ("course".equals(index)) {
            request = new UpdateRequest(Indices.COURSE_INDEX, id);
        } else if ("hashtag".equals(index)) {
            request = new UpdateRequest(Indices.HASHTAG_INDEX, id);
        }

        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("value",value);
        request.doc(jsonMap);

        UpdateResponse response = client.update(request, RequestOptions.DEFAULT);

    }


    public void deleteIndex(String id) throws IOException {

        DeleteRequest request = new DeleteRequest(Indices.COURSE_INDEX, id);
        DeleteResponse response = client.delete(request, RequestOptions.DEFAULT);

        DeleteRequest requestHashtag = new DeleteRequest(Indices.HASHTAG_INDEX, id);
        DeleteResponse responseHashtag = client.delete(requestHashtag, RequestOptions.DEFAULT);


        if (response.getResult() == DocWriteResponse.Result.NOT_FOUND) {
            throw new ElasticsearchException("Document not found with id " + id + " in index course");
        }
    }

    @Override
    public void deleteCli(String id, String index) throws IOException {

        DeleteRequest request = null;

        if ("course".equals(index)) {
            request = new DeleteRequest(Indices.COURSE_INDEX, id);
        } else if ("courselocation".equals(index)) {
            request = new DeleteRequest(Indices.COURSELOCATION_INDEX, id);
        } else if ("hashtag".equals(index)) {
            request = new DeleteRequest(Indices.HASHTAG_INDEX, id);
        }

        DeleteResponse response = client.delete(request, RequestOptions.DEFAULT);

        if (response.getResult() == DocWriteResponse.Result.NOT_FOUND) {
            throw new ElasticsearchException("Document not found with id " + id + " in index course");
        }
    }
}
