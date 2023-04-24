package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.UpdateTimeEntity;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.ToString;

@Entity
@Table(name = "course_location")
@ToString
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
    @JoinColumn(name = "course_id")
    private Course course;

    protected CourseLocation(CourseLocationBuilder<?, ?> b) {
        super(b);
        this.id = b.id;
        this.name = b.name;
        this.content = b.content;
        this.latitude = b.latitude;
        this.longitude = b.longitude;
        this.courseLocationImageList = b.courseLocationImageList;
        this.region = b.region;
        this.course = b.course;
    }

    public static CourseLocationBuilder<?, ?> builder() {
        return new CourseLocationBuilderImpl();
    }

    public int getId() {
        return this.id;
    }

    public @NotNull String getName() {
        return this.name;
    }

    public @NotNull String getContent() {
        return this.content;
    }

    public @NotNull double getLatitude() {
        return this.latitude;
    }

    public @NotNull double getLongitude() {
        return this.longitude;
    }

    public List<CourseLocationImage> getCourseLocationImageList() {
        return this.courseLocationImageList;
    }

    public Region getRegion() {
        return this.region;
    }

    public Course getCourse() {
        return this.course;
    }

    public static abstract class CourseLocationBuilder<C extends CourseLocation, B extends CourseLocationBuilder<C, B>> extends UpdateTimeEntityBuilder<C, B> {

        private int id;
        private @NotNull String name;
        private @NotNull String content;
        private @NotNull double latitude;
        private @NotNull double longitude;
        private List<CourseLocationImage> courseLocationImageList;
        private Region region;
        private Course course;

        public B id(int id) {
            this.id = id;
            return self();
        }

        public B name(@NotNull String name) {
            this.name = name;
            return self();
        }

        public B content(@NotNull String content) {
            this.content = content;
            return self();
        }

        public B latitude(@NotNull double latitude) {
            this.latitude = latitude;
            return self();
        }

        public B longitude(@NotNull double longitude) {
            this.longitude = longitude;
            return self();
        }

        public B courseLocationImageList(List<CourseLocationImage> courseLocationImageList) {
            this.courseLocationImageList = courseLocationImageList;
            return self();
        }

        public B region(Region region) {
            this.region = region;
            return self();
        }

        public B course(Course course) {
            this.course = course;
            return self();
        }

        protected abstract B self();

        public abstract C build();

        public String toString() {
            return "CourseLocation.CourseLocationBuilder(super=" + super.toString() + ", id=" + this.id + ", name=" + this.name + ", content=" + this.content
                    + ", latitude=" + this.latitude + ", longitude=" + this.longitude + ", courseLocationImageList=" + this.courseLocationImageList
                    + ", region=" + this.region + ", course=" + this.course + ")";
        }
    }

    private static final class CourseLocationBuilderImpl extends CourseLocationBuilder<CourseLocation, CourseLocationBuilderImpl> {

        private CourseLocationBuilderImpl() {
        }

        protected CourseLocationBuilderImpl self() {
            return this;
        }

        public CourseLocation build() {
            return new CourseLocation(this);
        }
    }
}