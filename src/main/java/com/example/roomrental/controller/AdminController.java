package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping
    public String adminDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);

        if (currentUser == null) {
            return "redirect:/auth/login";
        }

        if (currentUser.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }

        model.addAttribute("currentUser", currentUser);
        return "admin/index";
    }
}
