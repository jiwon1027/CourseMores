package com.moham.coursemores.api;

import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.service.InterestService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("interest")
@RequiredArgsConstructor
public class InterestController {

    // 해당 컨트롤러의 이름과 일치해야한다
    private static final Logger logger = LoggerFactory.getLogger(InterestController.class);

    private final InterestService interestService;

    //반환할 결과값이 있다면 ResponseEntity<Map<String, Object>>
    //    없다면 ResponseEntity<Void>
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

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getUserInterestCourseList(@PathVariable int userId) {
        logger.info(">> request : userId={}", userId);

        Map<String, Object> resultMap = new HashMap<>();

        List<InterestCourseResDto> interestCourseResDtoList = interestService.getUserInterestCourseList(userId);
        resultMap.put("myInterestCourseList", interestCourseResDtoList);
        logger.info("<< response : myInterestCourseList = {}", interestCourseResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkInterest(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        boolean isInterestCourse = interestService.checkInterest(userId, courseId);
        resultMap.put("isInterestCourse", isInterestCourse);
        logger.info("<< response : isInterestCourse={}", isInterestCourse);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addInterestCourse(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        interestService.addInterestCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteInterestCourse(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        interestService.deleteInterestCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

}