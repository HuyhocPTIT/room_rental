package com.example.roomrental.service;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.repository.RoomPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;

@Service
public class RoomPostService {
    @Autowired
    private RoomPostRepository roomPostRepository;

    public List<RoomPost> getActivePosts() {
        return roomPostRepository.findByStatus(PostStatus.ACTIVE);
    }

    public Page<RoomPost> getActivePosts(Pageable pageable) {
        return roomPostRepository.findByStatus(PostStatus.ACTIVE, pageable);
    }

    public Optional<RoomPost> getRoomPostById(Long id) {
        return roomPostRepository.findById(id);
    }
}
