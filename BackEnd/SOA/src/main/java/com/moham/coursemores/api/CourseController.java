package com.moham.coursemores.api;

import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("course")
@RequiredArgsConstructor
public class CourseController {

    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

    private final CourseService courseService;

    //반환할 결과값이 있다면 ResponseEntity<Map<String, Object>>
    //    없다면 ResponseEntity<Void>
    @GetMapping("test")
    private ResponseEntity<Map<String, Object>> test() throws Exception {
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

    @GetMapping("info/{courseId}")
    private ResponseEntity<Map<String, Object>> getCourseInfo(
            @PathVariable int courseId) throws Exception {
        logger.info(">> request : courseId={}",courseId);

        Map<String, Object> resultMap = new HashMap<>();

        CourseInfoResDto courseInfoResDto = courseService.getCourseInfo(courseId);
        resultMap.put("courseInfo", courseInfoResDto);
        logger.info("<< response : courseInfo={}", courseInfoResDto);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }


}
