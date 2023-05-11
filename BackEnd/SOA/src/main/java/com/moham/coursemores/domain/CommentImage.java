package com.moham.coursemores.domain;

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

import com.moham.coursemores.domain.time.CreateTimeEntity;
import lombok.*;

@Entity
@Table(name = "comment_image")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommentImage extends CreateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_image_id")
    private Long id;

    @NotNull
    @Column(length = 1000)
    private String image;

    @NotNull
    @ManyToOne(targetEntity = Comment.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "comment_id")
    private Comment comment; // 사진의 해당 댓글

    @Builder
    public CommentImage(String image,
                        Comment comment){
        this.image = image;
        this.comment = comment;
    }

}