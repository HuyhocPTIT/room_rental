package com.example.roomrental.service;

import com.example.roomrental.constant.NotificationType;
import com.example.roomrental.dto.ChatMessageDTO;
import com.example.roomrental.entity.ChatMessage;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.ChatMessageRepository;
import com.example.roomrental.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

@Service
public class ChatService {

    @Autowired
    private ChatMessageRepository chatRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private UserRepository userRepository;

    public ChatMessage saveMessage(ChatMessageDTO dto) {

        User sender = userRepository.findById(dto.getSenderId())
                .orElseThrow(() -> new RuntimeException("Sender not found"));

        User receiver = userRepository.findById(dto.getReceiverId())
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        ChatMessage message = new ChatMessage();
        message.setSender(sender);
        message.setReceiver(receiver);
        message.setContent(dto.getContent());
        message.setTimestamp(LocalDateTime.now());

        ChatMessage saved = chatRepository.save(message);

        notificationService.createNotification(
                receiver.getId(),   // ai nhận
                sender.getId(),     // ai gửi
                "Tin nhắn mới",
                NotificationType.CHAT
        );

        HashMap<String, Object> payload = new HashMap<>();
        payload.put("id", saved.getId());
        payload.put("senderId", sender.getId());
        payload.put("content", saved.getContent());
        payload.put("senderName", sender.getUsername());
        payload.put("type", "CHAT");

        messagingTemplate.convertAndSend(
                "/topic/messages/" + receiver.getId(),
                (Object) payload
        );

        return saved;
    }

    public List<ChatMessage> getChatHistory(Long senderId, Long receiverId) {
        return chatRepository.findChatHistory(senderId, receiverId);
    }
}
