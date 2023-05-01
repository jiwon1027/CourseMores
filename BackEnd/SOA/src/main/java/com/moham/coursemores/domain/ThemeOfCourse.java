package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="theme_of_course")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ThemeOfCourse extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "theme_of_course_id")
    private Long id;

    @NotNull
    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_id")
    private Course course;

    @NotNull
    @ManyToOne(targetEntity = Theme.class, fetch = FetchType.LAZY)
    @JoinColumn(name="theme_id")
    private Theme theme;

    @Builder
    public ThemeOfCourse(Course course,
                         Theme theme){
        this.course = course;
        this.theme = theme;
    }
}
