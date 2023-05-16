package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Theme;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ThemeRepository extends JpaRepository<Theme, Long> {

    @Query(value = "SELECT * FROM theme order by RAND() limit :number", nativeQuery = true)
    List<Theme> findRandomTheme(@Param("number") int number);

}