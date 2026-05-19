package com.example.roomrental.service;



import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.entity.RoomImage;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.RoomImageRepository;
import com.example.roomrental.repository.RoomPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {
    @Autowired
    private RoomPostRepository roomPostRepository;

    @Autowired
    private RoomImageRepository roomImageRepository;

    public List<RoomPost> findRoomPostByRoomId(Long userId){
        return roomPostRepository.findAllByUserId(userId);
    }

    public Page<RoomPost> findByStatus(PostStatus status, Pageable pageable){
        return roomPostRepository.findByStatus(status, pageable);
    }

    public RoomPost updatePost(Long id, RoomPost newPost) {
        RoomPost post = roomPostRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        post.setTitle(newPost.getTitle());
        post.setPrice(newPost.getPrice());
        post.setDescription(newPost.getDescription());

        return roomPostRepository.save(post);
    }

    public void deletePost(Long id) {
        if (!roomPostRepository.existsById(id)) {
            throw new RuntimeException("Post not found");
        }
        roomPostRepository.deleteById(id);
    }

    public void save(RoomPost roomPost) {
        roomPostRepository.save(roomPost);
    }

    public void saveAll(List<RoomImage> roomImages) {
        roomImageRepository.saveAll(roomImages);
    }

    public List<RoomPost> findByUser(User user) {
        return roomPostRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public RoomPost findById(Long id) {
        return roomPostRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));
    }

    public void saveImage(RoomImage roomImage) {
        roomImageRepository.save(roomImage);
    }

    public List<RoomImage> findByRoomPost(RoomPost roomPost) {
        return roomImageRepository.findByRoomPost(roomPost);
    }

    public void deletePostImage(List<RoomImage> roomImages) {
        roomImageRepository.deleteAll(roomImages);
    }

    public RoomImage findImageById(Long id) {
        return roomImageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));
    }

    public void deleteImage(RoomImage roomImage) {
        roomImageRepository.deleteById(roomImage.getId());
    }
}
