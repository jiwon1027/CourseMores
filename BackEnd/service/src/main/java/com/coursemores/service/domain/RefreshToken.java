package com.coursemores.service.domain;

import com.coursemores.service.domain.time.UpdateTimeEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "refresh_token")
@Getter
@ToString
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RefreshToken extends UpdateTimeEntity {

    @Id
    @Column(name = "refresh_token_key")
    private String key;

    @NotNull
    private String value;

    @Builder
    public RefreshToken(String key, String value) {
        this.key = key;
        this.value = value;
    }
}