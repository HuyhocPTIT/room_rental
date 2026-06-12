package com.example.roomrental.service;

import com.example.roomrental.constant.LandlordRequestStatus;
import com.example.roomrental.constant.NotificationType;
import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.Profile;
import com.example.roomrental.entity.User;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.repository.ChatMessageRepository;
import com.example.roomrental.repository.FavoriteRepository;
import com.example.roomrental.repository.RoomPostRepository;
import com.example.roomrental.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    private final UserRepository userRepository;
    private final RoomPostRepository roomPostRepository;
    private final FavoriteRepository favoriteRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final NotificationService notificationService;
    private final com.example.roomrental.repository.RoomImageRepository roomImageRepository;

    public AdminService(UserRepository userRepository,
                        RoomPostRepository roomPostRepository,
                        FavoriteRepository favoriteRepository,
                        ChatMessageRepository chatMessageRepository,
                        NotificationService notificationService,
                        com.example.roomrental.repository.RoomImageRepository roomImageRepository) {
        this.userRepository = userRepository;
        this.roomPostRepository = roomPostRepository;
        this.favoriteRepository = favoriteRepository;
        this.chatMessageRepository = chatMessageRepository;
        this.notificationService = notificationService;
        this.roomImageRepository = roomImageRepository;
    }

    @Transactional(readOnly = true)
    public Map<String, Long> getStatistics() {
        Map<String, Long> stats = new java.util.HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalAdmins", userRepository.countByRole(UserRole.ADMIN));
        stats.put("totalTenants", userRepository.countByRole(UserRole.TENANT));
        stats.put("totalLandlords", userRepository.countByRole(UserRole.LANDLORD));
        stats.put("pendingLandlordRequests", userRepository.countByLandlordRequestStatus(LandlordRequestStatus.PENDING));
        stats.put("totalPosts", roomPostRepository.count());
        stats.put("activePosts", roomPostRepository.findByStatus(PostStatus.ACTIVE).stream().count());
        stats.put("pendingPosts", roomPostRepository.findByStatus(PostStatus.PENDING_APPROVAL).stream().count());
        stats.put("totalFavorites", favoriteRepository.count());
        stats.put("totalMessages", chatMessageRepository.count());
        return stats;
    }

    @Transactional(readOnly = true)
    public Map<UserRole, Long> countUsersByRole() {
        Map<UserRole, Long> roleCounts = new EnumMap<>(UserRole.class);
        for (UserRole role : UserRole.values()) {
            roleCounts.put(role, userRepository.countByRole(role));
        }
        return roleCounts;
    }

    @Transactional(readOnly = true)
    public List<User> getUsers() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<User> getPendingLandlordRequests() {
        return userRepository.findByLandlordRequestStatusOrderByCreatedAtDesc(LandlordRequestStatus.PENDING);
    }

    @Transactional(readOnly = true)
    public List<RoomPost> getTopFavoritedPosts(int limit) {
        return roomPostRepository.findAll().stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .sorted((p1, p2) -> {
                    long fav1 = favoriteRepository.countByRoomPost(p1);
                    long fav2 = favoriteRepository.countByRoomPost(p2);
                    return Long.compare(fav2, fav1);
                })
                .limit(limit)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<RoomPost> getRecentPosts(int limit) {
        return roomPostRepository.findAll().stream()
                .filter(post -> post.getStatus() == PostStatus.ACTIVE)
                .sorted((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()))
                .limit(limit)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<RoomPost> getPendingPosts() {
        return roomPostRepository.findByStatus(PostStatus.PENDING_APPROVAL);
    }

    @Transactional
    public void approvePost(Long postId) {
        RoomPost post = roomPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài đăng."));
        post.setStatus(PostStatus.ACTIVE);
        roomPostRepository.save(post);
    }

    @Transactional
    public void rejectPost(Long postId) {
        RoomPost post = roomPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài đăng."));
        post.setStatus(PostStatus.HIDDEN);
        roomPostRepository.save(post);
    }

    @Transactional
    public void deletePost(Long postId) {
        RoomPost post = roomPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài đăng."));
        if (post.getRoomImages() != null && !post.getRoomImages().isEmpty()) {
            roomImageRepository.deleteAll(post.getRoomImages());
        }
        if (post.getFavorites() != null && !post.getFavorites().isEmpty()) {
            favoriteRepository.deleteAll(post.getFavorites());
        }
        roomPostRepository.delete(post);
    }

    @Transactional(readOnly = true)
    public long getFavoriteCountForPost(Long postId) {
        RoomPost post = roomPostRepository.findById(postId).orElse(null);
        if (post == null) return 0;
        return favoriteRepository.countByRoomPost(post);
    }

    @Transactional
    public void createUser(String username,
                           String password,
                           UserRole role,
                           String name,
                           String phoneNumber,
                           String email) {
        String normalizedUsername = normalize(username);
        if (!StringUtils.hasText(normalizedUsername)) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        if (!StringUtils.hasText(password)) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (userRepository.existsByUsername(normalizedUsername)) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
        }

        Profile profile = new Profile();
        profile.setName(normalize(name));
        profile.setPhoneNumber(normalize(phoneNumber));
        profile.setEmail(normalize(email));

        User user = new User();
        user.setUsername(normalizedUsername);
        user.setPassword(password);
        user.setRole(role);
        user.setLandlordRequestStatus(role == UserRole.LANDLORD
                ? LandlordRequestStatus.APPROVED
                : LandlordRequestStatus.NONE);
        user.setProfile(profile);

        userRepository.save(user);
    }

    @Transactional
    public void updateUser(Long userId,
                           String username,
                           String password,
                           UserRole role,
                           String name,
                           String phoneNumber,
                           String email) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng."));

        String normalizedUsername = normalize(username);
        if (!StringUtils.hasText(normalizedUsername)) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }

        userRepository.findByUsername(normalizedUsername)
                .filter(existing -> !existing.getId().equals(userId))
                .ifPresent(existing -> {
                    throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
                });

        user.setUsername(normalizedUsername);
        if (StringUtils.hasText(password)) {
            user.setPassword(password);
        }
        user.setRole(role);
        if (role == UserRole.LANDLORD) {
            user.setLandlordRequestStatus(LandlordRequestStatus.APPROVED);
        } else if (role == UserRole.TENANT && user.getLandlordRequestStatus() == LandlordRequestStatus.APPROVED) {
            user.setLandlordRequestStatus(LandlordRequestStatus.NONE);
        }

        Profile profile = user.getProfile();
        if (profile == null) {
            profile = new Profile();
            user.setProfile(profile);
        }
        profile.setName(normalize(name));
        profile.setPhoneNumber(normalize(phoneNumber));
        profile.setEmail(normalize(email));
    }

    @Transactional
    public void deleteUser(Long userId, Long currentAdminId) {
        if (userId.equals(currentAdminId)) {
            throw new IllegalArgumentException("Admin không thể tự xóa tài khoản đang đăng nhập.");
        }
        userRepository.deleteById(userId);
    }

    @Transactional
    public void approveLandlord(Long userId, Long adminId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng."));
        user.setRole(UserRole.LANDLORD);
        user.setLandlordRequestStatus(LandlordRequestStatus.APPROVED);

        notificationService.createNotification(
                user.getId(),
                adminId,
                "Yêu cầu trở thành người cho thuê của bạn đã được admin duyệt.",
                NotificationType.UPGRADE_TO_LANDLORD
        );
    }

    @Transactional
    public void rejectLandlord(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng."));
        user.setLandlordRequestStatus(LandlordRequestStatus.REJECTED);
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
