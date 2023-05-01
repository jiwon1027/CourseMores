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

    private static final Logger logger = LoggerFactory.getLogger(InterestController.class);

    private final InterestService interestService;

    @GetMapping("{userId}")
    public ResponseEntity<Map<String, Object>> getUserInterestCourseList(
            @PathVariable Long userId) {
        logger.info(">> request : userId={}", userId);

        Map<String, Object> resultMap = new HashMap<>();

        List<InterestCourseResDto> interestCourseResDtoList = interestService.getUserInterestCourseList(userId);
        resultMap.put("myInterestCourseList", interestCourseResDtoList);
        logger.info("<< response : myInterestCourseList = {}", interestCourseResDtoList);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkInterest(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        boolean isInterestCourse = interestService.checkInterest(userId, courseId);
        resultMap.put("isInterestCourse", isInterestCourse);
        logger.info("<< response : isInterestCourse={}", isInterestCourse);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addInterestCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        interestService.addInterestCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteInterestCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        interestService.deleteInterestCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

}