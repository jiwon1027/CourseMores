package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.CourseLike;
import com.moham.coursemores.repository.CourseLikeRepository;
import com.moham.coursemores.service.LikeService;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LikeServiceImpl implements LikeService {

    private final CourseLikeRepository courseLikeRepository;

    @Override
    public boolean checkLikeCourse(int userId, int courseId) {
        Optional<CourseLike> courseLike = courseLikeRepository.findByUserIdAndCourseId(userId, courseId);
        return courseLike.isPresent() && courseLike.get().isFlag();
    }

}