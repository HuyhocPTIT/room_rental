package com.example.roomrental.dto;


import com.example.roomrental.constant.NotificationType;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NotificationResponse {

    private Long id;

    private String content;

    private NotificationType type;

    private Boolean read;

    private Long senderId;

    private String senderName;
}