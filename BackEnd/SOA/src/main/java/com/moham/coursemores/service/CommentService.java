package com.moham.coursemores.service;

import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
import com.moham.coursemores.dto.comment.CommentResDTO;
import com.moham.coursemores.dto.comment.CommentUpdateDTO;
import java.util.List;
import org.springframework.data.domain.Page;

public interface CommentService {
    List<CommentResDTO> getCommentList(int courseId, int page, String sortby);
    List<CommentResDTO> getMyCommentList(int userId);


    void createComment(int courseId, int userId, CommentCreateReqDTO commentCreateReqDTO);

    void updateComment(int commentId, int userId, CommentUpdateDTO commentUpdateDTO);

    void deleteComment(int commentId, int userId);

}

