package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.course.CoursePreviewResDto;
import com.moham.coursemores.dto.interest.InterestCourseResDto;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.InterestService;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class InterestServiceImp implements InterestService {

    private final UserRepository userRepository;

    @Override
    public List<InterestCourseResDto> getUserInterestCourseList(int userId) throws Exception {
        List<InterestCourseResDto> result = null;

        User user = userRepository.findById(userId).orElseThrow(() -> new Exception("해당 사용자를 찾을 수 없습니다."));

        result = user.getInterestList()
                .stream()
                .map(x -> InterestCourseResDto.builder()
                        .interestCourseId(x.getId())
                        .CoursePreviewResDto(CoursePreviewResDto.builder()
                                .courseId(x.getCourse().getId())
                                .title(x.getCourse().getTitle())
                                .content(x.getCourse().getContent())
                                .people(x.getCourse().getPeople())
                                .visited(x.getCourse().isVisited())
                                .likeCount(x.getCourse().getLikeCount())
                                .commentCount(x.getCourse().getCommentList().size())
                                .mainImageUrl(x.getCourse().getMainImage())
                                .sido(x.getCourse().getCourseLocationList().get(0).getRegion().getSido())
                                .gugun(x.getCourse().getCourseLocationList().get(0).getRegion().getGugun())
                                .locationName(x.getCourse().getCourseLocationList().get(0).getName())
                                .isInterest(true)
                                .build())
                        .build())
                .collect(Collectors.toList());

        return result;
    }
}