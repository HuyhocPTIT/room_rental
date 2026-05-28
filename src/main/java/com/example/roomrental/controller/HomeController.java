package com.example.roomrental.controller;

import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.entity.Notification;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.FavoriteService;
import com.example.roomrental.service.NotificationService;
import com.example.roomrental.service.RoomPostService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class HomeController {

    @Autowired
    private RoomPostService roomPostService;

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/")
    public String home(@RequestParam(required = false) String province,
                       @RequestParam(required = false) String priceRange,
                       @RequestParam(required = false) RoomCategory category,
                       @RequestParam(defaultValue = "0") int page,
                       @RequestParam(defaultValue = "6") int size,
                       HttpSession session,
                       Model model) {
        Page<RoomPost> roomPage = roomPostService.searchPosts(province, priceRange, category, PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
        model.addAttribute("roomPosts", roomPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", roomPage.getTotalPages());
        model.addAttribute("province", province);
        model.addAttribute("priceRange", priceRange);
        model.addAttribute("category", category);

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

    @GetMapping("/notifications/api")
    @ResponseBody
    public List<Map<String, Object>> getNotifications(HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");

        List<Notification> list =
                notificationService.getTop5ByReceiver(currentUser.getId());
        //log.debug(list.toString());
        return list.stream().map(n -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", n.getId());
            map.put("type", n.getType().name());
            map.put("content", n.getContent());
            map.put("read", n.getIsRead());
            map.put("receiverId", n.getReceiver().getId());
            map.put("senderId", n.getSender().getId());
            map.put("senderName", n.getSender().getUsername());
            map.put("receiverName", n.getReceiver().getUsername());
            return map;
        }).toList();
    }

    @PostMapping("/notifications/read/{id}")
    @ResponseBody
    public void markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
    }
}