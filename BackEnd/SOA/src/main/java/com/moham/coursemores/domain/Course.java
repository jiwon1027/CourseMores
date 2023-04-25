package com.moham.coursemores.domain;

import java.util.List;
import javax.persistence.*;
import javax.validation.constraints.NotNull;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import lombok.*;

@Entity
@Table(name = "course")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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

    @Column
    private int people;

    @Column
    private int time;

    @NotNull
    @Column
    private boolean visited;

    @NotNull
    @Column
    private int viewCount;

    @NotNull
    @Column
    private int likeCount;

    @NotNull
    @Column
    private int interestCount;

    @NotNull
    @Column(length = 500)
    private String mainImage;

    @NotNull
    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLocation> courseLocationList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseHashtag> courseHashtagList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ThemeOfCourse> themeOfCourseList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLike> courseLikeList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Interest> interestList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> commentList;

    @Builder
    public Course(String title,
                  String content,
                  int people,
                  int time,
                  boolean visited,
                  String mainImage,
                  User user){
        this.title = title;
        this.content = content;
        this.people = people;
        this.time = time;
        this.visited = visited;
        this.viewCount = 0;
        this.interestCount = 0;
        this.likeCount = 0;
        this.mainImage = mainImage;
        this.user = user;
    }
}