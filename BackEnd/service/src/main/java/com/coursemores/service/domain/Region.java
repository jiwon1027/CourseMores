package com.coursemores.service.domain;

import com.coursemores.service.domain.time.UpdateTimeEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "region")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Region extends UpdateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "region_id")
    private Long id;

    @NotNull
    @Column
    private String sido;

    @NotNull
    @Column
    private String gugun;

    @Builder
    public Region(String sido,
            String gugun) {
        this.sido = sido;
        this.gugun = gugun;
    }
}