package com.moham.coursemores.repository.querydsl;

import com.moham.coursemores.domain.Course;
import com.moham.coursemores.domain.QCourse;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;
import com.querydsl.jpa.JPQLQuery;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import static com.moham.coursemores.domain.QCourse.course;
import static com.moham.coursemores.domain.QCourseLocation.courseLocation;
import static com.moham.coursemores.domain.QHashtagOfCourse.hashtagOfCourse;
import static com.moham.coursemores.domain.QHashtag.hashtag;
import static com.moham.coursemores.domain.QThemeOfCourse.themeOfCourse;
import static com.moham.coursemores.domain.QTheme.theme;
import static com.moham.coursemores.domain.QRegion.region;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class CourseCustomRepositoryImpl implements CourseCustomRepository {

    private final JPAQueryFactory jpaQueryFactory;

    public Predicate searchCoursesFilter(String word, int regionId, List<Integer> themeIds) {

        BooleanBuilder builder = new BooleanBuilder();

        if (word != null) {
            builder.or(course.title.contains(word))
                    .or(course.courseHashtagList.any().hashtag.name.contains(word))
                    .or(course.courseLocationList.any().name.contains(word));
        }

        if (regionId > 0) {
            builder.and(course.courseLocationList.any().region.id.eq(regionId));
        }

        if(themeIds.size() > 0 && themeIds.get(0) != 0){
            themeIds.forEach(id -> builder.and(course.themeOfCourseList.any().theme.id.eq(id)));
        }

        return builder.getValue();
    }

    @Override
    public Page<Course> searchAll(String word, int regionId, List<Integer> themeIds, Pageable pageable) {
        //content를 가져오는 쿼리는 fetch로 하고
        List<Course> fetch = jpaQueryFactory
                .selectFrom(course)
                .distinct()
                .leftJoin(course.courseLocationList, courseLocation)
                .leftJoin(course.courseHashtagList, hashtagOfCourse)
                .leftJoin(hashtagOfCourse.hashtag, hashtag)
                .leftJoin(course.themeOfCourseList, themeOfCourse)
                .leftJoin(themeOfCourse.theme, theme)
                .where(searchCoursesFilter(word, regionId, themeIds))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        //count 만 가져오는 쿼리
        JPQLQuery<Course> count = jpaQueryFactory
                .selectFrom(course)
                .distinct()
                .leftJoin(course.courseLocationList, courseLocation)
                .leftJoin(course.courseHashtagList, hashtagOfCourse)
                .leftJoin(hashtagOfCourse.hashtag, hashtag)
                .leftJoin(course.themeOfCourseList, themeOfCourse)
                .leftJoin(themeOfCourse.theme, theme)
                .where(searchCoursesFilter(word, regionId, themeIds));

        return PageableExecutionUtils.getPage(fetch, pageable,()-> count.fetchCount());


//        JPAQuery<Course> query = jpaQueryFactory
//                .selectFrom(course)
//                .distinct()
//                .leftJoin(course.courseLocationList, courseLocation).fetchJoin()
//                .leftJoin(course.courseHashtagList, hashtagOfCourse)
//                .leftJoin(hashtagOfCourse.hashtag, hashtag)
//                .leftJoin(course.themeOfCourseList, themeOfCourse)
//                .leftJoin(themeOfCourse.theme, theme)
//                .where(searchCoursesFilter(word, regionId, themeIds));
//
//        return PageableExecutionUtils.getPage(query.fetch(), pageable, query::fetchCount);
    }
}
