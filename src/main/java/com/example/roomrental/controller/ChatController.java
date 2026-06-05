package com.example.roomrental.controller;

import com.example.roomrental.dto.ChatMessageDTO;
import com.example.roomrental.entity.ChatMessage;
import com.example.roomrental.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.roomrental.entity.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.web.bind.annotation.PostMapping;
import jakarta.servlet.http.HttpServletRequest;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
public class ChatController {

    @Autowired
    private ChatService chatService;

    @MessageMapping("/send-message")
    public void sendMessage(@Payload ChatMessageDTO requestDto, SimpMessageHeaderAccessor headerAccessor) {

        Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();
        User currentUser = null;
        if (sessionAttributes != null) {
            currentUser = (User) sessionAttributes.get("currentUser");
        }

        if (currentUser == null) {
            log.error("Unauthenticated user tried to send a message.");
            return;
        }

        // Force senderId to be the logged in user
        requestDto.setSenderId(currentUser.getId());

        // chatService.saveMessage will save to DB and send WebSocket message
        chatService.saveMessage(requestDto);
    }

    @GetMapping("/api/chat/history")
    @ResponseBody
    public ResponseEntity<?> getHistory(
            @RequestParam String receiverId,
            HttpServletRequest request) {

        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
        }

        List<ChatMessage> history = chatService.getChatHistory(
                currentUser.getId(),
                Long.parseLong(receiverId)
        );

        List<ChatMessageDTO> dtoList = history.stream().map(m -> {
            ChatMessageDTO dto = new ChatMessageDTO();
            dto.setId(m.getId());
            dto.setSenderId(m.getSender().getId());
            dto.setReceiverId(m.getReceiver().getId());
            dto.setContent(m.getContent());
            dto.setTimestamp(m.getTimestamp());
            dto.setRead(m.isRead());
            return dto;
        }).toList();

        return ResponseEntity.ok(dtoList);
    }

    @PostMapping("/api/chat/mark-read")
    @ResponseBody
    public ResponseEntity<?> markAsRead(
            @RequestParam String senderId,
            HttpServletRequest request) {

        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
        }

        chatService.markMessagesAsRead(Long.parseLong(senderId), currentUser.getId());
        return ResponseEntity.ok(Map.of("success", true));
    }

    @GetMapping("/api/chat/contacts")
    @ResponseBody
    public ResponseEntity<?> getContacts(
            @RequestParam(defaultValue = "0") int offset,
            @RequestParam(defaultValue = "5") int limit,
            HttpServletRequest request) {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
        }
        
        List<com.example.roomrental.dto.ChatContactDTO> contacts = chatService.getRecentContacts(currentUser.getId(), offset, limit);
        return ResponseEntity.ok(contacts);
    }
}
