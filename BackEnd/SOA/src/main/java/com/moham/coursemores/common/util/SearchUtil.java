package com.moham.coursemores.common.util;

import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.action.search.SearchRequest;
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
    public static SearchRequest buildSearchRequestNested(String indexName, String value, String id){
        try {
            SearchSourceBuilder builder = new SearchSourceBuilder()
                    .postFilter(getQueryBuilderNested(value, id));

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
    private static QueryBuilder getQueryBuilderNested(String value, String id){
        if (value == null && id == null)
            return null;

        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        if (value != null) {
            boolQueryBuilder.must(QueryBuilders.wildcardQuery("value", "*" + value + "*"));
        }
        if (id != null) {
            boolQueryBuilder.must(QueryBuilders.termQuery("id", id));
        }

        return boolQueryBuilder;
    }
}
