package com.moham.coursemores.service;

import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
import com.moham.coursemores.dto.comment.CommentResDTO;
import com.moham.coursemores.dto.comment.CommentUpdateDTO;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface CommentService {
    List<CommentResDTO> getCommentList(Long courseId, int page, String sortby);
    List<CommentResDTO> getMyCommentList(Long userId);
    void createComment(Long courseId, Long userId, CommentCreateReqDTO commentCreateReqDTO, List<MultipartFile> imageList);
    void updateComment(Long commentId, Long userId, CommentUpdateDTO commentUpdateDTO);
    void deleteComment(Long commentId, Long userId);
}