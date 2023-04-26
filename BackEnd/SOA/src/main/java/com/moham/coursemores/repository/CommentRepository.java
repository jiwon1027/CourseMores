package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Comment;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CommentRepository extends JpaRepository<Comment, Integer> {

    List<Comment> findByCourseIdAndDeleteTimeIsNull(int courseId, Pageable pageable);

    List<Comment> findByUserIdAndDeleteTimeIsNull(int userId);

    Optional<Comment> findByIdAndUserIdAndDeleteTimeIsNull(int commentId, int userId);
}
