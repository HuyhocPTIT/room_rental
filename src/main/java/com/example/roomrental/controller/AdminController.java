package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.AdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping
    public String adminDashboard(HttpSession session, Model model) {
        User currentUser = requireAdmin(session);
        if (currentUser == null) return "redirect:/auth/login";

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("stats", adminService.getStatistics());
        model.addAttribute("roleCounts", adminService.countUsersByRole());
        model.addAttribute("users", adminService.getUsers());
        model.addAttribute("pendingLandlordRequests", adminService.getPendingLandlordRequests());
        model.addAttribute("pendingPosts", adminService.getPendingPosts());
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("topFavoritedPosts", adminService.getTopFavoritedPosts(5));
        model.addAttribute("recentPosts", adminService.getRecentPosts(5));
        return "admin/index";
    }

    @PostMapping("/users/create")
    public String createUser(@RequestParam String username,
                             @RequestParam String password,
                             @RequestParam UserRole role,
                             @RequestParam(required = false) String name,
                             @RequestParam(required = false) String phoneNumber,
                             @RequestParam(required = false) String email,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.createUser(username, password, role, name, phoneNumber, email);
            redirectAttributes.addFlashAttribute("success", "Đã thêm người dùng mới.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#users";
    }

    @PostMapping("/users/{id}/update")
    public String updateUser(@PathVariable Long id,
                             @RequestParam String username,
                             @RequestParam(required = false) String password,
                             @RequestParam UserRole role,
                             @RequestParam(required = false) String name,
                             @RequestParam(required = false) String phoneNumber,
                             @RequestParam(required = false) String email,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.updateUser(id, username, password, role, name, phoneNumber, email);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật người dùng.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#users";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User admin = requireAdmin(session);
        if (admin == null) return "redirect:/auth/login";
        try {
            adminService.deleteUser(id, admin.getId());
            redirectAttributes.addFlashAttribute("success", "Đã xóa người dùng.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa người dùng này vì đang có dữ liệu liên quan.");
        }
        return "redirect:/admin#users";
    }

    @PostMapping("/users/{id}/approve-landlord")
    public String approveLandlord(@PathVariable Long id,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        User admin = requireAdmin(session);
        if (admin == null) return "redirect:/auth/login";
        try {
            adminService.approveLandlord(id, admin.getId());
            redirectAttributes.addFlashAttribute("success", "Đã duyệt người dùng thành người cho thuê.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#landlord-requests";
    }

    @PostMapping("/users/{id}/reject-landlord")
    public String rejectLandlord(@PathVariable Long id,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.rejectLandlord(id);
            redirectAttributes.addFlashAttribute("success", "Đã từ chối yêu cầu trở thành người cho thuê.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#landlord-requests";
    }

    @PostMapping("/posts/{id}/approve")
    public String approvePost(@PathVariable Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.approvePost(id);
            redirectAttributes.addFlashAttribute("success", "Đã duyệt bài đăng.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#post-moderation";
    }

    @PostMapping("/posts/{id}/reject")
    public String rejectPost(@PathVariable Long id,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.rejectPost(id);
            redirectAttributes.addFlashAttribute("success", "Đã ẩn bài đăng.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin#post-moderation";
    }

    @PostMapping("/posts/{id}/delete")
    public String deletePost(@PathVariable Long id,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (requireAdmin(session) == null) return "redirect:/auth/login";
        try {
            adminService.deletePost(id);
            redirectAttributes.addFlashAttribute("success", "Đã xóa bài đăng.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin";
    }

    private User requireAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null || currentUser.getRole() != UserRole.ADMIN) {
            return null;
        }
        return currentUser;
    }
}
