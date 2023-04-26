package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.RecordTimeEntity;
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
@Table(name = "comment_like")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommentLike extends RecordTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_like_id")
    private int id;

    @NotNull
    @Column
    private boolean flag;

    @NotNull
    @ManyToOne(targetEntity = User.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user; // 댓글에 좋아요를 누른 유저

    @NotNull
    @ManyToOne(targetEntity = Comment.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "comment_id")
    private Comment comment; // 좋아요가 눌린 댓글

    @Builder
    public CommentLike(User user,
            Comment comment) {
        this.flag = true;
        this.registerTime = LocalDateTime.now();
        this.user = user;
        this.comment = comment;
    }

    public void register() {
        this.flag = true;
        this.registerTime = LocalDateTime.now();
    }

}