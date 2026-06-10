package com.example.roomrental.service;

import com.example.roomrental.constant.LandlordRequestStatus;
import com.example.roomrental.constant.NotificationType;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LandlordRequestService {

    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public LandlordRequestService(UserRepository userRepository, NotificationService notificationService) {
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    @Transactional
    public void requestLandlord(User currentUser) {
        User user = userRepository.findById(currentUser.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay nguoi dung."));

        if (user.getRole() == UserRole.LANDLORD || user.getRole() == UserRole.ADMIN) {
            throw new IllegalArgumentException("Tai khoan nay khong can gui yeu cau.");
        }
        if (user.getLandlordRequestStatus() == LandlordRequestStatus.PENDING) {
            throw new IllegalArgumentException("Yeu cau cua ban dang cho admin duyet.");
        }

        user.setLandlordRequestStatus(LandlordRequestStatus.PENDING);

        userRepository.findByRole(UserRole.ADMIN).forEach(admin ->
                notificationService.createNotification(
                        admin.getId(),
                        user.getId(),
                        user.getUsername() + " da gui yeu cau tro thanh nguoi cho thue.",
                        NotificationType.LANDLORD_REQUEST
                )
        );
    }
}
