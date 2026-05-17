package com.example.roomrental.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RoomDetailDTO {
    private Long id;
    private String title;
    private String description;
    private float price;
    private float area;
    private String address;
    private String category;
    private String phoneContact;
    private String zaloContact;
    private String createdAt;
    
    // Owner info
    private String ownerName;
    private String ownerPhone;
    private String ownerEmail;
    private String ownerAvatar;
    
    // Location
    private String city;
    private String district;
    private String ward;
    
    // Images
    private List<String> roomImages;
    
    // Reviews removed
    
    // Favorite status
    private boolean favorite;
}
