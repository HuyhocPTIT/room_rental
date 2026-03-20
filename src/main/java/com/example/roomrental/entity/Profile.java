package com.example.roomrental.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "Profile")
@Getter
@Setter

public class Profile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long profileId;

    private String avatar;
    private String name;
    private String phoneNumber;
    private String email;

    @OneToOne(mappedBy = "profile")
    private User user;
}
