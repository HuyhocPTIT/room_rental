<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thuê Phòng Trọ - RoomRental</title>
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
        
        .navbar {
            background-color: white !important;
            border-bottom: 1px solid #ddd;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            color: var(--primary-color) !important;
            font-weight: 700;
        }
        
        .hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 60px 0;
            margin-bottom: 40px;
        }
        
        .hero h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .hero p {
            font-size: 1.1rem;
            opacity: 0.95;
        }
        
        .search-form {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-top: -50px;
            position: relative;
            z-index: 10;
            margin-bottom: 40px;
        }
        
        .search-form input,
        .search-form select {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
        }
        
        .search-form button {
            background-color: var(--primary-color);
            border: none;
            padding: 12px 30px;
            border-radius: 6px;
            font-weight: 600;
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 30px;
            color: var(--secondary-color);
            position: relative;
            padding-bottom: 15px;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 4px;
            background-color: var(--primary-color);
            border-radius: 2px;
        }
        
        .room-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s ease;
            background: white;
            height: 100%;
        }
        
        .room-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .room-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .room-card-body {
            padding: 15px;
        }
        
        .room-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 10px;
            min-height: 2.2em;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .room-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        
        .room-info {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            font-size: 0.9rem;
            color: #666;
        }
        
        .room-location {
            color: #999;
            font-size: 0.85rem;
            margin-bottom: 10px;
        }
        
        .room-card-footer {
            padding: 10px 0;
            border-top: 1px solid #f0f0f0;
        }
        
        .btn-view {
            background-color: var(--primary-color);
            border: none;
            width: 100%;
            color: white;
            padding: 8px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            display: block;
            text-align: center;
        }
        
        .btn-view:hover {
            background-color: #E55A2B;
            text-decoration: none;
            color: white;
        }
        
        footer {
            background-color: var(--secondary-color);
            color: white;
            padding: 40px 0 20px;
            margin-top: 60px;
        }
    </style>
</head>
<body>
<jsp:include page="common/header.jsp" />

<div class="hero">
    <div class="container">
        <h1><i class="bi bi-house-heart"></i> Tìm Phòng Trọ Lý Tưởng</h1>
        <p>Hàng nghìn phòng chất lượng với giá cả hợp lý - Tìm kiếm dễ dàng, thuê nhanh chóng</p>
    </div>
</div>

<div class="container">
    <div class="search-form" id="search-section">
        <form method="get" action="<c:url value='/rooms'/>">
            <div class="row g-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm theo tên hoặc mô tả...">
                </div>
                <div class="col-md-2">
                    <input type="number" class="form-control" name="minPrice" placeholder="Giá từ (đ)">
                </div>
                <div class="col-md-2">
                    <input type="number" class="form-control" name="maxPrice" placeholder="Giá đến (đ)">
                </div>
                <div class="col-md-2">
                    <select class="form-select" name="category">
                        <option value="">-- Loại phòng --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i> Tìm
                    </button>
                </div>
            </div>
        </form>
    </div>

    <c:if test="${not empty featuredRooms}">
        <section class="mb-5">
            <h2 class="section-title">
                <i class="bi bi-star-fill" style="color: var(--primary-color);"></i> Phòng Nổi Bật
            </h2>
            <div class="row g-4">
                <c:forEach var="room" items="${featuredRooms}">
                    <div class="col-md-4 col-lg-3">
                        <div class="room-card">
                            <img src="https://via.placeholder.com/300x200?text=Room" alt="${room.title}">
                            <div class="room-card-body">
                                <h5 class="room-title">${room.title}</h5>
                                <div class="room-price">
                                    <fmt:formatNumber value="${room.price}" type="currency" pattern="### ###" /> đ
                                </div>
                                <div class="room-info">
                                    <span><i class="bi bi-rulers"></i> ${room.area} m²</span>
                                    <span><i class="bi bi-door-closed"></i> ${room.bedrooms} phòng</span>
                                </div>
                                <div class="room-location">
                                    <i class="bi bi-geo-alt"></i>
                                    <c:if test="${room.location != null}">
                                        ${room.location.district}, ${room.location.city}
                                    </c:if>
                                </div>
                                <div class="room-card-footer">
                                    <a href="<c:url value='/rooms/${room.id}'/>" class="btn-view">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <c:if test="${not empty newestRooms}">
        <section class="mb-5">
            <h2 class="section-title">
                <i class="bi bi-clock-history" style="color: var(--primary-color);"></i> Phòng Mới Đăng
            </h2>
            <div class="row g-4">
                <c:forEach var="room" items="${newestRooms}">
                    <div class="col-md-6 col-lg-3">
                        <div class="room-card">
                            <img src="https://via.placeholder.com/300x200?text=Room" alt="${room.title}">
                            <div class="room-card-body">
                                <h5 class="room-title">${room.title}</h5>
                                <div class="room-price">
                                    <fmt:formatNumber value="${room.price}" type="currency" pattern="### ###" /> đ
                                </div>
                                <div class="room-info">
                                    <span><i class="bi bi-rulers"></i> ${room.area} m²</span>
                                    <span><i class="bi bi-door-closed"></i> ${room.bedrooms} phòng</span>
                                </div>
                                <div class="room-location">
                                    <i class="bi bi-geo-alt"></i>
                                    <c:if test="${room.location != null}">
                                        ${room.location.district}, ${room.location.city}
                                    </c:if>
                                </div>
                                <div class="room-card-footer">
                                    <a href="<c:url value='/rooms/${room.id}'/>" class="btn-view">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>
</div>

<jsp:include page="common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>