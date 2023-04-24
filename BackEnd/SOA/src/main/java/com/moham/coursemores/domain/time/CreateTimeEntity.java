package com.moham.coursemores.domain.time;

import lombok.Getter;
import lombok.ToString;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@ToString
@EntityListeners(AuditingEntityListener.class)
public abstract class CreateTimeEntity {
    @CreatedDate
    @NotNull
    @Column(updatable = false)
    protected LocalDateTime createTime;
}
