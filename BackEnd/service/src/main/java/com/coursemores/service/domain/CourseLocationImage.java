package com.coursemores.service.domain;

import com.coursemores.service.domain.time.CreateTimeEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "course_location_image")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CourseLocationImage extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_location_image_id")
    private Long id;

    @NotNull
    @Column(length = 500)
    private String image;

    @NotNull
    @ManyToOne(targetEntity = CourseLocation.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "course_location_id")
    private CourseLocation courseLocation;

    @Builder
    public CourseLocationImage(String image,
            CourseLocation courseLocation) {
        this.image = image;
        this.courseLocation = courseLocation;
    }
}