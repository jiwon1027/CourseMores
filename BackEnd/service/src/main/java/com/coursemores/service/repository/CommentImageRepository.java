package com.coursemores.service.repository;

import com.coursemores.service.domain.CommentImage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentImageRepository extends JpaRepository<CommentImage, Long> {

    List<CommentImage> findByCommentId(Long commentId);

    void deleteByCommentId(Long commentId);

}