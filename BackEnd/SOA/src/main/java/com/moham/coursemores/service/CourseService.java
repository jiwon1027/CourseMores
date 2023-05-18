package com.moham.coursemores.service;

import com.moham.coursemores.dto.course.CourseCreateReqDto;
import com.moham.coursemores.dto.course.CourseDetailResDto;
import com.moham.coursemores.dto.course.CourseImportResDto;
import com.moham.coursemores.dto.course.CourseInfoResDto;
import com.moham.coursemores.dto.course.CoursePreviewResDto;
import com.moham.coursemores.dto.course.CourseUpdateReqDto;
import com.moham.coursemores.dto.course.HotPreviewResDto;
import com.moham.coursemores.dto.course.MyCourseResDto;
import com.moham.coursemores.dto.course.NearPreviewResDto;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface CourseService {
    List<HotPreviewResDto> getHotCourseList();
    void setHotCourse();
    List<NearPreviewResDto> getCoursesNearby(double latitude, double longitude);
    Page<CoursePreviewResDto> search(Long userId, String word, Long regionId, List<Long> themeIds, int isVisited, int page, String sortby);
    void increaseViewCount(Long courseId);
    CourseInfoResDto getCourseInfo(Long courseId, Long userId);
    List<CourseDetailResDto> getCourseDetail(Long courseId);
    List<CourseImportResDto> importCourse(Long courseId);
    List<MyCourseResDto> getMyCourseList(Long userId);
    Long addCourse(Long userId, CourseCreateReqDto courseCreateReqDto, List<MultipartFile> imageList);
    void setCourse(Long userId, Long courseId, CourseUpdateReqDto courseUpdateReqDto, List<MultipartFile> imageList);
    void deleteCourse(Long userId, Long courseId);
    Map<String, List<Integer>> testES();
}