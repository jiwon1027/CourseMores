package com.moham.coursemores.service;


import com.moham.coursemores.domain.Comment;
import com.moham.coursemores.domain.CommentImage;
import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
import com.moham.coursemores.dto.comment.CommentResDTO;
import com.moham.coursemores.dto.comment.CommentUpdateDTO;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import com.moham.coursemores.repository.CommentImageRepository;
import com.moham.coursemores.repository.CommentRepository;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.impl.CommentServiceImpl;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CommentServiceJUnitTest {
    @InjectMocks
    CommentServiceImpl commentService;

    @Mock
    CommentRepository commentRepository;

    @Mock
    CommentImageRepository commentImageRepository;

    @Mock
    UserRepository userRepository;

    @Mock
    CourseRepository courseRepository;


    User user1 = User.builder().build();
    User user2 = User.builder().build();


    Course course1 = Course.builder()
            .title("test1 title")
            .content("test1 content")
            .people(10)
            .time(30)
            .visited(true)
            .viewCount(10)
            .interestCount(20)
            .likeCount(30)
            .user(user1)
            .build();

    Comment comment1 = Comment.builder()
            .content("comment1")
            .people(12)
            .user(user1)
            .course(course1)
            .build();

    Comment comment2 = Comment.builder()
            .content("comment2")
            .people(20)
            .user(user2)
            .course(course1)
            .build();

    CommentImage commentImage1 = CommentImage.builder()
            .image("image1")
            .comment(comment1)
            .build();

    CommentImage commentImage2 = CommentImage.builder()
            .image("image2")
            .comment(comment1)
            .build();



    @Test
    @DisplayName("댓글 목록 조회 테스트")
    public void getCommentListTest() {
        // given
        int courseId = 1;
        int page = 0;
        String sortby = "Like";

        user1.update(UserInfoUpdateReqDto.builder()
                .nickname("test1")
                .profileImage("testUrl1")
                .build());

        user2.update(UserInfoUpdateReqDto.builder()
                .nickname("test2")
                .profileImage("testUrl2")
                .build());

        List<Comment> commentList = new ArrayList<>();
        commentList.add(comment1);
        commentList.add(comment2);

        List<CommentImage> commentImageList1 = new ArrayList<>();
        commentImageList1.add(commentImage1);
        commentImageList1.add(commentImage2);

        // 한 페이지에 보여줄 댓글의 수
        final int size = 5;

        // Sort 정렬 기준
        Sort sort = ("Like".equals(sortby))?Sort.by("likeCount").descending():Sort.by("createTime").descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        // 쿼리메소드가 각각 commentList, commentImageList를 return 하게끔 바인딩
        when(commentRepository.findByCourseIdAndDeleteTimeIsNull(courseId, pageable)).thenReturn(commentList);
        when(commentImageRepository.findByCommentId(comment1.getId())).thenReturn(commentImageList1);

        // when
        List<CommentResDTO> commentList1 = commentService.getCommentList(courseId, page, sortby);

        // then
        assertThat(commentList1.size()).isEqualTo(2);

        assertEquals(commentList1.get(0).getContent(), comment1.getContent());
        assertEquals(commentList1.get(0).getPeople(), comment1.getPeople());
        assertEquals(commentList1.get(0).getLikeCount(), comment1.getLikeCount());

        assertEquals(commentList1.get(0).getImageList().size(), 2);
        assertEquals(commentList1.get(0).getImageList().get(0), commentImage1.getImage());
        assertEquals(commentList1.get(0).getImageList().get(1), commentImage2.getImage());

        assertEquals(commentList1.get(1).getContent(), comment2.getContent());
        assertEquals(commentList1.get(1).getPeople(), comment2.getPeople());
        assertEquals(commentList1.get(1).getLikeCount(), comment2.getLikeCount());
    }



    @Test
    @DisplayName("내 댓글 조회 테스트")
    public void getMyCommentListTest(){

        // given
        user1.update(UserInfoUpdateReqDto.builder()
                .nickname("test1")
                .profileImage("testUrl1")
                .build());

        List<Comment> commentList = new ArrayList<>();
        commentList.add(comment1);
        commentList.add(comment2);

        List<CommentImage> commentImageList = new ArrayList<>();
        commentImageList.add(commentImage1);
        commentImageList.add(commentImage2);

        // 쿼리메소드가 각각 commentList, commentImageList를 return 하게끔 바인딩
        when(commentRepository.findByUserIdAndDeleteTimeIsNull(user1.getId())).thenReturn(commentList);
        when(commentImageRepository.findByCommentId(comment1.getId())).thenReturn(commentImageList);

        // when
        List<CommentResDTO> myCommentList = commentService.getMyCommentList(user1.getId());


        // then
        assertThat(myCommentList.size()).isEqualTo(2);

        assertEquals(myCommentList.get(0).getContent(), comment1.getContent());
        assertEquals(myCommentList.get(0).getPeople(), comment1.getPeople());
        assertEquals(myCommentList.get(0).getLikeCount(), comment1.getLikeCount());

        assertEquals(myCommentList.get(0).getImageList().size(), 2);
        assertEquals(myCommentList.get(0).getImageList().get(0), commentImage1.getImage());
        assertEquals(myCommentList.get(0).getImageList().get(1), commentImage2.getImage());

        assertEquals(myCommentList.get(1).getContent(), comment2.getContent());
        assertEquals(myCommentList.get(1).getPeople(), comment2.getPeople());
        assertEquals(myCommentList.get(1).getLikeCount(), comment2.getLikeCount());
    }

    @Test
    @DisplayName("댓글 생성 테스트")
    public void createCommentTest(){
        // given
        user1.update(UserInfoUpdateReqDto.builder()
                .nickname("test1")
                .profileImage("testUrl1")
                .build());

        // 쿼리메소드가 각각 user1, course1을 return 하게끔 바인딩
        when(userRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(user1));
        when(courseRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.ofNullable(course1));

        CommentCreateReqDTO commentCreateReqDTO = CommentCreateReqDTO.builder()
                .content("test1")
                .people(12)
                .imageList(new ArrayList<>(Arrays.asList("test1", "test2")))
                .build();

        // when
        commentService.createComment(course1.getId(), user1.getId(), commentCreateReqDTO);

        // then
        verify(userRepository, times(1)).findByIdAndDeleteTimeIsNull(anyInt());
        verify(courseRepository, times(1)).findByIdAndDeleteTimeIsNull(anyInt());
        verify(commentRepository, times(1)).save(any(Comment.class));
        verify(commentImageRepository, times(2)).save(any(CommentImage.class));

    }

    @Test
    @DisplayName("댓글 수정 테스트")
    public void updateCommentTest(){

        // given
        user1.update(UserInfoUpdateReqDto.builder()
                .nickname("test1")
                .profileImage("testUrl1")
                .build());

        List<String> newImageList = Arrays.asList("test3", "test4");
        CommentUpdateDTO commentUpdateDTO = CommentUpdateDTO.builder()
                .content("updated comment")
                .people(15)
                .imageList(newImageList)
                .build();


        // 쿼리메소드가 각각 user1, comment1을 return 하게끔 바인딩
        when(userRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(user1));
        when(commentRepository.findByIdAndUserIdAndDeleteTimeIsNull(any(Integer.class), any(Integer.class))).thenReturn(Optional.of(comment1));

        // when
        commentService.updateComment(comment1.getId(), user1.getId(), commentUpdateDTO);

        // then
        // 각각 메소드가 1번씩 실행된게 맞는지 확인
        verify(userRepository, times(1)).findByIdAndDeleteTimeIsNull(anyInt());
        verify(commentRepository, times(1)).findByIdAndUserIdAndDeleteTimeIsNull(anyInt(), anyInt());
        verify(commentImageRepository, times(1)).deleteByCommentId(anyInt());

        // commentImage save가 newImageList.size에 맞게 실행되었는지 확인
        verify(commentImageRepository, times(newImageList.size())).save(any(CommentImage.class));


        
    }

    @Test
    @DisplayName("댓글 삭제 테스트")
    public void deleteCommentTest(){

        // given
        user1.update(UserInfoUpdateReqDto.builder()
                .nickname("test1")
                .profileImage("testUrl1")
                .build());

        // 쿼리메소드가 각각 user1, comment1을 return 하게끔 바인딩
        when(userRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(user1));
        when(commentRepository.findByIdAndUserIdAndDeleteTimeIsNull(any(Integer.class), any(Integer.class))).thenReturn(Optional.of(comment1));

        // when
        commentService.deleteComment(comment1.getId(), user1.getId());

        // then
        assertNotNull(comment1.getDeleteTime());
    }

}
