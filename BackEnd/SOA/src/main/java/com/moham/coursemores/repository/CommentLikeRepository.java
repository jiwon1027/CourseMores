package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CommentLike;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentLikeRepository extends JpaRepository<CommentLike, Integer> {

    Optional<CommentLike> findByUserIdAndCommentId(int userId, int commentId);

}