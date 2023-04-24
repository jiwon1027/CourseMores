package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@ToString
@MappedSuperclass
public abstract class RecordTimeEntity extends CreateTimeEntity {

    @NotNull
    @Column
    protected LocalDateTime registerTime;

    @Column
    protected LocalDateTime releaseTime;
}
