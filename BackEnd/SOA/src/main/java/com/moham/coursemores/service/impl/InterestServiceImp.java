package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.*;
import com.moham.coursemores.dto.course.CoursePreviewResDto;
import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.repository.InterestRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.InterestService;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class InterestServiceImp implements InterestService {

    private final InterestRepository interestRepository;

    @Override
    public List<InterestCourseResDto> getUserInterestCourseList(int userId) {
        List<InterestCourseResDto> result = new ArrayList<>();

        interestRepository.findByUserId(userId)
                .forEach(interest -> {
                    int interestId = interest.getId();
                    Course course = interest.getCourse();
                    CourseLocation firstCourseLocation = course.getCourseLocationList().get(0);

                    CoursePreviewResDto coursePreviewResDto = CoursePreviewResDto.builder()
                            .courseId(course.getId())
                            .title(course.getTitle())
                            .content(course.getContent())
                            .people(course.getPeople())
                            .visited(course.isVisited())
                            .likeCount(course.getLikeCount())
                            .commentCount(course.getCommentList().size())
                            .mainImage(course.getMainImage())
                            .sido(firstCourseLocation.getRegion().getSido())
                            .gugun(firstCourseLocation.getRegion().getGugun())
                            .locationName(firstCourseLocation.getName())
                            .isInterest(true)
                            .build();

                    result.add(InterestCourseResDto.builder()
                                    .interestCourseId(interestId)
                                    .CoursePreviewResDto(coursePreviewResDto)
                            .build());
                });

        return result;
    }
}