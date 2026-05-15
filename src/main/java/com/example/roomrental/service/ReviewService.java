package com.example.roomrental.service;

import com.example.roomrental.dto.ReviewDTO;
import com.example.roomrental.dto.ReviewRequest;
import com.example.roomrental.entity.Review;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;

    public List<ReviewDTO> getReviewsByRoomPost(Long roomPostId) {
        List<Review> reviews = reviewRepository.findByRoomPostId(roomPostId);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        
        return reviews.stream().map(review -> {
            ReviewDTO dto = new ReviewDTO();
            dto.setId(review.getId());
            dto.setRating(review.getRating());
            dto.setComment(review.getComment());
            dto.setUserName(review.getUser().getProfile().getName());
            dto.setUserAvatar(review.getUser().getProfile().getAvatar());
            dto.setCreatedAt(review.getCreatedAt().format(formatter));
            return dto;
        }).collect(Collectors.toList());
    }

    public double getAverageRating(Long roomPostId) {
        List<Review> reviews = reviewRepository.findByRoomPostId(roomPostId);
        if (reviews.isEmpty()) {
            return 0.0;
        }
        return reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
    }

    public Review addReview(Long roomPostId, User user, ReviewRequest request, RoomPost roomPost) {
        Review review = new Review();
        review.setRating(request.getRating());
        review.setComment(request.getComment());
        review.setUser(user);
        review.setRoomPost(roomPost);
        return reviewRepository.save(review);
    }

    public boolean hasUserReviewedRoom(Long userId, Long roomPostId) {
        return reviewRepository.existsByUserIdAndRoomPostId(userId, roomPostId);
    }

    public List<Review> getReviewsByRoomPostId(Long roomPostId) {
        return reviewRepository.findByRoomPostId(roomPostId);
    }
}
