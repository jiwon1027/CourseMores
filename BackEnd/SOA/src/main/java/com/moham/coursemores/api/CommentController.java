package com.moham.coursemores.api;

import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
import com.moham.coursemores.dto.comment.CommentResDTO;
import com.moham.coursemores.dto.comment.CommentUpdateReqDTO;
import com.moham.coursemores.dto.comment.MyCommentResDto;
import com.moham.coursemores.service.CommentService;
import com.moham.coursemores.service.NotificationService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("comment")
@RequiredArgsConstructor
public class CommentController {

    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);

    private final CommentService commentService;
    private final NotificationService notificationService;

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> getCommentAll(
            @PathVariable Long courseId,
            @PathVariable Long userId,
            @RequestParam int page,
            @RequestParam String sortby) {
        logger.debug("[0/2][GET][/comment/course/{}/{}] << request : page, sortby\n page = {}\n sortby = {}", courseId, userId, page, sortby);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/comment/course/{}/{}] ... cs.getCommentList", courseId, userId);
        List<CommentResDTO> commentList = commentService.getCommentList(courseId, page, sortby);
        resultMap.put("commentList", commentList);

        logger.debug("[2/2][GET][/comment/course/{}/{}] >> response : commentList\n commentList = {}\n", courseId, userId, commentList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getMyCommentList(
            @PathVariable Long userId) {
        logger.debug("[0/2][GET][/comment/{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/comment/{}] ... cs.getMyCommentList", userId);
        List<MyCommentResDto> myCommentList = commentService.getMyCommentList(userId);
        resultMap.put("myCommentList", myCommentList);

        logger.debug("[2/2][GET][/comment/{}] >> response : myCommentList\n myCommentList = {}\n", userId, myCommentList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }


    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> postComment(
            @PathVariable Long courseId,
            @PathVariable Long userId,
            @RequestPart CommentCreateReqDTO commentCreateReqDTO,
            @RequestPart(required = false) List<MultipartFile> imageList) {
        logger.debug("[0/3][POST][/comment/course/{}/{}] << request : commentCreateReqDTO, imageList\n commentCreateReqDTO = {}\n imageList = {}", courseId,
                userId, commentCreateReqDTO, imageList);

        logger.debug("[1/3][POST][/comment/course/{}/{}] ... cs.createComment", courseId, userId);
        commentService.createComment(courseId, userId, commentCreateReqDTO, imageList);

        logger.debug("[2/3][POST][/comment/course/{}/{}] ... ns.makeNotification", courseId, userId);
        notificationService.makeNotification(userId, courseId, 1);

        logger.debug("[3/3][POST][/comment/course/{}/{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("{commentId}/{userId}")
    public ResponseEntity<Void> putComment(
            @PathVariable Long commentId,
            @PathVariable Long userId,
            @RequestPart CommentUpdateReqDTO commentUpdateReqDTO,
            @RequestPart(required = false) List<MultipartFile> imageList) {
        logger.debug("[0/2][PUT][/comment/{}/{}] << request : commentUpdateReqDTO, imageList\n commentUpdateReqDTO = {}\n imageList = {}",
                commentId, userId, commentUpdateReqDTO, imageList);

        logger.debug("[1/2][PUT][/comment/{}/{}] ... cs.updateComment", commentId, userId);
        commentService.updateComment(commentId, userId, commentUpdateReqDTO, imageList);

        logger.debug("[2/2][PUT][/comment/{}/{}] >> response : none\n", commentId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("{commentId}/{userId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable Long commentId,
            @PathVariable Long userId) {
        logger.debug("[0/2][DELETE][/comment/{}/{}] << request : none", commentId, userId);

        logger.debug("[1/2][DELETE][/comment/{}/{}] ... cs.deleteComment", commentId, userId);
        commentService.deleteComment(commentId, userId);

        logger.debug("[2/2][DELETE][/comment/{}/{}] >> response : none\n", commentId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}