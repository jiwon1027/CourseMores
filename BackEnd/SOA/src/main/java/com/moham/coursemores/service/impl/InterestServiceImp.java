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
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InterestServiceImp implements InterestService {

    private final InterestRepository interestRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;

    @Override
    public List<InterestCourseResDto> getUserInterestCourseList(Long userId) {
        List<InterestCourseResDto> result = new ArrayList<>();

        // 현재의 관심 여부(flag)가 true인 것만 가져오기
        interestRepository.findByUserIdAndFlag(userId, true)
                .forEach(interest -> {
                    Long interestId = interest.getId();
                    // 관심 코스 정보 가져오기
                    Course course = interest.getCourse();
                    // 코스의 첫 번째 장소 가져오기
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
    public boolean checkInterest(Long userId, Long courseId) {
        // 관심 객체가 존재하고 flag 또한 true이면 해당 유저의 관심 코스이다.
        Optional<Interest> interest = interestRepository.findByUserIdAndCourseId(userId, courseId);
        return interest.isPresent() && interest.get().isFlag();
    }

    @Override
    @Transactional
    public void addInterestCourse(Long userId, Long courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));

        Optional<Interest> interest = interestRepository.findByUserIdAndCourseId(userId, courseId);

        if (interest.isPresent()) {
            // 관심 객체가 존재하는데, flag가 true라면 이미 관심 등록된 코스이다.
            if (interest.get().isFlag()) {
                throw new RuntimeException("이미 관심 등록된 코스입니다.");
            }
            // 그렇지 않다면 관심 객체의 등록일시를 설정해준다.
            interest.get().register();
        } else {
            // 관심 객체가 존재하지 않으면 새로 생성해준다.
            User user = userRepository.findByIdAndDeleteTimeIsNull(userId)
                    .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

            interestRepository.save(Interest.builder()
                    .user(user)
                    .course(course)
                    .build());
        }

        // 코스의 관심수 증가
        course.increaseInterestCount();
    }

    @Override
    @Transactional
    public void deleteInterestCourse(Long userId, Long courseId) {
        Course course = courseRepository.findByIdAndDeleteTimeIsNull(courseId)
                .orElseThrow(() -> new RuntimeException("해당 코스를 찾을 수 없습니다."));

        Interest interest = interestRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseThrow(() -> new RuntimeException("해당 관심 내역을 찾을 수 없습니다."));

        // 관심 객체의 flag가 false라면 이미 관심 해제된 코스이다.
        if (!interest.isFlag()) {
            throw new RuntimeException("이미 관심 해제된 코스입니다.");
        }
        // 그렇지 않다면 관심 객체의 해제일시를 설정해준다.
        interest.release();

        // 코스의 관심수 감소
        course.decreaseInterestCount();
    }

}