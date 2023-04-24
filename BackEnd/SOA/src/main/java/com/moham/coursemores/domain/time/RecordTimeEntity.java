package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@ToString
public abstract class RecordTimeEntity extends CreateTimeEntity{

    @NotNull
    protected LocalDateTime registerTime;
    protected LocalDateTime releaseTime;
}
