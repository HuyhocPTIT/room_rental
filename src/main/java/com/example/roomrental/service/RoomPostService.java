package com.example.roomrental.service;

import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.repository.RoomPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoomPostService {

    @Autowired
    private RoomPostRepository roomPostRepository;

    // Lấy tất cả bài đăng đang hoạt động
    public List<RoomPost> getAllActivePosts() {
        return roomPostRepository.findAll()
                .stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .collect(Collectors.toList());
    }

    // Lấy các bài đắc biệt (featured)
    public List<RoomPost> getFeaturedRooms(int limit) {
        return roomPostRepository.findAll()
                .stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .limit(limit)
                .collect(Collectors.toList());
    }

    // Lấy các bài mới nhất
    public List<RoomPost> getNewestRooms(int limit) {
        return roomPostRepository.findAll()
                .stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    // Tìm kiếm với bộ lọc
    public List<RoomPost> searchAndFilter(
            String keyword,
            Float minPrice,
            Float maxPrice,
            String city,
            String district,
            RoomCategory category,
            Integer minBedrooms
    ) {
        return roomPostRepository.findAll()
                .stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .filter(post -> keyword == null || keyword.isEmpty() || 
                        post.getTitle().toLowerCase().contains(keyword.toLowerCase()) ||
                        post.getDescription().toLowerCase().contains(keyword.toLowerCase()))
                .filter(post -> minPrice == null || post.getPrice() >= minPrice)
                .filter(post -> maxPrice == null || post.getPrice() <= maxPrice)
                .filter(post -> city == null || city.isEmpty() || 
                        (post.getLocation() != null && 
                         post.getLocation().getCity().equalsIgnoreCase(city)))
                .filter(post -> district == null || district.isEmpty() || 
                        (post.getLocation() != null && 
                         post.getLocation().getDistrict().equalsIgnoreCase(district)))
                .filter(post -> category == null || post.getCategory() == category)
                .filter(post -> minBedrooms == null || post.getBedrooms() >= minBedrooms)
                .collect(Collectors.toList());
    }

    // Lấy chi tiết bài đăng
    public RoomPost getRoomPostById(Long id) {
        return roomPostRepository.findById(id).orElse(null);
    }

    // Lấy tất cả bài đăng của một user
    public List<RoomPost> getRoomPostsByUserId(Long userId) {
        return roomPostRepository.findAll()
                .stream()
                .filter(post -> post.getUser() != null && post.getUser().getId().equals(userId))
                .collect(Collectors.toList());
    }

    // Tạo mới bài đăng
    public RoomPost createRoomPost(RoomPost roomPost) {
        roomPost.setStatus(PostStatus.ACTIVE);
        return roomPostRepository.save(roomPost);
    }

    // Cập nhật bài đăng
    public RoomPost updateRoomPost(Long id, RoomPost roomPost) {
        RoomPost existing = roomPostRepository.findById(id).orElse(null);
        if (existing != null) {
            existing.setTitle(roomPost.getTitle());
            existing.setDescription(roomPost.getDescription());
            existing.setPrice(roomPost.getPrice());
            existing.setAddress(roomPost.getAddress());
            existing.setPhoneContact(roomPost.getPhoneContact());
            existing.setZaloContact(roomPost.getZaloContact());
            existing.setArea(roomPost.getArea());
            existing.setBedrooms(roomPost.getBedrooms());
            existing.setBathrooms(roomPost.getBathrooms());
            existing.setUtilities(roomPost.getUtilities());
            existing.setCategory(roomPost.getCategory());
            return roomPostRepository.save(existing);
        }
        return null;
    }

    // Xóa bài đăng
    public void deleteRoomPost(Long id) {
        roomPostRepository.deleteById(id);
    }

    // Thay đổi trạng thái bài đăng
    public RoomPost updateStatus(Long id, PostStatus status) {
        RoomPost post = roomPostRepository.findById(id).orElse(null);
        if (post != null) {
            post.setStatus(status);
            return roomPostRepository.save(post);
        }
        return null;
    }
}
