package com.example.roomrental.repository;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.entity.RoomPost;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;

public interface RoomPostRepository extends JpaRepository<RoomPost, Long> {
    List<RoomPost> findByStatus(PostStatus status);
    Page<RoomPost> findByStatus(PostStatus status, Pageable pageable);
    Page<RoomPost> findByStatusAndCategory(PostStatus status, RoomCategory category, Pageable pageable);
}
