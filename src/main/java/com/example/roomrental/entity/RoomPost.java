package com.example.roomrental.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "RoomPost")
@Getter
@Setter
public class RoomPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long postId;

    private String title;
    private String description;
    private float price;
    private String address;
    private String phoneContact;
    private String zaloContact;
    private enum status {
        active,
        hidden,
        expried
    };
    private LocalDateTime createdAt;
    private enum roomCategory {
        Apartment,
        House,
        Villa,
        Other
    }

    // Quan hệ với User
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "location_id")
    private Location location;
}
