# 🚀 Hướng Dẫn Nhanh - Chạy Room Rental

## ✅ Yêu Cầu Trước
- Java 17+
- MySQL 8.0+
- Maven 3.6+ (có sẵn trong project - mvnw.cmd)

---

## 📦 Bước 1: Chuẩn Bị Database

### Cách 1: Tự Động (Khuyến Khích)
- Application sẽ **tự động tạo database** nếu chưa có
- Sẽ **tự động chạy data.sql** để thêm dữ liệu mẫu
- Không cần làm gì thêm!

### Cách 2: Thủ Công
```sql
-- Mở MySQL
mysql -u root -p123456

-- Chạy lệnh tạo DB
CREATE DATABASE room_rental_db;
USE room_rental_db;

-- Hoặc import nếu có script SQL
SOURCE C:\path\to\schema.sql;
```

---

## 🔧 Bước 2: Cấu Hình Connection (nếu cần)

Sửa file: `src/main/resources/application.properties`

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/room_rental_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=123456
```

**Note:**
- `createDatabaseIfNotExist=true` - Tự tạo DB nếu không có
- Port MySQL: 3306 (mặc định)
- Username/password: Điều chỉnh theo setup của bạn

---

## 🎬 Bước 3: Chạy Ứng Dụng

### Windows (Dùng Maven Wrapper)

**Terminal / CMD:**
```cmd
cd C:\Users\DELL\OneDrive\Documents\room_rental
mvnw.cmd spring-boot:run
```

**PowerShell:**
```powershell
cd "C:\Users\DELL\OneDrive\Documents\room_rental"
.\mvnw.cmd spring-boot:run
```

### Mac/Linux

```bash
cd ~/room_rental
./mvnw spring-boot:run
```

### Dùng IDE (IntelliJ IDEA)

1. Open project
2. Right-click `RoomRentalApplication.java`
3. Choose "Run"
4. Hoặc bấm `Ctrl+Shift+F10`

---

## ✨ Bước 4: Kiểm Tra

Sau khi chạy, bạn sẽ thấy:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_|\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v4.0.3)

2026-04-07 14:20:29.123  INFO 12345 --- [main] c.e.r.RoomRentalApplication : Started
2026-04-07 14:20:29.456  INFO 12345 --- [main] c.e.r.RoomRentalApplication : 
  Tomcat started on port(s): 8082 (http) with context path ''
```

---

## 🌐 Bước 5: Truy Cập Website

Mở browser và vào:

| Trang | URL |
|-------|-----|
| **Trang Chủ** | http://localhost:8082/ |
| **Danh Sách Phòng** | http://localhost:8082/rooms |
| **Chi Tiết Phòng #1** | http://localhost:8082/rooms/1 |
| **Đăng Bài Mới** | http://localhost:8082/rooms/post/new |

---

## 🎯 Các Tính Năng Có Sẵn

✅ **Trang Chủ**
- Hero section với search
- Phòng nổi bật
- Phòng mới đăng

✅ **Danh Sách Phòng** (/rooms)
- Liệt kê tất cả phòng
- Bộ lọc (giá, loại, số phòng)
- Tìm kiếm từ khóa

✅ **Chi Tiết Phòng** (/rooms/1)
- Thông tin đầy đủ
- Liên hệ chủ phòng
- Nút "Lưu Tin"

✅ **Dữ Liệu Mẫu**
- 8 phòng mẫu từ Hà Nội & TP. HCM
- Tự động tạo khi khởi động

---

## 🐛 Xử Lý Lỗi

### Lỗi: "Port 8082 đã được sử dụng"
```cmd
mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--server.port=8083"
```

### Lỗi: "MySQL connection refused"
```
✓ Kiểm tra MySQL đang chạy: 
  - Windows: Task Manager → MySQL57 (hoặc phiên bản khác)
  - Linux: systemctl status mysql
  
✓ Kiểm tra creds trong application.properties
✓ Kiểm tra firewall (port 3306)
```

