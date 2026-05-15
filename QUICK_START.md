# 🚀 QUICK START - CHI TIẾT PHÒNG

## 1️⃣ Chuẩn Bị

### Database Tự Động
- JPA sẽ tự tạo 2 bảng mới:
  - `reviews` - Lưu đánh giá và bình luận
  - `bookings` - Lưu đơn đặt phòng

### Build Project
```bash
mvn clean install
# Hoặc chỉ compile
mvn compile
```

### Run Project
```bash
mvn spring-boot:run
# Hoặc bấm F5 trong VS Code (Spring Boot Extension)
```

## 2️⃣ Test Chức Năng

### A. Trang Chủ → Chi Tiết Phòng
1. Truy cập: `http://localhost:8082/`
2. Bấm vào bất kỳ phòng nào
3. Sẽ thấy trang chi tiết phòng đầy đủ

### B. Xem Hình Ảnh
- Ảnh main lớn ở trên
- Click vào ảnh nhỏ phía dưới để đổi
- Tất cả ảnh sẽ hiển thị đầy đủ

### C. Liên Hệ Chủ Trọ
- Bấp nút "📞 Gọi chủ trọ" → Mở app điện thoại (trên mobile)
- Bấp "📋 Copy số điện thoại" → Copy vào clipboard
- Bấp "💬 Chat Zalo" (nếu có) → Mở Zalo (trên mobile)

### D. Đặt Phòng
**Yêu cầu:** Đăng nhập trước

1. Scroll xuống phần "Đặt phòng"
2. Chọn ngày nhận phòng (bắt buộc)
3. Chọn ngày trả phòng (tùy chọn)
4. Viết ghi chú (tùy chọn)
5. Bấp "Gửi yêu cầu đặt phòng"
6. Sẽ thấy thông báo thành công

### E. Đánh Giá & Bình Luận
**Yêu cầu:** Đăng nhập trước

1. Scroll xuống phần "Đánh giá & Bình luận"
2. Chọn sao (1-5) bằng cách click vào sao
3. Viết bình luận
4. Bấp "Gửi đánh giá"
5. Trang sẽ reload và hiển thị đánh giá mới

### F. Lưu Yêu Thích
**Yêu cầu:** Đăng nhập trước

- Click nút "🤍 Lưu phòng" ở góc phải
- Icon thay thành "❤️ Đã lưu"
- Click lại để bỏ lưu

## 3️⃣ Test Data

### Tạo Phòng Test

Nếu bạn muốn test với phòng mới:

```sql
-- Insert test room post
INSERT INTO room_posts (title, description, price, area, address, phone_contact, zalo_contact, status, category, user_id, location_id, created_at) 
VALUES (
  'Phòng test chi tiết',
  'Đây là phòng test để kiểm tra chức năng chi tiết',
  3500000,
  25,
  'Số 1, Đường ABC, Quận 1',
  '0123456789',
  '0123456789',
  'ACTIVE',
  'OTHER',
  1,
  1,
  NOW()
);

-- Insert test images
INSERT INTO room_images (image_url, post_id) VALUES 
('https://via.placeholder.com/600x400?text=Room1', LAST_INSERT_ID()),
('https://via.placeholder.com/600x400?text=Room2', LAST_INSERT_ID()),
('https://via.placeholder.com/600x400?text=Room3', LAST_INSERT_ID());
```

## 4️⃣ Kiểm Tra Database

### Xem Data Bảng Mới

```sql
-- Xem đánh giá
SELECT * FROM reviews;

-- Xem đơn đặt phòng
SELECT * FROM bookings;

-- Xem yêu thích
SELECT * FROM favorites;
```

## 5️⃣ Gỡ Lỗi

### Lỗi: Import không tìm thấy
- Chắc chắn dùng `jakarta.servlet.http` không phải `javax.servlet.http`

### Lỗi: NullPointerException khi load trang
- Kiểm tra room có tồn tại không
- Kiểm tra RoomImages có dữ liệu không

### Không thấy hình ảnh
- Kiểm tra URL trong `room_images` table hợp lệ không
- Verify images load trên browser

### Form đặt phòng/đánh giá không hiển thị
- Kiểm tra đã đăng nhập chưa (bắt buộc)
- Kiểm tra browser console có error không (F12)

## 6️⃣ API Endpoints (cURL)

### Xem Chi Tiết
```bash
curl http://localhost:8082/room/1
```

### Thêm Đánh Giá
```bash
curl -X POST http://localhost:8082/room/1/review \
  -H "Content-Type: application/json" \
  -d '{"rating": 5, "comment": "Phòng rất tốt!"}'
```

### Tạo Booking
```bash
curl -X POST http://localhost:8082/room/1/booking \
  -H "Content-Type: application/json" \
  -d '{"checkInDate": "2026-06-01", "checkOutDate": "2026-07-01", "notes": "Cần wifi"}'
```

### Lưu Yêu Thích
```bash
curl -X POST http://localhost:8082/room/1/favorite/add
```

## 7️⃣ Troubleshooting Checklist

- [ ] Maven compile thành công
- [ ] Spring Boot app chạy without errors
- [ ] Database bảng `reviews`, `bookings` được tạo
- [ ] Trang chủ hiển thị danh sách phòng
- [ ] Click vào phòng → chuyển sang `/room/{id}`
- [ ] Trang chi tiết hiển thị hình ảnh, thông tin
- [ ] Đăng nhập tài khoản
- [ ] Scroll thấy form đặt phòng
- [ ] Scroll thấy form đánh giá
- [ ] Nút lưu yêu thích hiển thị
- [ ] Gửi đánh giá → thành công
- [ ] Gửi booking → thành công
- [ ] Reload trang → dữ liệu được lưu

## 8️⃣ File Quan Trọng

| File | Mục Đích |
|------|----------|
| `RoomDetailController.java` | Xử lý logic chính |
| `room-detail.jsp` | Giao diện trang chi tiết |
| `ReviewService.java` | Xử lý đánh giá |
| `BookingService.java` | Xử lý booking |
| `Review.java` | Entity đánh giá |
| `Booking.java` | Entity booking |

## 9️⃣ Lưu Ý Quan Trọng

⚠️ **Chỉ Có Thể:**
- Thêm đánh giá khi đăng nhập
- Đặt phòng khi đăng nhập
- Lưu yêu thích khi đăng nhập

⚠️ **Không Thay Đổi:**
- Các entity hiện có
- Các repository, service hiện có
- Trang login, register, admin

✅ **Mở Rộng Có Thể:**
- Thêm admin panel quản lý booking
- Thêm notification cho landlord
- Thêm filter, search room
- Thêm chat giữa user

---

**Nếu có vấn đề, kiểm tra:**
1. Browser console (F12) có error?
2. Server logs có exception?
3. Database có dữ liệu?
4. User đã đăng nhập?
