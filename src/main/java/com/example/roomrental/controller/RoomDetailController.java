package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.dto.RoomDetailDTO;
import com.example.roomrental.entity.*;
import com.example.roomrental.service.RoomPostService;
import com.example.roomrental.repository.FavoriteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/room")
public class RoomDetailController {

    @Autowired
    private RoomPostService roomPostService;

    @Autowired
    private FavoriteRepository favoriteRepository;

    @GetMapping("/{id}")
    public String getRoomDetail(@PathVariable Long id, Model model, HttpSession session) {
        RoomPost roomPost = roomPostService.getRoomPostById(id).orElse(null);

        if (roomPost == null) {
            return "redirect:/";
        }

        // Tạo RoomDetailDTO
        RoomDetailDTO roomDetail = buildRoomDetailDTO(roomPost, session);

        model.addAttribute("roomDetail", roomDetail);
        model.addAttribute("isLoggedIn", session.getAttribute(SessionAttribute.CURRENT_USER) != null);

        return "room/detail";
    }


    @PostMapping("/{id}/favorite/add")
    @ResponseBody
    public Map<String, Object> addFavorite(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) {
            return Map.of("success", false, "message", "Vui lòng đăng nhập");
        }

        RoomPost roomPost = roomPostService.getRoomPostById(id).orElse(null);
        if (roomPost == null) {
            return Map.of("success", false, "message", "Phòng không tồn tại");
        }

        try {
            if (!favoriteRepository.existsByUserIdAndRoomPostId(currentUser.getId(), id)) {
                Favorite favorite = new Favorite();
                favorite.setUser(currentUser);
                favorite.setRoomPost(roomPost);
                favoriteRepository.save(favorite);
            }
            return Map.of("success", true, "message", "Đã thêm vào yêu thích");
        } catch (Exception e) {
            return Map.of("success", false, "message", "Lỗi khi thêm vào yêu thích");
        }
    }

    @PostMapping("/{id}/favorite/remove")
    @ResponseBody
    public Map<String, Object> removeFavorite(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) {
            return Map.of("success", false, "message", "Vui lòng đăng nhập");
        }

        try {
            Favorite favorite = favoriteRepository.findByUserIdAndRoomPostId(currentUser.getId(), id);
            if (favorite != null) {
                favoriteRepository.delete(favorite);
            }
            return Map.of("success", true, "message", "Đã xóa khỏi yêu thích");
        } catch (Exception e) {
            return Map.of("success", false, "message", "Lỗi khi xóa khỏi yêu thích");
        }
    }

    private RoomDetailDTO buildRoomDetailDTO(RoomPost roomPost, HttpSession session) {
        RoomDetailDTO dto = new RoomDetailDTO();
        
        // Room info
        dto.setId(roomPost.getId());
        dto.setTitle(roomPost.getTitle());
        dto.setDescription(roomPost.getDescription());
        dto.setPrice(roomPost.getPrice());
        dto.setArea(roomPost.getArea());
        dto.setAddress(roomPost.getAddress());
        dto.setCategory(roomPost.getCategory().toString());
        dto.setPhoneContact(roomPost.getPhoneContact());
        dto.setZaloContact(roomPost.getZaloContact());
        dto.setCreatedAt(roomPost.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

        // Owner info
        User owner = roomPost.getUser();
        if (owner != null && owner.getProfile() != null) {
            Profile profile = owner.getProfile();
            dto.setOwnerName(profile.getName());
            dto.setOwnerPhone(profile.getPhoneNumber());
            dto.setOwnerEmail(profile.getEmail());
            dto.setOwnerAvatar(profile.getAvatar());
        }

        // Location
        if (roomPost.getLocation() != null) {
            Location location = roomPost.getLocation();
            dto.setCity(location.getCity());
            dto.setDistrict(location.getDistrict());
            dto.setWard(location.getWard());
        }

        // Images
        if (roomPost.getRoomImages() != null && !roomPost.getRoomImages().isEmpty()) {
            dto.setRoomImages(
                roomPost.getRoomImages().stream()
                    .map(RoomImage::getImageUrl)
                    .collect(Collectors.toList())
            );
        }

        // Reviews removed from detail page — no action needed

        // Favorite status
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser != null) {
            dto.setFavorite(favoriteRepository.existsByUserIdAndRoomPostId(currentUser.getId(), roomPost.getId()));
        }

        return dto;
    }
}
