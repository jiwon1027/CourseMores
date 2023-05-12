package com.moham.coursemores.api;

import com.moham.coursemores.dto.course.CourseCreateReqDto;
import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseImportResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.dto.course.CoursePreviewResDto;
import com.moham.coursemores.dto.course.CourseUpdateReqDto;
import com.moham.coursemores.dto.course.HotPreviewResDto;
import com.moham.coursemores.dto.course.MyCourseResDto;
import com.moham.coursemores.dto.course.NearPreviewResDto;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.service.CourseService;
import com.moham.coursemores.service.ElasticSearchService;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("course")
@RequiredArgsConstructor
public class CourseController {

    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

    private final CourseService courseService;
    private final ElasticSearchService elasticSearchService;

    @GetMapping("hot")
    public ResponseEntity<Map<String, Object>> getHotCourse() {
        logger.debug("[0/2][GET][/course/hot] << request : none");

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/hot]... cs.getHotCourseList");
        List<HotPreviewResDto> courseList = courseService.getHotCourseList();
        resultMap.put("courseList", courseList);

        logger.debug("[2/2][GET][/course/hot] >> response : courseList\n courseList = {}\n", courseList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("hot/calculation")
    public ResponseEntity<Void> setHotCourse() {
        logger.debug("[0/2][GET][/course/hot/calculation] << request: none");

        logger.debug("[1/2][GET][/course/hot/calculation] ... cs.setHotCourse");
        courseService.setHotCourse();

        logger.debug("[2/2][GET][/course/hot/calculation] >> response : none\n");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("around")
    public ResponseEntity<Map<String, Object>> aroundCourse(
            @RequestParam double latitude,
            @RequestParam double longitude) {
        logger.debug("[0/2][GET][/course/around] << request : latitude, longitude\n latitude = {}\n\n longitude = {}", latitude, longitude);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/around] ... cd.getCoursesNearby");
        List<NearPreviewResDto> courseList = courseService.getCoursesNearby(latitude, longitude);
        resultMap.put("courseList", courseList);

        // 몇 개 보낼지 변수를 만들어야 할듯
        logger.debug("[2/2][GET][/course/around] >> response : courseList, distance\n courseList = {}\n distance = {}\n", courseList, 5);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("search")
    public ResponseEntity<Map<String, Object>> searchCourse(
            @RequestParam(required = false) String word,
            @RequestParam Long regionId,
            @RequestParam(required = false) List<Long> themeIds,
            @RequestParam int isVisited,
            @RequestParam int page,
            @RequestParam String sortby,
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug(
                "[0/2][GET][/course/search][{}] << request : word, regionId, themeIds, isVisited, page, sortby\n word = {}\n regionId = {}\n themeIds = {}\n isVisited = {}\n page = {}\n sortby = {}",
                userId, word, regionId, themeIds, isVisited, page, sortby);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/search][{}] ... cd.search", userId);
        Page<CoursePreviewResDto> pageCourse = courseService.search(userId, word, regionId, themeIds, isVisited, page, sortby);
        resultMap.put("courseList", pageCourse.getContent());
        resultMap.put("isFirst", pageCourse.isFirst());
        resultMap.put("isLast", pageCourse.isLast());

        logger.debug("[2/2][GET][/course/search][{}] >> response : courseList, isFirst, isLast\n courseList = {}\n isFirst = {}\n isLast = {}\n",
                userId, pageCourse.getContent(), pageCourse.isFirst(), pageCourse.isLast());
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("info/{courseId}")
    public ResponseEntity<Map<String, Object>> getCourseInfo(
            @PathVariable Long courseId,
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/3][GET][/course/info/{}][{}] << request : none", courseId, userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/3][GET][/course/info/{}][{}] ... cs.increaseViewCount", courseId, userId);
        courseService.increaseViewCount(courseId);

        logger.debug("[2/3][GET][/course/info/{}][{}] ... cs.getCourseInfo", courseId, userId);
        CourseInfoResDto courseInfoResDto = courseService.getCourseInfo(courseId, userId);
        resultMap.put("courseInfo", courseInfoResDto);

        logger.debug("[3/3][GET][/course/info/{}][{}] >> response : courseInfo\n courseInfo = {}\n", courseId, userId, courseInfoResDto);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("detail/{courseId}")
    public ResponseEntity<Map<String, Object>> getCourseDetail(
            @PathVariable Long courseId) {
        logger.debug("[0/2][GET][/course/detail/{}] << request : none", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/detail/{}] ... cs.getCourseDetail", courseId);
        List<CourseDetailResDto> courseDetailResDtoList = courseService.getCourseDetail(courseId);
        resultMap.put("courseDetailList", courseDetailResDtoList);

        logger.debug("[2/2][GET][/course/detail/{}] >> response : courseDetailList\n courseDetailList = {}\n", courseId, courseDetailResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("my")
    public ResponseEntity<Map<String, Object>> getMyCourseList(
            @AuthenticationPrincipal User user) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/2][GET][/course/my][{}] << request :none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/my][{}] ... cd.getMyCourseList", userId);
        List<MyCourseResDto> myCourseResDtoList = courseService.getMyCourseList(userId);
        resultMap.put("myCourseList", myCourseResDtoList);

        logger.debug("[2/2][GET][/course/my][{}] >> response : myCourseList\n myCourseList = {}\n", userId, myCourseResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{courseId}")
    public ResponseEntity<Map<String, Object>> importCourse(
            @PathVariable Long courseId) {
        logger.debug("[0/2][GET][/course/{}] << request : none", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/course/{}] ... cs.importCourse", courseId);
        List<CourseImportResDto> courseImportResDtoList = courseService.importCourse(courseId);
        resultMap.put("courseImportList ", courseImportResDtoList);

        logger.debug("[2/2][GET][/course/{}] >> response : courseImportList\n courseImportList = {}\n", courseId, courseImportResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<Void> addCourse(
            @AuthenticationPrincipal User user,
            @RequestPart CourseCreateReqDto courseCreateReqDto,
            @RequestPart(required = false) List<MultipartFile> imageList) {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/3][POST][/course][{}] << request : courseCreateReqDto, imageList\n courseCreateReqDto = {}\n imageList = {}",
                userId, courseCreateReqDto, imageList);

        logger.debug("[1/3][POST][/course][{}] ... cd.addCourse", userId);
        Long courseId = courseService.addCourse(userId, courseCreateReqDto, imageList);

        logger.debug("[2/3][POST][/course][{}] ... ess.addIndex", userId);
        // elasticsearch index 데이터 추가
        elasticSearchService.addIndex(IndexDataReqDTO.builder()
                .id(Long.toString(courseId))
                .title(courseCreateReqDto.getTitle())
                .courselocationList(courseCreateReqDto.getLocationList()
                        .stream()
                        .map(locationCreateReqDto -> locationCreateReqDto.getName())
                        .collect(Collectors.toList()))
                .hashtagList(courseCreateReqDto.getHashtagList())
                .build());

        logger.debug("[3/3][POST][/course][{}] >> response : none\n", userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("{courseId}")
    public ResponseEntity<Void> setCourse(
            @PathVariable Long courseId,
            @RequestPart CourseUpdateReqDto courseUpdateReqDto,
            @RequestPart(required = false) List<MultipartFile> imageList,
            @AuthenticationPrincipal User user) throws IOException {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/3][PUT][/course/{}][{}] << request : courseUpdateReqDto, imageList\n courseUpdateReqDto = {}\n imageList = {}",
                courseId, userId, courseUpdateReqDto, imageList);

        logger.debug("[1/3][PUT][/course/{}][{}] ... cs.setCourse", courseId, userId);
        courseService.setCourse(userId, courseId, courseUpdateReqDto, imageList);

        logger.debug("[2/3][PUT][/course/{}][{}] ... ess.updateIndex", courseId, userId);
        // elasticsearch index 데이터 수정
        elasticSearchService.updateIndex(IndexDataReqDTO.builder()
                .id(Long.toString(courseId))
                .title(courseUpdateReqDto.getTitle())
                .courselocationList(courseUpdateReqDto.getLocationList()
                        .stream()
                        .map(locationUpdateReqDto -> locationUpdateReqDto.getName())
                        .collect(Collectors.toList()))
                .hashtagList(courseUpdateReqDto.getHashtagList())
                .build());

        logger.debug("[3/3][PUT][/course/{}][{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("{courseId}")
    public ResponseEntity<Void> deleteCourse(
            @PathVariable Long courseId,
            @AuthenticationPrincipal User user) throws IOException {
        Long userId = Long.parseLong(user.getUsername());
        logger.debug("[0/3][DELETE][/course/{}][{}] << request : none", courseId, userId);

        logger.debug("[1/3][DELETE][/course/{}][{}] ... cs.deleteCourse", courseId, userId);
        courseService.deleteCourse(userId, courseId);

        logger.debug("[2/3][DELETE][/course/{}][{}] ... ess.deleteIndex", courseId, userId);
        elasticSearchService.deleteIndex(Long.toString(courseId));

        logger.debug("[3/3][DELETE][/course/{}][{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}