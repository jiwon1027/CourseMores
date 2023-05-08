package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Region;
import com.moham.coursemores.repository.querydsl.RegionCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface RegionRepository extends JpaRepository<Region, Long>, RegionCustomRepository {
    List<Region> findBySido(String sido);
    Optional<Region> findBySidoAndGugun(String sido, String gugun);
}
