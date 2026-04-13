package com.example.roomrental.service;

import com.example.roomrental.constant.UserRole;
import com.example.roomrental.dto.auth.LoginRequest;
import com.example.roomrental.dto.auth.RegisterRequest;
import com.example.roomrental.entity.Profile;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class AuthService {

    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional
    public User register(RegisterRequest request) {
        String username = normalize(request.getUsername());
        String password = request.getPassword();
        String confirmPassword = request.getConfirmPassword();

        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        if (!StringUtils.hasText(password)) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự.");
        }
        if (!password.equals(confirmPassword)) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
        }
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
        }

        Profile profile = new Profile();
        profile.setName(normalize(request.getFullName()));
        profile.setEmail(normalize(request.getEmail()));
        profile.setPhoneNumber(normalize(request.getPhoneNumber()));

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(UserRole.TENANT);
        user.setProfile(profile);

        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User login(LoginRequest request) {
        String username = normalize(request.getUsername());
        String password = request.getPassword();

        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
        }

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Sai tên đăng nhập hoặc mật khẩu."));

        if (!password.equals(user.getPassword())) {
            throw new IllegalArgumentException("Sai tên đăng nhập hoặc mật khẩu.");
        }

        return user;
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
