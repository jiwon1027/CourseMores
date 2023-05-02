package com.moham.coursemores.domain;

import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.*;
import javax.validation.constraints.NotNull;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import com.moham.coursemores.dto.course.CourseUpdateReqDto;
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
    private Long id;

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
    @Column
    private int commentCount;

    @NotNull
    @Column(length = 500)
    private String mainImage;

    @NotNull
    @Column(length = 50)
    private String locationName;

    @NotNull
    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLocation> courseLocationList;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<HashtagOfCourse> courseHashtagList;

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
                  String locationName,
                  int viewCount,
                  int likeCount,
                  int interestCount,
                  int commentCount,
                  User user){
        this.title = title;
        this.content = content;
        this.people = people;
        this.time = time;
        this.visited = visited;
        this.viewCount = viewCount;
        this.interestCount = interestCount;
        this.likeCount = likeCount;
        this.mainImage = mainImage;
        this.commentCount = commentCount;
        this.locationName = locationName;
        this.user = user;
    }

    public void increaseViewCount(){
        this.viewCount++;
    }

    public void increaseInterestCount() {
        this.interestCount++;
    }

    public void decreaseInterestCount() {
        this.interestCount--;
    }

    public void increaseLikeCount() {
        this.likeCount++;
    }

    public void decreaseLikeCount() {
        this.likeCount--;
    }

    public void increaseCommentCount(){
        this.commentCount++;
    }

    public void decreaseCommentCount(){
        this.commentCount--;
    }

    public void update(CourseUpdateReqDto courseUpdateReqDto){
        this.title = courseUpdateReqDto.getTitle();
        this.content = courseUpdateReqDto.getContent();
        this.people = courseUpdateReqDto.getPeople();
        this.time = courseUpdateReqDto.getTime();
        this.visited = courseUpdateReqDto.isVisited();
        this.mainImage = courseUpdateReqDto.getLocationList().get(0).getImageList().get(0);
        this.locationName = courseUpdateReqDto.getLocationList().get(0).getName();
    }

    public void delete(){
        this.deleteTime = LocalDateTime.now();
    }
}