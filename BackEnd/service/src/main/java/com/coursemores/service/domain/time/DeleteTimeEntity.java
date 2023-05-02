package com.coursemores.service.domain.time;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@MappedSuperclass
public abstract class DeleteTimeEntity extends UpdateTimeEntity {

    @Column
    protected LocalDateTime deleteTime;
}