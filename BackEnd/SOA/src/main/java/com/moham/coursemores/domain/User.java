package com.moham.coursemores.domain;

import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.time.DeleteTimeEntity;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.*;
import javax.validation.constraints.NotNull;

import lombok.*;

@Entity
@Table(name = "user")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @NotNull
    private String email;

    @NotNull
    @Column(length = 50)
    private String roles;

    @NotNull
    @Column
    @Enumerated(EnumType.STRING)
    private OAuthProvider provider;

//    @NotNull
//    @Column
//    private String providerId;

    @Column(length = 50)
    private String nickname;

    @Column(length = 1)
    private String gender;

    @Column
    private int age;

    @Column(length = 1000)
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

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Notification> notificationList; // 유저의 알림 목록

    @Builder
    public User(String email
            ,String roles
            ,OAuthProvider provider
//                ,String providerId
    ){
        this.email = email;
        this.roles = roles;
        this.provider = provider;
//        this.providerId = providerId;
    }

    public void create(UserInfoCreateReqDto userInfoCreateReqDto, String imageUrl){
        this.nickname = userInfoCreateReqDto.getNickname();
        this.age = userInfoCreateReqDto.getAge();
        this.gender = userInfoCreateReqDto.getGender();
        this.profileImage = imageUrl;
    }

    public void update(UserInfoUpdateReqDto userInfoUpdateReqDto, String imageUrl){
        this.nickname = userInfoUpdateReqDto.getNickname();
        this.age = userInfoUpdateReqDto.getAge();
        this.gender = userInfoUpdateReqDto.getGender();
        this.profileImage = imageUrl;
    }

    public void delete(){
        this.deleteTime = LocalDateTime.now();
    }
}