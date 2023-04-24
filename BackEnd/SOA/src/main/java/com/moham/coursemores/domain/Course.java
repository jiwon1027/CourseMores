package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="course")
@Getter
@ToString
@SuperBuilder
public class Course extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_id")
    private int id;
    @NotNull
    @Column(length = 50)
    private String title;
    @Column(length = 1000)
    private String content;
    private int people;
    private int time;
    @NotNull
    private boolean visited;
    @NotNull
    private int viewCount;
    @NotNull
    private int likeCount;
    @NotNull
    private int interestCount;
    @NotNull
    @Column(length = 500)
    private String mainImage;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLocation> courseLocationList;

    @OneToMany(mappedBy = "course_hashtag", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseHashtag> courseHashtagList;

    @OneToMany(mappedBy = "theme_of_course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ThemeOfCourse> themeOfCourseList;
}
