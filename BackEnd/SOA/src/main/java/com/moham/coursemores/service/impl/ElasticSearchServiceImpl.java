package com.moham.coursemores.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.moham.coursemores.common.util.Indices;
import com.moham.coursemores.common.util.SearchUtil;
import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.domain.document.HashtagDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.service.ElasticSearchService;
import java.io.IOException;
import java.util.*;

import lombok.RequiredArgsConstructor;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.DocWriteResponse;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.reindex.DeleteByQueryRequest;
import org.elasticsearch.rest.RestStatus;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.xcontent.XContentType;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ElasticSearchServiceImpl implements ElasticSearchService {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private final RestHighLevelClient client;
    private final String VALUE = "value";

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

            client.index(requestCourse, RequestOptions.DEFAULT);

            // CourselocationDocument
            for (String courselocation : indexDataReqDTO.getCourselocationList()) {
                CourseLocationDocument courseLocationDocument = CourseLocationDocument.builder()
                        .id(indexDataReqDTO.getId())
                        .value(courselocation)
                        .build();

                String temp = MAPPER.writeValueAsString(courseLocationDocument);

                IndexRequest requestHashtag = new IndexRequest(Indices.COURSELOCATION_INDEX);

                requestHashtag.id(UUID.randomUUID().toString());
                requestHashtag.source(temp, XContentType.JSON);

                client.index(requestHashtag, RequestOptions.DEFAULT);
            }

            // HashtagDocument index
            for (String hashtag : indexDataReqDTO.getHashtagList()) {
                HashtagDocument hashtagDocument = HashtagDocument.builder()
                        .id(indexDataReqDTO.getId())
                        .value(hashtag)
                        .build();

                String temp = MAPPER.writeValueAsString(hashtagDocument);

                IndexRequest requestHashtag = new IndexRequest(Indices.HASHTAG_INDEX);

                requestHashtag.id(UUID.randomUUID().toString());
                requestHashtag.source(temp, XContentType.JSON);

                client.index(requestHashtag, RequestOptions.DEFAULT);
            }

        } catch (final Exception e) {
            e.printStackTrace();
        }
    }

    public Map<String, List<Integer>> search(String value) throws IOException {
        SearchRequest requestCourse = SearchUtil.buildSearchRequest(Indices.COURSE_INDEX, value);
        SearchRequest requestCourseLocation = SearchUtil.buildSearchRequest(Indices.COURSELOCATION_INDEX, value);
        SearchRequest requestHashtag = SearchUtil.buildSearchRequest(Indices.HASHTAG_INDEX, value);

        SearchResponse responseCourse = client.search(requestCourse, RequestOptions.DEFAULT);
        SearchResponse responseCourseLocation = client.search(requestCourseLocation, RequestOptions.DEFAULT);
        SearchResponse responseHashtag = client.search(requestHashtag, RequestOptions.DEFAULT);

        SearchHit[] searchHitsCourse = responseCourse.getHits().getHits();
        SearchHit[] searchHitsCourseLocation = responseCourseLocation.getHits().getHits();
        SearchHit[] searchHitsHashtag = responseHashtag.getHits().getHits();

        Set<String> courses = new HashSet<>();
        Map<String, Object> sourceAsMap;
        for (SearchHit hit : searchHitsCourse) {
            sourceAsMap = hit.getSourceAsMap();
            courses.add((String) sourceAsMap.get(VALUE));
        }

        Set<String> courseLocations = new HashSet<>();
        for (SearchHit hit : searchHitsCourseLocation) {
            sourceAsMap = hit.getSourceAsMap();
            courseLocations.add((String) sourceAsMap.get(VALUE));
        }

        Set<String> hashtags = new HashSet<>();
        for (SearchHit hit : searchHitsHashtag) {
            sourceAsMap = hit.getSourceAsMap();
            hashtags.add((String) sourceAsMap.get(VALUE));
        }


        Map<String, List<Integer>> temp = new HashMap<>();

        for (String course : courses) {
            temp.put(course, new ArrayList<>(List.of(1)));
        }

        for (String courseLocation : courseLocations) {
            if (temp.containsKey(courseLocation)) {
                List<Integer> existingList = temp.get(courseLocation);
                existingList.add(2);
                temp.put(courseLocation, existingList);
            }
            else{
                temp.put(courseLocation, new ArrayList<>(List.of(2)));
            }
        }

        for (String hashtag : hashtags) {
            if (temp.containsKey(hashtag)) {
                List<Integer> existingList = temp.get(hashtag);
                existingList.add(3);
                temp.put(hashtag, existingList);
            }
            else{
                temp.put(hashtag, new ArrayList<>(List.of(3)));
            }
        }

        List<String> keySet = new ArrayList<>(temp.keySet());
        keySet.sort(Comparator.comparingInt(String::length));

        Map<String, List<Integer>> sortedResult = new LinkedHashMap<>();
        for (String key : keySet) {
            List<Integer> list = temp.get(key);
            sortedResult.put(key, list);
        }

        return sortedResult;

    }

    public void updateIndex(IndexDataReqDTO indexDataReqDTO) throws IOException {
        deleteIndex(indexDataReqDTO.getId());
        addIndex(indexDataReqDTO);

    }

    @Override
    public void updateCli(String id, String index, String value) throws IOException {
        UpdateRequest request = null;

        if ("course".equals(index)) {
            request = new UpdateRequest(Indices.COURSE_INDEX, id);
        } else if ("courselocation".equals(index)) {
            request = new UpdateRequest(Indices.COURSELOCATION_INDEX, id);
        } else if ("hashtag".equals(index)) {
            request = new UpdateRequest(Indices.HASHTAG_INDEX, id);
        }

        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put(VALUE, value);
        Objects.requireNonNull(request).doc(jsonMap);

        client.update(request, RequestOptions.DEFAULT);
    }


    public void deleteIndex(String id) throws IOException {
        // CourseTitle
        DeleteRequest requestCourse = new DeleteRequest(Indices.COURSE_INDEX, id);
        client.delete(requestCourse, RequestOptions.DEFAULT);

        // Courselocation
        DeleteByQueryRequest requestCourselocation = new DeleteByQueryRequest(Indices.COURSELOCATION_INDEX);
        QueryBuilder queryBuilderCourselocation = QueryBuilders.termQuery("id", id);
        requestCourselocation.setQuery(queryBuilderCourselocation);

        client.deleteByQuery(requestCourselocation, RequestOptions.DEFAULT);
        // Hashtag
        DeleteByQueryRequest requestHashtag = new DeleteByQueryRequest(Indices.HASHTAG_INDEX);
        QueryBuilder queryBuilderHashtag = QueryBuilders.termQuery("id", id);
        requestHashtag.setQuery(queryBuilderHashtag);

        client.deleteByQuery(requestHashtag, RequestOptions.DEFAULT);
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