package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="course_hashtag")
@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CourseHashtag extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_hashtag_id")
    private int id;

    @NotNull
    @Column(length = 20)
    private String name;

    @NotNull
    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_id")
    private Course course;

    @Builder
    public CourseHashtag(String name,
                         Course course){
        this.name = name;
        this.course = course;
    }
}
