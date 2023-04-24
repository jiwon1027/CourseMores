package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
public abstract class DeleteTimeEntity extends UpdateTimeEntity{

    protected LocalDateTime deleteTime;
}
