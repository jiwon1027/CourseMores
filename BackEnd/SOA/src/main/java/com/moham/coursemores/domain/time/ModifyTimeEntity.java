package com.moham.coursemores.domain.time;

import org.springframework.data.annotation.LastModifiedDate;
import java.time.LocalDateTime;

public abstract class ModifyTimeEntity extends CreateTimeEntity{
    @LastModifiedDate
    private LocalDateTime modifyTime;
}