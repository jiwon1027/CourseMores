package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.UpdateTimeEntity;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

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
