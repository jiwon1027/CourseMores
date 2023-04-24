package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.UpdateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="region")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Region extends UpdateTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "region_id")
    private int id;

    @NotNull
    @Column
    private String sido;

    @NotNull
    @Column
    private String gugun;

    @Builder
    public Region(String sido,
                  String gugun){
        this.sido = sido;
        this.gugun = gugun;
    }
}
