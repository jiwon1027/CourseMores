package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@Getter
@SuperBuilder
@ToString
@MappedSuperclass
public abstract class DeleteTimeEntity extends UpdateTimeEntity{
    private LocalDateTime deleteTime;
}