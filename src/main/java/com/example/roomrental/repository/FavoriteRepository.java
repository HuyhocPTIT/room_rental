package com.example.roomrental.repository;

import com.example.roomrental.entity.Favorite;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    boolean existsByUserIdAndRoomPostId(Long userId, Long roomPostId);
    Favorite findByUserIdAndRoomPostId(Long userId, Long roomPostId);
    List<Favorite> findAllByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<Favorite> findByUserAndRoomPost(User user, RoomPost roomPost);
    List<Favorite> findByUser(User user);
    long countByRoomPost(RoomPost roomPost);
}
