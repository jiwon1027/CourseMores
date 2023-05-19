package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Region;
import com.moham.coursemores.repository.querydsl.RegionCustomRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RegionRepository extends JpaRepository<Region, Long>, RegionCustomRepository {

    List<Region> findBySido(String sido);

    Optional<Region> findBySidoAndGugun(String sido, String gugun);

    Optional<Region> findByGugun(String gugun);

    boolean existsBySido(String sido);

    boolean existsByGugun(String gugun);

}