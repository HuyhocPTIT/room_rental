package com.example.roomrental.service;

import com.example.roomrental.constant.NotificationType;
import com.example.roomrental.dto.NotificationResponse;
import com.example.roomrental.entity.Notification;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.NotificationRepository;
import com.example.roomrental.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    private final SimpMessagingTemplate messagingTemplate;

    private final UserRepository userRepository;

    public List<Notification> getTop5ByReceiver(Long userId) {
        return notificationRepository
                .findTop5ByReceiverIdOrderByCreatedAtDesc(userId);
    }

    public void createNotification(
            Long receiverId,
            Long senderId,
            String content,
            NotificationType type
    ) {

        User sender = userRepository.findById(senderId).orElse(null);
        User receiver = userRepository.findById(receiverId).orElse(null);

        Notification notification = Notification.builder()
                .receiver(receiver)
                .sender(sender)
                .content(content)
                .type(type)
                .isRead(false)
                .build();

        notification = notificationRepository.save(notification);

        NotificationResponse response = NotificationResponse.builder()
                .id(notification.getId())
                .content(notification.getContent())
                .type(notification.getType())
                .read(notification.getIsRead())
                .senderId(
                        sender != null ? sender.getId() : null
                )
                .senderName(
                        sender != null ? sender.getUsername() : null
                )
                .build();

        messagingTemplate.convertAndSendToUser(
                receiver.getId().toString(),
                "/queue/notifications",
                response
        );

        messagingTemplate.convertAndSend(
                "/topic/notifications/" + receiver.getId(),
                response
        );
    }

    public void markAsRead(Long id) {
        Notification notification = notificationRepository.findById(id).orElseThrow();

        notification.setIsRead(true);

        notificationRepository.save(notification);
    }
}
