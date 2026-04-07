# 🏠 RoomRental - Hệ Thống Thuê Phòng Trọ

Một nền tảng web hiện đại để tìm kiếm và cho thuê phòng trọ, xây dựng bằng **Spring Boot**, **JSP** và **Bootstrap 5**.

## 🎯 Tính Năng Chính

### ✨ Người Tìm Phòng
- **Trang Chủ Hấp Dẫn** - Phòng nổi bật & mới đăng
- **Tìm Kiếm Nâng Cao** - Lọc theo giá, địa điểm, loại phòng, số phòng
- **Xem Chi Tiết Phòng** - Thông tin đầy đủ, ảnh, vị trí, liên hệ chủ
- **Giao Diện Responsive** - Hoạt động tốt trên mọi thiết bị

### 💼 Chủ Phòng (Coming Soon)
- Đăng bài cho thuê
- Quản lý bài đăng
- Theo dõi lượt xem

## 🛠️ Tech Stack

```
Frontend:  JSP, Bootstrap 5, HTML5, CSS3
Backend:   Spring Boot 4.0.3
Database:  MySQL 8.0
Language:  Java 17
Build:     Maven
```

## 📋 Cấu Trúc Dự Án

```
room_rental/
├── src/
│   ├── main/
│   │   ├── java/com/example/roomrental/
│   │   │   ├── controller/
│   │   │   │   ├── HomeController.java
│   │   │   │   ├── RoomPostController.java
│   │   │   │   └── AuthController.java
│   │   │   ├── service/
│   │   │   │   └── RoomPostService.java
│   │   │   ├── entity/
│   │   │   │   ├── User.java
│   │   │   │   ├── RoomPost.java
│   │   │   │   ├── Profile.java
│   │   │   │   ├── Location.java
│   │   │   │   └── Favorite.java
│   │   │   ├── repository/
│   │   │   │   └── RoomPostRepository.java
│   │   │   └── RoomRentalApplication.java
│   │   ├── webapp/WEB-INF/views/
│   │   │   ├── index.jsp (Trang chủ)
│   │   │   ├── list.jsp (Danh sách phòng)
│   │   │   ├── detail.jsp (Chi tiết phòng)
│   │   │   └── common/
│   │   │       ├── header.jsp
│   │   │       └── footer.jsp
│   │   └── resources/
│   │       ├── application.properties
│   │       └── data.sql
│   └── test/
├── pom.xml
└── README.md
```

## 🚀 Cách Chạy Ứng Dụng

### Prerequisites
- Java 17+
- MySQL 8.0+
- Maven 3.6+

### 1. Cấu Hình Database

```sql
-- Tạo database
CREATE DATABASE room_rental_db;
USE room_rental_db;
```

Hoặc để trống để Spring tự tạo (nếu có `createDatabaseIfNotExist=true` trong `application.properties`)

### 2. Cập Nhật Thông Tin Connection

Trong `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/room_rental_db
spring.datasource.username=root
spring.datasource.password=123456
```

### 3. Chạy Ứng Dụng

**Dùng Maven Wrapper (Windows):**
```cmd
cd C:\Users\DELL\OneDrive\Documents\room_rental
mvnw.cmd spring-boot:run
```

**Hoặc dùng Maven:**
```bash
mvn spring-boot:run
```

### 4. Truy Cập

- **Trang chủ**: http://localhost:8082/
- **Danh sách phòng**: http://localhost:8082/rooms
- **Chi tiết phòng**: http://localhost:8082/rooms/1

## 📊 Dữ Liệu Mẫu

Database sẽ tự động tạo 8 phòng mẫu khi khởi động:
- 4 phòng ở Hà Nội (Hai Bà Trưng, Thanh Xuân, Cầu Giấy, Đống Đa)
- 3 phòng ở TP. Hồ Chí Minh (Quận 1, Quận 3)
- 1 nhà nguyên căn

## 🔍 Hướng Dẫn Sử Dụng

### Tìm Kiếm Phòng

1. **Từ Trang Chủ**
   - Nhập từ khóa vào ô tìm kiếm
   - Chọn mức giá (từ - đến)
   - Chọn loại phòng
   - Bấm "Tìm"

2. **Từ Danh Sách Phòng** (/rooms)
   - Dùng bộ lọc bên trái sidebar
   - Chọn các tiêu chí mong muốn
   - Bấm "Áp dụng bộ lọc"

### Xem Chi Tiết Phòng

1. Bấm "Xem chi tiết" trên card phòng
2. Xem thông tin đầy đủ:
   - Giá, diện tích, số phòng ngủ
   - Mô tả & tiện ích
   - Vị trí trên bản đồ
   - Liên hệ chủ phòng

### Liên Hệ Chủ Phòng

- Bấm "Gọi Ngay" để gọi điện
- Bấm link Zalo để chat
- Bấm "Lưu Tin" để lưu phòng yêu thích

## 🎨 Giao Diện

### Màu Sắc
- **Primary**: #FF6B35 (Cam)
- **Secondary**: #004E89 (Xanh đậm)
- **Background**: #f8f9fa

### Component
- **Header**: Navigation + Logo
- **Hero**: Tiêu đề + Search Form
- **Cards**: Room info + Image + Contact buttons
- **Sidebar**: Filters
- **Footer**: Links + Contact info

## 📱 Responsive Design

✅ **Desktop** (1200px+) - Full layout
✅ **Tablet** (768px - 1199px) - Adjusted columns
✅ **Mobile** (< 768px) - Stack layout, full width

## 🔐 Security (TODO)

- [ ] Password hashing với BCrypt
- [ ] Session management
- [ ] CSRF protection
- [ ] Input validation
- [ ] Rate limiting

## 📝 API Endpoints

### Public
- `GET /` - Trang chủ
- `GET /rooms` - Danh sách phòng
- `GET /rooms/{id}` - Chi tiết phòng
- `GET /rooms/api/{id}` - API JSON

### Protected (Coming Soon)
- `POST /rooms` - Tạo bài đăng
- `PUT /rooms/{id}` - Cập nhật bài
- `DELETE /rooms/{id}` - Xóa bài
- `POST /favorites` - Lưu yêu thích

## 🐛 Troubleshooting

### Port đã được sử dụng
```bash
mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8083"
```

### Database connection error
- Kiểm tra MySQL đang chạy
- Kiểm tra username & password
- Kiểm tra database tồn tại

### JSP không render
- Đảm bảo application.properties có:
  ```properties
  spring.mvc.view.prefix=/WEB-INF/views/
  spring.mvc.view.suffix=.jsp
  ```

## 📚 Learning Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Bootstrap 5 Docs](https://getbootstrap.com/docs/5.0/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## 👥 Phân Công

### Frontend (Bạn)
- ✅ Homepage & List page design
- ✅ Search & Filter UI
- ✅ Room detail page
- ✅ Responsive styling

### Backend
- ✅ Controllers & Services
- ✅ Database entities
- ✅ Business logic

### TODO
- [ ] Authentication UI
- [ ] User Dashboard
- [ ] Admin Panel
- [ ] Image Upload
- [ ] Notifications

## 📞 Support

- 📧 Email: support@roomrental.com
- 🔔 Issues: Báo lỗi qua GitHub Issues
- 💬 Chat: Zalo/Telegram

## 📄 License

MIT License - Sử dụng tự do cho mục đích học tập

---

**Chúc bạn thành công với dự án! 🚀**
