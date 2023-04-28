package com.moham.coursemores.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLocation;
import com.moham.coursemores.domain.Interest;
import com.moham.coursemores.domain.Region;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.InterestRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.impl.InterestServiceImp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

@ExtendWith(MockitoExtension.class)
class InterestServiceJUnitTest {

    @InjectMocks
    InterestServiceImp interestService;
    @Mock
    UserRepository userRepository;
    @Mock
    CourseRepository courseRepository;
    @Mock
    InterestRepository interestRepository;
    User testUser;
    Course testCourse;
    Interest testInterest;

    @BeforeEach
    void 초기_설정() {
        // given
        testUser = User.builder().build();
        testCourse = Course.builder().build();
        testInterest = Interest.builder().user(testUser).course(testCourse).build();
    }

    @Nested
    class 관심_코스_목록_가져오기 {

        @BeforeEach
        void 테스트_코스_추가_설정() {
            // 테스트 코스의 댓글 목록 설정
            ReflectionTestUtils.setField(testCourse, "commentList", new ArrayList<>());

            // 테스트 코스의 장소 목록 설정
            List<CourseLocation> testCourseLocationList = new ArrayList<>();
            testCourseLocationList.add(CourseLocation.builder().region(Region.builder().build()).course(testCourse).build());
            ReflectionTestUtils.setField(testCourse, "courseLocationList", testCourseLocationList);
        }

        @Test
        void 성공() {
            // given
            List<Interest> testInterestList = new ArrayList<>();
            testInterestList.add(testInterest);

            when(interestRepository.findByUserIdAndFlag(any(Integer.class), any(Boolean.class))).thenReturn(testInterestList);

            // when
            List<InterestCourseResDto> interestCourseResDtoList = interestService.getUserInterestCourseList(testUser.getId());

            // then
            assertThat(testInterestList.size()).isEqualTo(interestCourseResDtoList.size()); // 주어진
        }

    } // 관심 코스 목록 가져오기

    @Nested
    class 관심_코스_추가 {

        @BeforeEach
        void 코스_찾기_반환값_설정() {
            when(courseRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(testCourse));
        }

        @Test
        void 이미_등록된_관심_오류() {
            // given
            when(interestRepository.findByUserIdAndCourseId(any(Integer.class), any(Integer.class))).thenReturn(Optional.of(testInterest));

            // when
            RuntimeException e = assertThrows(RuntimeException.class, () -> interestService.addInterestCourse(testUser.getId(), testCourse.getId()));

            // then
            assertThat(e.getMessage()).isEqualTo("이미 관심 등록된 코스입니다.");
            verify(interestRepository, never()).save(any(Interest.class));
        }

        @Test
        void 관심_객체_존재() {
            // given
            when(interestRepository.findByUserIdAndCourseId(any(Integer.class), any(Integer.class))).thenReturn(Optional.of(testInterest));

            // when
            testInterest.release();
            interestService.addInterestCourse(testUser.getId(), testCourse.getId());

            // then
            assertTrue(testInterest.getRegisterTime().isAfter(testInterest.getReleaseTime())); // 등록일이 더 최신인지 확인
            assertThat(testCourse.getInterestCount()).isEqualTo(1); // 코스의 관심수 증가 확인
        }

        @Test
        void 새로운_관심_객체() {
            // given
            when(interestRepository.findByUserIdAndCourseId(any(Integer.class), any(Integer.class))).thenReturn(Optional.empty());
            when(userRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(testUser));

            // when
            interestService.addInterestCourse(testUser.getId(), testCourse.getId());

            // then
            verify(interestRepository, times(1)).save(any(Interest.class)); // 새로운 관심 객체 생성 확인
            assertThat(testCourse.getInterestCount()).isEqualTo(1); // 코스의 관심수 증가 확인
        }

    } // 관심 코스 추가

}