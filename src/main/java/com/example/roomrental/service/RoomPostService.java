package com.example.roomrental.service;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.repository.RoomPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.stream.Collectors;

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

        // Compatibility wrappers for controller methods from other branch
        public List<RoomPost> getAllActivePosts() {
        return getActivePosts();
        }

        public RoomPost getRoomPostById(Long id) {
        return roomPostRepository.findById(id).orElse(null);
        }

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
}
