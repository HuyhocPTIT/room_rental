package com.example.roomrental.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // Ánh xạ đường dẫn gốc "/" (Trang chủ)
    @GetMapping("/")
    public String home(Model model) {
        /* * Sau này, bạn sẽ gọi RoomPostService ở đây để lấy dữ liệu từ Database.
         * Ví dụ:
         * List<RoomPost> featuredRooms = roomPostService.getFeaturedRooms();
         * model.addAttribute("featuredRooms", featuredRooms);
         * * List<RoomPost> newestRooms = roomPostService.getNewestRooms();
         * model.addAttribute("newestRooms", newestRooms);
         */

        // Trả về tên file jsp (không cần đuôi .jsp).
        // Dựa vào cấu hình trong application.properties, Spring sẽ tự tìm file ở /WEB-INF/views/index.jsp
        return "index";
    }
}