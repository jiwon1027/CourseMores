package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLocation;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.repository.*;
import com.moham.coursemores.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final CourseLocationRepository courseLocationRepository;
    private final CourseHashtagRepository courseHashtagRepository;
    private final ThemeOfCourseRepository themeOfCourseRepository;

    @Override
    public CourseInfoResDto getCourseInfo(int courseId) throws Exception {
        // 코스 정보 가져오기
        Course course = courseRepository.findById(courseId)
                .orElseThrow(()->new RuntimeException("해당 코스를 찾을 수 없습니다"));
        // 코스 해시태그 이름 가져오기
        List<String> hashtagList = courseHashtagRepository.findByCourseId(courseId)
                .stream()
                .map(hashtag -> hashtag.getName())
                .collect(Collectors.toList());
        // 코스 테마 id 가져오기
        List<Integer> themeIdList = themeOfCourseRepository.findByCourseId(courseId)
                .stream()
                .map(theme -> theme.getId())
                .collect(Collectors.toList());
        // 코스 작성자 정보 가져오기
        User user = userRepository.findById(course.getUser().getId())
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        // req 담기
        CourseInfoResDto courseInfoResDto = CourseInfoResDto.builder()
                .title(course.getTitle())
                .content(course.getContent())
                .people(course.getPeople())
                .time(course.getTime())
                .visited(course.isVisited())
                .viewCount(course.getViewCount())
                .likeCount(course.getLikeCount())
                .interestCount(course.getInterestCount())
                .mainImage(course.getMainImage())
                .hashtagList(hashtagList)
                .themeIdList(themeIdList)
                .simpleInfoOfWriter(UserSimpleInfoResDto.builder()
                        .nickname(user.getNickname())
                        .profileImage(user.getProfileImage())
                        .build())
            .build();

        return courseInfoResDto;
    }

    @Override
    public List<CourseDetailResDto> getCourseDetail(int courseId) throws Exception {
        // 코스 지역 정보 가져오기
        List<CourseDetailResDto> courseDetailResDtoList = courseLocationRepository.findByCourseId(courseId)
                .stream()
                .map(courseLocation -> CourseDetailResDto.builder()
                        .name(courseLocation.getName())
                        .content(courseLocation.getContent())
                        .latitude(courseLocation.getLatitude())
                        .longitude(courseLocation.getLongitude())
                        .sido(courseLocation.getRegion().getSido())
                        .gugun(courseLocation.getRegion().getGugun())
                        .locationImage(courseLocation.getCourseLocationImageList()
                                .stream()
                                .map(courseLocationImage->courseLocationImage.getImage())
                                .collect(Collectors.toList())
                        )
                        .build()
                )
                .collect(Collectors.toList());

        return courseDetailResDtoList;
    }
}
