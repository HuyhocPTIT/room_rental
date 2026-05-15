package com.example.roomrental.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ReviewDTO {
    private Long id;
    private int rating;
    private String comment;
    private String userName;
    private String userAvatar;
    private String createdAt;
}
