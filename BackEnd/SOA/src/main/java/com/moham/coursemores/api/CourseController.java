package com.moham.coursemores.api;

import com.moham.coursemores.dto.course.*;
import com.moham.coursemores.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.websocket.server.PathParam;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("course")
@RequiredArgsConstructor
public class CourseController {

    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

    private final CourseService courseService;

    @GetMapping("test")
    public ResponseEntity<Map<String, Object>> test() {
        // 메서드 실행 - logger에 request값 표시하기 (없다면 none)
        logger.info(">> request : none");

        // 결과값을 담을 resultMap 생성
        Map<String, Object> resultMap = new HashMap<>();

        /* 해당 과정 반복

        // service 실행
        String test = testService.getTest();

        // 결과값이 있다면 resultMap에 넣기
        resultMap.put("test", test);

        // logger에 결과값 표시하기 (없다면 none)
        logger.info("<< response : test={}", test);

         */

        // 결과값 반환하기
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("search/{userId}")
    public ResponseEntity<Map<String, Object>> searchCourse(
            @PathVariable int userId,
            @RequestParam String word,
            @RequestParam int regionId,
            @RequestParam List<Integer> themeIds,
            @RequestParam int page,
            @RequestParam String sortby) {
        logger.info(">> request : userId={}",userId);
        logger.info(">> request : word={}",word);
        logger.info(">> request : regionId={}",regionId);
        logger.info(">> request : themeIds={}",themeIds);
        logger.info(">> request : page={}",page);
        logger.info(">> request : sortby={}",sortby);

        Map<String, Object> resultMap = new HashMap<>();

        Page<CoursePreviewResDto> pageCourse = courseService.search(userId, word,regionId,themeIds,page,sortby);
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
            @PathVariable int courseId) {
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
            @PathVariable int courseId) {
        logger.info(">> request : courseId={}",courseId);

        Map<String, Object> resultMap = new HashMap<>();

        List<CourseDetailResDto> courseDetailResDtoList = courseService.getCourseDetail(courseId);
        resultMap.put("courseDetailList", courseDetailResDtoList);
        logger.info("<< response : courseDetailList={}", courseDetailResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getMyCourseList(
            @PathVariable int userId) {
        logger.info(">> request : userId={}",userId);

        Map<String, Object> resultMap = new HashMap<>();

        List<MyCourseResDto> myCourseResDtoList = courseService.getMyCourseList(userId);
        resultMap.put("myCourseList", myCourseResDtoList);
        logger.info("<< response : myCourseList={}", myCourseResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("{userId}")
    public ResponseEntity<Void> addCourse(
            @PathVariable int userId,
            @RequestBody CourseCreateReqDto courseCreateReqDto) {
        logger.info(">> request : userId={}",userId);
        logger.info(">> request : courseCreateReqDto={}",courseCreateReqDto);

        courseService.addCourse(userId, courseCreateReqDto);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("{courseId}/{userId}")
    public ResponseEntity<Void> setCourse(
            @PathVariable int courseId,
            @PathVariable int userId,
            @RequestBody CourseUpdateReqDto courseUpdateReqDto) {
        logger.info(">> request : courseId={}",courseId);
        logger.info(">> request : userId={}",userId);
        logger.info(">> request : courseUpdateReqDto={}",courseUpdateReqDto);

        courseService.setCourse(userId, courseId, courseUpdateReqDto);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("{courseId}/{userId}")
    public ResponseEntity<Void> deleteCourse(
            @PathVariable int courseId,
            @PathVariable int userId) {
        logger.info(">> request : courseId={}",courseId);
        logger.info(">> request : userId={}",userId);

        courseService.deleteCourse(userId,courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }
}