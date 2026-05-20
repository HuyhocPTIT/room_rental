package com.example.roomrental.repository;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RoomPostRepository extends JpaRepository<RoomPost, Long> {
    List<RoomPost> findByStatus(PostStatus status);

    List<RoomPost> findAllByUserId(Long userId);

    List<RoomPost> findByUser(User user);

    @Query("select distinct p from RoomPost p left join fetch p.roomImages where p.status = :status")
    Page<RoomPost> findByStatus(PostStatus status, Pageable pageable);

    List<RoomPost> findByUserOrderByCreatedAtDesc(User user);
    Page<RoomPost> findByStatusAndCategory(PostStatus status, RoomCategory category, Pageable pageable);

    @Query("SELECT r FROM RoomPost r WHERE r.status = :status " +
            "AND (:province IS NULL OR r.address LIKE %:province%) " +
            "AND (:category IS NULL OR r.category = :category) " +
            "AND (:minPrice IS NULL OR r.price >= :minPrice) " +
            "AND (:maxPrice IS NULL OR r.price <= :maxPrice)")
    Page<RoomPost> searchActivePosts(
            @Param("status") PostStatus status,
            @Param("province") String province,
            @Param("category") RoomCategory category,
            @Param("minPrice") Double minPrice,
            @Param("maxPrice") Double maxPrice,
            Pageable pageable);
}
