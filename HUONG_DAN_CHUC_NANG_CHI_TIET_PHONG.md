# Hướng Dẫn Chức Năng Xem Chi Tiết Phòng

## Giới Thiệu

Tôi đã thêm chức năng xem chi tiết phòng cho ứng dụng web cho thuê nhà trọ. Khi bấm vào một phòng trong danh sách, người dùng sẽ được chuyển đến trang chi tiết phòng với đầy đủ thông tin.

## Các Tính Năng Mới

### 1. **Trang Chi Tiết Phòng** (`/room/{id}`)
   - Hiển thị hình ảnh phòng với gallery (slide ảnh)
   - Thông tin giá, diện tích, loại phòng
   - Mô tả chi tiết phòng
   - Thông tin liên hệ chủ trọ (điện thoại, Zalo)
   - Thông tin chi tiết chủ trọ (avatar, tên, email, điện thoại)

### 2. **Chức Năng Đặt Phòng**
   - Biểu mẫu đặt phòng với:
     - Ngày nhận phòng (bắt buộc)
     - Ngày trả phòng dự kiến (tùy chọn)
     - Ghi chú (tùy chọn)
   - Status ban đầu: PENDING (chờ xác nhận)
   - Chủ trọ có thể xác nhận hoặc hủy

### 3. **Chức Năng Đánh Giá & Bình Luận**
   - Người dùng đã đăng nhập có thể:
     - Đánh giá từ 1-5 sao
     - Viết bình luận/đánh giá
   - Hiển thị:
     - Đánh giá trung bình
     - Tổng số đánh giá
     - Danh sách tất cả bình luận với tên người dùng, avatar, ngày đăng

### 4. **Chức Năng Lưu Yêu Thích**
   - Nút "Lưu phòng" (❤️ / 🤍)
   - Lưu trữ phòng yêu thích (tích hợp với Favorite entity hiện có)

### 5. **Thanh Bên (Sidebar)**
   - Thông tin nhanh: giá, diện tích, loại phòng, ngày đăng
   - Nút hành động:
     - Gọi chủ trọ (mở app điện thoại)
     - Copy số điện thoại
     - Chat Zalo (nếu có)

## Cấu Trúc Entities Mới

### Entity Review
- `id`: ID đánh giá
- `rating`: Đánh giá (1-5 sao)
- `comment`: Bình luận/đánh giá
- `createdAt`: Thời gian tạo
- `user`: Người đánh giá (N-1 với User)
- `roomPost`: Phòng được đánh giá (N-1 với RoomPost)

### Entity Booking
- `id`: ID đơn đặt
- `checkInDate`: Ngày nhận phòng
- `checkOutDate`: Ngày trả phòng dự kiến
- `notes`: Ghi chú
- `status`: Trạng thái (PENDING, CONFIRMED, CANCELLED)
- `createdAt`: Thời gian tạo
- `user`: Người đặt (N-1 với User)
- `roomPost`: Phòng được đặt (N-1 với RoomPost)

### Constant BookingStatus
- PENDING: Chờ xác nhận
- CONFIRMED: Đã xác nhận
- CANCELLED: Đã hủy

## Các Files Được Tạo

### Entities
- `Review.java` - Lưu trữ đánh giá và bình luận
- `Booking.java` - Lưu trữ thông tin đặt phòng

### Constants
- `BookingStatus.java` - Enum trạng thái đặt phòng

### Repositories
- `ReviewRepository.java` - Truy vấn đánh giá
- `BookingRepository.java` - Truy vấn đơn đặt phòng

### Services
- `ReviewService.java` - Xử lý logic đánh giá
- `BookingService.java` - Xử lý logic đặt phòng

### DTOs
- `ReviewDTO.java` - DTO cho đánh giá
- `ReviewRequest.java` - Request DTO cho thêm đánh giá
- `BookingRequest.java` - Request DTO cho đặt phòng
- `RoomDetailDTO.java` - DTO chứa toàn bộ thông tin chi tiết phòng

### Controllers
- `RoomDetailController.java` - Xử lý trang chi tiết phòng
  - `GET /room/{id}` - Xem chi tiết phòng
  - `POST /room/{id}/review` - Thêm đánh giá
  - `POST /room/{id}/booking` - Tạo đơn đặt phòng
  - `POST /room/{id}/favorite/add` - Thêm vào yêu thích
  - `POST /room/{id}/favorite/remove` - Xóa khỏi yêu thích

