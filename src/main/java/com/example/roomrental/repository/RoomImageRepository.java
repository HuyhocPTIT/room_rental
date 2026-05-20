package com.example.roomrental.repository;

import com.example.roomrental.entity.RoomImage;
import com.example.roomrental.entity.RoomPost;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoomImageRepository extends JpaRepository<RoomImage, Long> {
    List<RoomImage> findByRoomPost(RoomPost roomPost);
}
