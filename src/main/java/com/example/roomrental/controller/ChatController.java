package com.example.roomrental.controller;

import com.example.roomrental.dto.ChatMessageDTO;
import com.example.roomrental.entity.ChatMessage;
import com.example.roomrental.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Slf4j
@Controller
public class ChatController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private ChatService chatService;

    @MessageMapping("/send-message")
    public void sendMessage(@Payload ChatMessageDTO requestDto) {

        ChatMessage saved = chatService.saveMessage(requestDto);

        ChatMessageDTO responseDto = new ChatMessageDTO();
        responseDto.setId(saved.getId());
        responseDto.setSenderId(saved.getSender().getId());
        responseDto.setReceiverId(saved.getReceiver().getId());
        responseDto.setContent(saved.getContent());
        responseDto.setTimestamp(saved.getTimestamp());
        responseDto.setRead(saved.isRead());

        messagingTemplate.convertAndSend(
                "/topic/messages/" + responseDto.getReceiverId(),
                (Object) responseDto
        );
    }

    @GetMapping("/api/chat/history")
    @ResponseBody
    public List<ChatMessageDTO> getHistory(
            @RequestParam String senderId,
            @RequestParam String receiverId) {

        List<ChatMessage> history = chatService.getChatHistory(
                Long.parseLong(senderId),
                Long.parseLong(receiverId)
        );

        return history.stream().map(m -> {
            ChatMessageDTO dto = new ChatMessageDTO();
            dto.setId(m.getId());
            dto.setSenderId(m.getSender().getId());
            dto.setReceiverId(m.getReceiver().getId());
            dto.setContent(m.getContent());
            dto.setTimestamp(m.getTimestamp());
            dto.setRead(m.isRead());
            return dto;
        }).toList();
    }
}
