-- Insert Locations
INSERT INTO locations (id, city, district, ward) VALUES
                                                     (1, 'Hà Nội', 'Hai Bà Trưng', 'Trung Liệt'),
                                                     (2, 'Hà Nội', 'Thanh Xuân', 'Thanh Xuân Bắc'),
                                                     (3, 'Hà Nội', 'Cầu Giấy', 'Yên Hòa'),
                                                     (4, 'Hà Nội', 'Đống Đa', 'Trường Chinh'),
                                                     (5, 'TP. Hồ Chí Minh', 'Quận 1', 'Bến Nghé'),
                                                     (6, 'TP. Hồ Chí Minh', 'Quận 3', 'Võ Thị Sáu');

-- Insert Users (FIX ROLE)
INSERT INTO users (id, username, password, role, created_at) VALUES
                                                                 (1, 'user1', '$2a$10$...', 'TENANT', NOW()),
                                                                 (2, 'landlord1', '$2a$10$...', 'LANDLORD', NOW());

-- Insert Profiles
INSERT INTO profiles (id, name, phone_number, email, avatar) VALUES
                                                                 (1, 'Nguyễn Văn A', '0901234567', 'user1@email.com', 'avatar1.jpg'),
                                                                 (2, 'Trần Thị B', '0987654321', 'landlord1@email.com', 'avatar2.jpg');

-- ⚠️ COMMENT UPDATE (tránh lỗi FK nếu chưa mapping đúng)
-- UPDATE users SET profile_id = 1 WHERE id = 1;
-- UPDATE users SET profile_id = 2 WHERE id = 2;

-- Insert Room Posts
INSERT INTO room_posts (id, title, description, price, address, phone_contact, zalo_contact, area, bedrooms, bathrooms, utilities, status, category, location_id, user_id, created_at, updated_at) VALUES
                                                                                                                                                                                                       (1, 'Phòng trọ 25m² gần Đại học Thương Mại', 'Phòng sạch sẽ, thoáng mát.', 3500000, 'Hà Nội', '0901234567', '0901234567', 25, 1, 1, 'WiFi', 'ACTIVE', 'APARTMENT', 1, 2, NOW(), NOW()),
                                                                                                                                                                                                       (2, 'Phòng Thanh Xuân 30m²', 'Có ban công', 4000000, 'Hà Nội', '0987654321', '0987654321', 30, 1, 1, 'WiFi', 'ACTIVE', 'APARTMENT', 2, 2, NOW(), NOW()),
                                                                                                                                                                                                       (3, 'Phòng Cầu Giấy 20m²', 'Cho sinh viên', 2500000, 'Hà Nội', '0901234567', '0901234567', 20, 1, 1, 'WiFi', 'ACTIVE', 'APARTMENT', 3, 2, NOW(), NOW()),
                                                                                                                                                                                                       (4, 'Chung cư mini Đống Đa', 'Mới xây', 5000000, 'Hà Nội', '0987654321', '0987654321', 35, 1, 1, 'WiFi', 'ACTIVE', 'APARTMENT', 4, 2, NOW(), NOW()),
                                                                                                                                                                                                       (5, 'Phòng gần ĐH Kinh Tế', 'Yên tĩnh', 3000000, 'Hà Nội', '0901234567', '0901234567', 22, 1, 1, 'WiFi', 'ACTIVE', 'APARTMENT', 2, 2, NOW(), NOW()),
                                                                                                                                                                                                       (6, 'Nhà Quận 1', '2 tầng', 8000000, 'TPHCM', '0987654321', '0987654321', 60, 2, 2, 'WiFi', 'ACTIVE', 'HOUSE', 5, 2, NOW(), NOW());