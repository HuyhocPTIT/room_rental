package com.example.roomrental.controller;

import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.FavoriteService;
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

import java.util.ArrayList;
import java.util.List;


@Controller
public class HomeController {

    @Autowired
    private RoomPostService roomPostService;

    @Autowired
    private FavoriteService favoriteService;

    @GetMapping("/")
    public String home(@RequestParam(defaultValue = "0") int page,
                       @RequestParam(defaultValue = "6") int size,
                       HttpSession session,
                       Model model) {
        Page<RoomPost> roomPage = roomPostService.getActivePosts(PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
        model.addAttribute("roomPosts", roomPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", roomPage.getTotalPages());

        // Khởi tạo một list rỗng
        List<Long> savedPostIds = new ArrayList<>();

        // Kiểm tra xem có user đăng nhập không
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            // Lấy danh sách các bài đăng mà user này đã lưu
            savedPostIds = favoriteService.getSavedPostIdsByUser(currentUser);
        }

        model.addAttribute("savedPostIds", savedPostIds);
        return "index";
    }
}