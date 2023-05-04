package com.moham.coursemores.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.moham.coursemores.common.util.Indices;
import com.moham.coursemores.common.util.SearchUtil;
import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.domain.document.HashtagDocument;
import com.moham.coursemores.service.CourseSearchService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
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
public class CourseSearchServiceImpl implements CourseSearchService {
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

    public Map<String, List<String>> search(String value) throws IOException {
        SearchRequest requestCourse = SearchUtil.buildSearchRequest(Indices.COURSE_INDEX, value);
        SearchRequest requestCourseLocation = SearchUtil.buildSearchRequest(Indices.COURSELOCATION_INDEX, value);
        SearchRequest requestHashtag = SearchUtil.buildSearchRequest(Indices.HASHTAG_INDEX, value);

        Map<String, List<String>> map = new HashMap<>();

        SearchResponse responseCourse = client.search(requestCourse, RequestOptions.DEFAULT);
        SearchResponse responseCourseLocation = client.search(requestCourseLocation, RequestOptions.DEFAULT);
        SearchResponse responseHashtag = client.search(requestHashtag, RequestOptions.DEFAULT);

        SearchHit[] searchHitsCourse = responseCourse.getHits().getHits();
        SearchHit[] searchHitsCourseLocation = responseCourseLocation.getHits().getHits();
        SearchHit[] searchHitsHashtag = responseHashtag.getHits().getHits();


        List<String> courses = new ArrayList<>();

        Map<String, Object> sourceAsMap;
        for (SearchHit hit : searchHitsCourse) {
            sourceAsMap = hit.getSourceAsMap();
            courses.add((String) sourceAsMap.get("value"));
        }
        map.put("course", courses);

        List<String> courseLocations = new ArrayList<>();
        for (SearchHit hit : searchHitsCourseLocation) {
            sourceAsMap = hit.getSourceAsMap();
            courses.add((String) sourceAsMap.get("value"));
        }
        map.put("courseLocation", courseLocations);

        List<String> hashtags = new ArrayList<>();
        for (SearchHit hit : searchHitsHashtag) {
            sourceAsMap = hit.getSourceAsMap();
            courses.add((String) sourceAsMap.get("value"));
        }
        map.put("hashtag", hashtags);

        return map;

    }

    public void updateCourseDocument(String index, String id, String value) throws IOException {
        UpdateRequest request = null;

        if ("course".equals(index)) {
            request = new UpdateRequest(Indices.COURSE_INDEX, id);
        } else if ("courselocation".equals(index)) {
            request = new UpdateRequest(Indices.COURSELOCATION_INDEX, id);
        } else if ("hashtag".equals(index)) {
            request = new UpdateRequest(Indices.HASHTAG_INDEX, id);
        }

        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("value",value);
        request.doc(jsonMap);

        UpdateResponse response = client.update(request, RequestOptions.DEFAULT);
    }

    public void deleteCoureDocument(String index,String id) throws IOException {
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
