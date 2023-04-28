package com.moham.coursemores.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.when;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLocation;
import com.moham.coursemores.domain.Interest;
import com.moham.coursemores.domain.Region;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.repository.InterestRepository;
import com.moham.coursemores.service.impl.InterestServiceImp;
import java.util.ArrayList;
import java.util.List;
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

}