package com.example.roomrental.repository;

import com.example.roomrental.entity.RoomPost;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomPostRepository extends JpaRepository<RoomPost, Long> {
}
