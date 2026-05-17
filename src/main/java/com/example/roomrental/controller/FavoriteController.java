package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.entity.*;
import com.example.roomrental.service.FavoriteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/favorites")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @GetMapping
    public String favorites(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) {
            model.addAttribute("roomPosts", List.of());
            model.addAttribute("errorMessage", "Bạn cần đăng nhập để xem phòng đã lưu.");
        } else {
            model.addAttribute("roomPosts", favoriteService.findAllByUserIdOrderByCreatedAtDesc(currentUser.getId())
                    .stream()
                    .map(Favorite::getRoomPost)
                    .toList());
        }
        model.addAttribute("currentPage", 0);
        model.addAttribute("totalPages", 0);
        return "favorite/favorites";
    }

    @PostMapping("toggle")
    public ResponseEntity<?> toggleFavorite(@RequestParam Long postId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Vui lòng đăng nhập!");
        }

        try {
            boolean isFavorite = favoriteService.toggleFavorite(currentUser, postId);
            return ResponseEntity.ok(isFavorite);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
}
