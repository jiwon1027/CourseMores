package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.UpdateTimeEntity;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name="course_location")
@Getter
@ToString
@SuperBuilder
public class CourseLocation extends UpdateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_location_id")
    private int id;
    @NotNull
    @Column(length = 50)
    private String name;
    @NotNull
    @Column(length = 1000)
    private String content;
    @NotNull
    private double latitude;
    @NotNull
    private double longitude;

    @OneToMany(mappedBy = "course_location", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLocationImage> courseLocationImageList;

    @OneToOne
    @JoinColumn(name = "region_id")
    private Region region;

    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_id")
    private Course course;
}
