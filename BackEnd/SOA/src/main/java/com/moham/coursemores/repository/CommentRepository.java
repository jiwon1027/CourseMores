package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
    Optional<Comment> findByIdAndDeleteTimeIsNull(int commentId);
}
