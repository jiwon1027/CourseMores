package com.moham.coursemores.repository;

import com.moham.coursemores.domain.CommentImage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentImageRepository extends JpaRepository<CommentImage, Long> {

    List<CommentImage> findByCommentId(Long commentId);

    void deleteByCommentId(Long commentId);

}