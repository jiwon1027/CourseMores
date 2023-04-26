package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Comment;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;



public interface CommentRepository extends JpaRepository<Comment, Integer> {
    List<Comment> findByCourseId(int courseId);
    List<Comment> findByUserId(int userId);

    Optional<Comment> findByIdAndDeleteTimeIsNull(int commentId);
}
