package com.moham.coursemores.domain;

import com.moham.coursemores.domain.time.DeleteTimeEntity;
import lombok.*;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="user")
@Getter
@ToString
@SuperBuilder
public class User extends DeleteTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int id;
    @NotNull
    @Column(length = 20)
    private String email;
    @NotNull
    @Column(length = 15)
    private String roles;
    @NotNull
    private String provider;
    @NotNull
    private String providerId;
}
