package com.example.roomrental.controller;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.constant.SessionAttribute;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.Location; // Đảm bảo đã import Entity này
import com.example.roomrental.entity.RoomImage;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.service.CloudinaryService;
import com.example.roomrental.service.LocationService;
import com.example.roomrental.service.PostService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@Slf4j
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private CloudinaryService cloudinaryService;

    @Autowired
    private LocationService locationService;

    /**
     * Hiển thị danh sách bài đăng của tôi và nạp danh sách khu vực vào Modal
     */
    @GetMapping("/post-management")
    public String myPost(Model model, HttpSession session) {
        // 1. Lấy thông tin user hiện tại từ session
        User currentUser = (User) session.getAttribute(SessionAttribute.CURRENT_USER);

        // 2. Kiểm tra nếu chưa đăng nhập thì chuyển hướng
        if (currentUser == null) {
            return "redirect:/auth/login";
        }

        if (!UserRole.LANDLORD.equals(currentUser.getRole())) {
            return "redirect:/home?error=no_permission";
        }

        // Lấy danh sách phòng trọ của User
        List<RoomPost> rooms = postService.findByUser(currentUser);
        model.addAttribute("rooms", rooms);

        // 🌟 BỔ SUNG: Lấy danh sách vị trí/khu vực đổ vào Dropdown trong JSP Modal
        List<Location> locations = locationService.getLocations(); // Hoặc hàm tương đương trong LocationService của bạn
        model.addAttribute("locations", locations);

        return "postmanage/index";
    }

    /**
     * Xử lý Đăng tin mới (Khớp URL /post-room với Form JSP mới)
     */
    @PostMapping("/post-room")
    public String createRoom(
            @RequestParam("title") String title,
            @RequestParam("address") String address,
            @RequestParam("category") String category,
            @RequestParam("price") float price,
            @RequestParam("area") Integer area,             // 🌟 Bổ sung nhận diện Diện tích
            @RequestParam("locationId") Long locationId,   // 🌟 Bổ sung nhận diện ID Khu vực
            @RequestParam("phone") String phone,           // 🌟 Bổ sung nhận diện SĐT
            @RequestParam(value = "zalo", required = false) String zalo, // 🌟 Bổ sung nhận diện Zalo (Không bắt buộc)
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            @RequestParam("description")  String description,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User user = (User) session.getAttribute(SessionAttribute.CURRENT_USER);
        if (user == null) {
            return "redirect:/auth/login";
        }

        try {
            // Khởi tạo đối tượng Post bài đăng phòng trọ
            RoomPost room = new RoomPost();
            room.setTitle(title);
            room.setId(null);
            room.setStatus(PostStatus.PENDING_APPROVAL);
            room.setAddress(address);
            room.setCategory(RoomCategory.valueOf(category));
            room.setPrice(price);
            room.setDescription(description);
            room.setUser(user);

            // 🌟 Thiết lập các trường thông tin mới vào Entity của bạn
            room.setArea(area);
            room.setPhoneContact(phone);
            room.setZaloContact(zalo);

            // 🌟 Lấy đối tượng Location từ database bằng ID và map vào phòng
            Location location = locationService.findById(locationId);
            room.setLocation(location);

            // Lưu phòng trước để sinh ID cha
            postService.save(room);

            // Upload nhiều ảnh lên Cloudinary
            List<RoomImage> imageList = new ArrayList<>();
            if (images != null) {
                for (MultipartFile file : images) {
                    if (!file.isEmpty()) {
                        String imageUrl = cloudinaryService.uploadFile(file);

                        RoomImage roomImage = new RoomImage();
                        roomImage.setImageUrl(imageUrl);
                        roomImage.setRoomPost(room);

                        imageList.add(roomImage);
                    }
                }
            }

            if (!imageList.isEmpty()) {
                postService.saveAll(imageList);
            }

            redirectAttributes.addFlashAttribute("success", "Đăng tin phòng trọ thành công, đang chờ duyệt!");
        } catch (Exception e) {
            log.error("Lỗi khi đăng bài viết mới: ", e);
            redirectAttributes.addFlashAttribute("error", "Đăng tin thất bại! Vui lòng kiểm tra lại dữ liệu.");
        }

        return "redirect:/post-management";
    }

    @PostMapping("/update-post")
    public String updateRoom(
            @RequestParam("id") Long id,
            @RequestParam("title") String title,
            @RequestParam("address") String address,
            @RequestParam("category") String category,
            @RequestParam("price") float price,
            @RequestParam("description") String description,
            @RequestParam(value = "images", required = false) MultipartFile[] images,
            @RequestParam("locationId") Long locationId,
            HttpSession session
    ) {
        RoomPost room = postService.findById(id);
        if (room != null) {
            room.setTitle(title);
            room.setAddress(address);
            room.setCategory(RoomCategory.valueOf(category));
            room.setPrice(price);
            room.setDescription(description);
            Location location = locationService.findById(locationId);
            room.setLocation(location);
            // Xử lý ảnh mới nếu có
            if (images != null && images.length > 0 && !images[0].isEmpty()) {
                for (MultipartFile file : images) {
                    String imageUrl = cloudinaryService.uploadFile(file);
                    RoomImage roomImage = new RoomImage();
                    roomImage.setImageUrl(imageUrl);
                    roomImage.setRoomPost(room);
                    postService.saveImage(roomImage);
                }
            }
            log.info(room.toString());
            postService.save(room);
        }
        return "redirect:/post-management";
    }

    @GetMapping("/delete-post/{id}")
    public String deleteRoom(@PathVariable Long id,
                             RedirectAttributes redirectAttributes) {
        try {
            RoomPost post = postService.findById(id);
            if (post != null) {
                log.info("Đang xóa bài đăng: " + post.getTitle());

                List<RoomImage> images = postService.findByRoomPost(post);
                if (!images.isEmpty()) {
                    postService.deletePostImage(images);
                }

                postService.deletePost(post.getId());
                redirectAttributes.addFlashAttribute("success", "Xóa bài đăng thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy bài đăng!");
            }
        } catch (Exception e) {
            log.error("Lỗi xóa bài: ", e);
            redirectAttributes.addFlashAttribute("error", "Xóa thất bại!");
        }
        return "redirect:/post-management";
    }

    @DeleteMapping("/delete-room-image/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteRoomImage(@PathVariable Long id) {

        try {

            RoomImage image = postService.findImageById(id);

            if (image == null) {
                return ResponseEntity.notFound().build();
            }

            // Nếu muốn xóa luôn cloudinary:
            // cloudinaryService.deleteFile(image.getImageUrl());

            postService.deleteImage(image);

            return ResponseEntity.ok().build();

        } catch (Exception e) {

            log.error("Lỗi xóa ảnh", e);

            return ResponseEntity.badRequest().build();
        }
    }
}