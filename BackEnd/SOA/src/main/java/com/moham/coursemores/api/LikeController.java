package com.moham.coursemores.api;

import com.moham.coursemores.service.LikeService;
import java.util.HashMap;
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
@RequestMapping("like")
@RequiredArgsConstructor
public class LikeController {

    // 해당 컨트롤러의 이름과 일치해야한다
    private static final Logger logger = LoggerFactory.getLogger(LikeController.class);

    private final LikeService likeService;

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

    @GetMapping("course/{courseId}/{userId}")
    public ResponseEntity<Map<String, Object>> checkLikeCourse(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        Map<String, Object> resultMap = new HashMap<>();

        boolean isLikeCourse = likeService.checkLikeCourse(userId, courseId);
        resultMap.put("isLikeCourse", isLikeCourse);
        logger.info("<< response : isLikeCourse={}", isLikeCourse);

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> addLikeCourse(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        likeService.addLikeCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("course/{courseId}/{userId}")
    public ResponseEntity<Void> deleteLikeCourse(@PathVariable int userId, @PathVariable int courseId) {
        logger.info(">> request : userId={}", userId);
        logger.info(">> request : courseId={}", courseId);

        likeService.deleteLikeCourse(userId, courseId);
        logger.info("<< response : none");

        return new ResponseEntity<>(HttpStatus.OK);
    }

}