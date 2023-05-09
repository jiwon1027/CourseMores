package com.moham.coursemores.api;

import com.moham.coursemores.dto.course.*;
import com.moham.coursemores.dto.elasticsearch.IndexDataReqDTO;
import com.moham.coursemores.service.CourseService;
import com.moham.coursemores.service.ElasticSearchService;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
        logger.info("<< request: none");

        Map<String, Object> resultMap = new HashMap<>();

        List<MainPreviewResDto> courseList = courseService.getHotCourseList();
        resultMap.put("courseList", courseList);
        logger.info("<< response : courseLis={}", courseList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("search/{userId}")
    public ResponseEntity<Map<String, Object>> searchCourse(
            @PathVariable Long userId,
            @RequestParam(required = false) String word,
            @RequestParam(required = false) Long regionId,
            @RequestParam(required = false) List<Long> themeIds,
            @RequestParam int isVisited,
            @RequestParam int page,
            @RequestParam String sortby) {
        logger.info(">> request : userId={}",userId);
        logger.info(">> request : word={}",word);
        logger.info(">> request : regionId={}",regionId);
        logger.info(">> request : themeIds={}",themeIds);
        logger.info(">> request : isVisited={}",isVisited);
        logger.info(">> request : page={}",page);
        logger.info(">> request : sortby={}",sortby);

        Map<String, Object> resultMap = new HashMap<>();

        Page<CoursePreviewResDto> pageCourse = courseService.search(userId, word,regionId,themeIds,isVisited,page,sortby);
        resultMap.put("courseList", pageCourse.getContent());
        logger.info("<< response : courseList={}",pageCourse.getContent());
        resultMap.put("isFirst", pageCourse.isFirst());
        logger.info("<< response : isFirst={}",pageCourse.isFirst());
        resultMap.put("isLast", pageCourse.isLast());
        logger.info("<< response : isLast={}",pageCourse.isLast());

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("info/{courseId}")
    public ResponseEntity<Map<String, Object>> getCourseInfo(
            @PathVariable Long courseId) {
        logger.info(">> request : courseId={}",courseId);

        Map<String, Object> resultMap = new HashMap<>();

        courseService.increaseViewCount(courseId);
        CourseInfoResDto courseInfoResDto = courseService.getCourseInfo(courseId);
        resultMap.put("courseInfo", courseInfoResDto);
        logger.info("<< response : courseInfo={}", courseInfoResDto);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("detail/{courseId}")
    public ResponseEntity<Map<String, Object>> getCourseDetail(
            @PathVariable Long courseId) {
        logger.info(">> request : courseId={}",courseId);

        Map<String, Object> resultMap = new HashMap<>();

        List<CourseDetailResDto> courseDetailResDtoList = courseService.getCourseDetail(courseId);
        resultMap.put("courseDetailList", courseDetailResDtoList);
        logger.info("<< response : courseDetailList={}", courseDetailResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getMyCourseList(
            @PathVariable Long userId) {
        logger.info(">> request : userId={}",userId);

        Map<String, Object> resultMap = new HashMap<>();

        List<MyCourseResDto> myCourseResDtoList = courseService.getMyCourseList(userId);
        resultMap.put("myCourseList", myCourseResDtoList);
        logger.info("<< response : myCourseList={}", myCourseResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("{userId}")
    public ResponseEntity<Void> addCourse(
            @PathVariable Long userId,
            @RequestPart CourseCreateReqDto courseCreateReqDto,
            @RequestPart(required = false) List<MultipartFile> imageList) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseCreateReqDto={}", courseCreateReqDto);
        logger.info(">> request : imageList= {}", imageList);

        Long courseId = courseService.addCourse(userId, courseCreateReqDto, imageList);

        // elasticsearch index 데이터 추가
        elasticSearchService.addIndex(IndexDataReqDTO.builder()
                .id(Long.toString(courseId))
                .title(courseCreateReqDto.getTitle())
                .hashtagList(courseCreateReqDto.getHashtagList())
                .build());

        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("{courseId}/{userId}")
    public ResponseEntity<Void> setCourse(
            @PathVariable Long courseId,
            @PathVariable Long userId,
            @RequestPart CourseUpdateReqDto courseUpdateReqDto,
            @RequestPart(required = false) List<MultipartFile> imageList) throws IOException {
        logger.info(">> request : courseId={}",courseId);
        logger.info(">> request : userId={}",userId);
        logger.info(">> request : courseUpdateReqDto={}",courseUpdateReqDto);
        logger.info(">> request : imageList= {}", imageList);

        courseService.setCourse(userId, courseId, courseUpdateReqDto, imageList);

        // elasticsearch index 데이터 수정
        elasticSearchService.updateIndex(IndexDataReqDTO.builder()
                .id(Long.toString(courseId))
                .title(courseUpdateReqDto.getTitle())
                .hashtagList(courseUpdateReqDto.getHashtagList())
                .build());

        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("{courseId}/{userId}")
    public ResponseEntity<Void> deleteCourse(
            @PathVariable Long courseId,
            @PathVariable Long userId) throws IOException {
        logger.info(">> request : courseId={}",courseId);
        logger.info(">> request : userId={}",userId);

        courseService.deleteCourse(userId,courseId);

        elasticSearchService.deleteIndex(Long.toString(courseId));
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }
}