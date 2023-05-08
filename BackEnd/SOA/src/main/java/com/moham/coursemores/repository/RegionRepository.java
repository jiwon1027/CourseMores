package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Region;
import com.moham.coursemores.repository.querydsl.RegionCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RegionRepository extends JpaRepository<Region, Long>, RegionCustomRepository {

}
