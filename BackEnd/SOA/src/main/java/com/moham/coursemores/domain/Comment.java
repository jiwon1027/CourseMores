package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
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
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "comment")
@Getter
@ToString
@SuperBuilder
public class Comment extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id")
    private int id;

    @NotNull
    private int people;

    @NotNull
    @Column(length = 1000)
    private String content;

    @NotNull
    private int likeCount;

    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user; // 댓글 작성 유저

    @ManyToOne(targetEntity = Course.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id")
    private Course course; // 해당 코스

    @OneToMany(mappedBy = "comment", cascade = CascadeType.ALL)
    private List<CommentLike> commentLikeList; // 댓글의 좋아요 목록

}