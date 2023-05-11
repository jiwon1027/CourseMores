package com.moham.coursemores.repository.querydsl;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.moham.coursemores.domain.QRegion.region;

@Repository
@RequiredArgsConstructor
public class RegionCustomRepositoryImpl implements RegionCustomRepository{

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public List<String> getSidoList() {
        return jpaQueryFactory
                .select(region.sido)
                .from(region)
                .distinct()
                .fetch();
    }
}
