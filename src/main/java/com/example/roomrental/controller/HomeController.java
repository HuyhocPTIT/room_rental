package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.FavoriteRepository;
import com.example.roomrental.service.RoomPostService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private RoomPostService roomPostService;

    @Autowired
    private FavoriteRepository favoriteRepository;

    @GetMapping("/")
    public String home(@RequestParam(defaultValue = "0") int page,
                       @RequestParam(defaultValue = "6") int size,
                       Model model) {
        Page<RoomPost> roomPage = roomPostService.getActivePosts(PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
        model.addAttribute("roomPosts", roomPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", roomPage.getTotalPages());
        return "index";
    }

    @GetMapping("/favorites")
    public String favorites(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) {
            model.addAttribute("roomPosts", List.of());
            model.addAttribute("errorMessage", "Bạn cần đăng nhập để xem phòng đã lưu.");
        } else {
            model.addAttribute("roomPosts", favoriteRepository.findAllByUserIdOrderByCreatedAtDesc(currentUser.getId())
                    .stream()
                    .map(favorite -> favorite.getRoomPost())
                    .toList());
        }
        model.addAttribute("currentPage", 0);
        model.addAttribute("totalPages", 0);
        return "favorites";
    }
}