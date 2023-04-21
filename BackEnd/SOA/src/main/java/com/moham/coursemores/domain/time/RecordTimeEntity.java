package com.moham.coursemores.domain.time;

import java.time.LocalDateTime;

public abstract class RecordTimeEntity extends CreateTimeEntity{
    private LocalDateTime registerTime;
    private LocalDateTime releaseTime;
}
