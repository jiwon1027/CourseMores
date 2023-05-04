package com.moham.coursemores.common.elasticsearch;

import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.index.query.Operator;

import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.index.query.*;

public class SearchUtil {
    private SearchUtil() {}

    public static SearchRequest buildSearchRequest(String indexName, String value){
        try {
            SearchSourceBuilder builder = new SearchSourceBuilder()
                    .postFilter(getQueryBuilder(value));

            SearchRequest request = new SearchRequest(indexName);
            request.source(builder);

            return request;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static QueryBuilder getQueryBuilder(String value){
        if (value == null)
            return null;

        return QueryBuilders.wildcardQuery("value", "*" + value + "*");
    }
}
