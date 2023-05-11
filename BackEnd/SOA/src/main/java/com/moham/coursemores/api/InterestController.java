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
        logger.debug("[0/2][GET][/interest/{}] << request : none", userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/interest/{}] ... is.getUserInterestCourseList", userId);
        List<InterestCourseResDto> interestCourseResDtoList = interestService.getUserInterestCourseList(userId);
        resultMap.put("myInterestCourseList", interestCourseResDtoList);

        logger.debug("[2/2][GET][/interest/{}] >> response : myInterestCourseList\n myInterestCourseList = {}\n", userId, interestCourseResDtoList);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkInterest(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][GET][/interest/course/{}/{}] << request : none", courseId, userId);

        Map<String, Object> resultMap = new HashMap<>();

        logger.debug("[1/2][GET][/interest/course/{}/{}] ... is.checkInterest", courseId, userId);
        boolean isInterestCourse = interestService.checkInterest(userId, courseId);
        resultMap.put("isInterestCourse", isInterestCourse);

        logger.debug("[2/2][GET][/interest/course/{}/{}] >> response\n isInterestCourse = {}\n", courseId, userId, isInterestCourse);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addInterestCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][POST][/interest/course/{}/{}] << request : none", courseId, userId);

        logger.debug("[1/2][POST][/interest/course/{}/{}] ... is.addInterestCourse", courseId, userId);
        interestService.addInterestCourse(userId, courseId);

        logger.debug("[2/2][POST][/interest/course/{}/{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteInterestCourse(
            @PathVariable Long userId,
            @PathVariable Long courseId) {
        logger.debug("[0/2][DELETE][/interest/course/{}/{}] << request : none", courseId, userId);

        logger.debug("[1/2][DELETE][/interest/course/{}/{}] ... is.deleteInterestCourse", courseId, userId);
        interestService.deleteInterestCourse(userId, courseId);

        logger.debug("[2/2][DELETE][/interest/course/{}/{}] >> response : none\n", courseId, userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}