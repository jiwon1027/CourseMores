package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@ToString
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class RecordTimeEntity {

    @CreatedDate
    @NotNull
    @Column(updatable = false)
    private LocalDateTime createTime;

    @NotNull
    @Column
    protected LocalDateTime registerTime;

    @Column
    protected LocalDateTime releaseTime;
}
