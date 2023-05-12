package com.moham.coursemores.domain.document;


import com.moham.coursemores.common.util.Indices;
import javax.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;
import org.springframework.data.elasticsearch.annotations.Setting;
import org.springframework.data.elasticsearch.annotations.WriteTypeHint;


@Document(indexName = Indices.COURSE_INDEX, createIndex = false, writeTypeHint = WriteTypeHint.FALSE)
@Getter
@ToString
@Setting(settingPath = "static/es-setting.json")
@NoArgsConstructor
public class CourseDocument {

    @Id
    @Field(type = FieldType.Keyword)
    private String id;
    @Field(type = FieldType.Text)
    private String value;

    @Builder
    public CourseDocument(String id, String value) {
        this.id = id;
        this.value = value;
    }

    public void update(String value) {
        this.value = value;
    }

}