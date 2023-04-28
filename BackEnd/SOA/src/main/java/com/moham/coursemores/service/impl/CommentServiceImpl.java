package com.moham.coursemores.service.impl;


import com.moham.coursemores.domain.Comment;
import com.moham.coursemores.domain.CommentImage;
import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
import com.moham.coursemores.dto.comment.CommentResDTO;
import com.moham.coursemores.dto.comment.CommentUpdateDTO;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.repository.CommentImageRepository;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.CommentService;
import com.moham.coursemores.repository.CommentRepository;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommentServiceImpl implements CommentService {
    private final CommentRepository commentRepository;
    private final CommentImageRepository commentImageRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;

    @Override
    public List<CommentResDTO> getCommentList(int courseId, int page, String sortby) {
        // 한 페이지에 보여줄 댓글의 수
        final int size = 5;

        // Sort 정렬 기준
        Sort sort = ("Like".equals(sortby))?Sort.by("likeCount").descending():Sort.by("createTime").descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        List<CommentResDTO> commentList = commentRepository.findByCourseIdAndDeleteTimeIsNull(courseId, pageable)
                .stream()
                .map(comment -> CommentResDTO.builder()
                        .commentId(comment.getId())
                        .content(comment.getContent())
                        .people(comment.getPeople())
                        .likeCount(comment.getLikeCount())
                        .imageList(commentImageRepository.findByCommentId(comment.getId())
                                .stream()
                                .map(CommentImage::getImage)
                                .collect(Collectors.toList()))
                        .writeUser(UserSimpleInfoResDto.builder()
                                .nickname(comment.getUser().getNickname())
                                .profileImage(comment.getUser().getProfileImage())
                                .build())
                        .build()
                )
                .collect(Collectors.toList());
        return commentList;

    }

    @Override
    public List<CommentResDTO> getMyCommentList(int userId) {
        // userId가 작성한 댓글 중 deletetime이 null이 아닌 댓글(삭제되지 않은 댓글)
        return commentRepository.findByUserIdAndDeleteTimeIsNull(userId)
                .stream()
                .map(comment -> CommentResDTO.builder()
                        .commentId(comment.getId())
                        .content(comment.getContent())
                        .people(comment.getPeople())
                        .likeCount(comment.getLikeCount())
                        .imageList(commentImageRepository.findByCommentId(comment.getId())
                                .stream()
                                .map(CommentImage::getImage)
                                .collect(Collectors.toList()))
                        .writeUser(UserSimpleInfoResDto.builder()
                                .nickname(comment.getUser().getNickname())
                                .profileImage(comment.getUser().getProfileImage())
                                .build())
                        .build()
                )
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void createComment(int courseId, int userId, CommentCreateReqDTO commentCreateReqDTO) {
        // userId의 User 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        //courseId의 Course 가져오기
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(()-> new RuntimeException("해당 코스를 찾을 수 없습니다."));

        // courseId의 course가 있다면 course + DTO를 기반으로 새로운 댓글 생성
        Comment comment = Comment.builder()
                .content(commentCreateReqDTO.getContent())
                .people(commentCreateReqDTO.getPeople())
                .user(user)
                .course(course)
                .build();

        commentRepository.save(comment);

        // commentImage table에도 사진 추가
        commentCreateReqDTO.getImageList().forEach(
                imageUrl -> {
                    CommentImage commentImage = CommentImage.builder()
                            .comment(comment)
                            .image(imageUrl)
                            .build();
                    commentImageRepository.save(commentImage);
                }
        );
    }

    @Override
    @Transactional
    public void updateComment(int commentId, int userId, CommentUpdateDTO commentUpdateDTO) {
        // userId의 User 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        // commentId의 Comment 가져오기
        Comment comment = commentRepository.findByIdAndUserIdAndDeleteTimeIsNull(commentId, user.getId())
                .orElseThrow(()-> new RuntimeException("해당 댓글를 찾을 수 없습니다."));

        // commentId의 comment가 있다면 comment를 가져와서 수정
        comment.update(commentUpdateDTO);

        // 기존에 있었던 commentImage 삭제
        commentImageRepository.deleteByCommentId(commentId);

        // 이미지 새롭게 추가
        commentUpdateDTO.getImageList().forEach(
                imageUrl -> {
                    CommentImage commentImage = CommentImage.builder()
                            .image(imageUrl)
                            .comment(comment)
                            .build();
                    commentImageRepository.save(commentImage);
                }
        );
    }

    @Override
    @Transactional
    public void deleteComment(int commentId, int userId) {
        // userId의 User 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        // commentId의 Comment 가져오기
        Comment comment = commentRepository.findByIdAndUserIdAndDeleteTimeIsNull(commentId, user.getId())
                .orElseThrow(()-> new RuntimeException("해당 댓글를 찾을 수 없습니다."));

        // commentId의 comment가 있다면 comment를 가져와서 수정
        comment.delete();
    }
}
