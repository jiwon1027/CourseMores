package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLike;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.repository.CourseLikeRepository;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.LikeService;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LikeServiceImpl implements LikeService {

    private final CourseLikeRepository courseLikeRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;

    @Override
    public boolean checkLikeCourse(int userId, int courseId) {
        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);
        return courseLike.isPresent() && courseLike.get().isFlag();
    }

    @Override
    @Transactional
    public void addLikeCourse(int userId, int courseId) {
        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);

        if (courseLike.isPresent()) {
            courseLike.get().register();
        } else {
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
            Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                    .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));
            courseLikeRepository.save(CourseLike.builder()
                    .user(user)
                    .course(course)
                    .build());
        }
    }

}