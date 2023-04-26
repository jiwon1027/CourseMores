package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.Comment;
import com.moham.coursemores.domain.CommentLike;
import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLike;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.repository.CommentLikeRepository;
import com.moham.coursemores.repository.CommentRepository;
import com.moham.coursemores.repository.CourseLikeRepository;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.LikeService;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    public boolean checkLikeCourse(int userId, int courseId) {
        // 코스 좋아요 객체가 존재하고 flag 또한 true이면 해당 유저가 좋아하는 코스이다.
        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);
        return courseLike.isPresent() && courseLike.get().isFlag();
    }

    @Override
    @Transactional
    public void addLikeCourse(int userId, int courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));

        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);

        if (courseLike.isPresent()) {
            // 코스 좋아요 객체가 존재한다면 좋아요 등록일시를 설정해준다.
            courseLike.get().register();
        } else {
            // 코스 좋아요 객체가 존재하지 않으면 새로 생성해준다.
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
            courseLikeRepository.save(CourseLike.builder()
                    .user(user)
                    .course(course)
                    .build());
        }
        course.increaseLikeCount();
    }

    @Override
    @Transactional
    public void deleteLikeCourse(int userId, int courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));

        // 코스 좋아요 객체의 해제일시를 설정해준다.
        CourseLike courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스 좋아요 내역을 찾을 수 없습니다."));
        courseLike.release();

        course.decreaseLikeCount();
    }

    @Override
    public boolean checkLikeComment(int userId, int commentId) {
        // 댓글 좋아요 객체가 존재하고 flag 또한 true이면 해당 유저가 좋아하는 댓글이다.
        Optional<CommentLike> commentLike = commentLikeRepository.findByUserIdAndCommentId(userId, commentId);
        return commentLike.isPresent() && commentLike.get().isFlag();
    }

    @Override
    @Transactional
    public void addLikeComment(int userId, int commentId) {
        Comment comment = commentRepository.findByIdAndDeleteTimeIsNull(commentId)
                .orElseThrow(() -> new RuntimeException("해당 댓글을 찾을 수 없습니다."));

        Optional<CommentLike> commentLike = commentLikeRepository.findByUserIdAndCommentId(userId, commentId);

        if (commentLike.isPresent()) {
            // 댓글 좋아요 객체가 존재한다면 좋아요 등록일시를 설정해준다.
            commentLike.get().register();
        } else {
            // 댓글 좋아요 객체가 존재하지 않으면 새로 생성해준다.
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
            commentLikeRepository.save(CommentLike.builder()
                    .user(user)
                    .comment(comment)
                    .build());
        }

        // 댓글의 좋아요수 증가
        comment.increaseLikeCount();
    }

}