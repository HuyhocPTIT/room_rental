package com.example.roomrental.repository;

import com.example.roomrental.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    boolean existsByUserIdAndRoomPostId(Long userId, Long roomPostId);
    Favorite findByUserIdAndRoomPostId(Long userId, Long roomPostId);
    List<Favorite> findAllByUserIdOrderByCreatedAtDesc(Long userId);
}
