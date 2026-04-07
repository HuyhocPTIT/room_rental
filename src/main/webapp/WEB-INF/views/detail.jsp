<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${room.title} - RoomRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #FF6B35;
            --secondary-color: #004E89;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        .image-gallery {
            margin-bottom: 30px;
        }
        
        .main-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .room-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 15px;
        }
        
        .room-price {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .room-info-badge {
            display: inline-block;
            background-color: #f0f0f0;
            padding: 10px 15px;
            border-radius: 4px;
            margin-right: 10px;
            margin-bottom: 10px;
            font-weight: 500;
        }
        
        .contact-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
        }
        
        .contact-card h4 {
            color: var(--secondary-color);
            margin-bottom: 20px;
            font-weight: 700;
        }
        
        .contact-info {
            margin-bottom: 15px;
        }
        
        .contact-label {
            font-size: 0.9rem;
            color: #999;
            margin-bottom: 5px;
        }
        
        .contact-value {
            font-size: 1.1rem;
            color: #333;
            font-weight: 600;
        }
        
        .btn-contact {
            width: 100%;
            background-color: var(--primary-color);
            color: white;
            padding: 15px;
            border-radius: 4px;
            border: none;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            margin-bottom: 10px;
        }
        
        .btn-contact:hover {
            background-color: #E55A2B;
        }
        
        .btn-save {
            width: 100%;
            background-color: white;
            color: var(--primary-color);
            padding: 15px;
            border-radius: 4px;
            border: 2px solid var(--primary-color);
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
        }
        
        .btn-save:hover {
            background-color: #fff5f0;
        }
        
        .info-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .info-section h3 {
            color: var(--secondary-color);
            font-weight: 700;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary-color);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .info-item {
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #999;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        
        .info-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--secondary-color);
        }
        
        .description-text {
            color: #555;
            line-height: 1.8;
        }
        
        .location-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .back-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            display: inline-block;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />

<div class="container my-5">
    <a href="<c:url value='/rooms'/>" class="back-link"><i class="bi bi-arrow-left"></i> Quay lại</a>
    
    <div class="row">
        <!-- Main Content -->
        <div class="col-md-8">
            <!-- Image Gallery -->
            <div class="image-gallery">
                <img src="https://via.placeholder.com/600x400?text=Room+${room.id}" alt="${room.title}" class="main-image">
            </div>
            
            <!-- Room Info -->
            <h1 class="room-title">${room.title}</h1>
            <div class="room-price">
                <fmt:formatNumber value="${room.price}" type="currency" pattern="### ###" /> đ
                <span style="font-size: 0.6em; color: #999;">/tháng</span>
            </div>
            
            <!-- Quick Info -->
            <div class="mb-4">
                <span class="room-info-badge">
                    <i class="bi bi-rulers"></i> ${room.area} m²
                </span>
                <span class="room-info-badge">
                    <i class="bi bi-door-closed"></i> ${room.bedrooms} phòng ngủ
                </span>
                <span class="room-info-badge">
                    <i class="bi bi-droplet"></i> ${room.bathrooms} phòng tắm
                </span>
                <c:if test="${not empty room.category}">
                    <span class="room-info-badge">
                        <i class="bi bi-tag"></i> ${room.category}
                    </span>
                </c:if>
            </div>
            
            <!-- Room Details Section -->
            <div class="info-section">
                <h3>Thông Tin Chi Tiết</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Diện Tích</div>
                        <div class="info-value">${room.area} m²</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phòng Ngủ</div>
                        <div class="info-value">${room.bedrooms}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phòng Tắm</div>
                        <div class="info-value">${room.bathrooms}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Giá</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${room.price}" type="currency" pattern="### ###" /> đ
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Description Section -->
            <div class="info-section">
                <h3>Mô Tả</h3>
                <p class="description-text">${room.description}</p>
            </div>
            
            <!-- Utilities Section -->
            <c:if test="${not empty room.utilities}">
                <div class="info-section">
                    <h3>Tiện Ích</h3>
                    <p>${room.utilities}</p>
                </div>
            </c:if>
            
            <!-- Location Section -->
            <div class="location-section">
                <h3><i class="bi bi-geo-alt"></i> Vị Trí</h3>
                <c:if test="${room.location != null}">
                    <p>
                        <strong>Địa chỉ:</strong> ${room.location.ward}, ${room.location.district}, ${room.location.city}
                    </p>
                </c:if>
                <p>
                    <strong>Địa chỉ cụ thể:</strong> ${room.address}
                </p>
            </div>
        </div>
        
        <!-- Contact Section -->
        <div class="col-md-4">
            <div class="contact-card">
                <h4><i class="bi bi-telephone"></i> Liên Hệ Chủ Phòng</h4>
                
                <c:if test="${not empty room.phoneContact}">
                    <div class="contact-info">
                        <div class="contact-label">Điện Thoại</div>
                        <div class="contact-value">
                            <a href="tel:${room.phoneContact}" style="text-decoration: none; color: #333;">
                                ${room.phoneContact}
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty room.zaloContact}">
                    <div class="contact-info">
                        <div class="contact-label">Zalo</div>
                        <div class="contact-value">
                            <a href="https://zalo.me/${room.zaloContact}" target="_blank" style="text-decoration: none; color: #333;">
                                ${room.zaloContact}
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty room.user && not empty room.user.profile}">
                    <div class="contact-info">
                        <div class="contact-label">Tên Chủ Phòng</div>
                        <div class="contact-value">${room.user.profile.name}</div>
                    </div>
                </c:if>
                
                <a href="tel:${room.phoneContact}" class="btn-contact">
                    <i class="bi bi-telephone"></i> Gọi Ngay
                </a>
                
                <button class="btn-save">
                    <i class="bi bi-heart"></i> Lưu Tin
                </button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