### Lỗi: "Table doesn't exist"
```
→ Xóa DB và để app tự tạo lại
→ Hoặc chạy: spring.jpa.hibernate.ddl-auto=create
```

### Lỗi: JSP không hiển thị
```
✓ Kiểm tra view files tồn tại:
  - src/main/webapp/WEB-INF/views/
  - index.jsp, list.jsp, detail.jsp, post-form.jsp
  
✓ Kiểm tra application.properties:
  spring.mvc.view.prefix=/WEB-INF/views/
  spring.mvc.view.suffix=.jsp
```

---

## 📊 Database Schema

**Tables được tạo tự động:**

```sql
-- Users
users (id, username, password, role, profile_id, created_at)

-- Profiles
profiles (id, name, email, phone_number, avatar)

-- Locations
locations (id, city, district, ward)

-- Room Posts
room_posts (
  id, title, description, price, address, 
  area, bedrooms, bathrooms, utilities,
  phone_contact, zalo_contact, status, category,
  location_id, user_id, created_at, updated_at
)

-- Room Images
room_images (id, image_url, room_post_id)

-- Favorites
favorites (id, user_id, room_post_id, created_at)
```

---

## 🎨 Tùy Chỉnh

### Thay Đổi Port
```properties
# application.properties
server.port=9090
```

### Thay Đổi Màu Sắc
```css
/* views/index.jsp hoặc list.jsp */
:root {
  --primary-color: #FF6B35;    /* Cam */
  --secondary-color: #004E89;  /* Xanh đậm */
}
```

### Thêm Phòng Mẫu
```sql
-- Thêm vào data.sql
INSERT INTO room_posts (...) VALUES (...);
```

---

## 📚 File Quan Trọng

```
src/main/
├── java/com/example/roomrental/
│   ├── RoomRentalApplication.java        ← Main class
│   ├── controller/
│   │   ├── HomeController.java           ← Trang chủ
│   │   └── RoomPostController.java       ← Quản lý phòng
│   ├── service/
│   │   └── RoomPostService.java          ← Business logic
│   ├── entity/
│   │   └── RoomPost.java                 ← Model phòng
│   └── repository/
│       └── RoomPostRepository.java       ← Database query
│
├── webapp/WEB-INF/views/
│   ├── index.jsp                         ← Trang chủ
│   ├── list.jsp                          ← Danh sách phòng
│   ├── detail.jsp                        ← Chi tiết phòng
│   ├── post-form.jsp                     ← Form đăng bài
│   └── common/
│       ├── header.jsp                    ← Navigation
│       └── footer.jsp                    ← Footer
│
└── resources/
    ├── application.properties            ← Config
    └── data.sql                          ← Sample data
```

---

## ✅ Checklist Trước Khi Chạy

- [ ] Java 17+ cài đặt
- [ ] MySQL đang chạy
- [ ] MySQL root password = 123456 (hoặc sửa trong properties)
- [ ] Port 8082 không sử dụng
- [ ] Folder `views` có file JSP

---

## 🎓 Tiếp Theo

Sau khi chạy thành công, bạn có thể:

1. **Thêm Spring Security** - Đăng nhập/đăng ký
2. **Upload Ảnh** - Thay placeholder image
3. **Thêm Pagination** - Phân trang danh sách
4. **RESTful API** - JSON responses
5. **Admin Dashboard** - Quản lý phòng

---

## 💡 Mẹo

- 🔄 Dùng `Ctrl+Shift+F5` (IntelliJ) để reload khi sửa JSP
- 📱 Dùng DevTools (F12) để test responsive
- 🔍 Xem logs: `target/spring.log`
- 🧹 Clean build: `mvn clean install`

---

**Chúc bạn thành công! 🚀**

Nếu gặp vấn đề, check:
1. Application logs
2. MySQL connection
3. File paths
4. Browser console (F12)
