package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="course_location_image")
@Getter
@ToString
@SuperBuilder
public class CourseLocationImage extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_location_image_id")
    private int id;
    @NotNull
    @Column(length = 500)
    private String image;

    @ManyToOne(targetEntity = CourseLocation.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_location_id")
    private CourseLocation courseLocation;
}
