package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Comment;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    List<Comment> findByCourseIdAndDeleteTimeIsNull(Long courseId, Pageable pageable);

    List<Comment> findByUserIdAndDeleteTimeIsNull(Long userId);

    Optional<Comment> findByIdAndUserIdAndDeleteTimeIsNull(Long commentId, Long userId);

    Optional<Comment> findByIdAndDeleteTimeIsNull(Long commentId);

}