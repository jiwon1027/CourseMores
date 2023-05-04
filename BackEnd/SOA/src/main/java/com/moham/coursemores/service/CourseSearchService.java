package com.moham.coursemores.common.elasticsearch;

import com.moham.coursemores.domain.CourseDocument;
import com.moham.coursemores.domain.CourseLocationDocument;
import com.moham.coursemores.domain.HashtagDocument;
import java.io.IOException;
import java.util.List;

public interface CourseSearchService {

    Boolean index(CourseDocument courseDocument);
    Boolean indexLoction(CourseLocationDocument courseLocationDocument);
    Boolean indexHashtag(HashtagDocument hashtagDocument);

    List<String> search(String value);
    void updateCourseDocument(String index, String id, String value) throws IOException;
    void deleteCoureDocument(String index,String id) throws IOException;



}
