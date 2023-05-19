//package com.moham.coursemores.api;
//
//import static org.hamcrest.Matchers.hasSize;
//import static org.hamcrest.Matchers.is;
//import static org.mockito.Mockito.doNothing;
//import static org.mockito.Mockito.times;
//import static org.mockito.Mockito.verify;
//import static org.skyscreamer.jsonassert.JSONAssert.assertEquals;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
//import static org.mockito.BDDMockito.given;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//import com.moham.coursemores.domain.Comment;
//import com.moham.coursemores.domain.Course;
//import com.moham.coursemores.domain.User;
//import com.moham.coursemores.dto.comment.CommentCreateReqDTO;
//import com.moham.coursemores.dto.comment.CommentResDTO;
//import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
//import com.moham.coursemores.service.impl.CommentServiceImpl;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.jupiter.MockitoExtension;
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
//import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.setup.MockMvcBuilders;
//
//@SpringBootTest
//@AutoConfigureMockMvc
//public class CommentControllerJUnitTest {
//
//    private MockMvc mockMvc;
//
//    @Mock
//    private CommentServiceImpl commentService;
//
//    @InjectMocks
//    private CommentController commentController;
//
//    public CommentControllerJUnitTest() {
//    }
//
//    @BeforeEach
//    public void setUp() {
//        mockMvc = MockMvcBuilders.standaloneSetup(commentController).build();
//    }
//
//
//    User user1 = User.builder().build();
//    User user2 = User.builder().build();
//
//
//    Course course1 = Course.builder()
//            .title("test1 title")
//            .content("test1 content")
//            .people(10)
//            .time(30)
//            .visited(true)
//            .viewCount(10)
//            .interestCount(20)
//            .likeCount(30)
//            .user(user1)
//            .build();
//
//    Comment comment1 = Comment.builder()
//            .content("comment1")
//            .people(12)
//            .user(user1)
//            .course(course1)
//            .build();
//
//    Comment comment2 = Comment.builder()
//            .content("comment2")
//            .people(20)
//            .user(user2)
//            .course(course1)
//            .build();
//
//
//    @Test
//    @DisplayName("댓글 목록 조회 API")
//    public void searchCommentAllTest() throws Exception {
//        // given
//        int courseId = 1;
//        int userId = 1;
//        int page = 0;
//        String sortBy = "Like";
//
//        user1.update(UserInfoUpdateReqDto.builder()
//                .nickname("test1")
//                .profileImage("testUrl1")
//                .build());
//
//        CommentResDTO commentResDTO1 = CommentResDTO.builder()
//                .content("test1 comment")
//                .people(10)
//                .likeCount(10)
//                .imageList(new ArrayList<>(Arrays.asList("imgUrl1", "imgUrl2")))
//                .build();
//
//        CommentResDTO commentResDTO2 = CommentResDTO.builder()
//                .content("test2 comment")
//                .people(20)
//                .likeCount(20)
//                .imageList(new ArrayList<>(Arrays.asList("imgUrl3", "imgUrl4")))
//                .build();
//
//        List<CommentResDTO> commentList = Arrays.asList(commentResDTO1, commentResDTO2);
//
//        given(commentService.getCommentList(courseId, page, sortBy)).willReturn(commentList);
//
//        // when
//        mockMvc.perform(get("/comment/course/{courseId}/{userId}", courseId, userId)
//                        .param("page", String.valueOf(page))
//                        .param("sortby", sortBy))
//                .andExpect(status().isOk())
//                .andExpect(jsonPath("$.commentList[0].content").value(commentResDTO1.getContent()))
//                .andExpect(jsonPath("$.commentList[0].people").value(commentResDTO1.getPeople()))
//                .andExpect(jsonPath("$.commentList[0].likeCount").value(commentResDTO1.getLikeCount()))
//                .andExpect(jsonPath("$.commentList[0].imageList").value(commentResDTO1.getImageList()))
//
//                .andExpect(jsonPath("$.commentList[1].content").value(commentResDTO2.getContent()))
//                .andExpect(jsonPath("$.commentList[1].people").value(commentResDTO2.getPeople()))
//                .andExpect(jsonPath("$.commentList[1].likeCount").value(commentResDTO2.getLikeCount()))
//                .andExpect(jsonPath("$.commentList[1].imageList").value(commentResDTO2.getImageList()));
//
//    }
//
//    @Test
//    @DisplayName("내 댓글 목록 조회 API")
//    public void serarchMyCommentListTest() throws Exception {
//        user1.update(UserInfoUpdateReqDto.builder()
//                .nickname("test1")
//                .profileImage("testUrl1")
//                .build());
//
//        CommentResDTO commentResDTO1 = CommentResDTO.builder()
//                .content("test1 comment")
//                .people(10)
//                .likeCount(10)
//                .imageList(new ArrayList<>(Arrays.asList("imgUrl1", "imgUrl2")))
//                .build();
//
//        CommentResDTO commentResDTO2 = CommentResDTO.builder()
//                .content("test2 comment")
//                .people(20)
//                .likeCount(20)
//                .imageList(new ArrayList<>(Arrays.asList("imgUrl3", "imgUrl4")))
//                .build();
//
//        List<CommentResDTO> commentList = Arrays.asList(commentResDTO1, commentResDTO2);
//
//        given(commentService.getMyCommentList(user1.getId())).willReturn(commentList);
//
//        // when
//        mockMvc.perform(get("/comment/{userId}", user1.getId()))
//                .andExpect(status().isOk())
//                .andExpect(jsonPath("$.myCommentList[0].content").value(commentResDTO1.getContent()))
//                .andExpect(jsonPath("$.myCommentList[0].people").value(commentResDTO1.getPeople()))
//                .andExpect(jsonPath("$.myCommentList[0].likeCount").value(commentResDTO1.getLikeCount()))
//                .andExpect(jsonPath("$.myCommentList[0].imageList").value(commentResDTO1.getImageList()))
//
//                .andExpect(jsonPath("$.myCommentList[1].content").value(commentResDTO2.getContent()))
//                .andExpect(jsonPath("$.myCommentList[1].people").value(commentResDTO2.getPeople()))
//                .andExpect(jsonPath("$.myCommentList[1].likeCount").value(commentResDTO2.getLikeCount()))
//                .andExpect(jsonPath("$.myCommentList[1].imageList").value(commentResDTO2.getImageList()));
//    }
//
//}