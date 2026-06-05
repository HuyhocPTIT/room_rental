package com.example.roomrental.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Kích hoạt một broker đơn giản để gửi tin nhắn về client
        config.enableSimpleBroker("/topic", "/queue");
        // Tiền tố cho các đường dẫn mà client gửi tin lên server
        config.setApplicationDestinationPrefixes("/app");
        // Cấu hình gửi tin nhắn riêng cho từng user
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Đăng ký endpoint để client kết nối tới
        registry.addEndpoint("/ws")
                .addInterceptors(new org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor())
                .withSockJS();
    }
}
