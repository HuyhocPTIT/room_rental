package com.example.roomrental.controller;

import com.example.roomrental.service.RoomPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private RoomPostService roomPostService;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("featuredRooms", roomPostService.getFeaturedRooms(6));
        model.addAttribute("newestRooms", roomPostService.getNewestRooms(8));
        return "index";
    }
}