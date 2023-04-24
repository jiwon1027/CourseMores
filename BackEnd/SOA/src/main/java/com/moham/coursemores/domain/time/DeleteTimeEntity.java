package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@Getter
@ToString
@MappedSuperclass
public abstract class DeleteTimeEntity extends UpdateTimeEntity{

    @Column
    protected LocalDateTime deleteTime;
}
