package com.moham.coursemores.service;

import com.moham.coursemores.domain.*;
import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.dto.profile.UserInfoUpdateReqDto;
import com.moham.coursemores.repository.*;
import com.moham.coursemores.service.impl.CourseServiceImpl;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@ExtendWith(MockitoExtension.class)
public class CourseServiceJUnitTest {
    @InjectMocks
    CourseServiceImpl courseService;

    @Mock
    CourseRepository courseRepository;
    @Mock
    UserRepository userRepository;
    @Mock
    CourseLocationRepository courseLocationRepository;
    @Mock
    CourseLocationImageRepository courseLocationImageRepository;
    @Mock
    RegionRepository regionRepository;
    @Mock
    HashtagRepository hashtagRepository;
    @Mock
    HashtagOfCourseRepository hashtagOfCourseRepository;
    @Mock
    ThemeRepository themeRepository;
    @Mock
    ThemeOfCourseRepository themeOfCourseRepository;

    @Mock
    Region region;

    final int HOC_LIST_SIZE = 2;
    final int TOC_LIST_SIZE = 3;
    final int COURSE_LOCATION_LIST_SIZE = 3;
    final int COURSE_ID = 1;
    final int USER_ID = 1;

    // 유저 정보
    String email, roles, provider, providerId, gender, nickname, profileImage;
    int age;
    // 코스 정보
    String title, content, mainImage;
    int time, people, viewCount, interestCount, likeCount;
    boolean visited;
    // 코스 장소 정보
    String locationName, locationContent;
    double latitude, longitude;

    @Nested
    @DisplayName("코스 소개 조회")
    class 코스_소개_조회{

        @BeforeEach
        void 초기_세팅(){

            // 테스트 유저
            nickname = "test nickname";
            profileImage = "test profile image";

            // 테스트 코스
            title = "test title";
            time = 30;
            visited = true;
            people = 4;
            content = "test content";
            mainImage = "test main image";
            viewCount = 25;
            likeCount = 13;
            interestCount = 10;
        }

        @Test
        @DisplayName("정상 작동")
        void 정상_작동() {
            // given
            // 테스트 유저 세팅
            User user = User.builder().build();
            user.update(UserInfoUpdateReqDto.builder()
                    .nickname(nickname)
                    .profileImage(profileImage)
                    .build());

            when(userRepository.findByIdAndDeleteTimeIsNull(any(Integer.class))).thenReturn(Optional.of(user));

            // 테스트 코스 세팅
            Course course = Course.builder()
                    .title(title)
                    .time(time)
                    .visited(visited)
                    .people(people)
                    .content(content)
                    .mainImage(mainImage)
                    .likeCount(likeCount)
                    .interestCount(interestCount)
                    .viewCount(viewCount)
                    .user(user)
                    .build();

            when(courseRepository.findByIdAndDeleteTimeIsNull(COURSE_ID)).thenReturn(Optional.of(course));

            // 테스트 코스 해시태그 세팅
            List<HashtagOfCourse> hashtagOfCourseList = new ArrayList<>();
            for (int i=0;i<HOC_LIST_SIZE;i++) {
                hashtagOfCourseList.add(HashtagOfCourse.builder()
                        .hashtag(Hashtag.builder().build())
                        .course(course).build());
            }
            when(hashtagOfCourseRepository.findByCourseId(COURSE_ID)).thenReturn(hashtagOfCourseList);

            // 테스트 코스 테마 세팅
            List<ThemeOfCourse> themeOfCourseList = new ArrayList<>();
            for (int i=0;i<TOC_LIST_SIZE;i++){
                themeOfCourseList.add(ThemeOfCourse.builder()
                        .theme(Theme.builder().build())
                        .course(course)
                        .build());
            }
            when(themeOfCourseRepository.findByCourseId(COURSE_ID)).thenReturn(themeOfCourseList);

            // when
            CourseInfoResDto courseInfoResDto = courseService.getCourseInfo(COURSE_ID);

            // then
            assertThat(courseInfoResDto.getTitle()).isEqualTo(title);
            assertThat(courseInfoResDto.isVisited()).isEqualTo(visited);
            assertThat(courseInfoResDto.getMainImage()).isEqualTo(mainImage);
            assertThat(courseInfoResDto.getContent()).isEqualTo(content);
            assertThat(courseInfoResDto.getPeople()).isEqualTo(people);
            assertThat(courseInfoResDto.getTime()).isEqualTo(time);
            assertThat(courseInfoResDto.getLikeCount()).isEqualTo(likeCount);
            assertThat(courseInfoResDto.getViewCount()).isEqualTo(viewCount);
            assertThat(courseInfoResDto.getInterestCount()).isEqualTo(interestCount);
            assertThat(courseInfoResDto.getHashtagList().size()).isEqualTo(HOC_LIST_SIZE);
            assertThat(courseInfoResDto.getThemeIdList().size()).isEqualTo(TOC_LIST_SIZE);
            assertThat(courseInfoResDto.getSimpleInfoOfWriter().getNickname()).isEqualTo(nickname);
            assertThat(courseInfoResDto.getSimpleInfoOfWriter().getProfileImage()).isEqualTo(profileImage);
        }

    }

    @Nested
    @DisplayName("코스 상세 정보 조회")
    class 코스_상세_정보_조회{

        @BeforeEach
        void 초기_세팅(){
            // 테스트 코스
            title = "test title";
            time = 30;
            visited = true;
            people = 4;
            content = "test content";
            mainImage = "test main image";
            viewCount = 25;
            likeCount = 13;
            interestCount = 10;
        }

        @Test
        @DisplayName("정상 작동")
        void 정상_작동(){
            // given
//            when(courseRepository.existsByIdAndDeleteTimeIsNull(COURSE_ID)).thenReturn(true);
//            when(regionRepository.findById(any(Integer.class))).thenReturn(Optional.of(Region.builder().sido("test sido").gugun("test gugun").build()));
//            when(region.getId()).thenReturn();
////            when(courseLocationImageRepository.findByCourseLocationId())
//            List<CourseLocation> courseLocationList = new ArrayList<>();
//            for(int i=0;i<COURSE_LOCATION_LIST_SIZE;i++){
//                courseLocationList.add(CourseLocation.builder().build());
//            }
//            when(courseLocationRepository.findByCourseId(COURSE_ID)).thenReturn(courseLocationList);
//
//            // when
//            List<CourseDetailResDto> courseDetailResDtoList = courseService.getCourseDetail(COURSE_ID);
//
//            // then
//            assertThat(courseDetailResDtoList.size()).isEqualTo(COURSE_LOCATION_LIST_SIZE);
        }
    }


}
