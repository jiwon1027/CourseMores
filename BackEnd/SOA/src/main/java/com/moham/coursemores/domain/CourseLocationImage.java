package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="course_location_image")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CourseLocationImage extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_location_image_id")
    private int id;

    @NotNull
    @Column(length = 500)
    private String image;

    @NotNull
    @ManyToOne(targetEntity = CourseLocation.class, fetch = FetchType.LAZY)
    @JoinColumn(name="course_location_id")
    private CourseLocation courseLocation;

    @Builder
    public CourseLocationImage(String image,
                               CourseLocation courseLocation){
        this.image = image;
        this.courseLocation = courseLocation;
    }
}
