package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

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
}
