package com.example.roomrental.controller;

import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.dto.auth.LoginRequest;
import com.example.roomrental.dto.auth.RegisterRequest;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser != null) {
            return redirectByRole(currentUser);
        }
        if (!model.containsAttribute("loginRequest")) {
            model.addAttribute("loginRequest", new LoginRequest());
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute("loginRequest") LoginRequest loginRequest,
                        HttpSession session,
                        Model model) {
        try {
            User user = authService.login(loginRequest);
            session.setAttribute(SessionAttribute.CURRENT_USER, user);
            return redirectByRole(user);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            return "auth/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (currentUser != null) {
            return redirectByRole(currentUser);
        }
        if (!model.containsAttribute("registerRequest")) {
            model.addAttribute("registerRequest", new RegisterRequest());
        }
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute("registerRequest") RegisterRequest registerRequest,
                           HttpSession session,
                           Model model) {
        try {
            User user = authService.register(registerRequest);
            session.setAttribute(SessionAttribute.CURRENT_USER, user);
            return redirectByRole(user);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            return "auth/register";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    private String redirectByRole(User user) {
        if (user.getRole() == UserRole.ADMIN) {
            return "redirect:/admin";
        }
        return "redirect:/";
    }
}
