package com.example.roomrental.controller;

import com.example.roomrental.constant.LandlordRequestStatus;
import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.LandlordRequestService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LandlordRequestController {

    private final LandlordRequestService landlordRequestService;

    public LandlordRequestController(LandlordRequestService landlordRequestService) {
        this.landlordRequestService = landlordRequestService;
    }

    @PostMapping("/landlord-request")
    public String requestLandlord(HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) {
            return "redirect:/auth/login";
        }

        try {
            landlordRequestService.requestLandlord(currentUser);
            currentUser.setLandlordRequestStatus(LandlordRequestStatus.PENDING);
            session.setAttribute(SessionAttribute.CURRENT_USER, currentUser);
            redirectAttributes.addFlashAttribute("success", "Yeu cau cua ban da duoc gui den admin.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }

        return "redirect:/";
    }
}
