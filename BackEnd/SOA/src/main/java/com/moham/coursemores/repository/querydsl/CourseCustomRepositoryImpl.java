package com.moham.coursemores.repository.querydsl;

import com.moham.coursemores.domain.Course;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.PathBuilder;
import com.querydsl.jpa.JPQLQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.aspectj.weaver.ast.Or;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import static com.moham.coursemores.domain.QCourse.course;
import static com.moham.coursemores.domain.QCourseLocation.courseLocation;
import static com.moham.coursemores.domain.QHashtagOfCourse.hashtagOfCourse;
import static com.moham.coursemores.domain.QHashtag.hashtag;
import static com.moham.coursemores.domain.QThemeOfCourse.themeOfCourse;
import static com.moham.coursemores.domain.QTheme.theme;
import java.util.List;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class CourseCustomRepositoryImpl implements CourseCustomRepository {

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public Page<Course> searchAll(String word, Long regionId, List<Long> themeIds, int isVisited, Pageable pageable) {
        //content를 가져오는 쿼리는 fetch로 하고
        List<Course> fetch = jpaQueryFactory
                .selectFrom(course)
                .distinct()
//                .where(searchCoursesFilter(word, regionId, themeIds, isVisited))
                .where(wordContain(word),
                        regionEq(regionId),
                        themeContain(themeIds),
                        isVisited(isVisited))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .orderBy(getOrderSpecifier(pageable.getSort()).stream().toArray(OrderSpecifier[]::new))
                .fetch();

        //count 만 가져오는 쿼리
        JPQLQuery<Course> count = jpaQueryFactory
                .selectFrom(course)
                .distinct()
//                .where(searchCoursesFilter(word, regionId, themeIds, isVisited))
                .where(wordContain(word),
                        regionEq(regionId),
                        themeContain(themeIds),
                        isVisited(isVisited));

        return PageableExecutionUtils.getPage(fetch, pageable, count::fetchCount);
    }

    // 동적 정렬
    private List<OrderSpecifier> getOrderSpecifier(Sort sort){
        return sort
                .stream()
                .map(order -> {
                    Order direction = order.isAscending() ? Order.ASC : Order.DESC;
                    String prop = order.getProperty();
                    PathBuilder orderByExpression = new PathBuilder(Course.class, "course");

//                    System.out.println("order : "+order);
//                    System.out.println("디렉션 : "+direction);
//                    System.out.println("prop : "+prop);
//                    System.out.println("orderByExpression : "+orderByExpression);

                    return new OrderSpecifier(direction,orderByExpression.get(prop));
                })
                .collect(Collectors.toList());
    }

    private BooleanExpression wordContain(String word) {
        return (word != null && !word.isBlank()) ?
                course.title.contains(word)
                        .or(course.courseHashtagList.any().hashtag.name.contains(word))
                        .or(course.courseLocationList.any().name.contains(word)) :
                null;
    }

    private BooleanExpression regionEq(Long regionId) {
        return (regionId != null && regionId > 0) ?
                course.courseLocationList.any().region.id.eq(regionId) :
                null;
    }

    private BooleanExpression themeContain(List<Long> themeIds) {
        return (themeIds != null && !themeIds.isEmpty() && themeIds.get(0) != 0) ?
                course.themeOfCourseList.any().theme.id.in(themeIds) :
                null;
    }

    private BooleanExpression isVisited(int isVisited) {
        return isVisited == 1 ?
                course.visited.eq(true) :
                null;
    }

//    public Predicate searchCoursesFilter(String word, Long regionId, List<Long> themeIds, int isVisited) {
//
//        BooleanBuilder builder = new BooleanBuilder();
//
//        if (word != null && !word.isBlank()) {
//            builder.or(course.title.contains(word))
//                    .or(course.courseHashtagList.any().hashtag.name.contains(word))
//                    .or(course.courseLocationList.any().name.contains(word));
//        }
//
//        if (regionId != null && regionId > 0) {
//            builder.and(course.courseLocationList.any().region.id.eq(regionId));
//        }
//
//        if(themeIds != null && !themeIds.isEmpty() && themeIds.get(0) != 0){
//            BooleanBuilder themeBuilder = new BooleanBuilder();
//            themeIds.forEach(id -> themeBuilder.or(course.themeOfCourseList.any().theme.id.eq(id)));
//            builder.and(themeBuilder.getValue());
////            themeIds.forEach(id -> builder.or(course.themeOfCourseList.any().theme.id.eq(id)));
//        }
//
//        if(isVisited == 1){
//            builder.and(course.visited.eq(true));
//        }
//
//        return builder.getValue();
//    }

}
