package com.coursemores.service.domain;

import com.coursemores.service.domain.time.DeleteTimeEntity;
import com.coursemores.service.dto.profile.UserInfoUpdateReqDto;
import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "user")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends DeleteTimeEntity {

    @Id
    @Column(name = "user_id")
    private Long id;

    @Column(length = 20)
    private String nickname;

    @Column(length = 1)
    private String gender;

    @Column
    private int age;

    @Column
    private String profileImage;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Course> courseList; // 유저가 작성한 코스 목록

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> commentList; // 유저가 작성한 댓글 목록

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Interest> interestList; // 유저의 관심 코스 목록

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseLike> courseLikeList; // 유저의 코스 좋아요 목록

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommentLike> commentLikeList; // 유저의 댓글 좋아요 목록

    @Builder
    public User(long userAccountId) {
        this.id = userAccountId;
    }

    public void update(UserInfoUpdateReqDto userInfoUpdateReqDto) {
        this.nickname = userInfoUpdateReqDto.getNickname();
        this.age = userInfoUpdateReqDto.getAge();
        this.gender = userInfoUpdateReqDto.getGender();
        this.profileImage = userInfoUpdateReqDto.getProfileImage();
    }

    public void delete() {
        this.deleteTime = LocalDateTime.now();
    }
}