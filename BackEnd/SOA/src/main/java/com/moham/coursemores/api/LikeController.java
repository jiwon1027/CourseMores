package com.moham.coursemores.api;

import com.moham.coursemores.service.LikeService;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("like")
@RequiredArgsConstructor
public class LikeController {

    private static final Logger logger = LoggerFactory.getLogger(LikeController.class);

    private final LikeService likeService;

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkLikeCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][GET][/like/course/{}/{}] << request : none", courseId, userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/like/course/{}/{}] ... ls.checkLikeCourse", courseId, userId);
        boolean isLikeCourse = likeService.checkLikeCourse(userId, courseId);
        resultMap.put("isLikeCourse", isLikeCourse);

        logger.debug("[2/2][GET][/like/course/{}/{}] >> response : isLikeCourse\n isLikeCourse = {}\n", courseId, userId, isLikeCourse);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addLikeCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][POST][/like/course/{}/{}] << request : none", courseId, userId);

        logger.debug("[1/2][POST][/like/course/{}/{}] ... ls.addLikeCourse", courseId, userId);
        likeService.addLikeCourse(userId, courseId);

        logger.debug("[2/2][POST][/like/course/{}/{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteLikeCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][DELETE][/like/course/{}/{}] << request : none", courseId, userId);

        logger.debug("[1/2][DELETE][/like/course/{}/{}] ... ls.deleteLikeCourse", courseId, userId);
        likeService.deleteLikeCourse(userId, courseId);

        logger.debug("[2/2][DELETE][/like/course/{}/{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.debug("[0/2][GET][/like/comment/{}/{}] << request : none", commentId, userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/like/comment/{}/{}] ... ls.checkLikeComment", commentId, userId);
        boolean isLikeComment = likeService.checkLikeComment(userId, commentId);
        resultMap.put("isLikeComment", isLikeComment);

        logger.debug("[2/2][GET][/like/comment/{}/{}] >> response : isLikeComment\n isLikeComment = {}\n", commentId, userId, isLikeComment);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Void> addLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.debug("[0/2][POST][/like/comment/{}/{}] << request : none", commentId, userId);

        logger.debug("[1/2][POST][/like/comment/{}/{}] ... ls.addLikeComment", commentId, userId);
        likeService.addLikeComment(userId, commentId);

        logger.debug("[2/2][POST][/like/comment/{}/{}] >> response : none\n", commentId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Void> deleteLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.debug("[0/2][DELETE][/like/comment/{}/{}] << request : none", commentId, userId);

        logger.debug("[1/2][DELETE][/like/comment/{}/{}] ... ls.deleteLikeComment", commentId, userId);
        likeService.deleteLikeComment(userId, commentId);

        logger.debug("[2/2][DELETE][/like/comment/{}/{}] >> response : none\n", commentId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}