package com.coursemores.service.domain;


import com.coursemores.service.domain.time.RecordTimeEntity;
import java.time.LocalDateTime;
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
@Table(name = "course_like")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CourseLike extends RecordTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "course_like_id")
    private Long id;

    @NotNull
    @Column
    private boolean flag;

    @NotNull
    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user; // 좋아요를 누른 유저

    @NotNull
    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id")
    private Course course; // 좋아요가 눌린 코스

    @Builder
    public CourseLike(User user,
            Course course) {
        this.flag = true;
        this.registerTime = LocalDateTime.now();
        this.user = user;
        this.course = course;
    }

    public void register() {
        this.flag = true;
        this.registerTime = LocalDateTime.now();
    }

    public void release() {
        this.flag = false;
        this.releaseTime = LocalDateTime.now();
    }

}