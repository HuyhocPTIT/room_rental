package com.example.roomrental.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "profiles")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Profile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String avatar;
    private String name;
    private String phoneNumber;
    private String email;

    @OneToOne(mappedBy = "profile")
    private User user;
}
