package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.entity.Profile;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserRepository userRepository;

    public ProfileController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public String getProfile(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) return "redirect:/auth/login";

        Profile profile = currentUser.getProfile();
        if (profile == null) profile = new Profile();

        model.addAttribute("user", currentUser);
        model.addAttribute("profile", profile);
        return "profile/profile";
    }

    @PostMapping("/update")
    public String updateProfile(
            @RequestParam String name,
            @RequestParam String phoneNumber,
            @RequestParam String email,
            HttpSession session,
            RedirectAttributes ra
    ) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser == null) return "redirect:/auth/login";

        Profile profile = currentUser.getProfile();
        if (profile == null) profile = new Profile();

        profile.setName(name);
        profile.setPhoneNumber(phoneNumber);
        profile.setEmail(email);

        currentUser.setProfile(profile);
        userRepository.save(currentUser);

        session.setAttribute(SessionAttribute.CURRENT_USER, currentUser);
        ra.addFlashAttribute("success", "Cập nhật thông tin thành công");
        return "redirect:/profile";
    }
}