### Views
- `room-detail.jsp` - Trang chi tiết phòng đầy đủ

### Cập Nhật Files Hiện Có
- `index.jsp` - Thay đổi link từ `/post-detail/{id}` sang `/room/{id}`
- `FavoriteRepository.java` - Thêm methods `existsByUserIdAndRoomPostId()`, `findByUserIdAndRoomPostId()`
- `RoomPostService.java` - Thêm method `getRoomPostById()`

## API Endpoints

### Xem Chi Tiết Phòng
```
GET /room/{id}
Response: HTML page (room-detail.jsp)
```

### Thêm Đánh Giá
```
POST /room/{id}/review
Content-Type: application/json

Body:
{
  "rating": 5,
  "comment": "Phòng rất sạch và thoáng mát!"
}

Response:
{
  "success": true/false,
  "message": "..."
}
```

### Tạo Đơn Đặt Phòng
```
POST /room/{id}/booking
Content-Type: application/json

Body:
{
  "checkInDate": "2026-06-15",
  "checkOutDate": "2026-07-15",
  "notes": "Vui lòng chuẩn bị giường"
}

Response:
{
  "success": true/false,
  "message": "..."
}
```

### Thêm/Xóa Yêu Thích
```
POST /room/{id}/favorite/add
POST /room/{id}/favorite/remove

Response:
{
  "success": true/false,
  "message": "..."
}
```

## Các Tính Năng Bảo mật

1. **Yêu cầu Đăng Nhập**
   - Chỉ người dùng đã đăng nhập mới có thể:
     - Đánh giá và bình luận
     - Đặt phòng
     - Lưu yêu thích
   
2. **Kiểm Tra Quyền**
   - Chỉ kiểm tra user hiện tại từ session

## Ghi Chú Quan Trọng

✅ **KHÔNG THAY ĐỔI:**
- Các entity hiện có (User, RoomPost, Location, Profile, RoomImage, Favorite)
- Các repository, service hiện có
- Các controller và view hiện có (chỉ cập nhật link)

## Tiếp Theo - Có Thể Phát Triển Thêm

1. **Cho Admin:**
   - Quản lý đơn đặt phòng (xác nhận, hủy)
   - Quản lý đánh giá (xóa bình luận không phù hợp)
   - Thống kê rating, booking

2. **Cho Landlord:**
   - Xem danh sách booking của phòng
   - Xác nhận/hủy booking
   - Xem đánh giá phòng của mình

3. **Cho Tenant:**
   - Xem lịch sử booking
   - Xem lịch sử đánh giá
   - Quản lý danh sách yêu thích

4. **Tính Năng Bổ Sung:**
   - Chat trực tiếp với chủ trọ
   - Xem bản đồ vị trí
   - Bộ lọc và tìm kiếm nâng cao
   - Notification cho chủ trọ khi có booking/review mới

## Hướng Dẫn Sử Dụng

### Cho Người Dùng (Tenant)

1. **Xem Chi Tiết Phòng:**
   - Bấm vào phòng trong danh sách trang chủ
   - Xem toàn bộ thông tin phòng

2. **Đặt Phòng:**
   - Điền ngày nhận phòng (bắt buộc)
   - Điền ngày trả phòng (tùy chọn)
   - Thêm ghi chú (tùy chọn)
   - Bấm "Gửi yêu cầu đặt phòng"

3. **Đánh Giá Phòng:**
   - Chọn số sao (1-5)
   - Viết bình luận
   - Bấm "Gửi đánh giá"

4. **Lưu Yêu Thích:**
   - Bấm nút "Lưu phòng" (🤍)
   - Chuyển sang ❤️ khi đã lưu

### Cho Chủ Trọ (Landlord)

- Xem các đơn đặt phòng từ ứng dụng (cần phát triển admin panel thêm)
- Xem đánh giá của khách hàng

---

**Lưu Ý:** Tất cả các API endpoint đều yêu cầu session HTTP hợp lệ. Nếu user chưa đăng nhập, chức năng đánh giá, đặt phòng, lưu yêu thích sẽ yêu cầu đăng nhập.
