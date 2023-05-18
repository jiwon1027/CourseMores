package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.exception.CustomErrorCode;
import com.moham.coursemores.common.exception.CustomException;
import com.moham.coursemores.domain.*;
import com.moham.coursemores.dto.course.*;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.dto.theme.ThemeResDto;
import com.moham.coursemores.repository.*;
import com.moham.coursemores.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final HotCourseRepository hotCourseRepository;
    private final UserRepository userRepository;
    private final CourseLocationRepository courseLocationRepository;
    private final CourseLocationImageRepository courseLocationImageRepository;
    private final FileUploadService fileUploadService;
    private final RegionRepository regionRepository;
    private final HashtagRepository hashtagRepository;
    private final HashtagOfCourseRepository hashtagOfCourseRepository;
    private final ThemeRepository themeRepository;
    private final ThemeOfCourseRepository themeOfCourseRepository;
    private final InterestRepository interestRepository;
    private final CourseLikeRepository courseLikeRepository;
    private final CommentRepository commentRepository;

    private static final String ALL = "전체";
    private static final String DEFAULT_NICKNAME = "(알 수 없음)";
    private static final String DEFAULT_IMAGE_URL = "https://coursemores.s3.amazonaws.com/default_profile.png";

    @Override
    public List<HotPreviewResDto> getHotCourseList() {
        // 한 번에 넘길 인기 코스의 수
        int number = 10;
        return hotCourseRepository.findRandomHotCourse(number).stream()
                .map(hotCourse -> {
                            Course course = hotCourse.getCourse();
                            return HotPreviewResDto.builder()
                                    .courseId(course.getId())
                                    .title(course.getTitle())
                                    .content(course.getContent())
                                    .image(course.getImage())
                                    .sido(ALL.equals(course.getSido()) ? "대한민국" : course.getSido())
                                    .gugun(ALL.equals(course.getGugun()) ? "" : course.getGugun())
                                    .build();
                        }
                ).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void setHotCourse() {
        LocalDateTime standardTime = LocalDateTime.now().minusWeeks(1); // 인기도의 기간
        List<Comment> comments = commentRepository.findByDeleteTimeIsNullAndCreateTimeAfter(standardTime); // 기간 동안 댓글 목록
        List<Interest> interests = interestRepository.findByFlagIsTrueAndRegisterTimeAfter(standardTime); // 기간 동안 관심 목록
        List<CourseLike> courseLikes = courseLikeRepository.findByFlagIsTrueAndRegisterTimeAfter(standardTime); // 기간 동안 좋아요 목록

        Map<Course, Long> map = comments.stream()
                .collect(Collectors.groupingBy(Comment::getCourse, Collectors.counting()));
        interests.forEach(interest -> {
            Course course = interest.getCourse();
            long cnt = map.getOrDefault(course, 0L);
            map.put(course, ++cnt);
        });
        courseLikes.forEach(courseLike -> {
            Course course = courseLike.getCourse();
            long cnt = map.getOrDefault(course, 0L);
            map.put(course, ++cnt);
        });

        hotCourseRepository.deleteAllInBatch(); // 기존의 인기 코스들은 삭제
        List<Course> hotCourses = map.keySet().stream()
                .sorted((o1, o2) -> (map.get(o1).equals(map.get(o2))) ? Long.compare(o2.getId(), o1.getId()) : Long.compare(map.get(o2), map.get(o1)))
                .collect(Collectors.toList());

        int number = 50; // 인기 코스로 저장할 최대 개수
        for (Course course : hotCourses) {
            hotCourseRepository.save(HotCourse.builder()
                    .course(course)
                    .build());

            if (--number == 0)
                break;
        }
    }

    @Override
    public List<NearPreviewResDto> getCoursesNearby(double latitude, double longitude) {
        Pageable pageable = PageRequest.of(0, 10);
        return courseRepository.findTop5CoursesByLocation(latitude, longitude, pageable);
    }

    @Override
    public Page<CoursePreviewResDto> search(Long userId, String word, Long regionId, List<Long> themeIds, int isVisited, int page, String sortby) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId, CustomErrorCode.USER_NOT_FOUND));

        // 한 페이지에 보여줄 코스의 수
        final int size = 10;

        // Sort 정렬 기준
        Sort sort = (sortby == null || "latest".equals(sortby)) ?
                Sort.by("createTime").descending() :
                Sort.by("likeCount").descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<Course> pageCourse = courseRepository.searchAll(word, regionId, themeIds, isVisited, pageable);

        List<Long> userLikeCourse = user.getCourseLikeList()
                .stream()
                .map(like -> like.isFlag() ? like.getCourse().getId() : null)
                .collect(Collectors.toList());

        return pageCourse
                .map(course -> {
                    boolean isInterest = false;
                    for (Interest interest : course.getInterestList()) {
                        if (Objects.equals(interest.getUser().getId(), user.getId())) {
                            isInterest = interest.isFlag();
                            break;
                        }
                    }

                    return CoursePreviewResDto.builder()
                            .courseId(course.getId())
                            .title(course.getTitle())
                            .content(course.getContent())
                            .people(course.getPeople())
                            .visited(course.isVisited())
                            .likeCount(course.getLikeCount())
                            .commentCount(course.getCommentCount())
                            .image(course.getImage())
                            .sido(ALL.equals(course.getSido()) ? "대한민국" : course.getSido())
                            .gugun(ALL.equals(course.getGugun()) ? "" : course.getGugun())
                            .locationName(course.getLocationName() + " 외 " + (course.getLocationSize() - 1) + "곳")
                            .isInterest(isInterest)
                            .isLike(userLikeCourse.contains(course.getId()))
                            .build();
                });
    }

    @Override
    @Transactional
    public void increaseViewCount(Long courseId) {
        // 코스 정보 가져오기
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND));
        // 코스 조회수 증가
        course.increaseViewCount();
    }

    @Override
    public CourseInfoResDto getCourseInfo(Long courseId, Long userId) {
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
        // 코스 정보 가져오기
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND));

        return CourseInfoResDto.builder()
                .title(course.getTitle())
                .content(course.getContent())
                .people(course.getPeople())
                .time(course.getTime())
                .visited(course.isVisited())
                .viewCount(course.getViewCount())
                .likeCount(course.getLikeCount())
                .interestCount(course.getInterestCount())
                .commentCount(course.getCommentCount())
                .sido(ALL.equals(course.getSido()) ? "대한민국" : course.getSido())
                .gugun(ALL.equals(course.getGugun()) ? "" : course.getGugun())
                .createTime(course.getCreateTime())
                .hashtagList(course.getCourseHashtagList()
                        .stream()
                        .map(o -> o.getHashtag().getName())
                        .collect(Collectors.toList()))
                .themeList(course.getThemeOfCourseList()
                        .stream()
                        .map(o -> ThemeResDto.builder()
                                .themeId(o.getTheme().getId())
                                .name(o.getTheme().getName())
                                .build())
                        .collect(Collectors.toList()))
                .simpleInfoOfWriter(UserSimpleInfoResDto.builder()
                        .nickname(course.getUser().getDeleteTime() != null ? DEFAULT_NICKNAME : course.getUser().getNickname())
                        .profileImage(course.getUser().getDeleteTime() != null ? DEFAULT_IMAGE_URL : course.getUser().getProfileImage())
                        .build())
                .isWrite(Objects.equals(course.getUser().getId(), user.getId()))
                .build();
    }

    @Override
    public List<CourseDetailResDto> getCourseDetail(Long courseId) {
        // 해당 코스가 존재하는지 확인
        if (!courseRepository.existsByIdAndDeleteTimeIsNull(courseId))
            throw new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND);
        // 코스 정보 반환
        return courseLocationRepository.findByCourseId(courseId)
                .stream()
                .map(courseLocation -> CourseDetailResDto.builder()
                        .courseLocationId(courseLocation.getId())
                        .name(courseLocation.getName())
                        .title(courseLocation.getTitle())
                        .content(courseLocation.getContent())
                        .latitude(courseLocation.getLatitude())
                        .longitude(courseLocation.getLongitude())
                        .sido(ALL.equals(courseLocation.getRegion().getSido()) ? "대한민국" : courseLocation.getRegion().getSido())
                        .gugun(ALL.equals(courseLocation.getRegion().getGugun()) ? "" : courseLocation.getRegion().getGugun())
                        .roadViewImage(courseLocation.getRoadViewImage())
                        .locationImageList(courseLocation.getCourseLocationImageList()
                                .stream()
                                .map(CourseLocationImage::getImage)
                                .collect(Collectors.toList())
                        )
                        .build()
                )
                .collect(Collectors.toList());
    }

    @Override
    public List<CourseImportResDto> importCourse(Long courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND))
                .getCourseLocationList()
                .stream()
                .map(location -> CourseImportResDto.builder()
                        .name(location.getName())
                        .longitude(location.getLongitude())
                        .latitude(location.getLatitude())
                        .sido(ALL.equals(location.getRegion().getSido()) ? "대한민국" : location.getRegion().getSido())
                        .gugun(ALL.equals(location.getRegion().getGugun()) ? "" : location.getRegion().getGugun())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    public List<MyCourseResDto> getMyCourseList(Long userId) {
        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));

        // 유저의 코스들을 Dto로 가공하여 list에 담기
        return user.getCourseList()
                .stream()
                .map(course -> {
                    // 삭제한 코스인지 확인
                    if (course.getDeleteTime() != null)
                        return null;
                    // 코스를 Dto로 가공하기
                    return MyCourseResDto.builder()
                            .courseId(course.getId())
                            .title(course.getTitle())
                            .content(course.getContent())
                            .people(course.getPeople())
                            .visited(course.isVisited())
                            .likeCount(course.getLikeCount())
                            .image(course.getImage())
                            .sido(ALL.equals(course.getSido()) ? "대한민국" : course.getSido())
                            .gugun(ALL.equals(course.getGugun()) ? "" : course.getGugun())
                            .locationName(course.getLocationName() + " 외 " + (course.getLocationSize() - 1) + "곳")
                            .commentCount(course.getCommentCount())
                            .build();
                })
                .sorted((o1, o2) -> Long.compare(o2.getCourseId(), Objects.requireNonNull(o1).getCourseId()))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Long addCourse(Long userId, CourseCreateReqDto courseCreateReqDto, List<MultipartFile> imageList) {

        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
        LocationCreateReqDto firstLocation = courseCreateReqDto.getLocationList().get(0);
        // 코스 생성
        Course course = courseRepository.save(Course.builder()
                .title(courseCreateReqDto.getTitle())
                .content(courseCreateReqDto.getContent())
                .people(courseCreateReqDto.getPeople())
                .time(courseCreateReqDto.getTime())
                .visited(courseCreateReqDto.getVisited())
                .viewCount(0)
                .interestCount(0)
                .likeCount(0)
                .commentCount(0)
                .image(firstLocation.getRoadViewImage())
                .locationName(firstLocation.getName())
                .locationSize(courseCreateReqDto.getLocationList().size())
                .sido(initSido(firstLocation.getSido()))
                .gugun(initGugun(firstLocation.getGugun()))
                .latitude(firstLocation.getLatitude())
                .longitude(firstLocation.getLongitude())
                .user(user)
                .build());

        // 코스의 테마 생성
        courseCreateReqDto.getThemeIdList().forEach(themeId -> {
            // 테마 정보 가져오기
            Theme theme = themeRepository.findById(themeId)
                    .orElseThrow(() -> new CustomException(themeId,CustomErrorCode.THEME_NOT_FOUND));
            // 코스의 테마 저장
            themeOfCourseRepository.save(ThemeOfCourse.builder()
                    .course(course)
                    .theme(theme)
                    .build());
        });
        // 코스의 해시태그 생성
        courseCreateReqDto.getHashtagList().forEach(hashtagName -> {
            Optional<Hashtag> hashtag = hashtagRepository.findByName(hashtagName);
            // 해시태그가 이미 존재한다면
            if (hashtag.isPresent()) {
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(hashtag.get())
                        .build());
            }
            // 해시태그가 없다면
            else {
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

        int imageIdx = 0;
        boolean isFirstImage = firstLocation.getNumberOfImage() != 0;
        // 코스의 장소 정보 생성
        for (LocationCreateReqDto location : courseCreateReqDto.getLocationList()) {
            // 코스의 장소의 지역 가져오기
            Region region = getRegion(initSido(location.getSido()), initGugun(location.getGugun()));

            // 코스의 장소 저장
            CourseLocation courseLocation = courseLocationRepository.save(CourseLocation.builder()
                    .name(location.getName())
                    .title(location.getTitle())
                    .content(location.getContent())
                    .roadViewImage(location.getRoadViewImage())
                    .latitude(location.getLatitude())
                    .longitude(location.getLongitude())
                    .course(course)
                    .region(region)
                    .build());

            // 코스의 장소의 이미지 생성
            for (int end = imageIdx + location.getNumberOfImage(); imageIdx < end; imageIdx++) {
                String imagePath = fileUploadService.uploadImage(imageList.get(imageIdx));
                // 코스의 대표 이미지 설정
                if (isFirstImage) {
                    course.setMainImage(imagePath);
                    isFirstImage = false;
                }
                courseLocationImageRepository.save(CourseLocationImage.builder()
                        .image(imagePath)
                        .courseLocation(courseLocation)
                        .build());
            }
        }

        return course.getId();
    }

    @Override
    @Transactional
    public void setCourse(Long userId, Long courseId, CourseUpdateReqDto courseUpdateReqDto, List<MultipartFile> imageList) {
        // 유저 정보 가져오기
        User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
        // 코스 정보 가져오기
        Course course = courseRepository.findByIdAndUserIdAndDeleteTimeIsNull(courseId, user.getId())
                .orElseThrow(() -> new CustomException(courseId,CustomErrorCode.COURSE_NOT_FOUND));
        // 코스 정보 수정하기
        course.update(courseUpdateReqDto);
        // 기존 해시태그 지우기
        hashtagOfCourseRepository.deleteByCourseId(courseId);
        // 코스 해시태그 생성하기
        courseUpdateReqDto.getHashtagList().forEach(hashtag -> {
            Optional<Hashtag> beforeHashtag = hashtagRepository.findByName(hashtag);
            // 해시태그가 이미 존재한다면
            if (beforeHashtag.isPresent()) {
                // 코스의 해시태그 생성
                hashtagOfCourseRepository.save(HashtagOfCourse.builder()
                        .course(course)
                        .hashtag(beforeHashtag.get())
                        .build());
            }
            // 해시태그가 없다면
            else {
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
                    .orElseThrow(() -> new CustomException(themeId,CustomErrorCode.THEME_NOT_FOUND));
            // 코스의 테마 저장
            themeOfCourseRepository.save(ThemeOfCourse.builder()
                    .course(course)
                    .theme(theme)
                    .build());
        });

        int imageIdx = 0;
        boolean isFirstImage = courseUpdateReqDto.getLocationList().get(0).getNumberOfImage() != 0;
        for (LocationUpdateReqDto updateCourseLocation : courseUpdateReqDto.getLocationList()) {
            // 코스 장소 불러오기
            CourseLocation courseLocation = courseLocationRepository.findById(updateCourseLocation.getCourseLocationId())
                    .orElseThrow(() -> new CustomException(updateCourseLocation.getCourseLocationId(),CustomErrorCode.COURSE_LOCATION_NOT_FOUND));
            // 코스 장소 수정하기
            courseLocation.update(updateCourseLocation);
            // 이미지 삭제
            if(updateCourseLocation.getIsUpdate()){
                courseLocationImageRepository.deleteByCourseLocationId(courseLocation.getId());
                // 코스의 장소 이미지 추가 생성
                for (int end = imageIdx + updateCourseLocation.getNumberOfImage(); imageIdx < end; imageIdx++) {
                    String imagePath = fileUploadService.uploadImage(imageList.get(imageIdx));
                    // 코스의 대표 이미지 설정
                    if (isFirstImage) {
                        course.setMainImage(imagePath);
                        isFirstImage = false;
                    }
                    courseLocationImageRepository.save(CourseLocationImage.builder()
                            .image(imagePath)
                            .courseLocation(courseLocation)
                            .build());
                }
            }
        }
    }

    @Override
    @Transactional
    public void deleteCourse(Long userId, Long courseId) {
        // 유저 찾기
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));
        // 코스 찾기
        Course course = courseRepository.findByIdAndUserId(courseId, user.getId())
                .orElseThrow(() -> new CustomException(courseId,userId,CustomErrorCode.COURSE_NOT_FOUND));
        // 코스 삭제
        course.delete();
    }

    private String initSido(String sido) {
        if(sido == null) return ALL;
        return regionRepository.existsBySido(sido.trim()) ? sido.trim() : ALL;
    }

    private String initGugun(String gugun) {
        if(gugun == null) return ALL;
        return regionRepository.existsByGugun(gugun.trim()) ? gugun.trim() : ALL;
    }

    private Region getRegion(String sido, String gugun) {
        if (ALL.equals(sido)) { // 시도 : 전체
            if (ALL.equals(gugun)) { // 구군 : 전체
                return regionRepository.findBySidoAndGugun(ALL, ALL)
                        .orElseThrow(() -> new CustomException(ALL,ALL,CustomErrorCode.REGION_NOT_FOUND));
            } else { // 구군 : 유효
                return regionRepository.findByGugun(gugun)
                        .orElseThrow(() -> new CustomException(gugun,CustomErrorCode.REGION_NOT_FOUND));
            }
        } else {// 시도 : 유효
            if (ALL.equals(gugun)) { // 구군 : 전체
                return regionRepository.findBySidoAndGugun(sido, ALL)
                        .orElseThrow(() -> new CustomException(sido,ALL,CustomErrorCode.REGION_NOT_FOUND));
            } else { // 구군 : 유효
                return regionRepository.findBySidoAndGugun(sido, gugun)
                        .orElseThrow(() -> new CustomException(sido,gugun,CustomErrorCode.REGION_NOT_FOUND));
            }
        }
    }

}