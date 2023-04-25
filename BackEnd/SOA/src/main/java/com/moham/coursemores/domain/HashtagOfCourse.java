package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="hashtag_of_course")
@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class HashtagOfCourse extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "hashtag_of_course_id")
    private int id;

    @NotNull
    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_id")
    private Course course;

    @NotNull
    @ManyToOne(targetEntity = Hashtag.class, fetch = FetchType.LAZY)
    @JoinColumn(name="hashtag_id")
    private Hashtag hashtag;

    @Builder
    public HashtagOfCourse(Course course,
                           Hashtag hashtag){
        this.course = course;
        this.hashtag = hashtag;
    }
}
