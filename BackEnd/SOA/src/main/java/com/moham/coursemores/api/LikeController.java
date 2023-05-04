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
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        boolean isLikeCourse = likeService.checkLikeCourse(userId, courseId);
        resultMap.put("isLikeCourse", isLikeCourse);
        logger.info("<< response : isLikeCourse={}", isLikeCourse);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addLikeCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        likeService.addLikeCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteLikeCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        likeService.deleteLikeCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : commentId={}", commentId);

        Map<String, Object> resultMap = new HashMap<>();

        boolean isLikeComment = likeService.checkLikeComment(userId, commentId);
        resultMap.put("isLikeComment", isLikeComment);
        logger.info("<< response : isLikeComment={}", isLikeComment);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Void> addLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : commentId={}", commentId);

        likeService.addLikeComment(userId, commentId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("comment/{commentId}/{userId}")
    public ResponseEntity<Void> deleteLikeComment(
            @PathVariable Long userId,
            @PathVariable Long commentId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : commentId={}", commentId);

        likeService.deleteLikeComment(userId, commentId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

}