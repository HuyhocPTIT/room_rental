package com.example.roomrental.controller;

import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.service.RoomPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/rooms")
public class RoomPostController {

    @Autowired
    private RoomPostService roomPostService;

    // Trang danh sách phòng (có tìm kiếm và lọc)
    @GetMapping
    public String listRooms(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Float minPrice,
            @RequestParam(required = false) Float maxPrice,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) RoomCategory category,
            @RequestParam(required = false) Integer minBedrooms,
            Model model) {

        List<RoomPost> rooms;
        
        if (keyword != null || minPrice != null || maxPrice != null || 
            city != null || district != null || category != null || minBedrooms != null) {
            rooms = roomPostService.searchAndFilter(keyword, minPrice, maxPrice, city, district, category, minBedrooms);
        } else {
            rooms = roomPostService.getAllActivePosts();
        }

        model.addAttribute("rooms", rooms);
        model.addAttribute("keyword", keyword);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("city", city);
        model.addAttribute("district", district);
        model.addAttribute("category", category);
        model.addAttribute("minBedrooms", minBedrooms);
        model.addAttribute("categories", RoomCategory.values());

        return "list";
    }

    // Chi tiết phòng (GET)
    @GetMapping("/{id}")
    public String viewRoomDetail(@PathVariable Long id, Model model) {
        RoomPost room = roomPostService.getRoomPostById(id);
        if (room == null) {
            return "redirect:/rooms";
        }
        model.addAttribute("room", room);
        return "detail";
    }

    // API: Lấy chi tiết phòng dưới dạng JSON
    @GetMapping("/api/{id}")
    @ResponseBody
    public RoomPost getRoomJson(@PathVariable Long id) {
        return roomPostService.getRoomPostById(id);
    }
}
