package com.example.roomrental.entity;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "room_posts")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RoomPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;
    private float price;
    private String address;
    private String phoneContact;
    private String zaloContact;
    
    private float area; // Diện tích m2
    private int bedrooms; // Số phòng ngủ
    private int bathrooms; // Số phòng tắm
    private String utilities; // Tiện ích (máy lạnh, wifi, etc)

    @Enumerated(EnumType.STRING)
    private PostStatus status;

    @Enumerated(EnumType.STRING)
    private RoomCategory category;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    @PrePersist
    private void prePersist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    private void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // Quan hệ với User
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "location_id")
    private Location location;

    @OneToMany(mappedBy = "roomPost")
    private List<RoomImage> roomImages;

    @OneToMany(mappedBy = "roomPost")
    private List<Favorite> favorites;
}
