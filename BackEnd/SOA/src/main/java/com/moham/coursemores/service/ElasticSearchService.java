package com.moham.coursemores.service;

import com.moham.coursemores.domain.document.CourseDocument;
import com.moham.coursemores.domain.document.CourseLocationDocument;
import com.moham.coursemores.domain.document.HashtagDocument;
import com.moham.coursemores.dto.elasticsearch.IndexDataResDTO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface ElasticSearchService {

    Boolean index(CourseDocument courseDocument);
    Boolean indexLoction(CourseLocationDocument courseLocationDocument);
    Boolean indexHashtag(HashtagDocument hashtagDocument);

    IndexDataResDTO search(String value) throws IOException;
    void updateCourseDocument(String index, String id, String value) throws IOException;
    void deleteCoureDocument(String index,String id) throws IOException;



}
