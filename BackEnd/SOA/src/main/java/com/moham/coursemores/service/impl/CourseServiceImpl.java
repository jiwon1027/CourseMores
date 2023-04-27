package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.*;
import com.moham.coursemores.dto.course.*;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.repository.*;
import com.moham.coursemores.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final CourseLocationRepository courseLocationRepository;
    private final CourseLocationImageRepository courseLocationImageRepository;
    private final RegionRepository regionRepository;
    private final HashtagRepository hashtagRepository;
    private final HashtagOfCourseRepository hashtagOfCourseRepository;
    private final ThemeRepository themeRepository;
    private final ThemeOfCourseRepository themeOfCourseRepository;

    @Override
    @Transactional
    public void increaseViewCount(int courseId) {
        // 코스 정보 가져오기
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));
        // 코스 조회수 증가
        course.increaseViewCount();
    }

    @Override
    public CourseInfoResDto getCourseInfo(int courseId) {
        // 코스 정보 가져오기
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(()->new RuntimeException("해당 코스를 찾을 수 없습니다."));
        // 코스 해시태그 이름 가져오기
        List<String> hashtagList = hashtagOfCourseRepository.findByCourseId(courseId)
                .stream()
                .map(hashtagOfCourse -> hashtagOfCourse.getHashtag().getName())
                .collect(Collectors.toList());
        // 코스 테마 id 가져오기
        List<Integer> themeIdList = themeOfCourseRepository.findByCourseId(courseId)
                .stream()
                .map(themeOfCourse -> themeOfCourse.getTheme().getId())
                .collect(Collectors.toList());
        // 코스 작성자 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(course.getUser().getId())
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        // 코스 정보 반환
        return CourseInfoResDto.builder()
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
    }

    @Override
    public List<CourseDetailResDto> getCourseDetail(int courseId) {
        // 해당 코스가 존재하는지 확인
        if(!courseRepository.existsByIdAndDeleteTimeIsNull(courseId))
            throw new RuntimeException("해당 코스를 찾을 수 없습니다.");
        // 코스 정보 반환
        return courseLocationRepository.findByCourseId(courseId)
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
    }

    @Override
    public List<MyCourseResDto> getMyCourseList(int userId) {
        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        // 내 코스 목록 list 생성
        List<MyCourseResDto> myCourseResDtoList = new ArrayList<>();
        // 유저의 코스들을 Dto로 가공하여 list에 담기
        user.getCourseList().forEach(course -> {
            // 삭제한 코스인지 확인
            if(course.getDeleteTime()!=null) return;
            // 코스의 첫번째 지역
            CourseLocation firstCourseLocation = course.getCourseLocationList().get(0);
            // 코스를 Dto로 가공하기
            myCourseResDtoList.add(MyCourseResDto.builder()
                    .courseId(course.getId())
                    .title(course.getTitle())
                    .content(course.getContent())
                    .people(course.getPeople())
                    .visited(course.isVisited())
                    .likeCount(course.getLikeCount())
                    .mainImage(course.getMainImage())
                    .sido(firstCourseLocation.getRegion().getSido())
                    .gugun(firstCourseLocation.getRegion().getGugun())
                    .locationName(firstCourseLocation.getName())
                    .commentCount(course.getCommentList().size())
                    .build());
            });
        // 내 코스 목록 반환
        return myCourseResDtoList;
    }

    @Override
    @Transactional
    public void addCourse(int userId, CourseCreateReqDto courseCreateReqDto) {
        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        // 코스 생성
        Course course = courseRepository.save(Course.builder()
                .title(courseCreateReqDto.getTitle())
                .content(courseCreateReqDto.getContent())
                .people(courseCreateReqDto.getPeople())
                .time(courseCreateReqDto.getTime())
                .visited(courseCreateReqDto.isVisited())
                .viewCount(0)
                .interestCount(0)
                .likeCount(0)
                .mainImage(courseCreateReqDto.getLocationList().get(0).getImageList().get(0))
                .user(user)
                .build());
        // 코스의 테마 생성
        courseCreateReqDto.getThemeIdList().forEach(themeId -> {
            // 테마 정보 가져오기
            Theme theme = themeRepository.findById(themeId)
                            .orElseThrow(() -> new RuntimeException("해당 테마를 찾을 수 없습니다."));
            // 코스의 테마 저장
            themeOfCourseRepository.save(ThemeOfCourse.builder()
                    .course(course)
                    .theme(theme)
                    .build());
        });
        // 코스의 해시태그 생성
        courseCreateReqDto.getHashtagList().forEach(hashtagName ->{
            Optional<Hashtag> hashtag = hashtagRepository.findByName(hashtagName);
            // 해시태그가 이미 존재한다면
            if(hashtag.isPresent()){
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(hashtag.get())
                        .build());
            }
            // 해시태그가 없다면
            else{
                // 해시태그를 생성하고
                Hashtag newHashtag = hashtagRepository.save(Hashtag.builder()
                        .name(hashtagName)
                        .build());
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(newHashtag)
                        .build());
            }
        });
        // 코스의 장소 정보 생성
        courseCreateReqDto.getLocationList().forEach(location -> {
            // 코스의 장소의 지역 가져오기
            Region region = regionRepository.findById(location.getRegionId())
                    .orElseThrow(() -> new RuntimeException("해당 지역을 찾을 수 없습니다."));
            // 코스의 장소 저장
            CourseLocation courseLocation = courseLocationRepository.save(CourseLocation.builder()
                            .latitude(location.getLatitude())
                            .longitude(location.getLongitude())
                            .content(location.getContent())
                            .name(location.getName())
                            .course(course)
                            .region(region)
                    .build());
            // 코스의 장소의 이미지 생성
            location.getImageList().forEach(image -> courseLocationImageRepository.save(CourseLocationImage.builder()
                            .image(image)
                            .courseLocation(courseLocation)
                    .build()));
        });
    }

    @Override
    @Transactional
    public void setCourse(int userId, int courseId, CourseUpdateReqDto courseUpdateReqDto) {
        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        // 코스 정보 가져오기
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));
        // 코스 정보 수정하기
        course.update(courseUpdateReqDto);
        // 기존 해시태그 지우기
        hashtagOfCourseRepository.deleteByCourseId(courseId);
        // 코스 해시태그 생성하기
        courseUpdateReqDto.getHashtagList().forEach(hashtag -> {
            Optional<Hashtag> beforeHashtag = hashtagRepository.findByName(hashtag);
            // 해시태그가 이미 존재한다면
            if(beforeHashtag.isPresent()){
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(beforeHashtag.get())
                        .build());
            }
            // 해시태그가 없다면
            else{
                // 해시태그를 생성하고
                Hashtag newHashtag = hashtagRepository.save(Hashtag.builder()
                        .name(hashtag)
                        .build());
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(newHashtag)
                        .build());
            }
        });
        // 기존 테마 지우기
        themeOfCourseRepository.deleteByCourseId(courseId);
        // 코스의 테마 생성
        courseUpdateReqDto.getThemeIdList().forEach(themeId -> {
            // 테마 정보 가져오기
            Theme theme = themeRepository.findById(themeId)
                    .orElseThrow(() -> new RuntimeException("해당 테마를 찾을 수 없습니다."));
            // 코스의 테마 저장
            themeOfCourseRepository.save(ThemeOfCourse.builder()
                    .course(course)
                    .theme(theme)
                    .build());
        });
        // 코스 장소와 장소의 이미지 수정하기
        courseUpdateReqDto.getLocationList().forEach(updateCourseLocation -> {
            // 코스 장소 불러오기
            CourseLocation courseLocation = courseLocationRepository.findById(updateCourseLocation.getCourseLocationId())
                    .orElseThrow(() -> new RuntimeException("해당 장소를 찾을 수 없습니다."));
            // 코스 장소 수정하기
            courseLocation.update(updateCourseLocation);
            // 기존 코스 장소 이미지 지우기
            courseLocationImageRepository.deleteByCourseLocationId(courseLocation.getId());
            // 코스 장소 이미지 생성
            updateCourseLocation.getImageList().forEach(image -> {
                courseLocationImageRepository.save(CourseLocationImage.builder()
                        .courseLocation(courseLocation)
                        .image(image)
                        .build());
            });
        });
    }

    @Override
    @Transactional
    public void deleteCourse(int userId, int courseId) {
        // 유저 찾기
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        // 코스 찾기
        Course course = courseRepository.findByIdAndUserId(courseId,user.getId())
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));
        // 코스 삭제
        course.delete();
    }
}
