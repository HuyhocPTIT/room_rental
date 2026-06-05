package com.example.roomrental.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatContactDTO {
    private Long contactId;
    private String contactName;
    private String contactAvatar;
    private String lastMessage;
    private LocalDateTime lastMessageTime;
    private boolean hasUnread;
}
