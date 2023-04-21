package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.MappedSuperclass;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@SuperBuilder
@ToString
@MappedSuperclass
public class RecordTimeEntity extends CreateTimeEntity{
    @NotNull
    private LocalDateTime registerTime;
    private LocalDateTime releaseTime;
}
