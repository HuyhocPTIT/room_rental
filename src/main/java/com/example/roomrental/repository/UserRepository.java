package com.example.roomrental.repository;

import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByUsername(String username);

    Optional<User> findByUsername(String username);

    List<User> findByRole(UserRole role);
}
