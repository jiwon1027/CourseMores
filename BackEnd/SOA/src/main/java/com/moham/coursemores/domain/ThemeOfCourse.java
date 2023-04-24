package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;

@Entity
@Table(name="theme")
@Getter
@ToString
@SuperBuilder
public class ThemeOfCourse extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "theme_of_course_id")
    private int id;

    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_id")
    private Course course;

    @ManyToOne(targetEntity = Theme.class, fetch = FetchType.LAZY)
    @JoinColumn(name="theme_id")
    private Theme theme;
}
