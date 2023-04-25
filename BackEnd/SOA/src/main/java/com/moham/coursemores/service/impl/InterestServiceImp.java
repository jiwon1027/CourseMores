package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.CourseLocation;
import com.moham.coursemores.domain.Interest;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.course.CoursePreviewResDto;
import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.repository.CourseRepository;
import com.moham.coursemores.repository.InterestRepository;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.InterestService;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class InterestServiceImp implements InterestService {

    private final InterestRepository interestRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;

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
                            .coursePreviewResDto(coursePreviewResDto)
                            .build());
                });

        return result;
    }

    @Override
    public boolean checkInterest(int userId, int courseId) {
        Optional<Interest> interest = interestRepository.findByUserIdAndCourseId(userId, courseId);
        return interest.isPresent() && interest.get().isFlag();
    }

    @Override
    @Transactional
    public void addInterestCourse(int userId, int courseId) {
        Optional<Interest> interest = interestRepository.findByUserIdAndCourseId(userId, courseId);

        if (interest.isPresent()) {
            interest.get().register();
        } else {
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다"));
            Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                    .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다"));
            interestRepository.save(Interest.builder()
                    .user(user)
                    .course(course)
                    .build());
        }
    }

    @Override
    @Transactional
    public void deleteInterestCourse(int userId, int courseId) {
        Interest interest = interestRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseThrow(() -> new RuntimeException("해당 관심 내역을 찾을 수 없습니다"));
        interest.relese();
    }

}