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
import java.util.Optional;

@Service
public class RoomPostService {
    @Autowired
    private RoomPostRepository roomPostRepository;

    public List<RoomPost> getActivePosts() {
        return roomPostRepository.findByStatus(PostStatus.ACTIVE);
    }

    public List<String> getAvailableProvinces() {
        return roomPostRepository.findDistinctCitiesByStatus(PostStatus.ACTIVE);
    }

    public Page<RoomPost> getActivePosts(Pageable pageable) {
        return roomPostRepository.findByStatus(PostStatus.ACTIVE, pageable);
    }

    public Page<RoomPost> getActivePostsByCategory(RoomCategory category, Pageable pageable) {
        if (category == null) {
            return getActivePosts(pageable);
        }
        return roomPostRepository.findByStatusAndCategory(PostStatus.ACTIVE, category, pageable);
    }

    public Optional<RoomPost> getRoomPostById(Long id) {
        return roomPostRepository.findById(id);
    }

    public Page<RoomPost> searchPosts (String province, String priceRange, String areaRange, RoomCategory category, Pageable pageable) {
        if (province != null && province.trim().isEmpty()) province = null;

        Double minPrice = null;
        Double maxPrice = null;
        if (priceRange != null && !priceRange.trim().isEmpty()) {
            switch (priceRange) {
                case "1": maxPrice = 1000000.0; break;
                case "2": minPrice = 1000000.0; maxPrice = 2000000.0; break;
                case "3": minPrice = 2000000.0; maxPrice = 3000000.0; break;
                case "4": minPrice = 3000000.0; maxPrice = 5000000.0; break;
                case "5": minPrice = 5000000.0; break;
                default: break;
            }
        }

        Double minArea = null;
        Double maxArea = null;
        if (areaRange != null && !areaRange.trim().isEmpty()) {
            switch (areaRange) {
                case "1": maxArea = 20.0; break;
                case "2": minArea = 20.0; maxArea = 30.0; break;
                case "3": minArea = 30.0; maxArea = 50.0; break;
                case "4": minArea = 50.0; break;
                default: break;
            }
        }

        return roomPostRepository.searchActivePosts(PostStatus.ACTIVE, province, category, minPrice, maxPrice, minArea, maxArea, pageable);
    }
}
