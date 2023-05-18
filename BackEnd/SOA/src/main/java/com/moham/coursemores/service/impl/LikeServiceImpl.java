package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.exception.CustomErrorCode;
import com.moham.coursemores.common.exception.CustomException;
import com.moham.coursemores.domain.*;
import com.moham.coursemores.repository.*;
import com.moham.coursemores.service.LikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LikeServiceImpl implements LikeService {

    private final CourseLikeRepository courseLikeRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;
    private final CommentLikeRepository commentLikeRepository;
    private final CommentRepository commentRepository;

    @Override
    public boolean checkLikeCourse(Long userId, Long courseId) {
        // 코스 좋아요 객체가 존재하고 flag 또한 true이면 해당 유저가 좋아하는 코스이다.
        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);
        return courseLike.isPresent() && courseLike.get().isFlag();
    }

    @Override
    @Transactional
    public boolean addLikeCourse(Long userId, Long courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new CustomException(courseId, CustomErrorCode.COURSE_NOT_FOUND));

        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);
        boolean alarm;
        if (courseLike.isPresent()) {
            // 코스 좋아요 객체가 존재한다면 좋아요 등록일시를 설정해준다.
            if(courseLike.get().isFlag())
                return false;
            courseLike.get().register();
            alarm = false;
        } else {
            // 코스 좋아요 객체가 존재하지 않으면 새로 생성해준다.
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
            courseLikeRepository.save(CourseLike.builder()
                    .user(user)
                    .course(course)
                    .build());
            alarm = true;
        }
        course.increaseLikeCount();
        return alarm;
    }

    @Override
    @Transactional
    public void deleteLikeCourse(Long userId, Long courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                        .orElseThrow(() -> new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND));

        // 코스 좋아요 객체의 해제일시를 설정해준다.
        CourseLike courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseThrow(() -> new CustomException(userId,courseId,CustomErrorCode.LIKE_COURSE_NOT_FOUND));

        if(courseLike.isFlag()){
            courseLike.release();
            course.decreaseLikeCount();
        }
    }

    @Override
    public boolean checkLikeComment(Long userId, Long commentId) {
        // 댓글 좋아요 객체가 존재하고 flag 또한 true이면 해당 유저가 좋아하는 댓글이다.
        Optional<CommentLike> commentLike = commentLikeRepository.findByUserIdAndCommentId(userId, commentId);
        return commentLike.isPresent() && commentLike.get().isFlag();
    }

    @Override
    @Transactional
    public void addLikeComment(Long userId, Long commentId) {
        Comment comment = commentRepository.findByIdAndDeleteTimeIsNull(commentId)
                .orElseThrow(() -> new CustomException(commentId,CustomErrorCode.COMMENT_NOT_FOUND));

        Optional<CommentLike> commentLike = commentLikeRepository.findByUserIdAndCommentId(userId, commentId);

        if (commentLike.isPresent()) {
            // 댓글 좋아요 객체가 존재한다면 좋아요 등록일시를 설정해준다.
            if(commentLike.get().isFlag())
                return;
            commentLike.get().register();
        } else {
            // 댓글 좋아요 객체가 존재하지 않으면 새로 생성해준다.
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
            commentLikeRepository.save(CommentLike.builder()
                    .user(user)
                    .comment(comment)
                    .build());
        }

        // 댓글의 좋아요수 증가
        comment.increaseLikeCount();
    }

    @Override
    @Transactional
    public void deleteLikeComment(Long userId, Long commentId) {
        Comment comment = commentRepository.findByIdAndDeleteTimeIsNull(commentId)
                .orElseThrow(() -> new CustomException(commentId,CustomErrorCode.COMMENT_NOT_FOUND));

        // 댓글 좋아요 객체의 해제일시를 설정해준다.
        CommentLike commentLike = commentLikeRepository.findByUserIdAndCommentId(userId, commentId)
                .orElseThrow(() -> new CustomException(userId,commentId,CustomErrorCode.LIKE_COMMENT_NOT_FOUND));

        if(commentLike.isFlag()){
            commentLike.release();
            // 댓글의 좋아요수 감소
            comment.decreaseLikeCount();
        }
    }

}