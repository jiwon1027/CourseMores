package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Hashtag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HashtagRepository extends JpaRepository<Hashtag, Integer> {
    Optional<Hashtag> findByName(String name);
    boolean existsByName(String name);
}
