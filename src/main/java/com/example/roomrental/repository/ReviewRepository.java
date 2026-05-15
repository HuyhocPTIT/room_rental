package com.example.roomrental.repository;

import com.example.roomrental.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByRoomPostId(Long roomPostId);
    boolean existsByUserIdAndRoomPostId(Long userId, Long roomPostId);
}
