package com.example.roomrental.repository;

import com.example.roomrental.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    // Lấy lịch sử chat giữa User A và User B (sắp xếp theo thời gian)
    @Query("SELECT m FROM ChatMessage m WHERE " +
            "(m.sender.id = :u1 AND m.receiver.id = :u2) OR " +
            "(m.sender.id = :u2 AND m.receiver.id = :u1) " +
            "ORDER BY m.timestamp ASC")
    List<ChatMessage> findChatHistory(@Param("u1") Long user1, @Param("u2") Long user2);

}
